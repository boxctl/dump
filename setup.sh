#!/usr/bin/env bash
# this script will be run by a normal sudo user
# curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/setup.sh?v=$(date +%s)" | sudo -E bash

set -euo pipefail

COLORTERM="${COLORTERM:-}"
ANGIE_DIR="$HOME/boxctl/angie"

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

[ "$EUID" -eq 0 ] && [ -z "$SUDO_USER" ] && echo -e "${RED}Run as sudo user, not root directly${RESET}" && exit 1
[ "$EUID" -ne 0 ] && echo -e "${RED}Run with sudo${RESET}" && exit 1

step "Updating system"
apt-get update
apt-get upgrade -y

step "Enabling ip_unprivileged_port_start"
echo "net.ipv4.ip_unprivileged_port_start=80" | tee /etc/sysctl.d/99-boxctl-unprivileged-ports.conf && sysctl -p /etc/sysctl.d/99-boxctl-unprivileged-ports.conf

step "Installing build-essential"
apt-get install -y build-essential


step "Enabling linger"
loginctl enable-linger "$SUDO_USER"

step "Installing podman"
apt-get install -y podman

step "Installing angie container"
mkdir -p "$ANGIE_DIR/http.d"
mkdir -p "$ANGIE_DIR/logs"
mkdir -p "$ANGIE_DIR/certs"
mkdir -p "$ANGIE_DIR/html"
echo "Welcome to Boxctl" > "$ANGIE_DIR/html/default.html"
podman run --rm docker.angie.software/angie:minimal cat /etc/angie/angie.conf > "$ANGIE_DIR/angie.conf"
podman network create boxctl
podman run -d \
  --name boxctl-angie \
  --network boxctl \
  -p 80:80 \
  -p 443:443 \
  -v "$ANGIE_DIR/angie.conf:/etc/angie/angie.conf:ro" \
  -v "$ANGIE_DIR/http.d:/etc/angie/http.d:ro" \
  -v "$ANGIE_DIR/logs:/var/log/angie" \
  -v "$ANGIE_DIR/certs:/etc/angie/certs:ro" \
  -v "$ANGIE_DIR/html:/etc/angie/html:ro" \
  docker.angie.software/angie:minimal

step "Creating a default angie vhost"
cat > "$ANGIE_DIR/http.d/default.conf" << 'EOF'
server {
    listen 80 default_server;
    listen 443 default_server;
    root /etc/angie/html;
    location / {
        try_files /default.html =444;
    }
}
EOF
