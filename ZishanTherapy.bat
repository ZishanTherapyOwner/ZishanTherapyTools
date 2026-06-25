@echo off
title Zishan Therapy - Windows Master Tool
color 0F

:: ==========================================
:: ANSI Colors Setup
:: ==========================================
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_R=%ESC%[0m"
set "C_H=%ESC%[96m"
set "C_T=%ESC%[1m%ESC%[92m"
set "C_O=%ESC%[93m"
set "C_S=%ESC%[92m"
set "C_E=%ESC%[91m"
set "C_I=%ESC%[94m"
set "C_W=%ESC%[95m"

:: ==========================================
:: Working Directory & Strict Path
:: ==========================================
cd /d "%~dp0"
set "PATH=%~dp0platform-tools;%PATH%"
set "ADB=%~dp0platform-tools\adb.exe"
set "FASTBOOT=%~dp0platform-tools\fastboot.exe"

:: ==========================================
:: LOGIN SYSTEM (Secure Masked Input)
:: ==========================================
:Login
cls
echo %C_H%=========================================%C_R%
echo %C_T%       ZISHAN THERAPY - SECURE LOGIN       %C_R%
echo %C_H%=========================================%C_R%
set "password="
:: PowerShell is used here to hide password input with asterisks (*)
powershell -command "$pwd = Read-Host 'Enter Password' -AsSecureString; $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd); $plainPwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR); [IO.File]::WriteAllText('%temp%\zt_pass.tmp', $plainPwd)"

if exist "%temp%\zt_pass.tmp" (
    set /p password=<"%temp%\zt_pass.tmp"
    del /q "%temp%\zt_pass.tmp" >nul 2>&1
)

:: Password checking
if "%password%"=="bgbahad123" goto MainMenu

echo.
echo %C_E%[X] Incorrect Password! Try again.%C_R%
pause
goto Login

:: ==========================================
:: MAIN MENU
:: ==========================================
:MainMenu
cls
echo %C_H%=========================================%C_R%
echo %C_T%              Zishan Therapy              %C_R%
echo %C_H%=========================================%C_R%
echo  %C_O%[1]%C_R% Download Menu (Tools ^& APKs)
echo  %C_O%[2]%C_R% ADB Menu
echo  %C_O%[3]%C_R% Fastboot Menu
echo  %C_O%[4]%C_R% Sideload Menu
echo %C_H%-----------------------------------------%C_R%
echo  %C_W%[S]%C_R% Start Scrcpy Mirroring
echo %C_H%-----------------------------------------%C_R%
echo  %C_I%[M]%C_R% Delete Mobile Data (ZishanTherapy)
echo  %C_E%[P]%C_R% Delete PC Data (Clean Tool Folder)
echo  %C_E%[0]%C_R% Exit Tool
echo %C_H%=========================================%C_R%
set /p main_choice="%C_O%Select Category:%C_R% "

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
echo %C_E%=========================================%C_R%
echo %C_E%[!] ERROR: Platform Tools Not Found!%C_R%
echo %C_E%=========================================%C_R%
echo Please download the tools first before using this option.
echo.
echo 1. Go to "Download Menu"
echo 2. Select Option "1" to Auto Install Platform Tools.
echo.
pause
goto MainMenu

:: ==========================================
:: UNIVERSAL SCRCPY RUNNER
:: ==========================================
:RunScrcpy
cls
set "SCRCPY_EXE="
if exist "%~dp0scrcpy\scrcpy.exe" set "SCRCPY_EXE=%~dp0scrcpy\scrcpy.exe"
if exist "%~dp0scrcpy\scrcpy-win64-v2.4\scrcpy.exe" set "SCRCPY_EXE=%~dp0scrcpy\scrcpy-win64-v2.4\scrcpy.exe"

if not "%SCRCPY_EXE%"=="" goto LaunchScrcpy
echo %C_E%=========================================%C_R%
echo %C_E%[!] ERROR: Scrcpy Not Found!%C_R%
echo %C_E%=========================================%C_R%
echo Please download Scrcpy first from the Download Menu (Option 2).
echo.
pause
goto %back_to%

:LaunchScrcpy
echo %C_I%[*] Launching Scrcpy Screen Mirroring...%C_R%
echo %C_I%[*] Make sure USB Debugging is allowed on the device.%C_R%
start "" "%SCRCPY_EXE%"
timeout /t 1 >nul
goto %back_to%

:: ==========================================
:: DATA CLEANUP SYSTEM
:: ==========================================
:DeleteMobileData
if not exist "%ADB%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%               DELETE MOBILE DATA (PHONE)           %C_R%
echo %C_H%===================================================%C_R%
echo.
echo %C_I%[*] Cleaning ZishanTherapy directory from device...%C_R%
echo.
"%ADB%" shell rm -rf /sdcard/Download/ZishanTherapy
echo %C_S%[~] SUCCESS: Mobile 'ZishanTherapy' folder deleted successfully!%C_R%
echo.
pause
goto MainMenu

:DeletePcData
cls
echo %C_E%===================================================%C_R%
echo %C_E%               DELETE PC DATA (PC CLEANUP)          %C_R%
echo %C_E%===================================================%C_R%
echo.
echo %C_E%[!] WARNING: This will delete all downloaded folders, tools,%C_R% 
echo %C_E%     APKs, and ZIP files next to this script!%C_R%
echo %C_E%[!] Only this main batch script file will remain.%C_R%
echo.
set /p confirm="%C_O%Are you sure you want to completely clean up? (Y/N): %C_R%"
if /i not "%confirm%"=="Y" goto MainMenu

echo.
echo %C_I%[*] Cleaning up PC data...%C_R%
for %%i in ("%~dp0*") do (
    if not "%%~nxi"=="%~nx0" del /f /q "%%i"
)
for /d %%i in ("%~dp0*") do (
    rmdir /s /q "%%i"
)
echo.
echo %C_S%[~] SUCCESS: Tool folder cleaned! All downloaded data deleted.%C_R%
echo.
pause
goto MainMenu

:: ==========================================
:: 1. DOWNLOAD MENU
:: ==========================================
:DownloadMenu
cls
echo %C_H%=========================================%C_R%
echo %C_T%         DOWNLOAD MENU - Zishan Therapy   %C_R%
echo %C_H%=========================================%C_R%
echo  %C_O%[1]%C_R% Download Platform Tools (Auto Extract)
echo  %C_O%[2]%C_R% Download Scrcpy (Screen Mirroring)
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[3]%C_R% Download Magisk Manager (APK)
echo  %C_O%[4]%C_R% Download Kitsune Mask (APK)
echo  %C_O%[5]%C_R% Download Root Checker (APK)
echo  %C_O%[6]%C_R% Download Termux API (APK)
echo  %C_O%[7]%C_R% Download Termux (APK)
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[8]%C_R% Download MagiskHideProps Module (ZIP)
echo  %C_O%[9]%C_R% Download 7-Zip Installer (EXE)
echo  %C_O%[10]%C_R% Download FastbootEnhance (Auto Extract)
echo  %C_O%[11]%C_R% Download ADB Setup 1.3 (Auto Extract)
echo  %C_O%[12]%C_R% Download IDM Installer (EXE)
echo  %C_O%[13]%C_R% Download IDM Trial Reset (Auto Extract)
echo  %C_O%[14]%C_R% Download MultipleAccounts (APK)
echo %C_H%-----------------------------------------%C_R%
echo  %C_W%[S]%C_R% Start Scrcpy Mirroring
echo %C_H%-----------------------------------------%C_R%
echo  %C_E%[99]%C_R% Back to Main Menu
echo  %C_E%[0]%C_R% Exit Tool
echo %C_H%=========================================%C_R%
set /p choice="%C_O%Enter your choice:%C_R% "

if "%choice%"=="1" goto DloadOpt1
if "%choice%"=="2" goto DloadOpt2
if "%choice%"=="3" goto DloadOpt3
if "%choice%"=="4" goto DloadOpt4
if "%choice%"=="5" goto DloadOpt5
if "%choice%"=="6" goto DloadOpt6
if "%choice%"=="7" goto DloadOpt7
if "%choice%"=="8" goto DloadOpt8
if "%choice%"=="9" goto DloadOpt9
if "%choice%"=="10" goto DloadOpt10
if "%choice%"=="11" goto DloadOpt11
if "%choice%"=="12" goto DloadOpt12
if "%choice%"=="13" goto DloadOpt13
if "%choice%"=="14" goto DloadOpt14
if /i "%choice%"=="s" set "back_to=DownloadMenu"
if /i "%choice%"=="s" goto RunScrcpy
if "%choice%"=="99" goto MainMenu
if "%choice%"=="0" exit
goto DownloadMenu

:DloadOpt1
cls
if exist "%~dp0platform-tools\adb.exe" (
    echo %C_I%[*] Platform Tools is already installed!%C_R%
    echo %C_I%[*] No need to download again.%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading Official Platform Tools (Google Direct Link)...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" -o platform-tools.zip
echo ----------------------------------------------------------------------
if not exist platform-tools.zip (
    echo %C_E%[!] Download Failed! Check your internet connection.%C_R%
    pause
    goto DownloadMenu
)

:ExtractTools
echo.
echo %C_I%[*] Extracting files (Please wait)...%C_R%
if exist "pt_temp" rmdir /s /q "pt_temp"
powershell -command "Expand-Archive -Force -Path 'platform-tools.zip' -DestinationPath 'pt_temp'"

echo %C_I%[*] Organizing Platform Tools folder...%C_R%
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
    echo %C_E%[X] ERROR: adb.exe not found! Zip file might be corrupt.%C_R%
    rmdir /s /q "platform-tools" 2>nul
) else (
    echo.
    echo %C_S%[~] SUCCESS: Platform Tools Installed perfectly!%C_R%
)

echo %C_I%[*] Cleaning up temporary files...%C_R%
rmdir /s /q "pt_temp" 2>nul
del /f /q "platform-tools.zip" 2>nul
echo.
pause
goto DownloadMenu

:DloadOpt2
cls
if exist "%~dp0scrcpy\scrcpy.exe" (
    echo %C_I%[*] Scrcpy is already installed!%C_R%
    echo %C_I%[*] No need to download again.%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading Scrcpy...%C_R%
echo ----------------------------------------------------------------------
curl -L https://github.com/Genymobile/scrcpy/releases/download/v2.4/scrcpy-win64-v2.4.zip -o scrcpy.zip
echo ----------------------------------------------------------------------
if not exist scrcpy.zip (
    echo %C_E%[!] Download Failed! Check your internet connection.%C_R%
    pause
    goto DownloadMenu
)

:ExtractScrcpy
echo.
echo %C_I%[*] Extracting Scrcpy files (Please wait)...%C_R%
if exist "scrcpy_temp" rmdir /s /q "scrcpy_temp"
powershell -command "Expand-Archive -Force -Path 'scrcpy.zip' -DestinationPath 'scrcpy_temp'"

echo %C_I%[*] Organizing Scrcpy folder...%C_R%
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
    echo %C_E%[X] ERROR: scrcpy.exe not found!%C_R%
    rmdir /s /q "scrcpy" 2>nul
) else (
    echo.
    echo %C_S%[~] SUCCESS: Scrcpy Installed perfectly in the 'scrcpy' folder!%C_R%
)

echo %C_I%[*] Cleaning up...%C_R%
rmdir /s /q "scrcpy_temp" 2>nul
del /f /q "scrcpy.zip" 2>nul
echo.
pause
goto DownloadMenu

:DloadOpt3
cls
if exist "%~dp0MagiskManager.apk" (
    echo %C_I%[*] MagiskManager.apk is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Fetching Magisk Manager via Official GitHub Latest Link...%C_R%
set "MAGISK_URL="
for /f "delims=" %%i in ('powershell -command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/topjohnwu/Magisk/releases/latest').assets | Where-Object {$_.name -like '*.apk'} | Select-Object -ExpandProperty browser_download_url" 2^>nul') do set "MAGISK_URL=%%i"

if "%MAGISK_URL%"=="" goto MagiskDriveFallback
echo %C_I%[*] Downloading Latest Magisk Manager APK...%C_R%
echo ----------------------------------------------------------------------
curl -L "%MAGISK_URL%" -o MagiskManager.apk
echo ----------------------------------------------------------------------
if exist MagiskManager.apk goto MagiskSuccess
goto MagiskDriveFallback

:MagiskDriveFallback
echo.
echo %C_E%[!] GitHub Link Failed! Try 2: Downloading via Backup...%C_R%
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1o4bk2MJ8Khb9wp35JGlu4XpMDPcf6Orn'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'MagiskManager.apk')" 2>nul
echo ----------------------------------------------------------------------

:MagiskSuccess
echo.
echo %C_S%[~] SUCCESS: MagiskManager.apk is ready!%C_R%
pause
goto DownloadMenu

:DloadOpt4
cls
if exist "%~dp0KitsuneMask.apk" (
    echo %C_I%[*] KitsuneMask.apk is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading Kitsune Mask via Your GitHub Release...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux.api_1002.apk" -o KitsuneMask.apk
echo ----------------------------------------------------------------------
if exist KitsuneMask.apk goto KitsuneSuccess
goto KitsuneDriveFallback

:KitsuneDriveFallback
echo.
echo %C_E%[!] GitHub Release Failed! Try 2: Downloading via Backup...%C_R%
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1ZSVsougbTNpG7-LD_7UE720cOY7-4CBm'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'KitsuneMask.apk')" 2>nul
echo ----------------------------------------------------------------------

:KitsuneSuccess
echo.
echo %C_S%[~] SUCCESS: KitsuneMask.apk is ready!%C_R%
pause
goto DownloadMenu

:DloadOpt5
cls
if exist "%~dp0RootChecker.apk" (
    echo %C_I%[*] RootChecker.apk is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading Root Checker via Your GitHub Release...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/root-checker-6-5-3.apk" -o RootChecker.apk
echo ----------------------------------------------------------------------
if exist RootChecker.apk goto RootSuccess
goto RootDriveFallback

:RootDriveFallback
echo.
echo %C_E%[!] GitHub Release Failed! Try 2: Downloading via Backup...%C_R%
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1iwiN3PSXRVxbVJL1Mgz_qWsSHySw6A_S'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'RootChecker.apk')" 2>nul
echo ----------------------------------------------------------------------

:RootSuccess
echo.
echo %C_S%[~] SUCCESS: RootChecker.apk is ready!%C_R%
pause
goto DownloadMenu

:DloadOpt6
cls
if exist "%~dp0TermuxAPI.apk" (
    echo %C_I%[*] TermuxAPI.apk is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading Termux API via Your GitHub Release...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux.api_1002.apk" -o TermuxAPI.apk
echo ----------------------------------------------------------------------
if exist TermuxAPI.apk goto TermuxApiSuccess
goto TermuxApiDriveFallback

:TermuxApiDriveFallback
echo.
echo %C_E%[!] GitHub Release Failed! Try 2: Downloading via Backup...%C_R%
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='11KVDClixRM9Hrez6bSzQs7T6U486ym5F'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'TermuxAPI.apk')" 2>nul
echo ----------------------------------------------------------------------

:TermuxApiSuccess
echo.
echo %C_S%[~] SUCCESS: TermuxAPI.apk is ready!%C_R%
pause
goto DownloadMenu

:DloadOpt7
cls
if exist "%~dp0Termux.apk" (
    echo %C_I%[*] Termux.apk is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading Termux via Your GitHub Release...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/com.termux_1022.apk" -o Termux.apk
echo ----------------------------------------------------------------------
if exist Termux.apk goto TermuxSuccess
goto TermuxDriveFallback

:TermuxDriveFallback
echo.
echo %C_E%[!] GitHub Release Failed! Try 2: Downloading via Backup...%C_R%
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='1iP-_UJS5A_k4NXF6QmPGok4z9-973Ls7'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'Termux.apk')" 2>nul
echo ----------------------------------------------------------------------

:TermuxSuccess
echo.
echo %C_S%[~] SUCCESS: Termux.apk is ready!%C_R%
pause
goto DownloadMenu

:DloadOpt8
cls
if exist "%~dp0MagiskHideProps.zip" (
    echo %C_I%[*] MagiskHideProps Module ZIP is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading MagiskHideProps Module ZIP via Your GitHub Release...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MagiskHidePropsConf-v6.1.2.zip" -o MagiskHideProps.zip
echo ----------------------------------------------------------------------
if exist MagiskHideProps.zip goto PropsSuccess
goto PropsDriveFallback

:PropsDriveFallback
echo.
echo %C_E%[!] GitHub Release Failed! Try 2: Downloading via Backup...%C_R%
echo ----------------------------------------------------------------------
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $id='12EZPSihEkdm2o8LwJ4B9s8s2J0Y5kDEN'; $url='https://docs.google.com/uc?export=download&id='+$id; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0'); $h=$wc.DownloadString($url); if($h -match 'confirm=([^&''\s>]+)'){$c=$Matches[1].Split([char]34)[0]; $url='https://docs.google.com/uc?export=download&confirm='+$c+'&id='+$id}; $wc.DownloadFile($url, 'MagiskHideProps.zip')" 2>nul
echo ----------------------------------------------------------------------

:PropsSuccess
echo.
echo %C_S%[~] SUCCESS: MagiskHideProps.zip is ready!%C_R%
pause
goto DownloadMenu

:DloadOpt9
cls
if exist "%~dp07z2601-x64.exe" (
    echo %C_I%[*] 7-Zip Installer is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading Official 7-Zip Installer...%C_R%
echo ----------------------------------------------------------------------
curl -L https://github.com/ip7z/7zip/releases/download/26.01/7z2601-x64.exe -o 7z2601-x64.exe
echo ----------------------------------------------------------------------
echo.
echo %C_S%[~] SUCCESS: 7z2601-x64.exe saved in tool folder!%C_R%
pause
goto DownloadMenu

:DloadOpt10
cls
if exist "%~dp0FastbootEnhance" (
    echo %C_I%[*] FastbootEnhance is already installed!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading FastbootEnhance...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/FastbootEnhance-v1.4.0.1.zip" -o FastbootEnhance.zip
echo ----------------------------------------------------------------------
if exist FastbootEnhance.zip (
    echo %C_I%[*] Extracting FastbootEnhance...%C_R%
    powershell -command "Expand-Archive -Force -Path 'FastbootEnhance.zip' -DestinationPath 'FastbootEnhance'"
    del /f /q "FastbootEnhance.zip"
    echo %C_S%[~] SUCCESS: FastbootEnhance Installed perfectly!%C_R%
) else (
    echo %C_E%[!] Download Failed!%C_R%
)
pause
goto DownloadMenu

:DloadOpt11
cls
if exist "%~dp0ADB_Setup_1.3" (
    echo %C_I%[*] ADB Setup 1.3 is already installed/extracted!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading ADB Setup 1.3...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/adb-setup-1.3.zip" -o ADB_Setup.zip
echo ----------------------------------------------------------------------
if exist ADB_Setup.zip (
    echo %C_I%[*] Extracting ADB Setup 1.3...%C_R%
    powershell -command "Expand-Archive -Force -Path 'ADB_Setup.zip' -DestinationPath 'ADB_Setup_1.3'"
    del /f /q "ADB_Setup.zip"
    echo %C_S%[~] SUCCESS: ADB Setup 1.3 Installed perfectly!%C_R%
) else (
    echo %C_E%[!] Download Failed!%C_R%
)
pause
goto DownloadMenu

:DloadOpt12
cls
if exist "%~dp0idman643build1.exe" (
    echo %C_I%[*] IDM Installer is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading IDM Installer...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/idman643build1.exe" -o idman643build1.exe
echo ----------------------------------------------------------------------
if exist idman643build1.exe (
    echo %C_S%[~] SUCCESS: IDM Installer saved in tool folder!%C_R%
) else (
    echo %C_E%[!] Download Failed!%C_R%
)
pause
goto DownloadMenu

:DloadOpt13
cls
if exist "%~dp0IDM_Trial_Reset" (
    echo %C_I%[*] IDM Trial Reset is already installed/extracted!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading IDM Trial Reset...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/IDM.Trial.Reset.v1.0.0.zip" -o IDM_Trial_Reset.zip
echo ----------------------------------------------------------------------
if exist IDM_Trial_Reset.zip (
    echo %C_I%[*] Extracting IDM Trial Reset...%C_R%
    powershell -command "Expand-Archive -Force -Path 'IDM_Trial_Reset.zip' -DestinationPath 'IDM_Trial_Reset'"
    del /f /q "IDM_Trial_Reset.zip"
    echo %C_S%[~] SUCCESS: IDM Trial Reset Extracted perfectly!%C_R%
) else (
    echo %C_E%[!] Download Failed!%C_R%
)
pause
goto DownloadMenu

:DloadOpt14
cls
if exist "%~dp0MultipleAccounts.apk" (
    echo %C_I%[*] MultipleAccounts.apk is already downloaded!%C_R%
    echo.
    pause
    goto DownloadMenu
)
echo %C_I%[*] Downloading MultipleAccounts APK...%C_R%
echo ----------------------------------------------------------------------
curl -L "https://github.com/ZishanTherapyOwner/ZT-Files/releases/download/v1.0/MultipleAccounts.apk" -o MultipleAccounts.apk
echo ----------------------------------------------------------------------
if exist MultipleAccounts.apk (
    echo %C_S%[~] SUCCESS: MultipleAccounts.apk downloaded perfectly!%C_R%
) else (
    echo %C_E%[!] Download Failed!%C_R%
)
pause
goto DownloadMenu

:: ==========================================
:: 2. ADB MENU
:: ==========================================
:AdbMenu
cls
echo %C_H%=========================================%C_R%
echo %C_T%         ADB MENU - Zishan Therapy       %C_R%
echo %C_H%=========================================%C_R%
echo  %C_O%[1]%C_R% Check ADB Devices
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[2]%C_R% Reboot to System (Normal)
echo  %C_O%[3]%C_R% Reboot to Recovery
echo  %C_O%[4]%C_R% Reboot to Bootloader
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[5]%C_R% ADB Push File (Drag ^& Drop)
echo  %C_O%[6]%C_R% ADB Install APK (Normal)
echo  %C_O%[7]%C_R% ADB Install APK (Bypass Low SDK Block)
echo  %C_O%[8]%C_R% Enable Multiuser (Permanent via Magisk)
echo  %C_O%[9]%C_R% Get ADB Device Info (Version/Build)
echo %C_H%-----------------------------------------%C_R%
echo  %C_W%[S]%C_R% Start Scrcpy Mirroring
echo %C_H%-----------------------------------------%C_R%
echo  %C_E%[99]%C_R% Back to Main Menu
echo  %C_E%[0]%C_R% Exit Tool
echo %C_H%=========================================%C_R%
set /p choice="%C_O%Enter your choice:%C_R% "

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
echo %C_I%[*] Checking connected ADB devices...%C_R%
"%ADB%" devices
pause
goto AdbMenu

:AdbOpt2
if not exist "%ADB%" goto MissingTools
cls
echo %C_I%[*] Rebooting device to System...%C_R%
"%ADB%" reboot
pause
goto AdbMenu

:AdbOpt3
if not exist "%ADB%" goto MissingTools
cls
echo %C_I%[*] Rebooting to Recovery Mode...%C_R%
"%ADB%" reboot recovery
pause
goto AdbMenu

:AdbOpt4
if not exist "%ADB%" goto MissingTools
cls
echo %C_I%[*] Rebooting to Bootloader...%C_R%
"%ADB%" reboot bootloader
pause
goto AdbMenu

:AdbOpt5
if not exist "%ADB%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%             ADB PUSH (Drag ^& Drop System)         %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p push_file="%C_O%--> Drag and drop your file here and press Enter: %C_R%"
set push_file=%push_file:"=%

if not exist "%push_file%" (
    echo.
    echo %C_E%[!] Error: Invalid path or File not found!%C_R%
    pause
    goto AdbMenu
)

cls
echo %C_I%[*] Processing Device Storage Folder...%C_R%
"%ADB%" shell mkdir -p /sdcard/Download/ZishanTherapy
echo %C_I%[*] Pushing file into: Download/ZishanTherapy/%C_R%
echo.
"%ADB%" push "%push_file%" /sdcard/Download/ZishanTherapy/
echo.
echo %C_S%[~] Push completed successfully!%C_R%
pause
goto AdbMenu

:AdbOpt6
if not exist "%ADB%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%             ADB INSTALL (Normal)                   %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p apk_file="%C_O%--> Drag and drop your APK file here and press Enter: %C_R%"
set apk_file=%apk_file:"=%

if not exist "%apk_file%" (
    echo.
    echo %C_E%[!] Error: Invalid path or File not found!%C_R%
    pause
    goto AdbMenu
)

cls
echo %C_I%[*] Installing app, please look at your phone...%C_R%
echo.
"%ADB%" install -r "%apk_file%"
echo.
echo %C_S%[~] Process finished!%C_R%
pause
goto AdbMenu

:AdbOpt7
if not exist "%ADB%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%     ADB INSTALL (Bypass Low Target SDK Block)      %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p apk_file="%C_O%--> Drag and drop your APK file here and press Enter: %C_R%"
set apk_file=%apk_file:"=%

if not exist "%apk_file%" (
    echo.
    echo %C_E%[!] Error: Invalid path or File not found!%C_R%
    pause
    goto AdbMenu
)

cls
echo %C_I%[*] Installing app (Bypassing low target SDK block)...%C_R%
echo %C_I%[*] Please check your phone screen if any prompt appears...%C_R%
echo.
"%ADB%" install --bypass-low-target-sdk-block "%apk_file%"
echo.
echo %C_S%[~] Process finished!%C_R%
pause
goto AdbMenu

:AdbOpt8
if not exist "%ADB%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%      ENABLE MULTIUSER (Permanent via Magisk)       %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p user_count="%C_O%--> Enter maximum user limit (e.g., 4, 10, 100): %C_R%"

if "%user_count%"=="" set user_count=4

cls
echo %C_I%[*] Checking Root Access...%C_R%
echo %C_W%[!] PLEASE UNLOCK YOUR PHONE SCREEN AND TAP "GRANT" IF PROMPTED!%C_R%
echo.

:: Test Root access first
"%ADB%" shell "su -c 'echo ROOT_GRANTED'" > root_check.tmp 2>nul
set "ROOT_STATUS="
for /f "usebackq delims=" %%A in (`type root_check.tmp 2^>nul`) do set "ROOT_STATUS=%%A"
del root_check.tmp 2>nul

:: Check if the output string contains ROOT_GRANTED
echo %ROOT_STATUS% | findstr /i "ROOT_GRANTED" >nul
if errorlevel 1 (
    echo %C_E%---------------------------------------------------%C_R%
    echo %C_E%[X] ERROR: Root Permission Denied or Timed Out!%C_R%
    echo %C_E%[!] Magisk did not get permission.%C_R% 
    echo %C_E%Please try this option again and tap "Grant" on your phone quickly.%C_R%
    echo %C_E%---------------------------------------------------%C_R%
    echo.
    pause
    goto AdbMenu
)

echo %C_S%[✔] Root Access Confirmed!%C_R%
echo %C_I%[*] Injecting Magisk Boot Script...%C_R%
echo.

:: Apply immediately for current session
"%ADB%" shell "su -c 'settings put global fw.max_users %user_count%'"
"%ADB%" shell "su -c 'settings put global fw.show_multiuserui 1'"

:: Inject into Magisk post-fs-data.d for permanent effect on every boot
"%ADB%" shell "su -c 'echo \"#!/system/bin/sh\" > /data/adb/post-fs-data.d/zt_multiuser.sh'"
"%ADB%" shell "su -c 'echo \"resetprop -n fw.max_users %user_count%\" >> /data/adb/post-fs-data.d/zt_multiuser.sh'"
"%ADB%" shell "su -c 'echo \"resetprop -n fw.show_multiuserui 1\" >> /data/adb/post-fs-data.d/zt_multiuser.sh'"
"%ADB%" shell "su -c 'chmod 755 /data/adb/post-fs-data.d/zt_multiuser.sh'"

echo %C_S%---------------------------------------------------%C_R%
echo %C_S%[✔] Magisk Boot Script Injected Successfully!%C_R%
echo %C_I%[*] Rebooting device to apply permanent changes...%C_R%
"%ADB%" reboot
echo.
echo %C_S%[~] SUCCESS: Process finished! Device is restarting.%C_R%
echo %C_I%[*] Returning to ADB Menu automatically...%C_R%
timeout /t 2 >nul
goto AdbMenu

:AdbOpt9
if not exist "%ADB%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%               ADB DEVICE INFORMATION               %C_R%
echo %C_H%===================================================%C_R%
echo.
echo %C_I%[*] Fetching details from connected device...%C_R%
echo %C_H%---------------------------------------------------%C_R%
<nul set /p="%C_I%Device Model     : %C_R%" & "%ADB%" shell getprop ro.product.model
<nul set /p="%C_I%Product Code     : %C_R%" & "%ADB%" shell getprop ro.product.device
<nul set /p="%C_I%Android Version  : %C_R%" & "%ADB%" shell getprop ro.build.version.release
<nul set /p="%C_I%Hardware/Board   : %C_R%" & "%ADB%" shell getprop ro.hardware
<nul set /p="%C_I%Build/OS Version : %C_R%" & "%ADB%" shell getprop ro.build.display.id
echo %C_H%---------------------------------------------------%C_R%
echo.
pause
goto AdbMenu

:: ==========================================
:: 3. FASTBOOT MENU
:: ==========================================
:FastbootMenu
cls
echo %C_H%=========================================%C_R%
echo %C_T%      FASTBOOT MENU - Zishan Therapy     %C_R%
echo %C_H%=========================================%C_R%
echo  %C_O%[1]%C_R% Check Fastboot Devices
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[2]%C_R% Reboot to System
echo  %C_O%[3]%C_R% Reboot to Recovery
echo  %C_O%[4]%C_R% Reboot to Fastbootd (User space)
echo  %C_O%[5]%C_R% Reboot to Bootloader
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[6]%C_R% Get Product Name (getvar product)
echo  %C_O%[7]%C_R% Get Device Info (oem device-info)
echo  %C_O%[8]%C_R% Check Bootloader Status (Unlock State)
echo  %C_O%[9]%C_R% Get All Variables (getvar all)
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[10]%C_R% Bootloader Unlock (flashing unlock)
echo %C_H%-----------------------------------------%C_R%
echo  %C_O%[11]%C_R% Flash boot (Drag ^& Drop)
echo  %C_O%[12]%C_R% Flash init_boot (Drag ^& Drop)
echo  %C_O%[13]%C_R% Flash recovery (Drag ^& Drop)
echo  %C_O%[14]%C_R% Flash vbmeta (Drag ^& Drop)
echo %C_H%-----------------------------------------%C_R%
echo  %C_E%[15]%C_R% Factory Reset (fastboot -w)
echo  %C_E%[16]%C_R% Erase Userdata (fastboot erase userdata)
echo  %C_E%[17]%C_R% Erase FRP (fastboot erase frp)
echo %C_H%-----------------------------------------%C_R%
echo  %C_W%[S]%C_R% Start Scrcpy Mirroring
echo %C_H%-----------------------------------------%C_R%
echo  %C_E%[99]%C_R% Back to Main Menu
echo  %C_E%[0]%C_R% Exit Tool
echo %C_H%=========================================%C_R%
set /p choice="%C_O%Enter your choice:%C_R% "

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
if "%choice%"=="14" goto FbOpt14
if "%choice%"=="15" goto FbOpt15
if "%choice%"=="16" goto FbOpt16
if "%choice%"=="17" goto FbOpt17
if /i "%choice%"=="s" set "back_to=FastbootMenu"
if /i "%choice%"=="s" goto RunScrcpy
if "%choice%"=="99" goto MainMenu
if "%choice%"=="0" exit
goto FastbootMenu

:FbOpt1
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Checking connected Fastboot devices...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { Write-Output $txt; exit 0 }"
if %errorlevel% equ 124 (
    echo.
    echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
) else if %errorlevel% equ 1 (
    echo.
    echo %C_E%[!] Error: No fastboot device detected!%C_R%
)
pause
goto FastbootMenu

:FbOpt2
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Rebooting device to System...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
pause
goto FastbootMenu

:FbOpt3
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Rebooting device to Recovery...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot recovery' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
pause
goto FastbootMenu

:FbOpt4
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Rebooting device to Fastbootd (User space)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot fastboot' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
pause
goto FastbootMenu

:FbOpt5
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Rebooting device to Bootloader...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'reboot bootloader' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
pause
goto FastbootMenu

:FbOpt6
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Getting Product Name...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'getvar product' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
pause
goto FastbootMenu

:FbOpt7
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Getting OEM Device Info...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'oem device-info' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
pause
goto FastbootMenu

:FbOpt8
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%           CHECK BOOTLOADER UNLOCK STATUS           %C_R%
echo %C_H%===================================================%C_R%
echo.
echo %C_I%[*] Checking for connected fastboot device...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Fastboot connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No fastboot device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Fetching Unlock Status...%C_R%
echo %C_H%---------------------------------------------------%C_R%
echo %C_I%[*] Method 1 (Standard Android 'unlocked' state):%C_R%
"%FASTBOOT%" getvar unlocked 2>&1 | findstr /i "unlocked"
echo.
echo %C_I%[*] Method 2 (Secure boot state - 'yes' means locked):%C_R%
"%FASTBOOT%" getvar secure 2>&1 | findstr /i "secure"
echo.
echo %C_I%[*] Method 3 (Xiaomi / OEM Device Info):%C_R%
"%FASTBOOT%" oem device-info 2>&1 | findstr /i "unlock"
echo %C_H%---------------------------------------------------%C_R%
echo %C_W%[!] Note: If any method says "true" or "yes" for unlocked (or "no" for secure),%C_R%
echo %C_W%    your bootloader is UNLOCKED.%C_R%
echo.
pause
goto FastbootMenu

:FbOpt9
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Getting All Variables (getvar all)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'getvar all' -NoNewWindow -PassThru; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; exit 124 }"
if %errorlevel% equ 124 echo %C_E%[!] Error: Fastboot connection timed out or hung!%C_R%
pause
goto FastbootMenu

:FbOpt10
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_I%[*] Bootloader Unlock...%C_R%
echo %C_I%[*] Checking for connected fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Fastboot connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No fastboot device detected!%C_R% & pause & goto FastbootMenu )
echo %C_S%[✔] Device detected!%C_R%
echo %C_W%[*] Running unlock command. Check phone screen...%C_R%
"%FASTBOOT%" flashing unlock
pause
goto FastbootMenu

:FbOpt11
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%             FLASH BOOT (Drag ^& Drop System)       %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p img_file="%C_O%--> Drag and drop your BOOT .img file here: %C_R%"
set img_file=%img_file:"=%
if not exist "%img_file%" echo %C_E%[!] File not found!%C_R% & pause & goto FastbootMenu

echo %C_I%[*] Checking for fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { Write-Output $txt; exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Flashing boot...%C_R%
"%FASTBOOT%" flash boot "%img_file%"
echo %C_S%[~] Finished!%C_R%
pause & goto FastbootMenu

:FbOpt12
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%           FLASH INIT_BOOT (Drag ^& Drop System)    %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p img_file="%C_O%--> Drag and drop your INIT_BOOT .img file here: %C_R%"
set img_file=%img_file:"=%
if not exist "%img_file%" echo %C_E%[!] File not found!%C_R% & pause & goto FastbootMenu

echo %C_I%[*] Checking for fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Flashing init_boot...%C_R%
"%FASTBOOT%" flash init_boot "%img_file%"
echo %C_S%[~] Finished!%C_R%
pause & goto FastbootMenu

:FbOpt13
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%           FLASH RECOVERY (Drag ^& Drop System)     %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p img_file="%C_O%--> Drag and drop your RECOVERY .img file here: %C_R%"
set img_file=%img_file:"=%
if not exist "%img_file%" echo %C_E%[!] File not found!%C_R% & pause & goto FastbootMenu

echo %C_I%[*] Checking for fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Flashing recovery...%C_R%
"%FASTBOOT%" flash recovery "%img_file%"
echo %C_S%[~] Finished!%C_R%
pause & goto FastbootMenu

:FbOpt14
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%            FLASH VBMETA (Drag ^& Drop System)      %C_R%
echo %C_H%===================================================%C_R%
echo.
set /p img_file="%C_O%--> Drag and drop your VBMETA .img file here: %C_R%"
set img_file=%img_file:"=%
if not exist "%img_file%" echo %C_E%[!] File not found!%C_R% & pause & goto FastbootMenu

echo %C_I%[*] Checking for fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Flashing vbmeta (Disabling Verity/Verification)...%C_R%
"%FASTBOOT%" --disable-verity --disable-verification flash vbmeta "%img_file%"
echo %C_S%[~] Finished!%C_R%
pause & goto FastbootMenu

:FbOpt15
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_E%===================================================%C_R%
echo %C_E%            FACTORY RESET (fastboot -w)             %C_R%
echo %C_E%===================================================%C_R%
echo.
echo %C_E%[!] WARNING: This will WIPE ALL USER DATA on the device!%C_R%
set /p confirm="%C_O%Are you sure you want to proceed? (Y/N): %C_R%"
if /i not "%confirm%"=="Y" goto FastbootMenu

echo %C_I%[*] Checking for fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { Write-Output $txt; exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Wiping data...%C_R%
"%FASTBOOT%" -w
echo %C_S%[~] Finished!%C_R%
pause & goto FastbootMenu

:FbOpt16
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_E%===================================================%C_R%
echo %C_E%       ERASE USERDATA (fastboot erase userdata)     %C_R%
echo %C_E%===================================================%C_R%
echo.
echo %C_E%[!] WARNING: This will ERASE USERDATA partition!%C_R%
set /p confirm="%C_O%Are you sure you want to proceed? (Y/N): %C_R%"
if /i not "%confirm%"=="Y" goto FastbootMenu

echo %C_I%[*] Checking for fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { Write-Output $txt; exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Erasing userdata...%C_R%
"%FASTBOOT%" erase userdata
echo %C_S%[~] Finished!%C_R%
pause & goto FastbootMenu

:FbOpt17
if not exist "%FASTBOOT%" goto MissingTools
cls
echo %C_E%===================================================%C_R%
echo %C_E%          ERASE FRP (fastboot erase frp)            %C_R%
echo %C_E%===================================================%C_R%
echo.
echo %C_W%[!] Note: This command removes Google FRP Lock on supported devices.%C_R%
set /p confirm="%C_O%Are you sure you want to proceed? (Y/N): %C_R%"
if /i not "%confirm%"=="Y" goto FastbootMenu

echo %C_I%[*] Checking for fastboot device (waiting 3s)...%C_R%
powershell -command "$p = Start-Process '%FASTBOOT%' -ArgumentList 'devices' -NoNewWindow -PassThru -RedirectStandardOutput 'fb_t.txt'; if (-not $p.WaitForExit(3000)) { Stop-Process -Id $p.Id -Force; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; exit 124 }; $txt = Get-Content 'fb_t.txt' -Raw; Remove-Item 'fb_t.txt' -ErrorAction SilentlyContinue; if ([string]::IsNullOrWhiteSpace($txt)) { exit 1 } else { Write-Output $txt; exit 0 }"
if %errorlevel% equ 124 ( echo %C_E%[!] Error: Connection timed out!%C_R% & pause & goto FastbootMenu )
if %errorlevel% equ 1 ( echo %C_E%[!] Error: No device detected!%C_R% & pause & goto FastbootMenu )

echo %C_S%[✔] Device detected! Erasing FRP...%C_R%
"%FASTBOOT%" erase frp
echo %C_S%[~] Finished!%C_R%
pause & goto FastbootMenu

:: ==========================================
:: 4. SIDELOAD MENU
:: ==========================================
:SideloadMenu
cls
echo %C_H%=========================================%C_R%
echo %C_T%        SIDELOAD MENU - Zishan Therapy    %C_R%
echo %C_H%=========================================%C_R%
echo  %C_O%[1]%C_R% Check Sideload Devices
echo  %C_O%[2]%C_R% ADB Sideload ROM/ZIP (Drag ^& Drop)
echo %C_H%-----------------------------------------%C_R%
echo  %C_W%[S]%C_R% Start Scrcpy Mirroring
echo %C_H%-----------------------------------------%C_R%
echo  %C_E%[99]%C_R% Back to Main Menu
echo  %C_E%[0]%C_R% Exit Tool
echo %C_H%=========================================%C_R%
set /p choice="%C_O%Enter your choice:%C_R% "

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
echo %C_I%[*] Checking connected devices in sideload mode...%C_R%
"%ADB%" devices
pause
goto SideloadMenu

:SlOpt2
if not exist "%ADB%" goto MissingTools
cls
echo %C_H%===================================================%C_R%
echo %C_T%            ADB SIDELOAD (Drag ^& Drop System)      %C_R%
echo %C_H%===================================================%C_R%
echo %C_W%Please ensure phone is in Recovery -^> Apply update from ADB.%C_R%
echo.
set /p zip_file="%C_O%--> Drag and drop your ROM/OTA .zip file here: %C_R%"
set zip_file=%zip_file:"=%

if not exist "%zip_file%" (
    echo %C_E%[!] Error: File not found!%C_R%
    pause
    goto SideloadMenu
)

cls
echo %C_I%[*] Injecting package over Sideload. Do not remove cable...%C_R%
echo.
"%ADB%" sideload "%zip_file%"
echo.
echo %C_S%[~] Sideload process completed!%C_R%
pause
goto SideloadMenu
