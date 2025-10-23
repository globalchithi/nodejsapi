#!/bin/bash
# Test script to demonstrate parsing test results
# This creates a sample XML file and parses it

echo "🧪 Creating sample test results for demonstration..."

# Create TestReports directory if it doesn't exist
mkdir -p TestReports

# Create a sample XML file with test results
cat > TestReports/TestResults.xml << 'EOF'
<assemblies timestamp="10/23/2025 05:00:00">
  <assembly name="VaxCareApiTests.dll" run-date="2025-10-23" run-time="05:00:00" total="14" passed="12" failed="2" skipped="0" time="8.5" errors="0">
    <errors />
    <collection total="4" passed="4" failed="0" skipped="0" name="InventoryApiTests" time="2.1">
      <test name="GetInventoryProducts_ShouldValidateRequiredHeaders" type="InventoryApiTests" method="GetInventoryProducts_ShouldValidateRequiredHeaders" time="0.5" result="Pass">
        <traits />
      </test>
      <test name="GetInventoryProducts_ShouldReturnInventoryProducts" type="InventoryApiTests" method="GetInventoryProducts_ShouldReturnInventoryProducts" time="1.2" result="Pass">
        <traits />
      </test>
      <test name="GetInventoryProducts_ShouldValidateCurlCommandStructure" type="InventoryApiTests" method="GetInventoryProducts_ShouldValidateCurlCommandStructure" time="0.2" result="Pass">
        <traits />
      </test>
      <test name="GetInventoryProducts_ShouldHandleAuthenticationHeaders" type="InventoryApiTests" method="GetInventoryProducts_ShouldHandleAuthenticationHeaders" time="0.2" result="Pass">
        <traits />
      </test>
    </collection>
    <collection total="3" passed="2" failed="1" skipped="0" name="InventoryLotInventoryTests" time="3.2">
      <test name="GetInventoryLotInventory_ShouldValidateRequiredHeaders" type="InventoryLotInventoryTests" method="GetInventoryLotInventory_ShouldValidateRequiredHeaders" time="0.1" result="Pass">
        <traits />
      </test>
      <test name="GetInventoryLotInventory_ShouldReturnLotInventoryData" type="InventoryLotInventoryTests" method="GetInventoryLotInventory_ShouldReturnLotInventoryData" time="2.8" result="Pass">
        <traits />
      </test>
      <test name="GetInventoryLotInventory_ShouldValidateEndpointStructure" type="InventoryLotInventoryTests" method="GetInventoryLotInventory_ShouldValidateEndpointStructure" time="0.1" result="Fail">
        <traits />
      </test>
    </collection>
    <collection total="3" passed="3" failed="0" skipped="0" name="InventoryLotNumbersTests" time="2.1">
      <test name="GetInventoryLotNumbers_ShouldReturnLotNumbersData" type="InventoryLotNumbersTests" method="GetInventoryLotNumbers_ShouldReturnLotNumbersData" time="1.5" result="Pass">
        <traits />
      </test>
      <test name="GetInventoryLotNumbers_ShouldValidateRequiredHeaders" type="InventoryLotNumbersTests" method="GetInventoryLotNumbers_ShouldValidateRequiredHeaders" time="0.4" result="Pass">
        <traits />
      </test>
      <test name="GetInventoryLotNumbers_ShouldValidateEndpointStructure" type="InventoryLotNumbersTests" method="GetInventoryLotNumbers_ShouldValidateEndpointStructure" time="0.2" result="Pass">
        <traits />
      </test>
    </collection>
    <collection total="4" passed="3" failed="1" skipped="0" name="PatientsAppointmentSyncTests" time="1.1">
      <test name="GetPatientsAppointmentSync_ShouldValidateRequiredHeaders" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldValidateRequiredHeaders" time="0.1" result="Pass">
        <traits />
      </test>
      <test name="GetPatientsAppointmentSync_ShouldReturnAppointmentData" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldReturnAppointmentData" time="0.8" result="Pass">
        <traits />
      </test>
      <test name="GetPatientsAppointmentSync_ShouldValidateEndpointStructure" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldValidateEndpointStructure" time="0.1" result="Pass">
        <traits />
      </test>
      <test name="GetPatientsAppointmentSync_ShouldHandleAuthenticationHeaders" type="PatientsAppointmentSyncTests" method="GetPatientsAppointmentSync_ShouldHandleAuthenticationHeaders" time="0.1" result="Fail">
        <traits />
      </test>
    </collection>
  </assembly>
</assemblies>
EOF

echo "✅ Sample test results created!"
echo ""
echo "📊 Sample Test Results:"
echo "   Total Tests: 14"
echo "   Passed: 12"
echo "   Failed: 2"
echo "   Skipped: 0"
echo "   Success Rate: 85.7%"
echo "   Execution Time: 8.5 seconds"
echo ""

# Test parsing without sending to Teams
echo "🧪 Testing XML parsing (without sending to Teams)..."
echo "💡 To test with PowerShell on Windows, use:"
echo "   powershell -ExecutionPolicy Bypass -File \"parse-test-results.ps1\" -OutputDir \"TestReports\" -Environment \"Development\" -Browser \"Chrome\""
echo ""
echo "💡 To send to Teams on Windows, use:"
echo "   parse-and-send-results.bat \"your-webhook-url\" \"Development\" \"Chrome\""
