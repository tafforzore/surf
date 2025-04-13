FROM alpine:3.18

# Install dependencies with specific versions
RUN apk add --no-cache \
    haproxy=2.6.21-r0 \
    python3=3.10.12-r0 \
    py3-pip=23.0.1-r0 \
    openssh-client=9.3_p2-r0 \
    && pip3 install --no-cache-dir pproxy==2.8.0

# Copy config files
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY start-tunnel.sh /start-tunnel.sh

# Verify config file ends with newline
RUN if [ -n "$(tail -c 1 /etc/haproxy/haproxy.cfg)" ]; then \
        echo >> /etc/haproxy/haproxy.cfg; \
    fi

# Set permissions
RUN chmod +x /start-tunnel.sh

EXPOSE 8080 8888

HEALTHCHECK --interval=30s --timeout=3s \
    CMD nc -z localhost 8080 || exit 1

CMD ["/start-tunnel.sh"]