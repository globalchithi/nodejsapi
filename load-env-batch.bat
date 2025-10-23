@echo off
REM Simple batch file to load environment variables from .env file

REM Load from .env file
if exist ".env" (
    echo Loading from .env file...
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" (
            if not "%%a:~0,1%"=="#" (
                if not "%%a"=="TEAMS_WEBHOOK_URL" if not "%%a"=="ENVIRONMENT" if not "%%a"=="BROWSER" if not "%%a"=="OPEN_REPORTS" if not "%%a"=="VERBOSE" if not "%%a"=="OUTPUT_FORMAT" if not "%%a"=="REPORTS_DIR" if not "%%a"=="PROJECT_NAME" if not "%%a"=="SEND_TEAMS_NOTIFICATION" if not "%%a"=="XML_LOGGER_FORMAT" if not "%%a"=="CI_MODE" if not "%%a"=="DEBUG_MODE" (
                    set "%%a=%%b"
                ) else (
                    set "%%a=%%b"
                )
            )
        )
    )
)

REM Load from .env.local if it exists (overrides .env)
if exist ".env.local" (
    echo Loading from .env.local file...
    for /f "usebackq tokens=1,2 delims==" %%a in (".env.local") do (
        if not "%%a"=="" (
            if not "%%a:~0,1%"=="#" (
                set "%%a=%%b"
            )
        )
    )
)
