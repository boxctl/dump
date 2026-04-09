#!/usr/bin/env bash
# curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/colortest.sh" | bash
BOLD='\033[1m'
RED='\033[38;2;239;68;68m' #239 68 68
GREEN='\033[38;2;16;185;129m' #16 185 129
BLUE='\033[38;2;59;130;246m' #59 130 246
YELLOW='\033[38;2;250;204;21m' #250 204 21
ACCENT='\033[38;2;234;88;12m'
RESET='\033[0m'

echo -e "${BOLD}${RED}True RED${RESET}"
echo -e "${BOLD}${GREEN}True GREEN${RESET}"
echo -e "${BOLD}${BLUE}True BLUE${RESET}"
echo -e "${BOLD}${YELLOW}True YELLOW${RESET}"
echo -e "${BOLD}${ACCENT}True ACCENT${RESET}"

echo ""

echo -e "${RED}True RED${RESET}"
echo -e "${GREEN}True GREEN${RESET}"
echo -e "${BLUE}True BLUE${RESET}"
echo -e "${YELLOW}True YELLOW${RESET}"
echo -e "${ACCENT}True ACCENT${RESET}"
