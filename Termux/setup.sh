#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

menu_2() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}--------------- ${GREEN}ADB Menu ${CYAN}---------------${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "[${YELLOW}1${NC}] ${YELLOW}Check ADB Devices${NC}"
    echo -e "${CYAN}--------- ${BLUE}--- Reboot Menu ---${NC} ${CYAN}----------${NC}"
    echo -e "[${YELLOW}2${NC}] ${YELLOW}Reboot Normal${NC}"
    echo -e "[${YELLOW}3${NC}] ${YELLOW}Reboot Recovey${NC}"
    echo -e "[${YELLOW}4${NC}] ${YELLOW}Reboot Bootloader${NC}"
    echo -e "${CYAN}---------- ${BLUE}--- Extra Menu ---${NC} ${CYAN}----------${NC}"
    echo -e "[${YELLOW}5${NC}] ${YELLOW}Check Device Info${NC}"

    echo ""
    echo -e "[${RED}88${NC}] ${RED}Back${NC}   [${CYAN}99${NC}] ${CYAN}Home${NC}   [${RED}00${NC}] ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice
    case $choice in
        1)
            clear
            yes "Y" | termux-adb devices
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        2)
            clear
            termux-adb reboot
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        3)
            clear
            yes "Y" | termux-adb reboot recovery
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        4)
            clear
            yes "Y" | termux-adb reboot bootloader
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        5)
            clear
            echo -e "\n--- Device Info ---"
            echo "Model: $(termux-adb shell getprop ro.product.model)"
            echo "Android: $(termux-adb shell getprop ro.build.version.release)"
            echo "Build: $(termux-adb shell getprop ro.build.display.id)"
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        88) return ;;
        99) main_menu ;;
        00) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}

menu_3() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}------------ ${GREEN}Fastboot Menu ${CYAN}-------------${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "[${YELLOW}1${NC}] ${YELLOW}Check Fastboot Devicess${NC}"
    echo -e "${CYAN}--------- ${BLUE}--- Reboot Menu ---${NC} ${CYAN}----------${NC}"
    echo -e "[${YELLOW}2${NC}] ${YELLOW}Reboot to System${NC}"
    echo -e "[${YELLOW}3${NC}] ${YELLOW}Reboot to Recovery${NC}"
    echo -e "[${YELLOW}4${NC}] ${YELLOW}Reboot to FastbootD${NC}"
    echo -e "[${YELLOW}5${NC}] ${YELLOW}Reboot to Bootloader${NC}"
    echo -e "${CYAN}----- ${BLUE}--- Device Informations ---${NC} ${CYAN}------${NC}"
    echo -e "[${YELLOW}6${NC}] ${YELLOW}Get Product Name${NC}"
    echo -e "[${YELLOW}7${NC}] ${YELLOW}Check Bootloader Unlock Status${NC}"
    echo -e "[${YELLOW}8${NC}] ${YELLOW}Get All Variables${NC}"
    echo -e "${CYAN}------ ${BLUE}--- Bootloader Unlock ---${NC} ${CYAN}-------${NC}"
    echo -e "[${YELLOW}9${NC}] ${YELLOW}Unlock Bootloader (All Device)${NC}"
    echo -e "${CYAN}---------- ${BLUE}--- Flash Menu ---${NC} ${CYAN}----------${NC}"

    echo ""
    echo -e "[${RED}88${NC}] ${RED}Back${NC}   [${CYAN}99${NC}] ${CYAN}Home${NC}   [${RED}00${NC}] ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice
    case $choice in
        1)
            clear
            termux-fastboot devices
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        2)
            clear
            termux-fastboot reboot
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        3)
            clear
            termux-fastboot reboot recovery
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        4)
            clear
            yes "Y" | termux-fastboot reboot fastboot
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        5)
            clear
            termux-fastboot reboot bootloader
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        6)
            clear
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        7)
            clear
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        8)
            clear
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        9)
            clear
            termux-fastboot flashing unlock
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        88) return ;;
        99) main_menu ;;
        00) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}

main_menu() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}-------------- ${GREEN}ZishanTech ${CYAN}--------------${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "[${YELLOW}1${NC}] ${YELLOW}Master Setup${NC}"
    echo -e "[${YELLOW}2${NC}] ${CYAN}ADB Menu${NC}"
    echo -e "[${YELLOW}3${NC}] ${CYAN}Fastboot Menu${NC}"

    echo ""
    echo -e "[${RED}88${NC}] ${RED}Back${NC}   [${CYAN}99${NC}] ${CYAN}Home${NC}   [${RED}00${NC}] ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice
    case $choice in
        1)
            clear
            DEBIAN_FRONTEND=noninteractive yes "Y" | pkg update -y && pkg upgrade -y -o Dpkg::Options::="--force-confnew"
            yes "Y" | curl -s https://raw.githubusercontent.com/nohajc/termux-adb/master/install.sh | bash
            yes "Y" | termux-setup-storage
            echo -e "\n\n${CYAN}Task Completed!${NC}"
            read -p "Press Enter to continue..." ;;
        2)
            menu_2 ;;
        3)
            menu_3 ;;
        88) echo -e "\n${YELLOW}Already in Home Menu!${NC}"; sleep 1 ;;
        99) continue ;;
        00) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}

# --- Start Script ---
main_menu
