FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y \
    haproxy \
    python3 \
    python3-pip \
    git \
    openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir git+https://github.com/qwj/python-proxy.git@v2.7.5 cryptography==38.0.4

COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY start-tunnel.sh /start-tunnel.sh

RUN chmod +x /start-tunnel.sh

EXPOSE 8080 8888

CMD ["/start-tunnel.sh"]