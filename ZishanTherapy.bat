@echo off
title Zishan Therapy - Windows Master Tool
color 0B

:: ==========================================
:: Working Directory & Strict Path
:: ==========================================
cd /d "%~dp0"
set "PATH=%~dp0platform-tools;%PATH%"
set "ADB=%~dp0platform-tools\adb.exe"
set "FASTBOOT=%~dp0platform-tools\fastboot.exe"

:: ==========================================
:: MAIN MENU
:: ==========================================
:MainMenu
cls
echo =========================================
echo              Zishan Therapy              
echo =========================================
echo  [1] Download Menu (Tools ^& APKs)
echo  [2] ADB Menu
echo  [3] Fastboot Menu
echo  [4] Sideload Menu
echo -----------------------------------------
echo  [S] Start Scrcpy Mirroring
echo -----------------------------------------
echo  [M] Delete Mobile Data (ZishanTherapy)
echo  [P] Delete PC Data (Clean Tool Folder)
echo  [0] Exit Tool
echo =========================================
set /p main_choice="Select Category: "

if "%main_choice%"=="1" goto DownloadMenu
if "%main_choice%"=="2" goto AdbMenu
if "%main_choice%"=="3" goto FastbootMenu
if "%main_choice%"=="4" goto SideloadMenu
if /i "%main_choice%"=="s" set "back_to=MainMenu"
if /i "%main_choice%"=="s" goto RunScrcpy
if /i "%main_choice%"=="m" goto DeleteMobileData
if /i "%main_choice%"=="p" goto DeletePcData
if "%main_choice%"=="0" exit
goto MainMenu

:: ==========================================
:: TOOL CHECKER
:: ==========================================
:MissingTools
cls
echo =========================================
echo [!] ERROR: Platform Tools Not Found!
echo =========================================
echo Please download the tools first before using this option.
echo.
echo 1. Go to "Download Menu"
echo 2. Select Option "1" to Auto Install Platform Tools.
echo.
pause
goto MainMenu

:: ==========================================
:: UNIVERSAL SCRCPY RUNNER (ক্র্যাশ প্রুফ মেকানিজম)
:: ==========================================
:RunScrcpy
cls
set "SCRCPY_EXE="
if exist "%~dp0scrcpy\scrcpy.exe" set "SCRCPY_EXE=%~dp0scrcpy\scrcpy.exe"
if exist "%~dp0scrcpy\scrcpy-win64-v2.4\scrcpy.exe" set "SCRCPY_EXE=%~dp0scrcpy\scrcpy-win64-v2.4\scrcpy.exe"

if not "%SCRCPY_EXE%"=="" goto LaunchScrcpy
echo =========================================
echo [!] ERROR: Scrcpy Not Found!
echo =========================================
echo Please download Scrcpy first from the Download Menu (Option 2).
echo.
pause
goto %back_to%

:LaunchScrcpy
echo [*] Launching Scrcpy Screen Mirroring...
echo [*] Make sure USB Debugging is allowed on the device.
start "" "%SCRCPY_EXE%"
timeout /t 1 >nul
goto %back_to%

:: ==========================================
:: DATA CLEANUP SYSTEM
:: ==========================================
:DeleteMobileData
if not exist "%ADB%" goto MissingTools
cls
echo ===================================================
echo               DELETE MOBILE DATA (PHONE)
echo ===================================================
echo.
echo [*] Cleaning ZishanTherapy directory from device...
echo.
"%ADB%" shell rm -rf /sdcard/Download/ZishanTherapy
echo [~] SUCCESS: Mobile 'ZishanTherapy' folder deleted successfully!
echo.
pause
goto MainMenu

:DeletePcData
cls
echo ===================================================
echo               DELETE PC DATA (PC CLEANUP)
echo ===================================================
echo.
echo [!] WARNING: This will delete all downloaded folders, tools, 
echo      APKs, and ZIP files next to this script!
echo [!] Only this main batch script file will remain.
echo.
set /p confirm="Are you sure you want to completely clean up? (Y/N): "
if /i not "%confirm%"=="Y" goto MainMenu

