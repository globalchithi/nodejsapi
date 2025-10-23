@echo off
REM Test script to demonstrate parsing test results
REM This creates a sample XML file and parses it

setlocal enabledelayedexpansion

echo 🧪 Creating sample test results for demonstration...

REM Create TestReports directory if it doesn't exist
if not exist "TestReports" mkdir TestReports

REM Create a sample XML file with test results
echo ^<assemblies timestamp="10/23/2025 05:00:00"^> > TestReports\TestResults.xml
echo   ^<assembly name="VaxCareApiTests.dll" run-date="2025-10-23" run-time="05:00:00" total="14" passed="12" failed="2" skipped="0" time="8.5" errors="0"^> >> TestReports\TestResults.xml
echo     ^<errors /^> >> TestReports\TestResults.xml
echo     ^<collection total="4" passed="4" failed="0" skipped="0" name="InventoryApiTests" time="2.1"^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryProducts_ShouldValidateRequiredHeaders" type="InventoryApiTests" method="GetInventoryProducts_ShouldValidateRequiredHeaders" time="0.5" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryProducts_ShouldReturnInventoryProducts" type="InventoryApiTests" method="GetInventoryProducts_ShouldReturnInventoryProducts" time="1.2" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryProducts_ShouldValidateCurlCommandStructure" type="InventoryApiTests" method="GetInventoryProducts_ShouldValidateCurlCommandStructure" time="0.2" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryProducts_ShouldHandleAuthenticationHeaders" type="InventoryApiTests" method="GetInventoryProducts_ShouldHandleAuthenticationHeaders" time="0.2" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo     ^</collection^> >> TestReports\TestResults.xml
echo     ^<collection total="3" passed="2" failed="1" skipped="0" name="InventoryLotInventoryTests" time="3.2"^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryLotInventory_ShouldValidateRequiredHeaders" type="InventoryLotInventoryTests" method="GetInventoryLotInventory_ShouldValidateRequiredHeaders" time="0.1" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryLotInventory_ShouldReturnLotInventoryData" type="InventoryLotInventoryTests" method="GetInventoryLotInventory_ShouldReturnLotInventoryData" time="2.8" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryLotInventory_ShouldValidateEndpointStructure" type="InventoryLotInventoryTests" method="GetInventoryLotInventory_ShouldValidateEndpointStructure" time="0.1" result="Fail"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo     ^</collection^> >> TestReports\TestResults.xml
echo     ^<collection total="3" passed="3" failed="0" skipped="0" name="InventoryLotNumbersTests" time="2.1"^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryLotNumbers_ShouldReturnLotNumbersData" type="InventoryLotNumbersTests" method="GetInventoryLotNumbers_ShouldReturnLotNumbersData" time="1.5" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryLotNumbers_ShouldValidateRequiredHeaders" type="InventoryLotNumbersTests" method="GetInventoryLotNumbers_ShouldValidateRequiredHeaders" time="0.4" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetInventoryLotNumbers_ShouldValidateEndpointStructure" type="InventoryLotNumbersTests" method="GetInventoryLotNumbers_ShouldValidateEndpointStructure" time="0.2" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo     ^</collection^> >> TestReports\TestResults.xml
echo     ^<collection total="4" passed="3" failed="1" skipped="0" name="PatientsAppointmentSyncTests" time="1.1"^> >> TestReports\TestResults.xml
echo       ^<test name="GetPatientsAppointmentSync_ShouldValidateRequiredHeaders" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldValidateRequiredHeaders" time="0.1" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetPatientsAppointmentSync_ShouldReturnAppointmentData" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldReturnAppointmentData" time="0.8" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetPatientsAppointmentSync_ShouldValidateEndpointStructure" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldValidateEndpointStructure" time="0.1" result="Pass"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo       ^<test name="GetPatientsAppointmentSync_ShouldHandleAuthenticationHeaders" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldHandleAuthenticationHeaders" time="0.1" result="Fail"^> >> TestReports\TestResults.xml
echo         ^<traits /^> >> TestReports\TestResults.xml
echo       ^</test^> >> TestReports\TestResults.xml
echo     ^</collection^> >> TestReports\TestResults.xml
echo   ^</assembly^> >> TestReports\TestResults.xml
echo ^</assemblies^> >> TestReports\TestResults.xml

echo ✅ Sample test results created!
echo.
echo 📊 Sample Test Results:
echo    Total Tests: 14
echo    Passed: 12
echo    Failed: 2
echo    Skipped: 0
echo    Success Rate: 85.7%
echo    Execution Time: 8.5 seconds
echo.

REM Test parsing without sending to Teams
echo 🧪 Testing XML parsing (without sending to Teams)...
powershell -ExecutionPolicy Bypass -File "parse-test-results.ps1" -OutputDir "TestReports" -Environment "Development" -Browser "Chrome"

if %ERRORLEVEL% equ 0 (
    echo ✅ XML parsing test successful!
    echo.
    echo 💡 To send to Teams, use:
    echo    parse-and-send-results.bat "your-webhook-url" "Development" "Chrome"
) else (
    echo ❌ XML parsing test failed
    exit /b 1
)
