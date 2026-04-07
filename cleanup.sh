#!/usr/bin/env bash

set -euo pipefail

COLORTERM="${COLORTERM:-}"

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

step "Cleaning up ip_unprivileged_port_start"
sudo rm /etc/sysctl.d/99-boxctl-unprivileged-ports.conf && sudo sysctl -w net.ipv4.ip_unprivileged_port_start=1024
