#!/bin/sh

# Start HAProxy in foreground
haproxy -f /etc/haproxy/haproxy.cfg -db &

# Wait for HAProxy to initialize
sleep 2

# Start pproxy with reduced verbosity
pproxy -l http://0.0.0.0:8888 \
       -r socks5://${PROXY_USER}:${PROXY_PASS}@${SOCKS5_PROXY} \
       --dns 8.8.8.8 &

# Simple health check loop
while true; do
    sleep 60
    if ! pgrep haproxy >/dev/null; then
        echo "[$(date)] HAProxy died, exiting..."
        exit 1
    fi
    if ! pgrep pproxy >/dev/null; then
        echo "[$(date)] PPROXY died, exiting..."
        exit 1
    fi
done