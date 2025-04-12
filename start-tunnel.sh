#!/bin/sh

# Start HAProxy
haproxy -f /etc/haproxy/haproxy.cfg -db &

# Start pproxy with SOCKS5 authentication
pproxy -l http://0.0.0.0:8888 \
       -r socks5://${PROXY_USER}:${PROXY_PASS}@${SOCKS5_PROXY} \
       -v \
       --dns 8.8.8.8 &

# Monitoring
while true; do
    if ! pgrep haproxy >/dev/null; then
        echo "HAProxy died, restarting..."
        haproxy -f /etc/haproxy/haproxy.cfg -db &
    fi
    if ! pgrep pproxy >/dev/null; then
        echo "PPROXY died, restarting..."
        pproxy -l http://0.0.0.0:8888 \
               -r socks5://${PROXY_USER}:${PROXY_PASS}@${SOCKS5_PROXY} \
               -v \
               --dns 8.8.8.8 &
    fi
    sleep 30
done