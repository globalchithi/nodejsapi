@echo off
REM Example script showing how to use Microsoft Teams notifications
REM This script demonstrates different ways to send test results to Teams

echo 🧪 Microsoft Teams Notification Examples
echo ========================================
echo.

REM Example 1: Basic Teams notification
echo Example 1: Basic Teams notification
echo -----------------------------------
echo run-tests-with-reporting.bat --teams "https://your-webhook-url-here"
echo.

REM Example 2: Teams notification with custom environment
echo Example 2: Teams notification with custom environment
echo -----------------------------------------------------
echo run-tests-with-reporting.bat --teams "https://your-webhook-url-here" --env "Staging"
echo.

REM Example 3: Teams notification with environment and browser
echo Example 3: Teams notification with environment and browser
echo ----------------------------------------------------------
echo run-tests-with-reporting.bat --teams "https://your-webhook-url-here" --env "Production" --browser "Chrome"
echo.

REM Example 4: Run specific tests and send to Teams
echo Example 4: Run specific tests and send to Teams
echo ------------------------------------------------
echo run-tests-with-reporting.bat "FullyQualifiedName~Inventory" --teams "https://your-webhook-url-here"
echo.

REM Example 5: Using environment variables
echo Example 5: Using environment variables
echo --------------------------------------
echo set TEAMS_WEBHOOK_URL=https://your-webhook-url-here
echo set ENVIRONMENT=Staging
echo set BROWSER=Chrome
echo run-tests-with-reporting.bat
echo.

echo 📋 How to get Microsoft Teams webhook URL:
echo 1. Go to your Microsoft Teams channel
echo 2. Click the three dots (...) next to the channel name
echo 3. Select "Connectors"
echo 4. Find "Incoming Webhook" and click "Configure"
echo 5. Give it a name and click "Create"
echo 6. Copy the webhook URL
echo.

echo 💡 Tips:
echo - You can set TEAMS_WEBHOOK_URL as an environment variable
echo - The script will automatically detect test results from XML files
echo - Teams notifications include test statistics and execution details
echo - Failed tests will show with ❌ emoji, passed tests with ✅ emoji
echo.

pause