echo.
echo [*] Cleaning up PC data...
for %%i in ("%~dp0*") do (
    if not "%%~nxi"=="%~nx0" del /f /q "%%i"
)
for /d %%i in ("%~dp0*") do (
    rmdir /s /q "%%i"
)
echo.
echo [~] SUCCESS: Tool folder cleaned! All downloaded data deleted.
echo.
pause
goto MainMenu

:: ==========================================
:: 1. DOWNLOAD MENU
:: ==========================================
:DownloadMenu
cls
echo =========================================
echo         DOWNLOAD MENU - Zishan Therapy     
echo =========================================
echo  [1] Download Platform Tools (Auto Extract)
echo  [2] Download Scrcpy (Screen Mirroring)
echo -----------------------------------------
echo  [3] Download Magisk Manager (APK)
echo  [4] Download Kitsune Mask (APK)
echo  [5] Download Root Checker (APK)
echo  [6] Download Termux API (APK)
echo  [7] Download Termux (APK)
echo -----------------------------------------
echo  [8] Download MagiskHideProps Module (ZIP)
echo  [9] Download 7-Zip Installer (EXE)
echo -----------------------------------------
echo  [S] Start Scrcpy Mirroring
echo -----------------------------------------
echo  [99] Back to Main Menu
echo  [0] Exit Tool
echo =========================================
set /p choice="Enter your choice: "

if "%choice%"=="1" goto DloadOpt1
if "%choice%"=="2" goto DloadOpt2
if "%choice%"=="3" goto DloadOpt3
if "%choice%"=="4" goto DloadOpt4
if "%choice%"=="5" goto DloadOpt5
if "%choice%"=="6" goto DloadOpt6
if "%choice%"=="7" goto DloadOpt7
if "%choice%"=="8" goto DloadOpt8
if "%choice%"=="9" goto DloadOpt9
if /i "%choice%"=="s" set "back_to=DownloadMenu"
if /i "%choice%"=="s" goto RunScrcpy
if "%choice%"=="99" goto MainMenu
if "%choice%"=="0" exit
goto DownloadMenu

:DloadOpt1
cls
if exist "%~dp0platform-tools\adb.exe" (
    echo [*] Platform Tools is already installed!
    echo [*] No need to download again.
    echo.
    pause
    goto DownloadMenu
)
echo [*] Downloading Official Platform Tools (Google Direct Link)...
echo ----------------------------------------------------------------------
curl -L "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" -o platform-tools.zip
echo ----------------------------------------------------------------------
if not exist platform-tools.zip (
    echo [!] Download Failed! Check your internet connection.
    pause
    goto DownloadMenu
)

:ExtractTools
echo.
echo [*] Extracting files (Please wait)...
if exist "pt_temp" rmdir /s /q "pt_temp"
powershell -command "Expand-Archive -Force -Path 'platform-tools.zip' -DestinationPath 'pt_temp'"

echo [*] Organizing Platform Tools folder...
if exist "platform-tools" rmdir /s /q "platform-tools"
mkdir "platform-tools"

if exist "pt_temp\platform-tools\adb.exe" (
    xcopy /E /Y /H /Q "pt_temp\platform-tools\*.*" "platform-tools\" >nul
) else if exist "pt_temp\adb.exe" (
    xcopy /E /Y /H /Q "pt_temp\*.*" "platform-tools\" >nul
) else (
    for /f "delims=" %%i in ('dir /b /s "pt_temp\adb.exe" 2^>nul') do (
        xcopy /E /Y /H /Q "%%~dpi*.*" "platform-tools\" >nul
    )
)

:: Error checking after extraction
if not exist "platform-tools\adb.exe" (
    echo.
    echo [X] ERROR: adb.exe not found! Zip file might be corrupt or invalid.
    rmdir /s /q "platform-tools" 2>nul
) else (
    echo.
    echo [~] SUCCESS: Platform Tools Installed perfectly!
)

echo [*] Cleaning up temporary files...
rmdir /s /q "pt_temp" 2>nul
del /f /q "platform-tools.zip" 2>nul
echo.
pause
goto DownloadMenu

