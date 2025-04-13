#!/bin/sh

# Create PID directory
mkdir -p /var/run/haproxy

# Start HAProxy
haproxy -f /etc/haproxy/haproxy.cfg -db &

# Start pproxy
/opt/venv/bin/pproxy -l http://0.0.0.0:8888 \
       -r socks5://${PROXY_USER}:${PROXY_PASS}@${SOCKS5_PROXY} \
       --dns 8.8.8.8 &

# Keep container running
tail -f /dev/null