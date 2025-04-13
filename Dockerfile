FROM alpine:3.18

# Install system dependencies first
RUN apk add --no-cache \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    haproxy \
    python3 \
    py3-pip \
    openssh-client

# Install pproxy with dependencies
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir pproxy==2.8.0 cryptography==38.0.4

# Clean build dependencies
RUN apk del gcc musl-dev python3-dev libffi-dev openssl-dev

# Copy configuration files
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY start-tunnel.sh /start-tunnel.sh

# Verify config file ends with newline
RUN if [ -n "$(tail -c 1 /etc/haproxy/haproxy.cfg)" ]; then \
        echo >> /etc/haproxy/haproxy.cfg; \
    fi && \
    haproxy -c -f /etc/haproxy/haproxy.cfg

# Set permissions
RUN chmod +x /start-tunnel.sh

EXPOSE 8080 8888

HEALTHCHECK --interval=30s --timeout=3s \
    CMD nc -z localhost 8080 || exit 1

CMD ["/start-tunnel.sh"]