@echo off
REM VaxCare API Test Suite - Windows Test Runner
REM This batch file runs tests and generates HTML reports on Windows

echo ========================================
echo VaxCare API Test Suite - Windows Runner
echo ========================================

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.6+ and try again
    pause
    exit /b 1
)

REM Check if .NET is available
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: .NET SDK is not installed or not in PATH
    echo Please install .NET SDK and try again
    pause
    exit /b 1
)

echo Python and .NET are available
echo.

REM Create TestReports directory if it doesn't exist
if not exist "TestReports" mkdir TestReports

REM Run tests with dotnet test
echo Running tests...
dotnet test --logger "trx;LogFileName=TestResults_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%.trx" --logger "xunit;LogFileName=TestResults.xml" --verbosity normal --results-directory "TestReports"

if %errorlevel% neq 0 (
    echo ERROR: Test execution failed
    pause
    exit /b 1
)

echo.
echo Tests completed successfully!
echo.

REM Generate HTML report using Windows-compatible Python script
echo Generating HTML report...
python generate-enhanced-html-report-windows.py --xml "TestReports/TestResults.xml" --output "TestReports"

if %errorlevel% neq 0 (
    echo ERROR: HTML report generation failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Test execution completed successfully!
echo Reports saved in: TestReports
echo Open the HTML report to view results
echo ========================================
pause
