@echo off
REM Test script to debug environment variable loading

echo 🧪 Testing Environment Variable Loading
echo ======================================
echo.

REM Load environment variables from .env file
echo 📄 Loading environment configuration...

REM Load from .env file directly
if exist ".env" (
    echo   Loading from .env file...
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set "%%a=%%b"
            echo   Set %%a=%%b
        )
    )
) else (
    echo   ⚠️  .env file not found
)

REM Load from .env.local if it exists (overrides .env)
if exist ".env.local" (
    echo   Loading from .env.local file...
    for /f "usebackq tokens=1,2 delims==" %%a in (".env.local") do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set "%%a=%%b"
            echo   Set %%a=%%b
        )
    )
)

echo.
echo 🔍 Current Environment Variables:
echo   TEAMS_WEBHOOK_URL=%TEAMS_WEBHOOK_URL%
echo   SEND_TEAMS_NOTIFICATION=%SEND_TEAMS_NOTIFICATION%
echo   ENVIRONMENT=%ENVIRONMENT%
echo   BROWSER=%BROWSER%
echo   OPEN_REPORTS=%OPEN_REPORTS%
echo   VERBOSE=%VERBOSE%
echo   OUTPUT_FORMAT=%OUTPUT_FORMAT%
echo   REPORTS_DIR=%REPORTS_DIR%
echo   PROJECT_NAME=%PROJECT_NAME%
echo   XML_LOGGER_FORMAT=%XML_LOGGER_FORMAT%
echo   CI_MODE=%CI_MODE%
echo   DEBUG_MODE=%DEBUG_MODE%
echo.

echo 📋 .env file contents:
if exist ".env" (
    type .env
) else (
    echo .env file not found
)

echo.
echo 📋 .env.local file contents:
if exist ".env.local" (
    type .env.local
) else (
    echo .env.local file not found
)

pause
