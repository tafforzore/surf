#!/bin/sh

# Start HAProxy
haproxy -f /etc/haproxy/haproxy.cfg -db &

# Wait for HAProxy to initialize
sleep 2

# Start pproxy with simpler configuration
pproxy -l http://0.0.0.0:8888 \
       -r socks5://${PROXY_USER}:${PROXY_PASS}@${SOCKS5_PROXY} \
       --dns 8.8.8.8 \
       -vv &

# Monitoring
while true; do
    if ! pgrep haproxy >/dev/null; then
        echo "[$(date)] HAProxy died, restarting..."
        haproxy -f /etc/haproxy/haproxy.cfg -db &
    fi
    if ! pgrep pproxy >/dev/null; then
        echo "[$(date)] PPROXY died, restarting..."
        pproxy -l http://0.0.0.0:8888 \
               -r socks5://${PROXY_USER}:${PROXY_PASS}@${SOCKS5_PROXY} \
               --dns 8.8.8.8 \
               -vv &
    fi
    sleep 30
done