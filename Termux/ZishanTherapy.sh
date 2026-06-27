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
# 1. TERMUX SETUP MENU
# ==========================================
menu_setup() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}           TERMUX SETUP MENU             ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo "1. Basic Termux Setup"
        echo "2. Install Platform Tools"
        echo "3. Termux Setup Storage"
        echo "4. MiUnlockTool Setup & Open"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_E}[99]${C_R} Back to Main Menu"
        echo -e " ${C_E}[0]${C_R} Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        echo -ne "${C_O}Enter your choice:${C_R} "
        read choice < /dev/tty

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
            99)
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
# 2. DOWNLOAD & INSTALL MENU (OTG)
# ==========================================
menu_download() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}        DOWNLOAD & INSTALL MENU          ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo "1. Install Magisk Manager (APK)"
        echo "2. Install Kitsune Mask (APK)"
        echo "3. Install Root Checker (APK)"
        echo "4. Install MultipleAccounts (APK)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_E}[99]${C_R} Back to Main Menu"
        echo -e " ${C_E}[0]${C_R} Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        echo -ne "${C_O}Enter your choice:${C_R} "
        read choice

        # Create destination directory dynamically
        mkdir -p "$DL_DIR"

        case $choice in
            1)
                clear
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
            2)
                clear
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
            3)
                clear
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
            4)
                clear
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
            99)
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
    echo "1. Termux Setup Menu"
    echo "2. Download & Install Menu"
    echo -e "${C_H}-----------------------------------------${C_R}"
    echo -e " ${C_E}[0]${C_R} Exit Tool"
    echo -e "${C_H}=========================================${C_R}"
    echo -ne "${C_O}Enter your choice:${C_R} "
    read main_choice

    case $main_choice in
        1)
            menu_setup
            ;;
        2)
            menu_download
            ;;
        0)
            clear
            echo -e "${C_I}Exiting Master Tool...${C_R}"
            exit 0
            ;;
        *)
            echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2
            ;;
    esac
done
