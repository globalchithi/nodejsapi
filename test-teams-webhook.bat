@echo off
REM Test script to validate Teams webhook URL
REM Usage: test-teams-webhook.bat [webhook-url]

setlocal enabledelayedexpansion

set "WEBHOOK_URL=%~1"
if "%WEBHOOK_URL%"=="" set "WEBHOOK_URL=%TEAMS_WEBHOOK_URL%"

if "%WEBHOOK_URL%"=="" (
    echo ❌ No webhook URL provided
    echo 💡 Usage: test-teams-webhook.bat [webhook-url]
    echo 💡 Or set TEAMS_WEBHOOK_URL environment variable
    exit /b 1
)

echo 🧪 Testing Teams webhook URL...
echo    URL: %WEBHOOK_URL%
echo.

REM Create simple test payload
set "TEST_JSON={\"text\":\"🧪 Test message from VaxCare API Test Suite\",\"attachments\":[{\"contentType\":\"application/vnd.microsoft.card.adaptive\",\"content\":{\"type\":\"AdaptiveCard\",\"body\":[{\"type\":\"TextBlock\",\"text\":\"Test Notification\",\"weight\":\"Bolder\",\"size\":\"Medium\"},{\"type\":\"TextBlock\",\"text\":\"✅ This is a test message to verify your webhook is working correctly.\",\"wrap\":true},{\"type\":\"FactSet\",\"facts\":[{\"title\":\"Test Time\",\"value\":\"%date% %time%\"},{\"title\":\"Status\",\"value\":\"Webhook Test Successful\"}]}],\"version\":\"1.0\"}}]}"

echo 📤 Sending test message...
curl.exe "%WEBHOOK_URL%" -X POST -H "Content-Type: application/json" --data-raw "%TEST_JSON%"

if %ERRORLEVEL% equ 0 (
    echo.
    echo ✅ Test message sent successfully!
    echo 📱 Check your Microsoft Teams channel for the test message
    echo.
    echo 🎉 Your webhook URL is working correctly!
) else (
    echo.
    echo ❌ Test message failed to send
    echo 💡 Check your webhook URL and network connectivity
    echo 💡 Make sure curl.exe is available on your system
    exit /b 1
)