:DloadOpt2
cls
if exist "%~dp0scrcpy\scrcpy.exe" (
    echo [*] Scrcpy is already installed!
    echo [*] No need to download again.
    echo.
    pause
    goto DownloadMenu
)
echo [*] Downloading Scrcpy...
echo ----------------------------------------------------------------------
curl -L https://github.com/Genymobile/scrcpy/releases/download/v2.4/scrcpy-win64-v2.4.zip -o scrcpy.zip
echo ----------------------------------------------------------------------
if not exist scrcpy.zip (
    echo [!] Download Failed! Check your internet connection.
    pause
    goto DownloadMenu
)

:ExtractScrcpy
echo.
echo [*] Extracting Scrcpy files (Please wait)...
if exist "scrcpy_temp" rmdir /s /q "scrcpy_temp"
powershell -command "Expand-Archive -Force -Path 'scrcpy.zip' -DestinationPath 'scrcpy_temp'"

echo [*] Organizing Scrcpy folder...
if exist "scrcpy" rmdir /s /q "scrcpy"
mkdir "scrcpy"

if exist "scrcpy_temp\scrcpy.exe" (
    xcopy /E /Y /H /Q "scrcpy_temp\*.*" "scrcpy\" >nul
) else (
    for /f "delims=" %%i in ('dir /b /s "scrcpy_temp\scrcpy.exe" 2^>nul') do (
        xcopy /E /Y /H /Q "%%~dpi*.*" "scrcpy\" >nul
    )
)

if not exist "scrcpy\scrcpy.exe" (
    echo.
    echo [X] ERROR: scrcpy.exe not found!
    rmdir /s /q "scrcpy" 2>nul
) else (
    echo.
    echo [~] SUCCESS: Scrcpy Installed perfectly in the 'scrcpy' folder!
)

echo [*] Cleaning up...
rmdir /s /q "scrcpy_temp" 2>nul
del /f /q "scrcpy.zip" 2>nul
echo.
pause
goto DownloadMenu

:DloadOpt3
cls
if exist "%~dp0MagiskManager.apk" (
    echo [*] MagiskManager.apk is already downloaded!
    echo.
    pause
    goto DownloadMenu
)
echo [*] Try 1: Fetching Magisk Manager via Official GitHub Latest Link...
set "MAGISK_URL="
for /f "delims=" %%i in ('powershell -command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/topjohnwu/Magisk/releases/latest').assets | Where-Object {$_.name -like '*.apk'} | Select-Object -ExpandProperty browser_download_url" 2^>nul') do set "MAGISK_URL=%%i"

if "%MAGISK_URL%"=="" goto MagiskDriveFallback
echo [*] Downloading Latest Magisk Manager APK...
echo ----------------------------------------------------------------------
curl -L "%MAGISK_URL%" -o MagiskManager.apk
echo ----------------------------------------------------------------------
if exist MagiskManager.apk goto MagiskSuccess
goto MagiskDriveFallback

:MagiskDriveFallback
echo.
echo [!] GitHub Link Failed! Try 2: Downloading via Backup Drive Cookie Engine...
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1o4bk2MJ8Khb9wp35JGlu4XpMDPcf6Orn'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'MagiskManager.apk')" 2>nul
echo ----------------------------------------------------------------------

:MagiskSuccess
echo.
echo [~] SUCCESS: MagiskManager.apk is ready!
pause
goto DownloadMenu

:DloadOpt4
cls
if exist "%~dp0KitsuneMask.apk" (
    echo [*] KitsuneMask.apk is already downloaded!
    echo.
    pause
    goto DownloadMenu
)
echo [*] Try 1: Downloading Kitsune Mask via Your GitHub Release...
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux.api_1002.apk" -o KitsuneMask.apk
echo ----------------------------------------------------------------------
if exist KitsuneMask.apk goto KitsuneSuccess
goto KitsuneDriveFallback

:KitsuneDriveFallback
echo.
echo [!] GitHub Release Failed! Try 2: Downloading via Backup Drive Cookie Engine...
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1ZSVsougbTNpG7-LD_7UE720cOY7-4CBm'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'KitsuneMask.apk')" 2>nul
echo ----------------------------------------------------------------------

:KitsuneSuccess
echo.
echo [~] SUCCESS: KitsuneMask.apk is ready!
pause
goto DownloadMenu

