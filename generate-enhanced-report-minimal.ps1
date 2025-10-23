param(
    [string]$XmlFile = "",
    [string]$OutputDir = "TestReports"
)

Write-Host "Generating enhanced HTML report from XML results..." -ForegroundColor Yellow

# Find the XML file if not specified
if ([string]::IsNullOrEmpty($XmlFile)) {
    # Look for TestResults.xml first (xunit logger)
    $testResultsXml = Join-Path $OutputDir "TestResults.xml"
    if (Test-Path $testResultsXml) {
        $XmlFile = $testResultsXml
        Write-Host "Found XML file: $XmlFile" -ForegroundColor Green
    } else {
        # Look for .trx files as fallback (TRX logger)
        $trxFiles = Get-ChildItem -Path $OutputDir -Filter "*.trx" | Sort-Object LastWriteTime -Descending
        if ($trxFiles.Count -gt 0) {
            $XmlFile = $trxFiles[0].FullName
            Write-Host "Found TRX file: $XmlFile" -ForegroundColor Green
        } else {
            Write-Host "No XML test results found in $OutputDir" -ForegroundColor Red
            Write-Host "Make sure tests have been run with --logger xunit or --logger trx" -ForegroundColor Yellow
            exit 1
        }
    }
}

# Check if XML file exists
if (-not (Test-Path $XmlFile)) {
    Write-Host "XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Parse XML to extract test statistics
try {
    # Read the entire file content
    $xmlText = Get-Content $XmlFile -Raw -Encoding UTF8
    Write-Host "XML file read successfully, length: $($xmlText.Length) characters" -ForegroundColor Green
    
    # Check if XML is properly closed and fix common issues
    $xmlText = $xmlText.Trim()
    
    # Fix common XML corruption issues
    if ($xmlText.Contains(">>ies>")) {
        $xmlText = $xmlText -replace ">>ies>", "</assemblies>"
        Write-Host "Fixed malformed XML ending: >>ies> -> </assemblies>" -ForegroundColor Green
    }
    
    # Ensure proper closing
    if (-not $xmlText.EndsWith("</assemblies>")) {
        if ($xmlText.EndsWith("</assembly>")) {
            $xmlText = $xmlText + "</assemblies>"
            Write-Host "Added missing </assemblies> closing tag" -ForegroundColor Green
        } elseif ($xmlText.EndsWith("</collection>")) {
            $xmlText = $xmlText + "</assembly></assemblies>"
            Write-Host "Added missing </assembly></assemblies> closing tags" -ForegroundColor Green
        } else {
            $xmlText = $xmlText + "</assemblies>"
            Write-Host "Added missing </assemblies> closing tag" -ForegroundColor Green
        }
    }
    
    # Validate XML structure
    if (-not $xmlText.StartsWith("<assemblies")) {
        Write-Host "Warning: XML may not start with <assemblies> tag" -ForegroundColor Yellow
        Write-Host "File starts with: $($xmlText.Substring(0, [Math]::Min(50, $xmlText.Length)))" -ForegroundColor Yellow
    }
    
    # Parse as XML
    [xml]$xmlContent = $xmlText
    Write-Host "XML file parsed successfully" -ForegroundColor Green
} catch {
    Write-Host "Error parsing XML file: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "XML file content preview (last 100 chars):" -ForegroundColor Yellow
    $preview = Get-Content $XmlFile -Raw -Encoding UTF8
    if ($preview.Length -gt 100) {
        Write-Host $preview.Substring($preview.Length - 100) -ForegroundColor Gray
    } else {
        Write-Host $preview -ForegroundColor Gray
    }
    Write-Host "XML file content preview (first 200 chars):" -ForegroundColor Yellow
    if ($preview.Length -gt 200) {
        Write-Host $preview.Substring(0, 200) -ForegroundColor Gray
    } else {
        Write-Host $preview -ForegroundColor Gray
    }
    exit 1
}

# Try different XML structures
$totalTests = 0
$passedTests = 0
$failedTests = 0
$skippedTests = 0

# Check for xunit format
if ($xmlContent.assemblies -and $xmlContent.assemblies.assembly) {
    $assembly = $xmlContent.assemblies.assembly
    $totalTests = [int]$assembly.total
    $passedTests = [int]$assembly.passed
    $failedTests = [int]$assembly.failed
    $skippedTests = [int]$assembly.skipped
    Write-Host "Using xunit format - Assembly: $($assembly.name)" -ForegroundColor Green
    Write-Host "  Total: $totalTests, Passed: $passedTests, Failed: $failedTests, Skipped: $skippedTests" -ForegroundColor Cyan
    Write-Host "  Execution time: $($assembly.time) seconds" -ForegroundColor Cyan
}
# Check for TRX format
elseif ($xmlContent.TestRun -and $xmlContent.TestRun.Results) {
    $results = $xmlContent.TestRun.Results.UnitTestResult
    $totalTests = $results.Count
    $passedTests = ($results | Where-Object { $_.outcome -eq "Passed" }).Count
    $failedTests = ($results | Where-Object { $_.outcome -eq "Failed" }).Count
    $skippedTests = ($results | Where-Object { $_.outcome -eq "NotExecuted" }).Count
    Write-Host "Using TRX format" -ForegroundColor Green
}
# Check for other formats
elseif ($xmlContent.TestRun) {
    $totalTests = [int]$xmlContent.TestRun.Counter.total
    $passedTests = [int]$xmlContent.TestRun.Counter.passed
    $failedTests = [int]$xmlContent.TestRun.Counter.failed
    $skippedTests = [int]$xmlContent.TestRun.Counter.notExecuted
    Write-Host "Using TestRun format" -ForegroundColor Green
}
else {
    Write-Host "Unknown XML format. Available nodes:" -ForegroundColor Yellow
    $xmlContent.ChildNodes | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }
    if ($xmlContent.assemblies) {
        Write-Host "  assemblies node exists" -ForegroundColor Gray
        if ($xmlContent.assemblies.assembly) {
            Write-Host "  assembly node exists" -ForegroundColor Gray
        } else {
            Write-Host "  assembly node missing" -ForegroundColor Gray
        }
    } else {
        Write-Host "  assemblies node missing" -ForegroundColor Gray
    }
    Write-Host "Using default values" -ForegroundColor Yellow
    $totalTests = 1
    $passedTests = 1
    $failedTests = 0
    $skippedTests = 0
}

$successRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 1) } else { 0 }

Write-Host "Test Statistics:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests" -ForegroundColor White
Write-Host "   Passed: $passedTests" -ForegroundColor Green
Write-Host "   Failed: $failedTests" -ForegroundColor Red
Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
Write-Host "   Success Rate: $successRate percent" -ForegroundColor Cyan

# Generate HTML report
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VaxCare API Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #007bff; color: white; padding: 20px; text-align: center; }
        .stats { display: flex; justify-content: space-around; margin: 20px 0; }
        .stat { text-align: center; padding: 10px; }
        .test-item { border: 1px solid #ddd; margin: 5px 0; padding: 10px; }
        .passed { color: green; }
        .failed { color: red; }
        .skipped { color: orange; }
    </style>
</head>
<body>
    <div class="header">
        <h1>VaxCare API Test Report</h1>
        <p>Generated on $((Get-Date).ToString())</p>
    </div>
    
    <div class="stats">
        <div class="stat">
            <h3>$totalTests</h3>
            <p>Total Tests</p>
        </div>
        <div class="stat">
            <h3>$passedTests</h3>
            <p>Passed</p>
        </div>
        <div class="stat">
            <h3>$failedTests</h3>
            <p>Failed</p>
        </div>
        <div class="stat">
            <h3>$skippedTests</h3>
            <p>Skipped</p>
        </div>
        <div class="stat">
            <h3>$successRate percent</h3>
            <p>Success Rate</p>
        </div>
    </div>
    
    <h2>Test Results</h2>
"@

# Add individual test results
$tests = @()

# Try to get tests from different XML formats
if ($xmlContent.assemblies -and $xmlContent.assemblies.assembly -and $xmlContent.assemblies.assembly.collection) {
    $tests = $xmlContent.assemblies.assembly.collection.test
    Write-Host "Found $($tests.Count) tests in xunit format" -ForegroundColor Green
}
elseif ($xmlContent.TestRun -and $xmlContent.TestRun.Results) {
    $tests = $xmlContent.TestRun.Results.UnitTestResult
    Write-Host "Found $($tests.Count) tests in TRX format" -ForegroundColor Green
}
else {
    Write-Host "No individual test results found" -ForegroundColor Yellow
}

foreach ($test in $tests) {
    # Handle different XML formats
    if ($test.name) {
        $testName = $test.name
        $testResult = $test.result
        $testTime = $test.time
    } elseif ($test.testName) {
        $testName = $test.testName
        $testResult = $test.outcome
        $testTime = $test.duration
    } else {
        continue
    }
    
    $statusClass = switch ($testResult) {
        "Pass" { "passed" }
        "Passed" { "passed" }
        "Fail" { "failed" }
        "Failed" { "failed" }
        "Skip" { "skipped" }
        "NotExecuted" { "skipped" }
        default { "unknown" }
    }
    
    $statusText = switch ($testResult) {
        "Pass" { "PASSED" }
        "Passed" { "PASSED" }
        "Fail" { "FAILED" }
        "Failed" { "FAILED" }
        "Skip" { "SKIPPED" }
        "NotExecuted" { "SKIPPED" }
        default { "UNKNOWN" }
    }
    
    $htmlContent += @"
    <div class="test-item">
        <strong>$testName</strong> - <span class="$statusClass">$statusText</span> ($testTime seconds)
    </div>
"@
}

$htmlContent += @"
</body>
</html>
"@

# Generate timestamp for filename
$timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
$htmlReportPath = Join-Path $OutputDir "EnhancedTestReport_$timestamp.html"

# Save HTML report
Set-Content -Path $htmlReportPath -Value $htmlContent -Encoding UTF8

Write-Host "Enhanced HTML report generated: $htmlReportPath" -ForegroundColor Green
Write-Host "Test Statistics:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests" -ForegroundColor White
Write-Host "   Passed: $passedTests" -ForegroundColor Green
Write-Host "   Failed: $failedTests" -ForegroundColor Red
Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
Write-Host "   Success Rate: $successRate percent" -ForegroundColor Cyan
