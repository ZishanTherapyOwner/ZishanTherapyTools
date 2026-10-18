#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

main_menu() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}-------------- ${GREEN}ZishanTech ${CYAN}--------------${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "1. ${YELLOW}Master Setup${NC}"

    echo -e "88. ${RED}Back${NC}"
    echo -e "99. ${CYAN}Home${NC}"
    echo -e "00. ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice
    case $choice in
        1)
            clear
            pkg update -y && pkg upgrade -y
            yes | curl -s https://raw.githubusercontent.com/nohajc/termux-adb/master/install.sh | bash
            yes | termux-setup-storage
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        88) echo -e "\n${YELLOW}Already in Home Menu!${NC}"; sleep 1 ;;
        99) continue ;;
        00) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}

# --- Start Script ---
main_menu
