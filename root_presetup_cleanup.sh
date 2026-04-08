#!/usr/bin/env bash
# this script will be run root user. It just deletes the default user.
# curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/root_presetup_cleanup.sh" | bash
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

step "Cleaning processes"
pkill -u boxadmin

step "Removing boxadmin user"
userdel -r boxadmin

step "Cleaning up ip_unprivileged_port_start"
rm -f /etc/sysctl.d/99-boxctl-unprivileged-ports.conf
sysctl --system