:DloadOpt5
cls
if exist "%~dp0RootChecker.apk" (
    echo [*] RootChecker.apk is already downloaded!
    echo.
    pause
    goto DownloadMenu
)
echo [*] Try 1: Downloading Root Checker via Your GitHub Release...
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/root-checker-6-5-3.apk" -o RootChecker.apk
echo ----------------------------------------------------------------------
if exist RootChecker.apk goto RootSuccess
goto RootDriveFallback

:RootDriveFallback
echo.
echo [!] GitHub Release Failed! Try 2: Downloading via Backup Drive Cookie Engine...
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1iwiN3PSXRVxbVJL1Mgz_qWsSHySw6A_S'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'RootChecker.apk')" 2>nul
echo ----------------------------------------------------------------------

:RootSuccess
echo.
echo [~] SUCCESS: RootChecker.apk is ready!
pause
goto DownloadMenu

:DloadOpt6
cls
if exist "%~dp0TermuxAPI.apk" (
    echo [*] TermuxAPI.apk is already downloaded!
    echo.
    pause
    goto DownloadMenu
)
echo [*] Try 1: Downloading Termux API via Your GitHub Release...
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux.api_1002.apk" -o TermuxAPI.apk
echo ----------------------------------------------------------------------
if exist TermuxAPI.apk goto TermuxApiSuccess
goto TermuxApiDriveFallback

:TermuxApiDriveFallback
echo.
echo [!] GitHub Release Failed! Try 2: Downloading via Backup Drive Cookie Engine...
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='11KVDClixRM9Hrez6bSzQs7T6U486ym5F'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'TermuxAPI.apk')" 2>nul
echo ----------------------------------------------------------------------

:TermuxApiSuccess
echo.
echo [~] SUCCESS: TermuxAPI.apk is ready!
pause
goto DownloadMenu

:DloadOpt7
cls
if exist "%~dp0Termux.apk" (
    echo [*] Termux.apk is already downloaded!
    echo.
    pause
    goto DownloadMenu
)
echo [*] Try 1: Downloading Termux via Your GitHub Release...
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux_1022.apk" -o Termux.apk
echo ----------------------------------------------------------------------
if exist Termux.apk goto TermuxSuccess
goto TermuxDriveFallback

:TermuxDriveFallback
echo.
echo [!] GitHub Release Failed! Try 2: Downloading via Backup Drive Cookie Engine...
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1iP-_UJS5A_k4NXF6QmPGok4z9-973Ls7'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'Termux.apk')" 2>nul
echo ----------------------------------------------------------------------

:TermuxSuccess
echo.
echo [~] SUCCESS: Termux.apk is ready!
pause
goto DownloadMenu

:DloadOpt8
cls
if exist "%~dp0MagiskHideProps.zip" (
    echo [*] MagiskHideProps Module ZIP is already downloaded!
    echo.
    pause
    goto DownloadMenu
)
echo [*] Try 1: Downloading MagiskHideProps Module ZIP via Your GitHub Release...
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MagiskHidePropsConf-v6.1.2.zip" -o MagiskHideProps.zip
echo ----------------------------------------------------------------------
if exist MagiskHideProps.zip goto PropsSuccess
goto PropsDriveFallback

:PropsDriveFallback
echo.
echo [!] GitHub Release Failed! Try 2: Downloading via Backup Drive Cookie Engine...
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='12EZPSihEkdm2o8LwJ4B9s8s2J0Y5kDEN'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'MagiskHideProps.zip')" 2>nul
echo ----------------------------------------------------------------------

:PropsSuccess
echo.
echo [~] SUCCESS: MagiskHideProps.zip is ready!
pause
goto DownloadMenu

:DloadOpt9
cls
if exist "%~dp07z2601-x64.exe" (
    echo [*] 7-Zip Installer is already downloaded!
    echo.
    pause
    goto DownloadMenu
)
echo [*] Downloading Official 7-Zip Installer...
echo ----------------------------------------------------------------------
curl -L https://github.com/ip7z/7zip/releases/download/26.01/7z2601-x64.exe -o 7z2601-x64.exe
echo ----------------------------------------------------------------------
echo.
echo [~] SUCCESS: 7z2601-x64.exe saved in tool folder!
pause
goto DownloadMenu

