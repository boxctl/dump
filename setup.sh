#!/usr/bin/env bash
# this script will be run by a normal sudo user
# curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/setup.sh" | bash

if ! sudo -v; then
  echo "sudo auth failed"
  exit 1
fi

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

set -euo pipefail

COLORTERM="${COLORTERM:-}"
ANGIE_DIR="$HOME/boxctl/angie"
DOMAIN=""

if [[ "$COLORTERM" == "truecolor" || "$COLORTERM" == "24bit" ]]; then
  RED='\033[38;2;220;50;50m'
  GREEN='\033[38;2;50;220;100m'
  BLUE='\033[38;2;50;150;255m'
  YELLOW='\033[38;2;255;220;50m'
  ACCENT='\033[38;2;234;88;12m'
  RESET='\033[0m'
else
  RED='\033[0;31m'
  GREEN='\033[1;32m'
  BLUE='\033[0;34m'
  YELLOW='\033[1;33m'
  ACCENT='\033[0;33m'
  RESET='\033[0m'
fi

step() { echo -e "${GREEN}▶ $1${RESET}"; }

echo -e "${ACCENT}
  ▄█▄▄▄█▄    
▄█       █▄  ${RESET}█▄▄ ▄▄▄ ▄ ▄  ▄▄ █▄ █${ACCENT}
██ ▐▌ ▐▌ ██  ${RESET}█ █ █ █  █  █   █  █${ACCENT}
 ▀▄▄▄▄▄▄▄▀   ${RESET}▀▀▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀▀  ▀${RESET}
"

step "Updating repo"
sudo apt-get update

step "Enabling ip_unprivileged_port_start"
echo "net.ipv4.ip_unprivileged_port_start=80" | sudo tee /etc/sysctl.d/99-boxctl-unprivileged-ports.conf
sudo sysctl --system

step "Installing build-essential"
sudo apt-get install -y build-essential


step "Enabling linger"
sudo loginctl enable-linger "$USER"

step "Installing podman"
sudo apt-get install -y podman

step "Installing angie container"
mkdir -p "$ANGIE_DIR/http.d"
mkdir -p "$ANGIE_DIR/logs"
mkdir -p "$ANGIE_DIR/acme"
mkdir -p "$ANGIE_DIR/html"
echo "Welcome to Boxctl" > "$ANGIE_DIR/html/default.html"
podman run --rm docker.angie.software/angie:minimal cat /etc/angie/angie.conf > "$ANGIE_DIR/angie.conf"
podman network create boxctl
podman run -d \
  --name boxctl-angie \
  --network boxctl \
  -p 80:80 \
  -p 443:443 \
  -p 443:443/udp \
  -v "$ANGIE_DIR/angie.conf:/etc/angie/angie.conf:ro" \
  -v "$ANGIE_DIR/http.d:/etc/angie/http.d:ro" \
  -v "$ANGIE_DIR/logs:/var/log/angie" \
  -v "$ANGIE_DIR/html:/etc/angie/html:ro" \
  -v "$ANGIE_DIR/acme:/var/lib/angie/acme" \
  docker.angie.software/angie:minimal

step "Creating a default angie vhost"
cat > "$ANGIE_DIR/http.d/000.boxctl.default.conf" << 'EOF'
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

map $http_cf_connecting_ip $real_client_ip {
    default $http_cf_connecting_ip;
    ""      $remote_addr;
}

resolver 8.8.8.8 1.1.1.1 valid=300s ipv6=off;
resolver_timeout 5s;

acme_client letsencrypt https://acme-v02.api.letsencrypt.org/directory;

server {
    listen 80 default_server;
    server_name _;
    root /etc/angie/html;
    location / {
        try_files /default.html =444;
    }
}
EOF

step "Creating boxctl server vhost"
read -rp "Domain for boxctl GUI: " DOMAIN < /dev/tty
cat > "$ANGIE_DIR/http.d/$DOMAIN.conf" << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    return 301 https://$DOMAIN\$request_uri;
}

server {
    listen 443 ssl;
    listen 443 quic;
    server_name www.$DOMAIN;
    acme letsencrypt;
    ssl_certificate \$acme_cert_letsencrypt;
    ssl_certificate_key \$acme_cert_key_letsencrypt;
    return 301 https://$DOMAIN\$request_uri;
}

server {
    listen 443 ssl;
    listen 443 quic;
    server_name $DOMAIN;
    acme letsencrypt;
    ssl_certificate \$acme_cert_letsencrypt;
    ssl_certificate_key \$acme_cert_key_letsencrypt;

    add_header Alt-Svc 'h3=":443"; ma=86400';

    location / {
        proxy_pass http://host.containers.internal:8008;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_set_header X-Forwarded-For \$real_client_ip;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

step "Reloading angie"
podman exec boxctl-angie angie -s reload
