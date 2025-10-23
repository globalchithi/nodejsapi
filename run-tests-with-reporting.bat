@echo off
REM Batch script to run tests with automatic report generation (Windows)
REM Usage: run-tests-with-reporting.bat [filter] [options]

setlocal enabledelayedexpansion

REM Default values
set "FILTER="
set "OPEN_REPORTS=false"
set "VERBOSE=false"
set "GENERATE_PDF=true"
set "OUTPUT_FORMAT=html,json,markdown,pdf"

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :end_parse
if "%~1"=="--help" goto :show_help
if "%~1"=="-h" goto :show_help
if "%~1"=="--open-reports" set "OPEN_REPORTS=true" & shift & goto :parse_args
if "%~1"=="--verbose" set "VERBOSE=true" & shift & goto :parse_args
if "%~1"=="--no-pdf" set "GENERATE_PDF=false" & shift & goto :parse_args
if "%~1"=="--format" set "OUTPUT_FORMAT=%~2" & shift & shift & goto :parse_args
if "%~1"=="--open" set "OPEN_REPORTS=true" & shift & goto :parse_args
if "%~1"=="-v" set "VERBOSE=true" & shift & goto :parse_args
if "%~1"=="-o" set "OPEN_REPORTS=true" & shift & goto :parse_args
if "%~1"=="-p" set "GENERATE_PDF=false" & shift & goto :parse_args
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

REM Add XML logger for detailed results
set "TEST_COMMAND=%TEST_COMMAND% --logger "xunit;LogFilePath=%REPORTS_DIR%\TestResults.xml""

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
powershell -ExecutionPolicy Bypass -File "generate-enhanced-report-clean.ps1"

REM Generate PDF report if requested
if "%GENERATE_PDF%"=="true" (
    echo 📄 Generating PDF report...
    powershell -ExecutionPolicy Bypass -File "generate-pdf-report.ps1" -Latest
)

REM List all generated reports
echo.
echo 📁 Generated Reports:
echo ====================

REM List HTML reports
for /f "delims=" %%i in ('dir /b "%REPORTS_DIR%\EnhancedTestReport_*.html" 2^>nul ^| sort /r') do (
    echo 📄 HTML Report: %%i
)

REM List PDF reports
for /f "delims=" %%i in ('dir /b "%REPORTS_DIR%\TestReport_*.pdf" 2^>nul ^| sort /r') do (
    echo 📄 PDF Report: %%i
)

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
echo   -p, --no-pdf        Skip PDF generation
echo   -f, --format FORMAT Output formats (html,json,markdown,pdf)
echo.
echo Examples:
echo   %~nx0                                    # Run all tests with all reports
echo   %~nx0 "FullyQualifiedName~Inventory"   # Run inventory tests with reports
echo   %~nx0 "FullyQualifiedName~Patients"     # Run patient tests with reports
echo   %~nx0 --no-pdf                          # Run tests without PDF generation
echo   %~nx0 --open                            # Run tests and open reports
echo.
exit /b 0