:: ==========================================
:: 2. ADB MENU
:: ==========================================
:AdbMenu
cls
echo =========================================
echo         ADB MENU - Zishan Therapy       
echo =========================================
echo  [1] Check ADB Devices
echo -----------------------------------------
echo  [2] Reboot to System (Normal)
echo  [3] Reboot to Recovery
echo  [4] Reboot to Bootloader
echo -----------------------------------------
echo  [5] ADB Push File (Drag ^& Drop)
echo  [6] ADB Install APK (Normal)
echo  [7] ADB Install APK (Bypass Low SDK Block)
echo  [8] Enable Multiuser (Permanent via Magisk)
echo  [9] Get ADB Device Info (Version/Build)
echo -----------------------------------------
echo  [S] Start Scrcpy Mirroring
echo -----------------------------------------
echo  [99] Back to Main Menu
echo  [0] Exit Tool
echo =========================================
set /p choice="Enter your choice: "

if "%choice%"=="1" goto AdbOpt1
if "%choice%"=="2" goto AdbOpt2
if "%choice%"=="3" goto AdbOpt3
if "%choice%"=="4" goto AdbOpt4
if "%choice%"=="5" goto AdbOpt5
if "%choice%"=="6" goto AdbOpt6
if "%choice%"=="7" goto AdbOpt7
if "%choice%"=="8" goto AdbOpt8
if "%choice%"=="9" goto AdbOpt9
if /i "%choice%"=="s" set "back_to=AdbMenu"
if /i "%choice%"=="s" goto RunScrcpy
if "%choice%"=="99" goto MainMenu
if "%choice%"=="0" exit
goto AdbMenu

:AdbOpt1
if not exist "%ADB%" goto MissingTools
cls
echo [*] Checking connected ADB devices...
"%ADB%" devices
pause
goto AdbMenu

:AdbOpt2
if not exist "%ADB%" goto MissingTools
cls
echo [*] Rebooting device to System...
"%ADB%" reboot
pause
goto AdbMenu

:AdbOpt3
if not exist "%ADB%" goto MissingTools
cls
echo [*] Rebooting to Recovery Mode...
"%ADB%" reboot recovery
pause
goto AdbMenu

:AdbOpt4
if not exist "%ADB%" goto MissingTools
cls
echo [*] Rebooting to Bootloader...
"%ADB%" reboot bootloader
pause
goto AdbMenu

:AdbOpt5
if not exist "%ADB%" goto MissingTools
cls
echo ===================================================
echo             ADB PUSH (Drag ^& Drop System)
echo ===================================================
echo.
set /p push_file="--^> Drag and drop your file here and press Enter: "
set push_file=%push_file:"=%

if not exist "%push_file%" (
    echo.
    echo [!] Error: Invalid path or File not found!
    pause
    goto AdbMenu
)

cls
echo [*] Processing Device Storage Folder...
"%ADB%" shell mkdir -p /sdcard/Download/ZishanTherapy
echo [*] Pushing file into: Download/ZishanTherapy/
echo.
"%ADB%" push "%push_file%" /sdcard/Download/ZishanTherapy/
echo.
echo [~] Push completed successfully!
pause
goto AdbMenu

:AdbOpt6
if not exist "%ADB%" goto MissingTools
cls
echo ===================================================
echo             ADB INSTALL (Normal)
echo ===================================================
echo.
set /p apk_file="--^> Drag and drop your APK file here and press Enter: "
set apk_file=%apk_file:"=%

if not exist "%apk_file%" (
    echo.
    echo [!] Error: Invalid path or File not found!
    pause
    goto AdbMenu
)

cls
echo [*] Installing app, please look at your phone...
echo.
"%ADB%" install -r "%apk_file%"
echo.
echo [~] Process finished!
pause
goto AdbMenu

:AdbOpt7
if not exist "%ADB%" goto MissingTools
cls
echo ===================================================
echo     ADB INSTALL (Bypass Low Target SDK Block)
echo ===================================================
echo.
set /p apk_file="--^> Drag and drop your APK file here and press Enter: "
set apk_file=%apk_file:"=%

if not exist "%apk_file%" (
    echo.
    echo [!] Error: Invalid path or File not found!
    pause
    goto AdbMenu
)

