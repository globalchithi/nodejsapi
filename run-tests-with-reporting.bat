@echo off
REM Batch script to run tests with automatic report generation (Windows)
REM Usage: run-tests-with-reporting.bat [filter] [options]

setlocal enabledelayedexpansion

REM Load environment variables from .env file
echo 📄 Loading environment configuration...
call load-env-batch.bat

REM Default values (can be overridden by .env file)
set "FILTER="
if "%OPEN_REPORTS%"=="" set "OPEN_REPORTS=false"
if "%VERBOSE%"=="" set "VERBOSE=false"
if "%OUTPUT_FORMAT%"=="" set "OUTPUT_FORMAT=html,json,markdown"
if "%ENVIRONMENT%"=="" set "ENVIRONMENT=Development"
if "%BROWSER%"=="" set "BROWSER=N/A"
if "%REPORTS_DIR%"=="" set "REPORTS_DIR=TestReports"
if "%PROJECT_NAME%"=="" set "PROJECT_NAME=VaxCareApiTests"
if "%SEND_TEAMS_NOTIFICATION%"=="" set "SEND_TEAMS_NOTIFICATION=true"
if "%XML_LOGGER_FORMAT%"=="" set "XML_LOGGER_FORMAT=xunit"
if "%CI_MODE%"=="" set "CI_MODE=false"
if "%DEBUG_MODE%"=="" set "DEBUG_MODE=false"

REM Show loaded environment variables for debugging
if "%DEBUG_MODE%"=="true" (
    echo.
    echo 🔍 Loaded Environment Variables:
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
)

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :end_parse
if "%~1"=="--help" goto :show_help
if "%~1"=="-h" goto :show_help
if "%~1"=="--open-reports" set "OPEN_REPORTS=true" & shift & goto :parse_args
if "%~1"=="--verbose" set "VERBOSE=true" & shift & goto :parse_args
REM PDF options removed
if "%~1"=="--format" set "OUTPUT_FORMAT=%~2" & shift & shift & goto :parse_args
if "%~1"=="--open" set "OPEN_REPORTS=true" & shift & goto :parse_args
if "%~1"=="-v" set "VERBOSE=true" & shift & goto :parse_args
if "%~1"=="-o" set "OPEN_REPORTS=true" & shift & goto :parse_args
if "%~1"=="--teams" set "TEAMS_WEBHOOK_URL=%~2" & shift & shift & goto :parse_args
if "%~1"=="--env" set "ENVIRONMENT=%~2" & shift & shift & goto :parse_args
if "%~1"=="--browser" set "BROWSER=%~2" & shift & shift & goto :parse_args
if "%~1"=="-f" set "OUTPUT_FORMAT=%~2" & shift & shift & goto :parse_args

REM If it's not a recognized option, treat it as a filter
if "!FILTER!"=="" set "FILTER=%~1"
shift
goto :parse_args

:end_parse

echo.
echo 🧪 VaxCare API Test Suite - Running Tests with Reporting (Windows)
echo =================================================================
echo.

REM Set up variables
set "PROJECT_PATH=VaxCareApiTests.csproj"
set "REPORTS_DIR=TestReports"
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%_%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"

REM Create reports directory if it doesn't exist
if not exist "%REPORTS_DIR%" (
    mkdir "%REPORTS_DIR%"
    echo 📁 Created reports directory: %REPORTS_DIR%
)

REM Build the project first
echo 🔨 Building project...
dotnet build "%PROJECT_PATH%" --configuration Release --verbosity minimal
if %ERRORLEVEL% neq 0 (
    echo ❌ Build failed!
    exit /b 1
)
echo ✅ Build successful!

REM Prepare test command
set "TEST_COMMAND=dotnet test %PROJECT_PATH% --configuration Release --logger trx --results-directory %REPORTS_DIR%"

if not "%FILTER%"=="" (
    set "TEST_COMMAND=%TEST_COMMAND% --filter "%FILTER%""
)

if "%VERBOSE%"=="true" (
    set "TEST_COMMAND=%TEST_COMMAND% --verbosity normal"
) else (
    set "TEST_COMMAND=%TEST_COMMAND% --verbosity minimal"
)

REM Add XML logger for detailed results (format from .env file)
if "%XML_LOGGER_FORMAT%"=="xunit" (
    set "TEST_COMMAND=%TEST_COMMAND% --logger "xunit;LogFilePath=%REPORTS_DIR%\TestResults.xml""
) else (
    set "TEST_COMMAND=%TEST_COMMAND% --logger "trx;LogFileName=TestResults.trx""
)

