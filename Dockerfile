FROM debian:bookworm-slim

# Configure environment
ENV PIP_BREAK_SYSTEM_PACKAGES=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    haproxy \
    python3 \
    python3-pip \
    python3-venv \
    openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pproxy==2.7.5 cryptography==38.0.4

# Copy configuration files
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY start-tunnel.sh /start-tunnel.sh

# Set permissions and verify config
RUN chmod +x /start-tunnel.sh && \
    mkdir -p /var/run/haproxy && \
    haproxy -c -f /etc/haproxy/haproxy.cfg || true

EXPOSE 8080 8888

CMD ["/start-tunnel.sh"]