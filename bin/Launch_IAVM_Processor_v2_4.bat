@echo off
REM =========================================================================
REM IAVM Processor v2.4 - Launcher
REM Author: Hector L. Bones
REM Date: January 30, 2026
REM =========================================================================
REM
REM This batch file launches the IAVM Processor PowerShell script with
REM the appropriate execution policy bypass for the current session.
REM
REM USAGE:
REM   Double-click this file to launch IAVM Processor
REM   OR run from command prompt: Launch_IAVM_Processor_v2_4.bat
REM
REM =========================================================================

echo.
echo ========================================================================
echo IAVM Processor v2.4 - Launcher
echo ========================================================================
echo.
echo Author: Hector L. Bones
echo Version: 2.4.0
echo Date: January 30, 2026
echo.
echo Starting IAVM Processor...
echo.

REM Launch PowerShell script with ExecutionPolicy Bypass
REM %~dp0 = directory where this batch file is located
REM This ensures the script works regardless of current directory

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0IAVM_Processor_v2_4.ps1"

REM Check if PowerShell script executed successfully
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================================
    echo IAVM Processor completed successfully
    echo ========================================================================
) else (
    echo.
    echo ========================================================================
    echo ERROR: IAVM Processor encountered an error (Exit Code: %ERRORLEVEL%^)
    echo ========================================================================
    echo.
    echo Possible causes:
    echo   - PowerShell script file not found
    echo   - PowerShell execution error
    echo   - User cancelled operation
    echo.
    echo Please check the error messages above for details.
)

echo.
echo Press any key to exit...
pause >nul
