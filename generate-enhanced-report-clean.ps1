param(
    [string]$XmlFile = "TestResults.xml",
    [string]$OutputDir = "TestReports"
)

Write-Host "📊 Generating enhanced HTML report from XML results..." -ForegroundColor Yellow

# Check if XML file exists
if (-not (Test-Path $XmlFile)) {
    Write-Host "❌ XML file not found: $XmlFile" -ForegroundColor Red
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

Write-Host "📊 Test Statistics:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests" -ForegroundColor White
Write-Host "   Passed: $passedTests" -ForegroundColor Green
Write-Host "   Failed: $failedTests" -ForegroundColor Red
Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
Write-Host "   Success Rate: $successRate percent" -ForegroundColor Cyan

# Generate comprehensive HTML report
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VaxCare API Test Report - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 1.1em;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px;
            background: #f8f9fa;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .stat-label {
            color: #666;
            font-size: 1.1em;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .passed { color: #28a745; }
        .failed { color: #dc3545; }
        .skipped { color: #ffc107; }
        .total { color: #007bff; }
        .success-rate { color: #17a2b8; }
        .summary {
            padding: 30px;
            background: white;
        }
        .summary h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.8em;
        }
        .summary p {
            margin: 10px 0;
            font-size: 1.1em;
            color: #555;
        }
        .test-results {
            padding: 30px;
            background: #f8f9fa;
        }
        .test-results h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.8em;
        }
        .test-item {
            background: white;
            margin: 10px 0;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .test-name {
            font-weight: 500;
            color: #333;
        }
        .test-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }
        .status-passed {
            background: #d4edda;
            color: #155724;
        }
        .status-failed {
            background: #f8d7da;
            color: #721c24;
        }
        .status-skipped {
            background: #fff3cd;
            color: #856404;
        }
        .test-time {
            color: #666;
            font-size: 0.9em;
        }
        .footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 20px;
            font-size: 0.9em;
        }
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .test-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 VaxCare API Test Report</h1>
            <p>Generated on $(Get-Date -Format 'MMMM dd, yyyy at HH:mm:ss')</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card total">
                <div class="stat-number">$totalTests</div>
                <div class="stat-label">Total Tests</div>
            </div>
            <div class="stat-card passed">
                <div class="stat-number">$passedTests</div>
                <div class="stat-label">Passed</div>
            </div>
            <div class="stat-card failed">
                <div class="stat-number">$failedTests</div>
                <div class="stat-label">Failed</div>
            </div>
            <div class="stat-card skipped">
                <div class="stat-number">$skippedTests</div>
                <div class="stat-label">Skipped</div>
            </div>
            <div class="stat-card success-rate">
                <div class="stat-number">$successRate percent</div>
                <div class="stat-label">Success Rate</div>
            </div>
        </div>
        
        <div class="summary">
            <h2>📊 Test Execution Summary</h2>
            <p><strong>Total Tests:</strong> $totalTests</p>
            <p><strong>Passed:</strong> $passedTests</p>
            <p><strong>Failed:</strong> $failedTests</p>
            <p><strong>Skipped:</strong> $skippedTests</p>
            <p><strong>Success Rate:</strong> $successRate percent</p>
            <p><strong>Execution Time:</strong> $(Get-Date)</p>
        </div>
        
        <div class="test-results">
            <h2>📋 Detailed Test Results</h2>
"@

# Add individual test results
$tests = $xmlContent.assemblies.assembly.collection.test
foreach ($test in $tests) {
    $testName = $test.name
    $testResult = $test.result
    $testTime = $test.time
    $testClass = $test.class
    
    $statusClass = switch ($testResult) {
        "Pass" { "status-passed" }
        "Fail" { "status-failed" }
        "Skip" { "status-skipped" }
        default { "status-unknown" }
    }
    
    $statusText = switch ($testResult) {
        "Pass" { "✅ PASSED" }
        "Fail" { "❌ FAILED" }
        "Skip" { "⏭️ SKIPPED" }
        default { "❓ UNKNOWN" }
    }
    
    $htmlContent += @"
            <div class="test-item">
                <div class="test-name">$testName</div>
                <div class="test-status $statusClass">$statusText</div>
                <div class="test-time">$testTime seconds</div>
            </div>
"@
}

$htmlContent += @"
        </div>
        
        <div class="footer">
            <p>Generated by VaxCare API Test Suite | $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        </div>
    </div>
</body>
</html>
"@

# Generate timestamp for filename
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$htmlReportPath = Join-Path $OutputDir "EnhancedTestReport_$timestamp.html"

# Save HTML report
Set-Content -Path $htmlReportPath -Value $htmlContent -Encoding UTF8

Write-Host "✅ Enhanced HTML report generated: $htmlReportPath" -ForegroundColor Green
Write-Host "📊 Test Statistics:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests" -ForegroundColor White
Write-Host "   Passed: $passedTests" -ForegroundColor Green
Write-Host "   Failed: $failedTests" -ForegroundColor Red
Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
Write-Host "   Success Rate: $successRate percent" -ForegroundColor Cyan
