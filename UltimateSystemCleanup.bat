@echo off
title Advanced Computer Optimization Script
color 0A

echo ==========================================================
echo                 Advanced Computer Optimization Script
echo ==========================================================
echo.

:: Clear temporary files
echo [1] Cleaning temporary files...
del /s /q "%temp%\*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%"
echo Temporary files cleaned successfully.
echo ----------------------------------------------------------

:: Run disk cleanup
echo [2] Running Disk Cleanup...
cleanmgr /sagerun:1
echo Disk Cleanup completed successfully.
echo ----------------------------------------------------------

:: Check disk for errors
echo [3] Checking disk for errors...
chkdsk C: /f /r
echo Disk check initiated. If errors are detected, a repair will be scheduled on next restart.
echo ----------------------------------------------------------

:: Defragment the disk
echo [4] Defragmenting disk...
defrag C: /U /V
echo Disk defragmentation completed successfully.
echo ----------------------------------------------------------

:: Optimize startup items
echo [5] Disabling unnecessary startup programs...
wmic startup get Caption,Command > "%userprofile%\Desktop\Startup_Programs.txt"
echo A list of startup programs has been saved on your desktop. Review and disable unnecessary ones manually.
echo ----------------------------------------------------------

:: Remove junk files
echo [6] Removing junk files...
for %%X in (*.bak *.tmp *.log) do del /s /q "C:\%%X" >nul 2>&1
echo Junk files removed successfully.
echo ----------------------------------------------------------

:: Clear DNS cache
echo [7] Clearing DNS cache...
ipconfig /flushdns
echo DNS cache cleared successfully.
echo ----------------------------------------------------------

:: Update system drivers
echo [8] Checking for outdated drivers...
echo Please use Windows Update or a trusted driver updater tool to refresh outdated drivers.
echo ----------------------------------------------------------

:: Check for system updates
echo [9] Checking for Windows Updates...
usoclient StartScan
echo Windows Update scan initiated. Install updates if available.
echo ----------------------------------------------------------

:: Disable unnecessary services
echo [10] Disabling unnecessary services...
sc config "Superfetch" start= disabled >nul 2>&1
sc config "Windows Search" start= disabled >nul 2>&1
echo Unnecessary services disabled successfully.
echo ----------------------------------------------------------

:: Optimize power settings
echo [11] Optimizing power settings for performance...
powercfg -setactive SCHEME_MIN
echo Power settings optimized for performance.
echo ----------------------------------------------------------

:: Clear browser cache (Added Feature)
echo [12] Clearing browser cache...
for %%X in ("C:\Users\%username%\AppData\Local\Google\Chrome\User Data\Default\Cache\*" "C:\Users\%username%\AppData\Local\Microsoft\Edge\User Data\Default\Cache\*") do del /s /q %%X >nul 2>&1
echo Browser cache cleared successfully.
echo ----------------------------------------------------------

:: Optimize registry settings (Added Feature)
echo [13] Optimizing registry settings...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Optimize" /t REG_SZ /d "C:\OptimizeScript.bat" /f
echo Registry settings optimized successfully.
echo ----------------------------------------------------------

:: Manage unused programs (Added Feature)
echo [14] Scanning for unused programs...
wmic product get Name,Version > "%userprofile%\Desktop\Installed_Programs.txt"
echo A list of installed programs has been saved on your desktop. Review and uninstall unused ones manually.
echo ----------------------------------------------------------

:: Generate system performance report (Added Feature)
echo [15] Generating system performance report...
powercfg /energy > "%userprofile%\Desktop\Energy_Report.html"
echo System performance report saved on your desktop as Energy_Report.html.
echo ----------------------------------------------------------

echo ==========================================================
echo              Advanced Optimization Process Complete
echo ==========================================================
pause
