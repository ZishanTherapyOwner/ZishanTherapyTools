#!/bin/bash

# ==========================================
# Helper Function (কমান্ডের কাজ শেষে অপেক্ষা করার জন্য)
# ==========================================
pause_menu() {
    echo ""
    read -p "Press Enter to go back..."
}

# ==========================================
# 1. SETUP MENU (সেটআপ সম্পর্কিত কাজের ফোল্ডার)
# ==========================================
menu_setup() {
    while true; do
        clear
        echo "========================================="
        echo "       SETUP MENU - Zishan Therapy       "
        echo "========================================="
        echo "1. Basic Termux Setup"
        echo "2. Install Platform Tools"
        echo "3. Termux Setup Storage"
        echo "9. Back to Main Menu"
        echo "0. Exit Tool"
        echo "========================================="
        read -p "Enter your choice: " choice < /dev/tty

        case $choice in
            1)
                clear
                echo "[*] Running Basic Setup..."
                # --- ADD COMMANDS BELOW ---
                pkg update -y && pkg upgrade -y
                # --- ADD COMMANDS ABOVE ---
                echo "[✔] Done!"
                pause_menu
                ;;
            2)
                clear
                echo "[*] Installing Android Tools..."
                # --- ADD COMMANDS BELOW ---
                curl -s https://raw.githubusercontent.com/nohajc/termux-adb/master/install.sh | bash
                # --- ADD COMMANDS ABOVE ---
                echo "[✔] Done!"
                pause_menu
                ;;
            3)
                clear
                echo "[*] Termux Setup Storage..."
                # --- ADD COMMANDS BELOW ---
                termux-setup-storage
                # --- ADD COMMANDS ABOVE ---
                echo "[✔] Done!"
                pause_menu
                ;;
            9)
                break # এটি চাপলে আগের মেনুতে ফিরে যাবে
                ;;
            0)
                exit 0
                ;;
            *)
                echo "[!] Invalid Option!" && sleep 2 ;;
        esac
    done
}

# ==========================================
# 2. ADB MENU (ADB সম্পর্কিত কাজের ফোল্ডার)
# ==========================================
menu_adb() {
    while true; do
        clear
        echo "========================================="
        echo "        ADB MENU - Zishan Therapy        "
        echo "========================================="
        echo "1. Check ADB Devices"
        echo "2. Reboot to Recovery"
        echo "3. Reboot to Bootloader"
        echo "9. Back to Main Menu"
        echo "0. Exit Tool"
        echo "========================================="
        read -p "Enter your choice: " choice

        case $choice in
            1)
                clear
                echo "[*] Checking connected ADB devices..."
                # --- ADD COMMANDS BELOW ---
                termux-adb devices
                # --- ADD COMMANDS ABOVE ---
                pause_menu
                ;;
            2)
                clear
                echo "[*] Rebooting to Recovery Mode..."
                # --- ADD COMMANDS BELOW ---
                termux-adb reboot recovery
                # --- ADD COMMANDS ABOVE ---
                pause_menu
                ;;
            3)
                clear
                echo "[*] Rebooting to Bootloader..."
                # --- ADD COMMANDS BELOW ---
                termux-adb reboot bootloader
                # --- ADD COMMANDS ABOVE ---
                pause_menu
                ;;
            9)
                break
                ;;
            0)
                exit 0
                ;;
            *)
                echo "[!] Invalid Option!" && sleep 2 ;;
        esac
    done
}

