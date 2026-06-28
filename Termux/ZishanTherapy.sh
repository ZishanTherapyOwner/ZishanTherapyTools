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
            99) break ;;
            0) exit 0 ;;
            *) echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
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
        echo "4. Install MultipleAccounts (Normal)"
        echo "5. Install MultipleAccounts (Bypass Low SDK)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_E}[99]${C_R} Back to Main Menu"
        echo -e " ${C_E}[0]${C_R} Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        echo -ne "${C_O}Enter your choice:${C_R} "
        read choice

        mkdir -p "$DL_DIR"

        case $choice in
            1)
                clear
                APK_PATH="$DL_DIR/MagiskManager.apk"
                if [ ! -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Fetching Latest Magisk Manager...${C_R}"
                    MAGISK_URL=$(curl -s https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep "browser_download_url" | grep "\.apk" | cut -d '"' -f 4 | head -n 1)
                    if [ -z "$MAGISK_URL" ]; then echo -e "${C_E}[!] Fetch Failed! Check internet connection.${C_R}"; else
                        echo -e "${C_I}[*] Downloading to ZishanTherapy Folder...${C_R}"
                        curl -L "$MAGISK_URL" -o "$APK_PATH"
                    fi
                else
                    echo -e "${C_S}[✔] MagiskManager.apk already exists! Skipping download...${C_R}"
                fi

                if [ -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Installing to connected device via OTG...${C_R}"
                    termux-adb install -r "$APK_PATH"
                    echo -e "${C_S}[✔] Installation Process Finished!${C_R}"
                fi
                pause_menu
                ;;
            2)
                clear
                APK_PATH="$DL_DIR/KitsuneMask.apk"
                if [ ! -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Downloading Kitsune Mask...${C_R}"
                    curl -L "https://github.com/HuskyDG/magisk-files/releases/download/1c93a02d-v26.1/app-release.apk" -o "$APK_PATH"
                else
                    echo -e "${C_S}[✔] KitsuneMask.apk already exists! Skipping download...${C_R}"
                fi

                if [ -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Installing to connected device via OTG...${C_R}"
                    termux-adb install -r "$APK_PATH"
                    echo -e "${C_S}[✔] Installation Process Finished!${C_R}"
                fi
                pause_menu
                ;;
            3)
                clear
                APK_PATH="$DL_DIR/RootChecker.apk"
                if [ ! -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Downloading Root Checker...${C_R}"
                    curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/root-checker-6-5-3.apk" -o "$APK_PATH"
                else
                    echo -e "${C_S}[✔] RootChecker.apk already exists! Skipping download...${C_R}"
                fi

                if [ -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Installing to connected device via OTG...${C_R}"
                    termux-adb install -r "$APK_PATH"
                    echo -e "${C_S}[✔] Installation Process Finished!${C_R}"
                fi
                pause_menu
                ;;
            4)
                clear
                APK_PATH="$DL_DIR/MultipleAccounts.apk"
                if [ ! -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Downloading MultipleAccounts...${C_R}"
                    curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MultipleAccounts.apk" -o "$APK_PATH"
                else
                    echo -e "${C_S}[✔] MultipleAccounts.apk already exists! Skipping download...${C_R}"
                fi

                if [ -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Installing to connected device via OTG (Normal)...${C_R}"
                    termux-adb install -r "$APK_PATH"
                    echo -e "${C_S}[✔] Installation Process Finished!${C_R}"
                fi
                pause_menu
                ;;
            5)
                clear
                APK_PATH="$DL_DIR/MultipleAccounts.apk"
                if [ ! -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Downloading MultipleAccounts...${C_R}"
                    curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MultipleAccounts.apk" -o "$APK_PATH"
                else
                    echo -e "${C_S}[✔] MultipleAccounts.apk already exists! Skipping download...${C_R}"
                fi

                if [ -f "$APK_PATH" ]; then
                    echo -e "${C_I}[*] Installing to connected device via OTG (Bypass Low SDK)...${C_R}"
                    termux-adb install --bypass-low-target-sdk-block "$APK_PATH"
                    echo -e "${C_S}[✔] Installation Process Finished!${C_R}"
                fi
                pause_menu
                ;;
            99) break ;;
            0) exit 0 ;;
            *) echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
        esac
    done
}

# ==========================================
# 3. ADB MENU
# ==========================================
menu_adb() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}         ADB MENU - Zishan Therapy       ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo -e " ${C_O}[1]${C_R} Check ADB Devices"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_O}[2]${C_R} Reboot to System (Normal)"
        echo -e " ${C_O}[3]${C_R} Reboot to Recovery"
        echo -e " ${C_O}[4]${C_R} Reboot to Bootloader"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_O}[5]${C_R} Enable Multiuser (Permanent via Magisk)"
        echo -e " ${C_O}[6]${C_R} Get ADB Device Info (Version/Build)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_E}[99]${C_R} Back to Main Menu"
        echo -e " ${C_E}[0]${C_R} Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        echo -ne "${C_O}Enter your choice:${C_R} "
        read choice

        case $choice in
            1)
                clear
                echo -e "${C_I}[*] Checking connected ADB devices...${C_R}"
                termux-adb devices
                pause_menu
                ;;
            2)
                clear
                echo -e "${C_I}[*] Rebooting device to System...${C_R}"
                termux-adb reboot
                pause_menu
                ;;
            3)
                clear
                echo -e "${C_I}[*] Rebooting to Recovery Mode...${C_R}"
                termux-adb reboot recovery
                pause_menu
                ;;
            4)
                clear
                echo -e "${C_I}[*] Rebooting to Bootloader...${C_R}"
                termux-adb reboot bootloader
                pause_menu
                ;;
            5)
                clear
                echo -e "${C_H}===================================================${C_R}"
                echo -e "${C_T}      ENABLE MULTIUSER (Permanent via Magisk)      ${C_R}"
                echo -e "${C_H}===================================================${C_R}"
                echo ""
                echo -ne "${C_O}--> Enter maximum user limit (e.g., 4, 10, 100): ${C_R}"
                read user_count
                if [ -z "$user_count" ]; then user_count=4; fi

                clear
                echo -e "${C_I}[*] Checking Root Access...${C_R}"
                echo -e "${C_W}[!] PLEASE UNLOCK TARGET PHONE SCREEN AND TAP 'GRANT' IF PROMPTED!${C_R}\n"

                termux-adb shell "su -c 'echo ROOT_GRANTED'" > root_check.tmp 2>/dev/null
                if ! grep -q "ROOT_GRANTED" root_check.tmp; then
                    echo -e "${C_E}---------------------------------------------------${C_R}"
                    echo -e "${C_E}[X] ERROR: Root Permission Denied or Timed Out!${C_R}"
                    echo -e "${C_E}[!] Magisk did not get permission.${C_R}"
                    echo -e "${C_E}Please try this option again and tap 'Grant' quickly.${C_R}"
                    echo -e "${C_E}---------------------------------------------------${C_R}\n"
                    rm -f root_check.tmp
                    pause_menu
                    continue
                fi
                rm -f root_check.tmp

                echo -e "${C_S}[✔] Root Access Confirmed!${C_R}"
                echo -e "${C_I}[*] Injecting Magisk Boot Script...${C_R}\n"

                termux-adb shell "su -c 'settings put global fw.max_users $user_count'"
                termux-adb shell "su -c 'settings put global fw.show_multiuserui 1'"
                termux-adb shell "su -c 'echo \"#!/system/bin/sh\" > /data/adb/post-fs-data.d/zt_multiuser.sh'"
                termux-adb shell "su -c 'echo \"resetprop -n fw.max_users $user_count\" >> /data/adb/post-fs-data.d/zt_multiuser.sh'"
                termux-adb shell "su -c 'echo \"resetprop -n fw.show_multiuserui 1\" >> /data/adb/post-fs-data.d/zt_multiuser.sh'"
                termux-adb shell "su -c 'chmod 755 /data/adb/post-fs-data.d/zt_multiuser.sh'"

                echo -e "${C_S}---------------------------------------------------${C_R}"
                echo -e "${C_S}[✔] Magisk Boot Script Injected Successfully!${C_R}"
                echo -e "${C_I}[*] Rebooting device to apply permanent changes...${C_R}"
                termux-adb reboot
                echo -e "\n${C_S}[~] SUCCESS: Process finished! Device is restarting.${C_R}"
                sleep 1
                pause_menu
                ;;
            6)
                clear
                echo -e "${C_H}===================================================${C_R}"
                echo -e "${C_T}                ADB DEVICE INFORMATION             ${C_R}"
                echo -e "${C_H}===================================================${C_R}"
                echo ""
                echo -e "${C_I}[*] Fetching details from connected device...${C_R}"
                echo -e "${C_H}---------------------------------------------------${C_R}"
                
                MODEL=$(termux-adb shell getprop ro.product.model | tr -d '\r')
                DEVICE=$(termux-adb shell getprop ro.product.device | tr -d '\r')
                VERSION=$(termux-adb shell getprop ro.build.version.release | tr -d '\r')
                HARDWARE=$(termux-adb shell getprop ro.hardware | tr -d '\r')
                BUILD=$(termux-adb shell getprop ro.build.display.id | tr -d '\r')

                echo -e "${C_I}Device Model     : ${C_R}${MODEL}"
                echo -e "${C_I}Product Code     : ${C_R}${DEVICE}"
                echo -e "${C_I}Android Version  : ${C_R}${VERSION}"
                echo -e "${C_I}Hardware/Board   : ${C_R}${HARDWARE}"
                echo -e "${C_I}Build/OS Version : ${C_R}${BUILD}"
                
                echo -e "${C_H}---------------------------------------------------${C_R}"
                pause_menu
                ;;
            99) break ;;
            0) exit 0 ;;
            *) echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
        esac
    done
}

