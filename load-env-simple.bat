@echo off
REM Ultra-simple environment loader for Windows

REM Load from .env file
if exist ".env" (
    echo Loading from .env file...
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" (
            if not "%%a:~0,1%"=="#" (
                set "%%a=%%b"
            )
        )
    )
)

REM Load from .env.local if it exists
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

