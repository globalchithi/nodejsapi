param(
    [string]$XmlFile = "TestResults.xml",
    [string]$OutputDir = "TestReports"
)

Write-Host "Generating enhanced HTML report from XML results..." -ForegroundColor Yellow

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
[xml]$xmlContent = Get-Content $XmlFile
$assembly = $xmlContent.assemblies.assembly
$totalTests = [int]$assembly.total
$passedTests = [int]$assembly.passed
$failedTests = [int]$assembly.failed
$skippedTests = [int]$assembly.skipped
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
$tests = $xmlContent.assemblies.assembly.collection.test
foreach ($test in $tests) {
    $testName = $test.name
    $testResult = $test.result
    $testTime = $test.time
    
    $statusClass = switch ($testResult) {
        "Pass" { "passed" }
        "Fail" { "failed" }
        "Skip" { "skipped" }
        default { "unknown" }
    }
    
    $statusText = switch ($testResult) {
        "Pass" { "PASSED" }
        "Fail" { "FAILED" }
        "Skip" { "SKIPPED" }
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
