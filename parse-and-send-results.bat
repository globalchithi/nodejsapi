@echo off
REM Parse existing test results and send to Teams
REM Usage: parse-and-send-results.bat [webhook-url] [environment] [browser]

setlocal enabledelayedexpansion

REM Load environment variables
call load-env-batch.bat

REM Get parameters
set "WEBHOOK_URL=%~1"
set "ENVIRONMENT=%~2"
set "BROWSER=%~3"

REM Use environment variables if parameters not provided
if "%WEBHOOK_URL%"=="" set "WEBHOOK_URL=%TEAMS_WEBHOOK_URL%"
if "%ENVIRONMENT%"=="" set "ENVIRONMENT=%ENVIRONMENT%"
if "%BROWSER%"=="" set "BROWSER=%BROWSER%"

REM Check if webhook URL is provided
if "%WEBHOOK_URL%"=="" (
    echo ❌ Teams webhook URL is required!
    echo 💡 Usage: parse-and-send-results.bat [webhook-url] [environment] [browser]
    echo 💡 Or set TEAMS_WEBHOOK_URL in .env file
    exit /b 1
)

REM Check if TestReports directory exists
if not exist "TestReports" (
    echo ❌ TestReports directory not found!
    echo 💡 Run tests first to generate test results
    exit /b 1
)

echo 📊 Parsing test results and sending to Teams...
echo    Webhook URL: %WEBHOOK_URL%
echo    Environment: %ENVIRONMENT%
echo    Browser: %BROWSER%
echo.

REM Parse test results and send to Teams
powershell -ExecutionPolicy Bypass -File "parse-test-results.ps1" -OutputDir "TestReports" -WebhookUrl "%WEBHOOK_URL%" -Environment "%ENVIRONMENT%" -Browser "%BROWSER%"

if %ERRORLEVEL% neq 0 (
    echo ❌ Failed to parse test results or send to Teams
    exit /b 1
) else (
    echo ✅ Test results parsed and sent to Teams successfully!
)

