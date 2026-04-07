#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
RESET='\033[0m'

step() { echo -e "${GREEN}▶ $1${RESET}"; }

echo -e "${ORANGE}
  ▄█▄▄▄█▄    
▄█       █▄  ${RESET}█▄▄ ▄▄▄ ▄ ▄  ▄▄ █▄ █${ORANGE}
██ ▐▌ ▐▌ ██  ${RESET}█ █ █ █  █  █   █  █${ORANGE}
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
