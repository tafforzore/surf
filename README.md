# HA Tunnel Docker

Docker setup for HTTP tunneling to mobile devices using HAProxy and pproxy.

## Features
- HTTP proxy on port 8080
- SOCKS5 to HTTP conversion
- Auto-reconnect if services fail
- Health monitoring
- Log persistence

## Quick Start

1. Edit environment variables in `docker-compose.yml`:
   ```yaml
   environment:
     - SOCKS5_PROXY=your.proxy.com:1080
     - PROXY_USER=your_username
     - PROXY_PASS=your_password
   ```

2. Build and run:
   ```bash
   docker-compose up -d --build
   ```

3. On your mobile device, configure:
   - Proxy: Your server IP
   - Port: 8080
   - Type: HTTP

## Advanced Configuration

### Ports
- 8080: HTTP Proxy (for clients)
- 8888: Internal proxy port

### Volumes
- ./logs: HAProxy logs directory

### Environment Variables
| Variable      | Description                | Default |
|--------------|----------------------------|---------|
| SOCKS5_PROXY | Upstream SOCKS5 server     | Required|
| PROXY_USER   | SOCKS5 username            | ""      |
| PROXY_PASS   | SOCKS5 password            | ""      |

## Troubleshooting
Check logs:
```bash
docker logs hatunnel
```

View HAProxy stats:
```bash
docker exec hatunnel cat /var/log/haproxy.log
```#