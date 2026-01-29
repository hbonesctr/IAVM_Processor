@echo off
REM =====================================================
REM IAVM Processor v2.3 - Quick Launch Script
REM Author: Hector L. Bones
REM =====================================================
REM 
REM This batch file launches the IAVM Processor PowerShell tool.
REM 
REM Usage: Double-click this file to start the application
REM
REM Requirements:
REM   - Windows PowerShell 5.1 (included with Windows 10/11)
REM   - IAVM_Processor_v2.3.ps1 in same directory
REM
REM =====================================================

title IAVM Processor v2.3 Launcher

REM Check if PowerShell script exists in same directory
if not exist "%~dp0IAVM_Processor_v2.3.ps1" (
    echo.
    echo ERROR: Cannot find IAVM_Processor_v2.3.ps1
    echo.
    echo Make sure this batch file is in the same directory as IAVM_Processor_v2.3.ps1
    echo.
    echo Current directory: %~dp0
    echo.
    pause
    exit /b 1
)

echo =====================================================
echo  IAVM Processor v2.3
echo  Vulnerability Management ^& STIG Compliance Tool
echo =====================================================
echo.
echo Starting PowerShell application...
echo.

REM Launch PowerShell script with execution policy bypass for this session only
REM This allows the script to run without permanently changing execution policy
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0IAVM_Processor_v2.3.ps1"

REM Check if PowerShell encountered an error
if %ERRORLEVEL% neq 0 (
    echo.
    echo =====================================================
    echo  Application Error
    echo =====================================================
    echo.
    echo PowerShell encountered an error (Exit Code: %ERRORLEVEL%)
    echo.
    echo Common issues:
    echo   1. PowerShell 5.1 not installed (Check: Windows Update)
    echo   2. .NET Framework missing (Included with Windows 10+)
    echo   3. Script syntax error (Try re-downloading)
    echo.
    echo For help, see README.md or open a GitHub issue
    echo.
    pause
    exit /b %ERRORLEVEL%
)

REM If we get here, application closed normally
exit /b 0