echo 🚀 Running tests...
echo Command: %TEST_COMMAND%

REM Execute tests
%TEST_COMMAND%
set "TEST_EXIT_CODE=%ERRORLEVEL%"

REM Check if tests ran successfully
if %TEST_EXIT_CODE% equ 0 (
    echo ✅ All tests passed!
) else (
    echo ⚠️  Some tests failed or were skipped
)

REM Generate enhanced HTML report
echo 📊 Generating enhanced HTML report...
powershell -ExecutionPolicy Bypass -File "generate-enhanced-report-minimal.ps1"

REM Send Teams notification if enabled and webhook URL is provided
if "%SEND_TEAMS_NOTIFICATION%"=="true" (
    if not "%TEAMS_WEBHOOK_URL%"=="" (
        echo 📢 Sending test results to Microsoft Teams...
        powershell -ExecutionPolicy Bypass -File "send-teams-notification.ps1" -TeamsWebhookUrl "%TEAMS_WEBHOOK_URL%" -Environment "%ENVIRONMENT%" -Browser "%BROWSER%"
        if %ERRORLEVEL% neq 0 (
            echo ⚠️  Teams notification failed, but reports are available
        ) else (
            echo ✅ Teams notification sent successfully
        )
    ) else (
        echo ⚠️  Teams notification enabled but TEAMS_WEBHOOK_URL not configured
    )
) else (
    echo ℹ️  Teams notification disabled (set SEND_TEAMS_NOTIFICATION=true in .env to enable)
)

REM List all generated reports
echo.
echo 📁 Generated Reports:
echo ====================

REM List HTML reports
for /f "delims=" %%i in ('dir /b "%REPORTS_DIR%\EnhancedTestReport_*.html" 2^>nul ^| sort /r') do (
    echo 📄 HTML Report: %%i
)

REM PDF reports removed as requested

REM List JSON reports
for /f "delims=" %%i in ('dir /b "%REPORTS_DIR%\TestReport_*.json" 2^>nul ^| sort /r') do (
    echo 📄 JSON Report: %%i
)

REM List Markdown reports
for /f "delims=" %%i in ('dir /b "%REPORTS_DIR%\TestReport_*.md" 2^>nul ^| sort /r') do (
    echo 📄 Markdown Report: %%i
)

REM Open reports if requested
if "%OPEN_REPORTS%"=="true" (
    echo 🌐 Opening reports...
    
    REM Open latest HTML report
    for /f "delims=" %%i in ('dir /b "%REPORTS_DIR%\EnhancedTestReport_*.html" 2^>nul ^| sort /r') do (
        echo    Opening HTML report: %%i
        start "" "%REPORTS_DIR%\%%i"
        goto :open_pdf
    )
    
    :open_pdf
    REM Open latest PDF report
    for /f "delims=" %%i in ('dir /b "%REPORTS_DIR%\TestReport_*.pdf" 2^>nul ^| sort /r') do (
        echo    Opening PDF report: %%i
        start "" "%REPORTS_DIR%\%%i"
        goto :end_open
    )
    
    :end_open
)

echo.
echo 🎉 Test execution and report generation completed!
echo =================================================================

exit /b %TEST_EXIT_CODE%

:show_help
echo.
echo 🧪 VaxCare API Test Suite - Comprehensive Reporting (Windows)
echo =============================================================
echo.
echo Usage: %~nx0 [OPTIONS] [FILTER]
echo.
echo Options:
echo   -h, --help          Show this help message
echo   -o, --open          Open generated reports automatically
echo   -v, --verbose       Show verbose output
echo   -f, --format FORMAT Output formats (html,json,markdown)
echo   --teams URL         Send results to Microsoft Teams webhook
echo   --env NAME          Environment name (default: Development)
echo   --browser NAME      Browser used for tests (default: N/A)
echo.
echo Examples:
echo   %~nx0                                    # Run all tests with all reports
echo   %~nx0 "FullyQualifiedName~Inventory"   # Run inventory tests with reports
echo   %~nx0 "FullyQualifiedName~Patients"     # Run patient tests with reports
REM PDF examples removed
echo   %~nx0 --open                            # Run tests and open reports
echo   %~nx0 --teams "https://webhook-url"     # Send results to Teams
echo   %~nx0 --env "Staging" --browser "Chrome" # Custom environment and browser
echo.
exit /b 0