cls
echo [*] Installing app (Bypassing low target SDK block)...
echo [*] Please check your phone screen if any prompt appears...
echo.
"%ADB%" install --bypass-low-target-sdk-block "%apk_file%"
echo.
echo [~] Process finished!
pause
goto AdbMenu

:AdbOpt8
if not exist "%ADB%" goto MissingTools
cls
echo ===================================================
echo      ENABLE MULTIUSER (Permanent via Magisk)
echo ===================================================
echo.
set /p user_count="--^> Enter maximum user limit (e.g., 4, 10, 100): "

if "%user_count%"=="" set user_count=4

cls
echo [*] Checking Root Access...
echo [!] PLEASE UNLOCK YOUR PHONE SCREEN AND TAP "GRANT" IF PROMPTED!
echo.

:: Test Root access first
"%ADB%" shell "su -c 'echo ROOT_GRANTED'" > root_check.tmp 2>nul
set "ROOT_STATUS="
for /f "usebackq delims=" %%A in (`type root_check.tmp 2^>nul`) do set "ROOT_STATUS=%%A"
del root_check.tmp 2>nul

:: Check if the output string contains ROOT_GRANTED
echo %ROOT_STATUS% | findstr /i "ROOT_GRANTED" >nul
if errorlevel 1 (
    echo ---------------------------------------------------
    echo [X] ERROR: Root Permission Denied or Timed Out!
    echo [!] Magisk did not get permission. 
    echo Please try this option again and tap "Grant" on your phone quickly.
    echo ---------------------------------------------------
    echo.
    pause
    goto AdbMenu
)

echo [✔] Root Access Confirmed!
echo [*] Injecting Magisk Boot Script...
echo.

:: Apply immediately for current session
"%ADB%" shell "su -c 'settings put global fw.max_users %user_count%'"
"%ADB%" shell "su -c 'settings put global fw.show_multiuserui 1'"

:: Inject into Magisk post-fs-data.d for permanent effect on every boot
"%ADB%" shell "su -c 'echo \"#!/system/bin/sh\" > /data/adb/post-fs-data.d/zt_multiuser.sh'"
"%ADB%" shell "su -c 'echo \"resetprop -n fw.max_users %user_count%\" >> /data/adb/post-fs-data.d/zt_multiuser.sh'"
"%ADB%" shell "su -c 'echo \"resetprop -n fw.show_multiuserui 1\" >> /data/adb/post-fs-data.d/zt_multiuser.sh'"
"%ADB%" shell "su -c 'chmod 755 /data/adb/post-fs-data.d/zt_multiuser.sh'"

echo ---------------------------------------------------
echo [✔] Magisk Boot Script Injected Successfully!
echo [*] Rebooting device to apply permanent changes...
"%ADB%" reboot
echo.
echo [~] SUCCESS: Process finished! Device is restarting.
echo [*] Returning to ADB Menu automatically...
timeout /t 2 >nul
goto AdbMenu

:AdbOpt9
if not exist "%ADB%" goto MissingTools
cls
echo ===================================================
echo               ADB DEVICE INFORMATION
echo ===================================================
echo.
echo [*] Fetching details from connected device...
echo ---------------------------------------------------
<nul set /p="Device Model     : " & "%ADB%" shell getprop ro.product.model
<nul set /p="Product Code     : " & "%ADB%" shell getprop ro.product.device
<nul set /p="Android Version  : " & "%ADB%" shell getprop ro.build.version.release
<nul set /p="Hardware/Board   : " & "%ADB%" shell getprop ro.hardware
<nul set /p="Build/OS Version : " & "%ADB%" shell getprop ro.build.display.id
echo ---------------------------------------------------
echo.
pause
goto AdbMenu

