FROM debian:bookworm-slim

# Configure environment pour éviter les warnings pip
ENV PIP_BREAK_SYSTEM_PACKAGES=1 \
    PYTHONUNBUFFERED=1

# Installer les dépendances système
RUN apt-get update && \
    apt-get install -y \
    haproxy \
    python3 \
    python3-pip \
    python3-venv \
    git \
    openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Créer et activer un virtualenv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Installer les dépendances Python dans le virtualenv
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pproxy==2.7.5 cryptography==38.0.4

# Copier les fichiers de configuration
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY start-tunnel.sh /start-tunnel.sh

# Vérifier la configuration HAProxy
RUN chmod +x /start-tunnel.sh && \
    haproxy -c -f /etc/haproxy/haproxy.cfg

EXPOSE 8080 8888

CMD ["/start-tunnel.sh"]