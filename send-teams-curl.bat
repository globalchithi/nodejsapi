@echo off
REM Direct curl-based Teams notification
REM Usage: send-teams-curl.bat [webhook-url] [environment] [total] [passed] [failed] [duration] [browser]

setlocal enabledelayedexpansion

REM Get parameters
set "WEBHOOK_URL=%~1"
set "ENVIRONMENT=%~2"
set "TOTAL_TESTS=%~3"
set "PASSED_TESTS=%~4"
set "FAILED_TESTS=%~5"
set "DURATION=%~6"
set "BROWSER=%~7"

REM Use environment variables if parameters not provided
if "%WEBHOOK_URL%"=="" set "WEBHOOK_URL=%TEAMS_WEBHOOK_URL%"
if "%ENVIRONMENT%"=="" set "ENVIRONMENT=%ENVIRONMENT%"
if "%TOTAL_TESTS%"=="" set "TOTAL_TESTS=0"
if "%PASSED_TESTS%"=="" set "PASSED_TESTS=0"
if "%FAILED_TESTS%"=="" set "FAILED_TESTS=0"
if "%DURATION%"=="" set "DURATION=N/A"
if "%BROWSER%"=="" set "BROWSER=N/A"

REM Get current timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,4%/%dt:~4,2%/%dt:~6,2%, %dt:~8,2%:%dt:~10,2%:%dt:~12,2%"

REM Calculate success rate
set /a SUCCESS_RATE=0
if %TOTAL_TESTS% gtr 0 (
    set /a SUCCESS_RATE=(%PASSED_TESTS% * 100) / %TOTAL_TESTS%
)

REM Determine status
if %FAILED_TESTS% equ 0 (
    set "STATUS=✅ All %TOTAL_TESTS% tests passed successfully!"
) else (
    set "STATUS=❌ %FAILED_TESTS% tests failed out of %TOTAL_TESTS% total tests"
)

echo 📢 Sending Teams notification via curl...
echo    Webhook URL: %WEBHOOK_URL%
echo    Environment: %ENVIRONMENT%
echo    Status: %STATUS%
echo.

REM Create JSON payload
set "JSON_PAYLOAD={\"text\":\"🚀 VaxCare API Test Automation Results\",\"attachments\":[{\"contentType\":\"application/vnd.microsoft.card.adaptive\",\"content\":{\"type\":\"AdaptiveCard\",\"body\":[{\"type\":\"TextBlock\",\"text\":\"VaxCare API Test Results\",\"weight\":\"Bolder\",\"size\":\"Medium\"},{\"type\":\"TextBlock\",\"text\":\"%STATUS%\",\"wrap\":true},{\"type\":\"FactSet\",\"facts\":[{\"title\":\"Environment\",\"value\":\"%ENVIRONMENT%\"},{\"title\":\"Total Tests\",\"value\":\"%TOTAL_TESTS%\"},{\"title\":\"Passed\",\"value\":\"%PASSED_TESTS%\"},{\"title\":\"Failed\",\"value\":\"%FAILED_TESTS%\"},{\"title\":\"Success Rate\",\"value\":\"%SUCCESS_RATE%%%\"},{\"title\":\"Duration\",\"value\":\"%DURATION%\"},{\"title\":\"Browser\",\"value\":\"%BROWSER%\"},{\"title\":\"Timestamp\",\"value\":\"%TIMESTAMP%\"}]}],\"version\":\"1.0\"}}]}"

REM Send via curl
curl.exe "%WEBHOOK_URL%" -X POST -H "Content-Type: application/json" --data-raw "%JSON_PAYLOAD%"

if %ERRORLEVEL% equ 0 (
    echo ✅ Teams notification sent successfully!
    echo 📱 Check your Microsoft Teams channel for the test results
) else (
    echo ❌ Failed to send Teams notification
    echo 💡 Check your webhook URL and network connectivity
    exit /b 1
)