:: ==========================================
:: 3. FASTBOOT MENU
:: ==========================================
:FastbootMenu
cls
echo =========================================
echo      FASTBOOT MENU - Zishan Therapy     
echo =========================================
echo  [1] Check Fastboot Devices
echo -----------------------------------------
echo  [2] Reboot to System
echo  [3] Reboot to Recovery
echo  [4] Reboot to Fastbootd (User space)
echo  [5] Reboot to Bootloader
echo -----------------------------------------
echo  [6] Get Product Name (getvar product)
echo  [7] Get Device Info (oem device-info)
echo  [8] Get All Variables (getvar all)
echo -----------------------------------------
echo  [9] Bootloader Unlock (flashing unlock)
echo -----------------------------------------
echo  [10] Flash boot (Drag ^& Drop)
echo  [11] Flash init_boot (Drag ^& Drop)
echo  [12] Flash recovery (Drag ^& Drop)
echo  [13] Flash vbmeta (Drag ^& Drop)
echo -----------------------------------------
echo  [S] Start Scrcpy Mirroring
echo -----------------------------------------
echo  [99] Back to Main Menu
echo  [0] Exit Tool
echo =========================================
set /p choice="Enter your choice: "

if "%choice%"=="1" goto FbOpt1
if "%choice%"=="2" goto FbOpt2
if "%choice%"=="3" goto FbOpt3
if "%choice%"=="4" goto FbOpt4
if "%choice%"=="5" goto FbOpt5
if "%choice%"=="6" goto FbOpt6
if "%choice%"=="7" goto FbOpt7
if "%choice%"=="8" goto FbOpt8
if "%choice%"=="9" goto FbOpt9
if "%choice%"=="10" goto FbOpt10
if "%choice%"=="11" goto FbOpt11
if "%choice%"=="12" goto FbOpt12
if "%choice%"=="13" goto FbOpt13
if /i "%choice%"=="s" set "back_to=FastbootMenu"
if /i "%choice%"=="s" goto RunScrcpy
if "%choice%"=="99" goto MainMenu
if "%choice%"=="0" exit
goto FastbootMenu

:FbOpt1
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Checking connected Fastboot devices...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { Write-Output $txt; exit 0 }"
if %errorlevel% equ 124 (
    echo.
    echo [!] Error: Fastboot connection timed out or hung!
) else if %errorlevel% equ 1 (
    echo.
    echo [!] Error: No fastboot device detected!
)
pause
goto FastbootMenu

:FbOpt2
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Rebooting device to System...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo [!] Error: Fastboot connection timed out or hung!
pause
goto FastbootMenu

:FbOpt3
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Rebooting device to Recovery...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot recovery' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo [!] Error: Fastboot connection timed out or hung!
pause
goto FastbootMenu

:FbOpt4
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Rebooting device to Fastbootd (User space)...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot fastboot' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo [!] Error: Fastboot connection timed out or hung!
pause
goto FastbootMenu

:FbOpt5
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Rebooting device to Bootloader...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot bootloader' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo [!] Error: Fastboot connection timed out or hung!
pause
goto FastbootMenu

:FbOpt6
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Getting Product Name...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'getvar product' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo [!] Error: Fastboot connection timed out or hung!
pause
goto FastbootMenu

:FbOpt7
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Getting OEM Device Info...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'oem device-info' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo [!] Error: Fastboot connection timed out or hung!
pause
goto FastbootMenu

:FbOpt8
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Getting All Variables (getvar all)...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'getvar all' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo [!] Error: Fastboot connection timed out or hung!
pause
goto FastbootMenu

:FbOpt9
if not exist "%FASTBOOT%" goto MissingTools
cls
echo [*] Bootloader Unlock...
echo [*] Checking for connected fastboot device (waiting 3s)...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo [!] Error: Fastboot connection timed out! & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo [!] Error: No fastboot device detected! & pause & goto FastbootMenu )
echo [✔] Device detected!
echo [*] Running unlock command. Check phone screen...
"%FASTBOOT%" flashing unlock
pause
goto FastbootMenu

:FbOpt10
if not exist "%FASTBOOT%" goto MissingTools
cls
echo ===================================================
echo             FLASH BOOT (Drag ^& Drop System)
echo ===================================================
echo.
set /p img_file="--^> Drag and drop your BOOT .img file here: "
set img_file=%img_file:"=%
if not exist "%img_file%" echo [!] File not found! & pause & goto FastbootMenu

echo [*] Checking for fastboot device (waiting 3s)...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { Write-Output $txt; exit 0 }"
if %errorlevel% equ 124 ( echo [!] Error: Connection timed out! & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo [!] Error: No device detected! & pause & goto FastbootMenu )

