#!/usr/bin/env bash
# this script will be run root user before anything else. It just creates a default user for testing
# curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/root_presetup.sh" | bash

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

step "Creating user boxadmin"
useradd -m -s /bin/bash -G sudo boxadmin

step "Setting up .ssh directory"
mkdir -p /home/boxadmin/.ssh

step "Copying authorized_keys"
cp /root/.ssh/authorized_keys /home/boxadmin/.ssh/authorized_keys

step "Setting ownership"
chown -R boxadmin:boxadmin /home/boxadmin/.ssh

step "Setting permissions"
chmod 700 /home/boxadmin/.ssh
chmod 600 /home/boxadmin/.ssh/authorized_keys

echo -e "Set password using : ${YELLOW}passwd boxadmin${RESET}"
