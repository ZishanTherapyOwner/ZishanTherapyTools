#!/bin/bash

# ==========================================
# ANSI Colors Setup (Termux UI Accent)
# ==========================================
C_R='\e[0m'       # Reset
C_H='\e[96m'      # Cyan Highlight
C_T='\e[1;92m'    # Bold Green Title
C_O='\e[93m'      # Yellow Options
C_S='\e[92m'      # Green Success
C_E='\e[91m'      # Red Error
C_I='\e[94m'      # Blue Info

# Target Download Directory on Phone Storage
DL_DIR="/sdcard/Download/ZishanTherapy"

# ==========================================
# Helper Function
# ==========================================
pause_menu() {
    echo ""
    read -p "Press Enter to go back..."
}

# ==========================================
# 1. TERMUX SETUP & DOWNLOAD MENU
# ==========================================
menu_setup() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}   TERMUX SETUP & DOWNLOAD MENU - ZT     ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo "1. Basic Termux Setup"
        echo "2. Install Platform Tools"
        echo "3. Termux Setup Storage"
        echo "4. MiUnlockTool Setup & Open"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo "9. Back to Main Menu"
        echo "0. Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        read -p "Enter your choice: " choice < /dev/tty

        case $choice in
            1)
                clear
                echo -e "${C_I}[*] Running Basic Setup...${C_R}"
                pkg update -y && pkg upgrade -y
                echo -e "${C_S}[✔] Done!${C_R}"
                pause_menu
                ;;
            2)
                clear
                echo -e "${C_I}[*] Installing Android Tools...${C_R}"
                curl -s https://raw.githubusercontent.com/nohajc/termux-adb/master/install.sh | bash
                echo -e "${C_S}[✔] Done!${C_R}"
                pause_menu
                ;;
            3)
                clear
                echo -e "${C_I}[*] Termux Setup Storage...${C_R}"
                termux-setup-storage
                echo -e "${C_S}[✔] Done!${C_R}"
                pause_menu
                ;;
            4)
                clear
                # Checking if MiUnlockTool is already installed
                if command -v miunlock &> /dev/null; then
                    echo -e "${C_S}[✔] MiUnlockTool is already installed! Launching...${C_R}"
                    sleep 1
                    miunlock
                else
                    echo -e "${C_W}[!] MiUnlockTool not found! Installing now...${C_R}"
                    pkg install curl wget termux-api -y
                    curl -sL https://raw.githubusercontent.com/offici5l/MiUnlockTool/main/.install | bash
                    
                    # Double check after installation and launch
                    if command -v miunlock &> /dev/null; then
                        echo -e "${C_S}[✔] Installation Done! Launching MiUnlockTool...${C_R}"
                        sleep 1
                        miunlock
                    else
                        echo -e "${C_E}[!] Error: Setup finished but command path not refreshed.${C_R}"
                        echo -e "${C_I}[*] Please restart Termux or type 'miunlock' manually.${C_R}"
                    fi
                fi
                pause_menu
                ;;
            9)
                break
                ;;
            0)
                exit 0
                ;;
            *)
                echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
        esac
    done
}

# ==========================================
# 2. ADB MENU
# ==========================================
menu_adb() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}         ADB MENU - Zishan Therapy       ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo "1. Check ADB Devices"
        echo "2. Reboot to Recovery"
        echo "3. Reboot to Bootloader"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo "9. Back to Main Menu"
        echo "0. Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        read -p "Enter your choice: " choice

        case $choice in
            1)
                clear
                echo -e "${C_I}[*] Checking connected ADB devices...${C_R}"
                termux-adb devices
                pause_menu
                ;;
            2)
                clear
                echo -e "${C_I}[*] Rebooting to Recovery Mode...${C_R}"
                termux-adb reboot recovery
                pause_menu
                ;;
            3)
                clear
                echo -e "${C_I}[*] Rebooting to Bootloader...${C_R}"
                termux-adb reboot bootloader
                pause_menu
                ;;
            9)
                break
                ;;
            0)
                exit 0
                ;;
            *)
                echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
        esac
    done
}

