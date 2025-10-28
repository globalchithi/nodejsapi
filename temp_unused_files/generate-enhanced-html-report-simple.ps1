# Simple HTML Report Generator - No XML parsing issues
# This script uses basic text parsing instead of XML parsing

param(
    [string]$XmlFile = "TestReports/TestResults.xml",
    [string]$OutputDir = "TestReports"
)

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
$htmlReportPath = Join-Path $OutputDir "EnhancedTestReport_$timestamp.html"

Write-Host "Generating HTML report with simple text parsing..." -ForegroundColor Cyan

# Check if XML file exists
if (-not (Test-Path $XmlFile)) {
    Write-Host "XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

# Parse XML using simple text parsing instead of XML parsing
try {
    Write-Host "Reading XML file with simple text parsing..." -ForegroundColor Yellow
    
    # Read file as plain text
    $xmlText = Get-Content $XmlFile -Raw
    
    # Extract test statistics using regex
    $totalTests = 0
    $passedTests = 0
    $failedTests = 0
    $skippedTests = 0
    $testDetails = @()
    
    # Count tests using regex
    $totalTests = ([regex]::Matches($xmlText, '<test ')).Count
    $passedTests = ([regex]::Matches($xmlText, 'result="Pass"')).Count
    $failedTests = ([regex]::Matches($xmlText, 'result="Fail"')).Count
    $skippedTests = ([regex]::Matches($xmlText, 'result="Skip"')).Count
    
    Write-Host "Test Statistics:" -ForegroundColor Green
    Write-Host "   Total Tests: $totalTests" -ForegroundColor White
    Write-Host "   Passed: $passedTests" -ForegroundColor Green
    Write-Host "   Failed: $failedTests" -ForegroundColor Red
    Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
    
    # Calculate success rate
    $successRate = if ($totalTests -gt 0) { 
        [math]::Round(($passedTests / $totalTests) * 100, 1) 
    } else { 
        0 
    }
    
    Write-Host "   Success Rate: $successRate%" -ForegroundColor Cyan
    
    # Extract individual test details using regex
    $testMatches = [regex]::Matches($xmlText, '<test[^>]*>')
    foreach ($match in $testMatches) {
        $testLine = $match.Value
        
        # Extract attributes using regex
        $testName = if ($testLine -match 'name="([^"]*)"') { $matches[1] } else { "Unknown Test" }
        $testResult = if ($testLine -match 'result="([^"]*)"') { $matches[1] } else { "Unknown" }
        $testTime = if ($testLine -match 'time="([^"]*)"') { [double]$matches[1] } else { 0.0 }
        $testType = if ($testLine -match 'type="([^"]*)"') { $matches[1] } else { "Unknown" }
        
        # Extract class name from type
        $className = if ($testType -and $testType.Contains('.')) {
            $testType.Split('.')[-1]
        } elseif ($testType) {
            $testType
        } else {
            "Unknown"
        }
        
        # Extract method name for display
        $displayName = if ($testName) {
            $testName.Split('.')[-1] -replace '_', ' '
        } else {
            "Unknown Test"
        }
        
        # Add to test details
        $testDetails += [PSCustomObject]@{
            Name = $displayName
            FullName = $testName
            Class = $className
            Result = $testResult
            Duration = $testTime
            DurationMs = [math]::Round($testTime * 1000, 2)
            StatusIcon = if ($testResult -eq "Pass") { "&#10004;" } elseif ($testResult -eq "Fail") { "&#10008;" } else { "&#9193;" }
        }
    }
    
} catch {
    Write-Host "Error parsing XML file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Generate simple HTML content
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VaxCare API Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: #007bff; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .header h1 { margin: 0; font-size: 2em; }
        .stats { display: flex; gap: 20px; margin: 20px 0; flex-wrap: wrap; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 5px; text-align: center; flex: 1; min-width: 120px; }
        .stat-number { font-size: 2em; font-weight: bold; margin-bottom: 5px; }
        .stat-label { color: #666; }
        .passed .stat-number { color: #28a745; }
        .failed .stat-number { color: #dc3545; }
        .skipped .stat-number { color: #ffc107; }
        .total .stat-number { color: #007bff; }
        .success-rate .stat-number { color: #6f42c1; }
        .test-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .test-table th, .test-table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .test-table th { background: #007bff; color: white; font-weight: bold; }
        .test-table tbody tr:hover { background-color: #f5f5f5; }
        .status-passed { color: #28a745; font-weight: bold; }
        .status-failed { color: #dc3545; font-weight: bold; }
        .status-skipped { color: #ffc107; font-weight: bold; }
        .duration { font-family: monospace; background: #f8f9fa; padding: 2px 6px; border-radius: 3px; }
        .footer { text-align: center; margin-top: 30px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>&#129514; VaxCare API Test Report</h1>
            <p>Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        </div>
        
        <div class="stats">
            <div class="stat-card passed">
                <div class="stat-number">$passedTests</div>
                <div class="stat-label">&#10004; Passed</div>
            </div>
            <div class="stat-card failed">
                <div class="stat-number">$failedTests</div>
                <div class="stat-label">&#10008; Failed</div>
            </div>
            <div class="stat-card skipped">
                <div class="stat-number">$skippedTests</div>
                <div class="stat-label">&#9193; Skipped</div>
            </div>
            <div class="stat-card total">
                <div class="stat-number">$totalTests</div>
                <div class="stat-label">&#128202; Total</div>
            </div>
            <div class="stat-card success-rate">
                <div class="stat-number">$successRate%</div>
                <div class="stat-label">&#127919; Success Rate</div>
            </div>
        </div>
        
        <h2>&#128203; Test Results</h2>
        <table class="test-table">
            <thead>
                <tr>
                    <th>Status</th>
                    <th>Test Name</th>
                    <th>Class</th>
                    <th>Duration</th>
                </tr>
            </thead>
            <tbody>
"@

# Add test details to table
foreach ($test in $testDetails) {
    $statusClass = switch ($test.Result) {
        "Pass" { "status-passed" }
        "Fail" { "status-failed" }
        default { "status-skipped" }
    }
    
    $htmlContent += @"
                <tr>
                    <td class="$statusClass">$($test.StatusIcon) $($test.Result)</td>
                    <td>$($test.Name)</td>
                    <td>$($test.Class)</td>
                    <td><span class="duration">$($test.DurationMs)ms</span></td>
                </tr>
"@
}

$htmlContent += @"
            </tbody>
        </table>
        
        <div class="footer">
            <p>Report generated by VaxCare API Test Suite | $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        </div>
    </div>
</body>
</html>
"@

# Write HTML content to file
try {
    $htmlContent | Out-File -FilePath $htmlReportPath -Encoding UTF8
    Write-Host "HTML report generated: $htmlReportPath" -ForegroundColor Green
    Write-Host "Report Statistics:" -ForegroundColor Cyan
    Write-Host "   File: $htmlReportPath" -ForegroundColor White
    Write-Host "   Tests: $totalTests" -ForegroundColor White
    Write-Host "   Passed: $passedTests" -ForegroundColor Green
    Write-Host "   Failed: $failedTests" -ForegroundColor Red
    Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
    Write-Host "   Success Rate: $successRate%" -ForegroundColor Cyan
} catch {
    Write-Host "Error writing HTML file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "HTML report generation completed!" -ForegroundColor Green
