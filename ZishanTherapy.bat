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
C_W='\e[95m'      # Magenta Warning

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
        echo -e "${C_O}   DOWNLOAD & AUTO-INSTALL MENU (OTG)    ${C_R}"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo "5. Install Magisk Manager (APK)"
        echo "6. Install Kitsune Mask (APK)"
        echo "7. Install Root Checker (APK)"
        echo "8. Install MultipleAccounts (APK)"
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
                    echo -e "${C_W}[!] TIP: To exit MiUnlockTool and return here, press 'CTRL + C' (or Vol Down + C).${C_R}"
                    sleep 3
                    miunlock
                else
                    echo -e "${C_W}[!] MiUnlockTool not found! Installing now...${C_R}"
                    pkg install curl wget termux-api -y
                    curl -sL https://raw.githubusercontent.com/offici5l/MiUnlockTool/main/.install | bash
                    
                    if command -v miunlock &> /dev/null; then
                        echo -e "${C_S}[✔] Installation Done! Launching MiUnlockTool...${C_R}"
                        echo -e "${C_W}[!] TIP: To exit MiUnlockTool and return here, press 'CTRL + C' (or Vol Down + C).${C_R}"
                        sleep 3
                        miunlock
                    else
                        echo -e "${C_E}[!] Error: Setup finished but command path not refreshed.${C_R}"
                        echo -e "${C_I}[*] Please restart Termux or type 'miunlock' manually.${C_R}"
                    fi
                fi
                pause_menu
                ;;
            5)
                clear
                mkdir -p "$DL_DIR"
                echo -e "${C_I}[*] Fetching Latest Magisk Manager...${C_R}"
                MAGISK_URL=$(curl -s https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep "browser_download_url" | grep "\.apk" | cut -d '"' -f 4 | head -n 1)
                
                if [ -z "$MAGISK_URL" ]; then
                    echo -e "${C_E}[!] Fetch Failed! Check internet connection.${C_R}"
                else
                    echo -e "${C_I}[*] Downloading to ZishanTherapy Folder...${C_R}"
                    curl -L "$MAGISK_URL" -o "$DL_DIR/MagiskManager.apk"
                    
                    if [ -f "$DL_DIR/MagiskManager.apk" ]; then
                        echo -e "${C_S}[✔] Download Done! Installing to connected device...${C_R}"
                        termux-adb install -r "$DL_DIR/MagiskManager.apk"
                        
                        echo -e "${C_I}[*] Deleting APK from local storage...${C_R}"
                        rm -f "$DL_DIR/MagiskManager.apk"
                        echo -e "${C_S}[✔] Cleanup Successful!${C_R}"
                    fi
                fi
                pause_menu
                ;;
            6)
                clear
                mkdir -p "$DL_DIR"
                echo -e "${C_I}[*] Downloading Kitsune Mask...${C_R}"
                curl -L "https://github.com/HuskyDG/magisk-files/releases/download/1c93a02d-v26.1/app-release.apk" -o "$DL_DIR/KitsuneMask.apk"
                
                if [ -f "$DL_DIR/KitsuneMask.apk" ]; then
                    echo -e "${C_S}[✔] Download Done! Installing to connected device...${C_R}"
                    termux-adb install -r "$DL_DIR/KitsuneMask.apk"
                    
                    echo -e "${C_I}[*] Deleting APK from local storage...${C_R}"
                    rm -f "$DL_DIR/KitsuneMask.apk"
                    echo -e "${C_S}[✔] Cleanup Successful!${C_R}"
                fi
                pause_menu
                ;;
            7)
                clear
                mkdir -p "$DL_DIR"
                echo -e "${C_I}[*] Downloading Root Checker...${C_R}"
                curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/root-checker-6-5-3.apk" -o "$DL_DIR/RootChecker.apk"
                
                if [ -f "$DL_DIR/RootChecker.apk" ]; then
                    echo -e "${C_S}[✔] Download Done! Installing to connected device...${C_R}"
                    termux-adb install -r "$DL_DIR/RootChecker.apk"
                    
                    echo -e "${C_I}[*] Deleting APK from local storage...${C_R}"
                    rm -f "$DL_DIR/RootChecker.apk"
                    echo -e "${C_S}[✔] Cleanup Successful!${C_R}"
                fi
                pause_menu
                ;;
            8)
                clear
                mkdir -p "$DL_DIR"
                echo -e "${C_I}[*] Downloading MultipleAccounts...${C_R}"
                curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MultipleAccounts.apk" -o "$DL_DIR/MultipleAccounts.apk"
                
                if [ -f "$DL_DIR/MultipleAccounts.apk" ]; then
                    echo -e "${C_S}[✔] Download Done! Installing to connected device...${C_R}"
                    termux-adb install -r "$DL_DIR/MultipleAccounts.apk"
                    
                    echo -e "${C_I}[*] Deleting APK from local storage...${C_R}"
                    rm -f "$DL_DIR/MultipleAccounts.apk"
                    echo -e "${C_S}[✔] Cleanup Successful!${C_R}"
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
                    echo -e "${C_W}[!] TIP: To exit MiUnlockTool and return here, press 'CTRL + C' (or Vol Down + C).${C_R}"
                    sleep 3
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