# ==========================================
# 3. FASTBOOT MENU
# ==========================================
menu_fastboot() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}      FASTBOOT MENU - Zishan Therapy     ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo "1. Check Fastboot Devices"
        echo "2. Reboot to System"
        echo "3. Flash boot"
        echo "4. Flash init_boot"
        echo "5. Run MiUnlockTool (Xiaomi Bootloader)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo "9. Back to Main Menu"
        echo "0. Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        read -p "Enter your choice: " choice

        case $choice in
            1)
                clear
                echo -e "${C_I}[*] Checking connected Fastboot devices...${C_R}"
                timeout 15s termux-fastboot devices
                if [ $? -eq 124 ]; then
                    echo ""
                    echo -e "${C_E}[!] No fastboot device detected or connection timed out!${C_R}"
                fi
                pause_menu
                ;;
            2)
                clear
                echo -e "${C_I}[*] Rebooting device to System...${C_R}"
                timeout 15s termux-fastboot reboot
                if [ $? -eq 124 ]; then
                    echo ""
                    echo -e "${C_E}[!] No fastboot device detected or connection timed out!${C_R}"
                fi
                pause_menu
                ;;
            3)
                clear
                echo -e "${C_I}[*] Flashing boot Image...${C_R}"
                BOOT_IMG="/sdcard/Download/mboot.img"
                if [ -f "$BOOT_IMG" ]; then
                    echo -e "${C_S}[✔] File found: $BOOT_IMG${C_R}"
                    echo -e "${C_I}[*] Checking for connected fastboot device (waiting 3s)...${C_R}"
                    timeout 15s termux-fastboot devices > /dev/null 2>&1
                    if [ $? -eq 124 ]; then
                        echo ""
                        echo -e "${C_E}[!] Error: No fastboot device detected!${C_R}"
                    else
                        echo -e "${C_S}[✔] Device detected!${C_R}"
                        echo -e "${C_I}[*] Flashing in progress. Please do not disconnect...${C_R}"
                        termux-fastboot flash boot "$BOOT_IMG"
                        echo -e "${C_S}[✔] Flashing process finished!${C_R}"
                    fi
                else
                    echo ""
                    echo -e "${C_E}[!] Error: mboot.img file not found in Downloads folder!${C_R}"
                fi
                pause_menu
                ;;
            4)
                clear
                echo -e "${C_I}[*] Flashing init_boot Image...${C_R}"
                INIT_BOOT_IMG="/sdcard/Download/minit_boot.img"
                if [ -f "$INIT_BOOT_IMG" ]; then
                    echo -e "${C_S}[✔] File found: $INIT_BOOT_IMG${C_R}"
                    echo -e "${C_I}[*] Checking for connected fastboot device (waiting 3s)...${C_R}"
                    timeout 15s termux-fastboot devices > /dev/null 2>&1
                    if [ $? -eq 124 ]; then
                        echo ""
                        echo -e "${C_E}[!] Error: No fastboot device detected!${C_R}"
                    else
                        echo -e "${C_S}[✔] Device detected!${C_R}"
                        echo -e "${C_I}[*] Flashing in progress. Please do not disconnect...${C_R}"
                        termux-fastboot flash init_boot "$INIT_BOOT_IMG"
                        echo -e "${C_S}[✔] Flashing process finished!${C_R}"
                    fi
                else
                    echo ""
                    echo -e "${C_E}[!] Error: minit_boot.img file not found in Downloads folder!${C_R}"
                fi
                pause_menu
                ;;
            5)
                clear
                echo -e "${C_I}[*] Launching MiUnlockTool...${C_R}"
                if command -v miunlock &> /dev/null; then
                    miunlock
                else
                    echo -e "${C_E}[!] MiUnlockTool is not installed!${C_R}"
                    echo -e "${C_I}[*] Please go to 'Termux Setup & Download Menu' and select option 4 first.${C_R}"
                fi
                pause_menu
                ;;
            9)
                break
                ;;
            0)
                exit 0
                ;;
            *)
                echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
        esac
    done
}

