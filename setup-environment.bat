@echo off
REM Setup script for VaxCare API Test Suite environment configuration

echo 🚀 VaxCare API Test Suite - Environment Setup
echo ============================================
echo.

REM Check if .env file exists
if exist ".env" (
    echo ✅ .env file already exists
    echo.
    echo Current configuration:
    echo ---------------------
    type .env | findstr /v "^#" | findstr /v "^$"
    echo.
    echo 💡 To modify settings, edit the .env file
    echo 💡 To create local overrides, copy .env to .env.local and edit
    echo.
) else (
    echo 📄 Creating .env file from template...
    if exist ".env.example" (
        copy ".env.example" ".env" >nul
        echo ✅ .env file created successfully
        echo.
        echo 📝 Next steps:
        echo 1. Edit .env file with your configuration
        echo 2. Set TEAMS_WEBHOOK_URL for Teams notifications
        echo 3. Configure ENVIRONMENT and other settings
        echo 4. Run: run-tests-with-reporting.bat
        echo.
    ) else (
        echo ❌ .env.example file not found
        echo 💡 Please ensure the project files are complete
        exit /b 1
    )
)

REM Check for PowerShell
powershell -Command "Get-Host" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ⚠️  PowerShell not found or not accessible
    echo 💡 Please ensure PowerShell is installed and accessible
    echo.
) else (
    echo ✅ PowerShell is available
)

REM Test environment loading
echo 🧪 Testing environment loading...
powershell -ExecutionPolicy Bypass -File "load-env.ps1" -EnvFile ".env" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Environment loading test passed
) else (
    echo ⚠️  Environment loading test failed
    echo 💡 Check PowerShell execution policy
)

echo.
echo 🎉 Setup completed!
echo.
echo 📋 Available commands:
echo   run-tests-with-reporting.bat                    # Run all tests
echo   run-tests-with-reporting.bat --help             # Show help
echo   run-tests-with-reporting.bat --teams "URL"      # Send to Teams
echo.
echo 📖 Documentation:
echo   ENVIRONMENT-SETUP.md                            # Environment guide
echo   teams-notification-example.bat                 # Teams examples
echo.

pause

