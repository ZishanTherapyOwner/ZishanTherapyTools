#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

select_file_popup() {
    local target_file="$1"
    while true; do
        rm -f "$target_file"
        echo -e "\n${CYAN}[*] Opening File Manager... Please select your file.${NC}"
        termux-storage-get "$target_file"
        echo -e "${YELLOW}[*] Waiting for file selection...${NC}"
        echo -e "${CYAN}    (If screen stays on File Picker, switch back to Termux)${NC}"
        local elapsed=0
        while [ ! -s "$target_file" ]; do
            sleep 1
            elapsed=$((elapsed + 1))
            if [ $elapsed -ge 90 ]; then
                echo -e "\n${RED}[!] File selection timed out.${NC}"
                break
            fi
        done
        am start --user 0 -n com.termux/com.termux.app.TermuxActivity >/dev/null 2>&1
        if [ -s "$target_file" ]; then
            local fsize=$(du -h "$target_file" 2>/dev/null | cut -f1)
            echo -e "\n${GREEN}[✓] File Loaded Successfully! (Size: ${fsize})${NC}"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "[${GREEN}1${NC}] Confirm & Execute"
            echo -e "[${YELLOW}2${NC}] Reselect File (Reset)"
            echo -e "[${RED}0${NC}] Cancel Operation"
            echo -e "${CYAN}----------------------------------------${NC}"
            read -p "Choose an option [1/2/0]: " f_choice
            case $f_choice in
                1) return 0 ;;
                2) echo -e "${YELLOW}[*] Resetting file selection...${NC}"; continue ;;
                *) rm -f "$target_file"; echo -e "${RED}[!] Operation Cancelled.${NC}"; return 1 ;;
            esac
        else
            echo -e "\n${RED}[!] No file was selected or file is empty.${NC}"
            echo -e "[${YELLOW}1${NC}] Try Again   [${RED}0${NC}] Cancel"
            read -p "Choose an option [1/0]: " r_choice
            case $r_choice in
                1) continue ;;
                *) rm -f "$target_file"; echo -e "${RED}[!] Operation Cancelled.${NC}"; return 1 ;;
            esac
        fi
    done
}

download_from_link() {
    local target_file="$1"
    while true; do
        rm -f "$target_file"
        echo ""
        read -p "Paste Google Drive or Direct Download URL (or 0 to cancel): " dl_url
        if [ "$dl_url" = "0" ] || [ -z "$dl_url" ]; then
            echo -e "${RED}[!] Operation Cancelled.${NC}"
            return 1
        fi
        if [[ "$dl_url" == *"drive.google.com"* ]]; then
            file_id=$(echo "$dl_url" | sed -n 's/.*\/d\/\([a-zA-Z0-9_-]*\).*/\1/p')
            [ -z "$file_id" ] && file_id=$(echo "$dl_url" | sed -n 's/.*id=\([a-zA-Z0-9_-]*\).*/\1/p')
            echo -e "${CYAN}[*] Downloading from Google Drive...${NC}"
            curl -L --progress-bar "https://drive.usercontent.google.com/download?id=${file_id}&export=download&confirm=t" -o "$target_file"
        else
            echo -e "${CYAN}[*] Downloading from Direct URL...${NC}"
            curl -L --progress-bar "$dl_url" -o "$target_file"
        fi
        if [ -s "$target_file" ]; then
            local fsize=$(du -h "$target_file" 2>/dev/null | cut -f1)
            echo -e "\n${GREEN}[✓] Download Complete! (Size: ${fsize})${NC}"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "[${GREEN}1${NC}] Confirm & Execute"
            echo -e "[${YELLOW}2${NC}] Enter Different Link (Reset)"
            echo -e "[${RED}0${NC}] Cancel Operation"
            echo -e "${CYAN}----------------------------------------${NC}"
            read -p "Choose an option [1/2/0]: " l_choice
            case $l_choice in
                1) return 0 ;;
                2) continue ;;
                *) rm -f "$target_file"; echo -e "${RED}[!] Operation Cancelled.${NC}"; return 1 ;;
            esac
        else
            echo -e "\n${RED}[!] Download failed or file is empty.${NC}"
            echo -e "[${YELLOW}1${NC}] Try Again   [${RED}0${NC}] Cancel"
            read -p "Choose an option [1/0]: " r_choice
            [ "$r_choice" = "1" ] && continue || return 1
        fi
    done
}

select_drag_file() {
    while true; do
        echo ""
        read -p "Drag & Drop file here or enter full path (0 to cancel): " raw_path
        drag_path=$(echo "$raw_path" | tr -d "'\"")
        if [ "$drag_path" = "0" ] || [ -z "$drag_path" ]; then
            echo -e "${RED}[!] Operation Cancelled.${NC}"
            return 1
        fi
        if [ -f "$drag_path" ]; then
            local fsize=$(du -h "$drag_path" 2>/dev/null | cut -f1)
            echo -e "\n${GREEN}[✓] Selected File:${NC} $drag_path (${fsize})"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "[${GREEN}1${NC}] Confirm & Execute"
            echo -e "[${YELLOW}2${NC}] Reselect File (Reset)"
            echo -e "[${RED}0${NC}] Cancel Operation"
            echo -e "${CYAN}----------------------------------------${NC}"
            read -p "Choose an option [1/2/0]: " d_choice
            case $d_choice in
                1) return 0 ;;
                2) continue ;;
                *) echo -e "${RED}[!] Operation Cancelled.${NC}"; return 1 ;;
            esac
        else
            echo -e "${RED}[!] File not found: $drag_path${NC}"
        fi
    done
}

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
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        2)
            clear
            termux-adb reboot
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        3)
            clear
            yes "Y" | termux-adb reboot recovery
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        4)
            clear
            yes "Y" | termux-adb reboot bootloader
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        5)
            clear
            echo -e "\n--- Device Info ---"
            echo -e "Model: $(timeout 5 termux-adb shell getprop ro.product.model)"
            echo -e "Android: $(timeout 5 termux-adb shell getprop ro.build.version.release)"
            echo -e "Build: $(timeout 5 termux-adb shell getprop ro.build.display.id)"
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
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
    echo -e "[${YELLOW}10${NC}] ${YELLOW}Flash boot${NC}"
    echo -e "[${YELLOW}11${NC}] ${YELLOW}Flash init_boot${NC}"

    echo ""
    echo -e "[${RED}88${NC}] ${RED}Back${NC}   [${CYAN}99${NC}] ${CYAN}Home${NC}   [${RED}00${NC}] ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice
    case $choice in
        1)
            clear
            timeout 10 termux-fastboot devices
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        2)
            clear
            termux-fastboot reboot
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        3)
            clear
            termux-fastboot reboot recovery
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        4)
            clear
            yes "Y" | termux-fastboot reboot fastboot
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        5)
            clear
            termux-fastboot reboot bootloader
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        6)
            clear
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        7)
            clear
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        8)
            clear
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        9)
            clear
            termux-fastboot flashing unlock
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        10)
            clear
            if select_file_popup "zishan_temp_$$.img"; then echo -e "\n${CYAN}[*] Executing command...${NC}"; timeout 10 termux-fastboot flash boot zishan_temp_$$.img; rm -f "zishan_temp_$$.img"; fi
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        11)
            clear
            if select_file_popup "zishan_temp_$$.img"; then echo -e "\n${CYAN}[*] Executing command...${NC}"; timeout 10 termux-fastboot flash init_boot zishan_temp_$$.img; rm -f "zishan_temp_$$.img"; fi
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
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
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
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