# ==========================================
# 4. DOWNLOAD MENU (Direct to Phone Storage)
# ==========================================
menu_download() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}      DOWNLOAD MENU - Zishan Therapy     ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo "1. Download Root Checker (APK)"
        echo "2. Download Kitsune Mask (APK)"
        echo "3. Download Termux API (APK)"
        echo "4. Download Termux App (APK)"
        echo "5. Download MagiskHideProps Module (ZIP)"
        echo "6. Download MultipleAccounts (APK)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo "9. Back to Main Menu"
        echo "0. Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        read -p "Enter your choice: " choice

        # Create destination directory dynamically
        mkdir -p "$DL_DIR"

        case $choice in
            1)
                clear
                echo -e "${C_I}[*] Downloading Root Checker APK...${C_R}"
                curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/root-checker-6-5-3.apk" -o "$DL_DIR/RootChecker.apk"
                echo -e "\n${C_S}[✔] File saved to: $DL_DIR/RootChecker.apk${C_R}"
                pause_menu
                ;;
            2)
                clear
                echo -e "${C_I}[*] Downloading Kitsune Mask APK...${C_R}"
                curl -L "https://github.com/HuskyDG/magisk-files/releases/download/1c93a02d-v26.1/app-release.apk" -o "$DL_DIR/KitsuneMask.apk"
                echo -e "\n${C_S}[✔] File saved to: $DL_DIR/KitsuneMask.apk${C_R}"
                pause_menu
                ;;
            3)
                clear
                echo -e "${C_I}[*] Downloading Termux API APK...${C_R}"
                curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux.api_1002.apk" -o "$DL_DIR/TermuxAPI.apk"
                echo -e "\n${C_S}[✔] File saved to: $DL_DIR/TermuxAPI.apk${C_R}"
                pause_menu
                ;;
            4)
                clear
                echo -e "${C_I}[*] Downloading Termux App APK...${C_R}"
                curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux_1022.apk" -o "$DL_DIR/Termux.apk"
                echo -e "\n${C_S}[✔] File saved to: $DL_DIR/Termux.apk${C_R}"
                pause_menu
                ;;
            5)
                clear
                echo -e "${C_I}[*] Downloading MagiskHideProps Module ZIP...${C_R}"
                curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MagiskHidePropsConf-v6.1.2.zip" -o "$DL_DIR/MagiskHideProps.zip"
                echo -e "\n${C_S}[✔] File saved to: $DL_DIR/MagiskHideProps.zip${C_R}"
                pause_menu
                ;;
            6)
                clear
                echo -e "${C_I}[*] Downloading MultipleAccounts APK...${C_R}"
                curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MultipleAccounts.apk" -o "$DL_DIR/MultipleAccounts.apk"
                echo -e "\n${C_S}[✔] File saved to: $DL_DIR/MultipleAccounts.apk${C_R}"
                pause_menu
                ;;
            9)
                break
                ;;
            0)
                exit 0
                ;;
            *)
                echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
        esac
    done
}

# ==========================================
# MAIN MENU
# ==========================================
while true; do
    clear
    echo -e "${C_H}=========================================${C_R}"
    echo -e "${C_T}             Zishan Therapy              ${C_R}"
    echo -e "${C_H}=========================================${C_R}"
    echo "1. Termux Setup & Download Menu"
    echo "2. ADB Menu"
    echo "3. Fastboot Menu"
    echo "4. Download Menu"
    echo -e "${C_H}-----------------------------------------${C_R}"
    echo "0. Exit Tool"
    echo -e "${C_H}=========================================${C_R}"
    read -p "Select Category: " main_choice

    case $main_choice in
        1)
            menu_setup
            ;;
        2)
            menu_adb
            ;;
        3)
            menu_fastboot
            ;;
        4)
            menu_download
            ;;
        0)
            clear
            echo "Exiting Master Tool..."
            exit 0
            ;;
        *)
            echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2
            ;;
    esac
done