echo [✔] Device detected! Flashing boot...
"%FASTBOOT%" flash boot "%img_file%"
echo [~] Finished!
pause & goto FastbootMenu

:FbOpt11
if not exist "%FASTBOOT%" goto MissingTools
cls
echo ===================================================
echo           FLASH INIT_BOOT (Drag ^& Drop System)
echo ===================================================
echo.
set /p img_file="--^> Drag and drop your INIT_BOOT .img file here: "
set img_file=%img_file:"=%
if not exist "%img_file%" echo [!] File not found! & pause & goto FastbootMenu

echo [*] Checking for fastboot device (waiting 3s)...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo [!] Error: Connection timed out! & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo [!] Error: No device detected! & pause & goto FastbootMenu )

echo [✔] Device detected! Flashing init_boot...
"%FASTBOOT%" flash init_boot "%img_file%"
echo [~] Finished!
pause & goto FastbootMenu

:FbOpt12
if not exist "%FASTBOOT%" goto MissingTools
cls
echo ===================================================
echo           FLASH RECOVERY (Drag ^& Drop System)
echo ===================================================
echo.
set /p img_file="--^> Drag and drop your RECOVERY .img file here: "
set img_file=%img_file:"=%
if not exist "%img_file%" echo [!] File not found! & pause & goto FastbootMenu

echo [*] Checking for fastboot device (waiting 3s)...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo [!] Error: Connection timed out! & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo [!] Error: No device detected! & pause & goto FastbootMenu )

echo [✔] Device detected! Flashing recovery...
"%FASTBOOT%" flash recovery "%img_file%"
echo [~] Finished!
pause & goto FastbootMenu

:FbOpt13
if not exist "%FASTBOOT%" goto MissingTools
cls
echo ===================================================
echo            FLASH VBMETA (Drag ^& Drop System)
echo ===================================================
echo.
set /p img_file="--^> Drag and drop your VBMETA .img file here: "
set img_file=%img_file:"=%
if not exist "%img_file%" echo [!] File not found! & pause & goto FastbootMenu

echo [*] Checking for fastboot device (waiting 3s)...
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo [!] Error: Connection timed out! & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo [!] Error: No device detected! & pause & goto FastbootMenu )

echo [✔] Device detected! Flashing vbmeta (Disabling Verity/Verification)...
"%FASTBOOT%" --disable-verity --disable-verification flash vbmeta "%img_file%"
echo [~] Finished!
pause & goto FastbootMenu

:: ==========================================
:: 4. SIDELOAD MENU
:: ==========================================
:SideloadMenu
cls
echo =========================================
echo        SIDELOAD MENU - Zishan Therapy      
echo =========================================
echo  [1] Check Sideload Devices
echo  [2] ADB Sideload ROM/ZIP (Drag ^& Drop)
echo -----------------------------------------
echo  [S] Start Scrcpy Mirroring
echo -----------------------------------------
echo  [99] Back to Main Menu
echo  [0] Exit Tool
echo =========================================
set /p choice="Enter your choice: "

if "%choice%"=="1" goto SlOpt1
if "%choice%"=="2" goto SlOpt2
if /i "%choice%"=="s" set "back_to=SideloadMenu"
if /i "%choice%"=="s" goto RunScrcpy
if "%choice%"=="99" goto MainMenu
if "%choice%"=="0" exit
goto SideloadMenu

:SlOpt1
if not exist "%ADB%" goto MissingTools
cls
echo [*] Checking connected devices in sideload mode...
"%ADB%" devices
pause
goto SideloadMenu

:SlOpt2
if not exist "%ADB%" goto MissingTools
cls
echo ===================================================
echo            ADB SIDELOAD (Drag ^& Drop System)
echo ===================================================
echo Please ensure phone is in Recovery -^> Apply update from ADB.
echo.
set /p zip_file="--^> Drag and drop your ROM/OTA .zip file here: "
set zip_file=%zip_file:"=%

if not exist "%zip_file%" (
    echo [!] Error: File not found!
    pause
    goto SideloadMenu
)

cls
echo [*] Injecting package over Sideload. Do not remove cable...
echo.
"%ADB%" sideload "%zip_file%"
echo.
echo [~] Sideload process completed!
pause
goto SideloadMenu
