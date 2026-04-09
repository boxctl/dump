#!/usr/bin/env bash
# curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/colortest.sh" | bash

RED='\033[38;2;220;38;38m'
GREEN='\033[38;2;34;197;94m'
BLUE='\033[38;2;37;99;235m'
YELLOW='\033[38;2;234;179;8m'
ACCENT='\033[38;2;234;88;12m'
RESET='\033[0m'

echo -e "${RED}True RED${RESET}"
echo -e "${GREEN}True GREEN${RESET}"
echo -e "${BLUE}True BLUE${RESET}"
echo -e "${YELLOW}True YELLOW${RESET}"
echo -e "${ACCENT}True ACCENT${RESET}"

RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
ACCENT='\033[0;33m'
RESET='\033[0m'

echo -e "${RED}8-Bit RED${RESET}"
echo -e "${GREEN}8-Bit GREEN${RESET}"
echo -e "${BLUE}8-Bit BLUE${RESET}"
echo -e "${YELLOW}8-Bit YELLOW${RESET}"
echo -e "${ACCENT}8-Bit ACCENT${RESET}"
