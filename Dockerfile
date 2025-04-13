FROM alpine:3.18

# Install dependencies with compatible versions
RUN apk add --no-cache \
    haproxy \
    python3 \
    py3-pip \
    openssh-client \
    && pip3 install --no-cache-dir pproxy==2.8.0

# Verify installed versions
RUN echo "Versions installed:" && \
    haproxy -v && \
    python3 --version && \
    pip3 --version && \
    ssh -V

# Copy config files
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY start-tunnel.sh /start-tunnel.sh

# Ensure config file ends with newline
RUN if [ -n "$(tail -c 1 /etc/haproxy/haproxy.cfg)" ]; then \
        echo >> /etc/haproxy/haproxy.cfg; \
    fi

# Set permissions
RUN chmod +x /start-tunnel.sh

EXPOSE 8080 8888

HEALTHCHECK --interval=30s --timeout=3s \
    CMD nc -z localhost 8080 || exit 1

CMD ["/start-tunnel.sh"]