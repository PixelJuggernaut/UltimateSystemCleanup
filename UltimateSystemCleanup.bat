@echo off
setlocal enabledelayedexpansion
title 🛠 Ultimate System Maintenance & Optimization - 2025
color 0B

:: === Setup Log File ===
set "LogFile=%~dp0SystemCleanup_%DATE:/=-%_%TIME::=-%.log"
echo Starting cleanup at %DATE% %TIME% > "%LogFile%"
echo ----------------------------------------------------- >> "%LogFile%"

:: === GUI Toggle Menu ===
set "doChk=0"
set "doKill=0"
set "doShowLog=0"

powershell -Command ^
"$title = 'Cleanup Options';" ^
"$msg = 'Select what additional actions you want to perform:';" ^
"$choices = [System.Windows.Forms.MessageBoxButtons]::YesNoCancel;" ^
"$diskCheck = [System.Windows.Forms.MessageBox]::Show('Enable Disk Check on Reboot?', 'Option 1', 'YesNo');" ^
"if ($diskCheck -eq 'Yes') { $env:doChk='1' };" ^
"$bgKill = [System.Windows.Forms.MessageBox]::Show('Kill OneDrive & Background Services?', 'Option 2', 'YesNo');" ^
"if ($bgKill -eq 'Yes') { $env:doKill='1' };" ^
"$showLog = [System.Windows.Forms.MessageBox]::Show('Open Log After Completion?', 'Option 3', 'YesNo');" ^
"if ($showLog -eq 'Yes') { $env:doShowLog='1' };"

:: === Logging Function ===
:log
echo [%TIME%] %~1 >> "%LogFile%"
goto :eof

echo.
echo 🚀 Running Cleanup...
echo.

:: === Cleanup Tasks ===
call :log "Cleaning TEMP folders..."
del /f /s /q "%TEMP%\*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
call :log "TEMP folders cleaned."

call :log "Clearing Prefetch..."
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1
call :log "Prefetch cleaned."

call :log "Flushing DNS..."
ipconfig /flushdns >> "%LogFile%"
call :log "DNS flushed."

call :log "Emptying Recycle Bin..."
PowerShell -Command "Clear-RecycleBin -Force" >> "%LogFile%"
call :log "Recycle Bin emptied."

:: === Browser Cache Cleaning ===
call :log "Cleaning Chrome cache..."
rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" 2>>"%LogFile%"
mkdir "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
call :log "Chrome cache cleaned."

call :log "Cleaning Edge cache..."
rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" 2>>"%LogFile%"
mkdir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
call :log "Edge cache cleaned."

call :log "Cleaning Firefox cache..."
for /d %%d in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do (
    rmdir /s /q "%%d\cache2" 2>>"%LogFile%"
    mkdir "%%d\cache2"
    call :log "Firefox cache cleaned in %%d"
)

:: === Optimize Drive ===
call :log "Optimizing C: drive..."
defrag C: /O >> "%LogFile%"
call :log "Drive optimization complete."

:: === Disk Check Toggle ===
if "%doChk%"=="1" (
    call :log "Scheduling disk check..."
    chkdsk C: /F /R /X >> "%LogFile%"
) else (
    call :log "Disk check skipped."
)

:: === Kill Background Services ===
if "%doKill%"=="1" (
    call :log "Killing background services..."
    taskkill /f /im OneDrive.exe >> "%LogFile%" 2>&1
    taskkill /f /im SearchIndexer.exe >> "%LogFile%" 2>&1
    taskkill /f /im OneDriveStandaloneUpdater.exe >> "%LogFile%" 2>&1
    call :log "Services terminated."
) else (
    call :log "Background services untouched."
)

:: === Restart Explorer ===
call :log "Restarting Explorer..."
taskkill /f /im explorer.exe >nul
start explorer.exe
call :log "Explorer restarted."

:: === Done ===
echo.
echo -----------------------------------------------------
echo   ✅ CLEANUP COMPLETE!
echo   Log saved at: %LogFile%
echo -----------------------------------------------------
call :log "Cleanup finished successfully."

if "%doShowLog%"=="1" (
    start notepad "%LogFile%"
)

pause
exit
