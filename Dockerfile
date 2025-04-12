FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache \
    haproxy \
    python3 \
    py3-pip \
    openssh-client \
    && pip3 install --no-cache-dir pproxy

# Copy config files
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY start-tunnel.sh /start-tunnel.sh

# Set permissions
RUN chmod +x /start-tunnel.sh

# Expose ports
EXPOSE 8080 8888

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD nc -z localhost 8080 || exit 1

CMD ["/start-tunnel.sh"]