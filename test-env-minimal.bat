@echo off
REM Minimal test for environment loading

echo Testing environment loading...

REM Test loading from .env
if exist ".env" (
    echo .env file exists
    echo First few lines of .env:
    type .env | more
    echo.
    echo Loading variables...
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" (
            if not "%%a:~0,1%"=="#" (
                echo Setting %%a=%%b
                set "%%a=%%b"
            )
        )
    )
) else (
    echo .env file not found
)

echo.
echo Current environment variables:
echo TEAMS_WEBHOOK_URL=%TEAMS_WEBHOOK_URL%
echo SEND_TEAMS_NOTIFICATION=%SEND_TEAMS_NOTIFICATION%
echo ENVIRONMENT=%ENVIRONMENT%

pause