# ==========================================
# 4. FASTBOOT MENU
# ==========================================
menu_fastboot() {
    while true; do
        clear
        echo -e "${C_H}=========================================${C_R}"
        echo -e "${C_T}      FASTBOOT MENU - Zishan Therapy     ${C_R}"
        echo -e "${C_H}=========================================${C_R}"
        echo -e " ${C_O}[1]${C_R} Check Fastboot Devices"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_O}[2]${C_R} Reboot to System"
        echo -e " ${C_O}[3]${C_R} Reboot to Recovery"
        echo -e " ${C_O}[4]${C_R} Reboot to Fastbootd (User space)"
        echo -e " ${C_O}[5]${C_R} Reboot to Bootloader"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_O}[6]${C_R} Get Product Name (getvar product)"
        echo -e " ${C_O}[7]${C_R} Get Device Info (oem device-info)"
        echo -e " ${C_O}[8]${C_R} Check Bootloader Status (Unlock State)"
        echo -e " ${C_O}[9]${C_R} Get All Variables (getvar all)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_O}[10]${C_R} Bootloader Unlock (flashing unlock)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_O}[11]${C_R} Flash boot"
        echo -e " ${C_O}[12]${C_R} Flash init_boot"
        echo -e " ${C_O}[13]${C_R} Flash recovery"
        echo -e " ${C_O}[14]${C_R} Flash vbmeta"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_E}[15]${C_R} Factory Reset (fastboot -w)"
        echo -e " ${C_E}[16]${C_R} Erase Userdata (fastboot erase userdata)"
        echo -e " ${C_E}[17]${C_R} Erase FRP (fastboot erase frp)"
        echo -e "${C_H}-----------------------------------------${C_R}"
        echo -e " ${C_E}[99]${C_R} Back to Main Menu"
        echo -e " ${C_E}[0]${C_R} Exit Tool"
        echo -e "${C_H}=========================================${C_R}"
        echo -ne "${C_O}Enter your choice:${C_R} "
        read choice

        case $choice in
            1)
                clear
                echo -e "${C_I}[*] Checking connected Fastboot devices...${C_R}"
                timeout 15s termux-fastboot devices
                pause_menu
                ;;
            2)
                clear
                echo -e "${C_I}[*] Rebooting device to System...${C_R}"
                timeout 15s termux-fastboot reboot
                pause_menu
                ;;
            3)
                clear
                echo -e "${C_I}[*] Rebooting to Recovery Mode...${C_R}"
                timeout 15s termux-fastboot reboot recovery
                pause_menu
                ;;
            4)
                clear
                echo -e "${C_I}[*] Rebooting to Fastbootd (User space)...${C_R}"
                timeout 15s termux-fastboot reboot fastboot
                pause_menu
                ;;
            5)
                clear
                echo -e "${C_I}[*] Rebooting to Bootloader...${C_R}"
                timeout 15s termux-fastboot reboot bootloader
                pause_menu
                ;;
            6)
                clear
                echo -e "${C_I}[*] Getting Product Name...${C_R}"
                timeout 15s termux-fastboot getvar product
                pause_menu
                ;;
            7)
                clear
                echo -e "${C_I}[*] Getting OEM Device Info...${C_R}"
                timeout 15s termux-fastboot oem device-info
                pause_menu
                ;;
            8)
                clear
                echo -e "${C_H}===================================================${C_R}"
                echo -e "${C_T}            CHECK BOOTLOADER UNLOCK STATUS         ${C_R}"
                echo -e "${C_H}===================================================${C_R}"
                echo ""
                echo -e "${C_I}[*] Checking for connected fastboot device...${C_R}"
                
                timeout 15s termux-fastboot devices > fb_t.tmp 2>&1
                if ! grep -q "fastboot" fb_t.tmp; then
                    echo -e "${C_E}[!] Error: No fastboot device detected or connection timed out!${C_R}"
                    rm -f fb_t.tmp; pause_menu; continue
                fi
                rm -f fb_t.tmp

                echo -e "${C_S}[✔] Device detected! Fetching Unlock Status...${C_R}"
                echo -e "${C_H}---------------------------------------------------${C_R}"
                echo -e "${C_I}[*] Method 1 (Standard Android 'unlocked' state):${C_R}"
                termux-fastboot getvar unlocked 2>&1 | grep -i "unlocked"
                echo ""
                echo -e "${C_I}[*] Method 2 (Secure boot state - 'yes' means locked):${C_R}"
                termux-fastboot getvar secure 2>&1 | grep -i "secure"
                echo ""
                echo -e "${C_I}[*] Method 3 (Xiaomi / OEM Device Info):${C_R}"
                termux-fastboot oem device-info 2>&1 | grep -i "unlock"
                echo -e "${C_H}---------------------------------------------------${C_R}"
                echo -e "${C_W}[!] Note: If any method says 'true' or 'yes' for unlocked (or 'no' for secure),${C_R}"
                echo -e "${C_W}    your bootloader is UNLOCKED.${C_R}\n"
                pause_menu
                ;;
            9)
                clear
                echo -e "${C_I}[*] Getting All Variables (getvar all)...${C_R}"
                timeout 15s termux-fastboot getvar all
                pause_menu
                ;;
            10)
                clear
                echo -e "${C_I}[*] Bootloader Unlock...${C_R}"
                echo -e "${C_I}[*] Checking for connected fastboot device...${C_R}"
                timeout 15s termux-fastboot devices > fb_t.tmp 2>&1
                if ! grep -q "fastboot" fb_t.tmp; then
                    echo -e "${C_E}[!] Error: No fastboot device detected or connection timed out!${C_R}"
                    rm -f fb_t.tmp; pause_menu; continue
                fi
                rm -f fb_t.tmp
                
                echo -e "${C_S}[✔] Device detected!${C_R}"
                echo -e "${C_W}[*] Running unlock command. Check phone screen...${C_R}"
                termux-fastboot flashing unlock
                pause_menu
                ;;
            11|12|13|14)
                clear
                part_name=""
                img_name=""
                
                # Auto matching the files
                if [ "$choice" == "11" ]; then part_name="boot"; img_name="boot.img"; fi
                if [ "$choice" == "12" ]; then part_name="init_boot"; img_name="init_boot.img"; fi
                if [ "$choice" == "13" ]; then part_name="recovery"; img_name="recovery.img"; fi
                if [ "$choice" == "14" ]; then part_name="vbmeta"; img_name="vbmeta.img"; fi

                IMG_PATH="$DL_DIR/$img_name"
                
                echo -e "${C_H}===================================================${C_R}"
                echo -e "${C_T}             FLASH ${part_name^^} (Auto File System)             ${C_R}"
                echo -e "${C_H}===================================================${C_R}"
                echo ""
                echo -e "${C_I}[*] Flashing $part_name from ZishanTherapy Folder...${C_R}"
                
                if [ ! -f "$IMG_PATH" ]; then
                    echo -e "${C_E}[!] Error: '$img_name' not found in Downloads/ZishanTherapy folder!${C_R}"
                    echo -e "${C_W}[!] Please put the exact file there and try again.${C_R}"
                    pause_menu
                    continue
                fi

                echo -e "${C_S}[✔] File found: $IMG_PATH${C_R}"
                echo -e "${C_I}[*] Checking for connected fastboot device...${C_R}"
                timeout 15s termux-fastboot devices > fb_t.tmp 2>&1
                if ! grep -q "fastboot" fb_t.tmp; then
                    echo -e "\n${C_E}[!] Error: No fastboot device detected or timed out!${C_R}"
                    rm -f fb_t.tmp; pause_menu; continue
                fi
                rm -f fb_t.tmp

                echo -e "${C_S}[✔] Device detected! Flashing $part_name...${C_R}"
                if [ "$choice" == "14" ]; then
                    termux-fastboot --disable-verity --disable-verification flash "$part_name" "$IMG_PATH"
                else
                    termux-fastboot flash "$part_name" "$IMG_PATH"
                fi
                echo -e "\n${C_S}[✔] Finished Successfully!${C_R}"
                pause_menu
                ;;
            15)
                clear
                echo -e "${C_E}===================================================${C_R}"
                echo -e "${C_E}             FACTORY RESET (fastboot -w)           ${C_R}"
                echo -e "${C_E}===================================================${C_R}"
                echo ""
                echo -e "${C_E}[!] WARNING: This will WIPE ALL USER DATA on the device!${C_R}"
                echo -ne "${C_O}Are you sure you want to proceed? (Y/N): ${C_R}"
                read confirm
                if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then continue; fi

                timeout 15s termux-fastboot devices > fb_t.tmp 2>&1
                if ! grep -q "fastboot" fb_t.tmp; then echo -e "${C_E}[!] No device detected!${C_R}"; rm -f fb_t.tmp; pause_menu; continue; fi
                rm -f fb_t.tmp

                echo -e "${C_S}[✔] Device detected! Wiping data...${C_R}"
                termux-fastboot -w
                echo -e "${C_S}[✔] Finished!${C_R}"
                pause_menu
                ;;
            16)
                clear
                echo -e "${C_E}===================================================${C_R}"
                echo -e "${C_E}       ERASE USERDATA (fastboot erase userdata)    ${C_R}"
                echo -e "${C_E}===================================================${C_R}"
                echo ""
                echo -e "${C_E}[!] WARNING: This will ERASE USERDATA partition!${C_R}"
                echo -ne "${C_O}Are you sure you want to proceed? (Y/N): ${C_R}"
                read confirm
                if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then continue; fi
                
                timeout 15s termux-fastboot devices > fb_t.tmp 2>&1
                if ! grep -q "fastboot" fb_t.tmp; then echo -e "${C_E}[!] No device detected!${C_R}"; rm -f fb_t.tmp; pause_menu; continue; fi
                rm -f fb_t.tmp

                echo -e "${C_S}[✔] Device detected! Erasing userdata...${C_R}"
                termux-fastboot erase userdata
                echo -e "${C_S}[✔] Finished!${C_R}"
                pause_menu
                ;;
            17)
                clear
                echo -e "${C_E}===================================================${C_R}"
                echo -e "${C_E}           ERASE FRP (fastboot erase frp)          ${C_R}"
                echo -e "${C_E}===================================================${C_R}"
                echo ""
                echo -e "${C_W}[!] Note: This command removes Google FRP Lock on supported devices.${C_R}"
                echo -ne "${C_O}Are you sure you want to proceed? (Y/N): ${C_R}"
                read confirm
                if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then continue; fi
                
                timeout 15s termux-fastboot devices > fb_t.tmp 2>&1
                if ! grep -q "fastboot" fb_t.tmp; then echo -e "${C_E}[!] No device detected!${C_R}"; rm -f fb_t.tmp; pause_menu; continue; fi
                rm -f fb_t.tmp

                echo -e "${C_S}[✔] Device detected! Erasing FRP...${C_R}"
                termux-fastboot erase frp
                echo -e "${C_S}[✔] Finished!${C_R}"
                pause_menu
                ;;
            99) break ;;
            0) exit 0 ;;
            *) echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
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
    echo "3. ADB Menu"
    echo "4. Fastboot Menu"
    echo -e "${C_H}-----------------------------------------${C_R}"
    echo -e " ${C_E}[0]${C_R} Exit Tool"
    echo -e "${C_H}=========================================${C_R}"
    echo -ne "${C_O}Enter your choice:${C_R} "
    read main_choice

    case $main_choice in
        1) menu_setup ;;
        2) menu_download ;;
        3) menu_adb ;;
        4) menu_fastboot ;;
        0) clear; echo -e "${C_I}Exiting Master Tool...${C_R}"; exit 0 ;;
        *) echo -e "${C_E}[!] Invalid Option!${C_R}" && sleep 2 ;;
    esac
done