# ==========================================
# 3. FASTBOOT MENU (Fastboot সম্পর্কিত কাজের ফোল্ডার)
# ==========================================
menu_fastboot() {
    while true; do
        clear
        echo "========================================="
        echo "      FASTBOOT MENU - Zishan Therapy     "
        echo "========================================="
        echo "1. Check Fastboot Devices"
        echo "2. Reboot to System"
        echo "3. Flash boot"
        echo "4. Flash init_boot"
        echo "9. Back to Main Menu"
        echo "0. Exit Tool"
        echo "========================================="
        read -p "Enter your choice: " choice

        case $choice in
            1)
                clear
                echo "[*] Checking connected Fastboot devices..."
                # --- ADD COMMANDS BELOW ---
    
                # ৩ সেকেন্ডের জন্য কমান্ডটি রান করবে
                timeout 15s termux-fastboot devices
                
                # যদি ৩ সেকেন্ড পার হয়ে যায় এবং কমান্ড আটকে থাকে (Timeout Error 124)
                if [ $? -eq 124 ]; then
                    echo ""
                    echo "[!] No fastboot device detected or connection timed out!"
                fi
                
                # --- ADD COMMANDS ABOVE ---
                pause_menu
                ;;
            2)
                clear
                echo "[*] Rebooting device to System..."
                # --- ADD COMMANDS BELOW ---
    
                # ৩ সেকেন্ডের জন্য কমান্ডটি রান করবে
                timeout 15s termux-fastboot reboot
                
                # যদি ৩ সেকেন্ড পার হয়ে যায় এবং কমান্ড আটকে থাকে (Timeout Error 124)
                if [ $? -eq 124 ]; then
                    echo ""
                    echo "[!] No fastboot device detected or connection timed out!"
                fi
                
                # --- ADD COMMANDS ABOVE ---
                pause_menu
                ;;
            3)
                clear
                echo "[*] Flashing boot Image..."
                # --- ADD COMMANDS BELOW ---
                
                # ফাইলের লোকেশন ভ্যারিয়েবল
                BOOT_IMG="/sdcard/Download/mboot.img"
                
                # ১. প্রথমে চেক করবে ফাইলটি আছে কি না
                if [ -f "$BOOT_IMG" ]; then
                    echo "[✔] File found: $BOOT_IMG"
                    echo "[*] Checking for connected fastboot device (waiting 3s)..."
                    
                    # ২. শুধু ডিভাইস চেক করার জন্য ৩ সেকেন্ড সময় নেবে (ফ্ল্যাশের জন্য নয়)
                    timeout 15s termux-fastboot devices > /dev/null 2>&1
                    
                    if [ $? -eq 124 ]; then
                        # ৩ সেকেন্ডে ডিভাইস না পেলে আটকে না থেকে এরর দেখাবে
                        echo ""
                        echo "[!] Error: No fastboot device detected!"
                        echo "Please connect your phone in fastboot mode and try again."
                    else
                        # ৩. ডিভাইস পেলে কোনো টাইমআউট ছাড়া ফ্ল্যাশ করবে (যত সময় লাগুক)
                        echo "[✔] Device detected!"
                        echo "[*] Flashing in progress. Please do not disconnect..."
                        
                        termux-fastboot flash boot "$BOOT_IMG"
                        
                        echo "[✔] Flashing process finished!"
                    fi
                else
                    # যদি Downloads ফোল্ডারে ফাইলটি না পাওয়া যায়
                    echo ""
                    echo "[!] Error: mboot.img file not found in Downloads folder!"
                    echo "[!] Please put the mboot.img file in your Downloads folder and try again."
                fi
                
                # --- ADD COMMANDS ABOVE ---
                pause_menu
                ;;
            4)
                clear
                echo "[*] Flashing init_boot Image..."
                # --- ADD COMMANDS BELOW ---
                
                # ফাইলের লোকেশন ভ্যারিয়েবল
                INIT_BOOT_IMG="/sdcard/Download/minit_boot.img"
                
                # ১. প্রথমে চেক করবে ফাইলটি আছে কি না
                if [ -f "$INIT_BOOT_IMG" ]; then
                    echo "[✔] File found: $INIT_BOOT_IMG"
                    echo "[*] Checking for connected fastboot device (waiting 3s)..."
                    
                    # ২. শুধু ডিভাইস চেক করার জন্য ৩ সেকেন্ড সময় নেবে (ফ্ল্যাশের জন্য নয়)
                    timeout 15s termux-fastboot devices > /dev/null 2>&1
                    
                    if [ $? -eq 124 ]; then
                        # ৩ সেকেন্ডে ডিভাইস না পেলে আটকে না থেকে এরর দেখাবে
                        echo ""
                        echo "[!] Error: No fastboot device detected!"
                        echo "Please connect your phone in fastboot mode and try again."
                    else
                        # ৩. ডিভাইস পেলে কোনো টাইমআউট ছাড়া ফ্ল্যাশ করবে (যত সময় লাগুক)
                        echo "[✔] Device detected!"
                        echo "[*] Flashing in progress. Please do not disconnect..."
                        
                        termux-fastboot flash init_boot "$INIT_BOOT_IMG"
                        
                        echo "[✔] Flashing process finished!"
                    fi
                else
                    # যদি Downloads ফোল্ডারে ফাইলটি না পাওয়া যায়
                    echo ""
                    echo "[!] Error: minit_boot.img file not found in Downloads folder!"
                    echo "[!] Please put the minit_boot.img file in your Downloads folder and try again."
                fi
                
                # --- ADD COMMANDS ABOVE ---
                pause_menu
                ;;
            9)
                break
                ;;
            0)
                exit 0
                ;;
            *)
                echo "[!] Invalid Option!" && sleep 2 ;;
        esac
    done
}

# ==========================================
# MAIN MENU (মূল মেনু যেখান থেকে ক্যাটাগরিতে যাবে)
# ==========================================
while true; do
    clear
    echo "========================================="
    echo "             Zishan Therapy              "
    echo "========================================="
    echo "1. Setup Menu"
    echo "2. ADB Menu"
    echo "3. Fastboot Menu"
    echo "0. Exit Tool"
    echo "========================================="
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
            echo "[!] Invalid Option!" && sleep 2
            ;;
    esac
done
