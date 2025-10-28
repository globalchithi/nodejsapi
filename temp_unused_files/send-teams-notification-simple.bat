@echo off
REM Simple batch file to send Teams notifications
REM Usage: send-teams-notification-simple.bat [webhook-url] [environment] [total] [passed] [failed] [skipped] [duration] [browser]

setlocal enabledelayedexpansion

REM Default values
set "WEBHOOK_URL=%~1"
set "ENVIRONMENT=%~2"
set "TOTAL_TESTS=%~3"
set "PASSED_TESTS=%~4"
set "FAILED_TESTS=%~5"
set "SKIPPED_TESTS=%~6"
set "DURATION=%~7"
set "BROWSER=%~8"

REM Use environment variables if parameters not provided
if "%WEBHOOK_URL%"=="" set "WEBHOOK_URL=%TEAMS_WEBHOOK_URL%"
if "%ENVIRONMENT%"=="" set "ENVIRONMENT=%ENVIRONMENT%"
if "%TOTAL_TESTS%"=="" set "TOTAL_TESTS=0"
if "%PASSED_TESTS%"=="" set "PASSED_TESTS=0"
if "%FAILED_TESTS%"=="" set "FAILED_TESTS=0"
if "%SKIPPED_TESTS%"=="" set "SKIPPED_TESTS=0"
if "%DURATION%"=="" set "DURATION=N/A"
if "%BROWSER%"=="" set "BROWSER=N/A"

echo 📢 Sending Teams notification...
echo    Webhook URL: %WEBHOOK_URL%
echo    Environment: %ENVIRONMENT%
echo    Total Tests: %TOTAL_TESTS%
echo    Passed: %PASSED_TESTS%
echo    Failed: %FAILED_TESTS%
echo    Skipped: %SKIPPED_TESTS%
echo    Duration: %DURATION%
echo    Browser: %BROWSER%
echo.

REM Call PowerShell script
powershell -ExecutionPolicy Bypass -File "send-teams-simple.ps1" -WebhookUrl "%WEBHOOK_URL%" -Environment "%ENVIRONMENT%" -TotalTests %TOTAL_TESTS% -PassedTests %PASSED_TESTS% -FailedTests %FAILED_TESTS% -SkippedTests %SKIPPED_TESTS% -Duration "%DURATION%" -Browser "%BROWSER%"

if %ERRORLEVEL% neq 0 (
    echo ❌ Teams notification failed
    exit /b 1
) else (
    echo ✅ Teams notification sent successfully
)

