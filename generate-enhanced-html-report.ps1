# Enhanced HTML Report Generator with Beautiful Table
# This script parses XML test results and generates a comprehensive HTML report with test details in a table

param(
    [string]$XmlFile = "TestReports/TestResults.xml",
    [string]$OutputDir = "TestReports",
    [string]$ProjectName = "VaxCare API Test Suite"
)

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
$htmlReportPath = Join-Path $OutputDir "EnhancedTestReport_$timestamp.html"

Write-Host "📊 Generating enhanced HTML report with beautiful table..." -ForegroundColor Cyan

# Check if XML file exists
if (-not (Test-Path $XmlFile)) {
    Write-Host "❌ XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

# Load and parse XML
try {
    [xml]$xmlContent = Get-Content $XmlFile -Raw -Encoding UTF8
    
    # Extract test statistics
    $totalTests = 0
    $passedTests = 0
    $failedTests = 0
    $skippedTests = 0
    $testDetails = @()
    
    # Parse test results
    $testCases = $xmlContent.SelectNodes("//test")
    foreach ($test in $testCases) {
        $totalTests++
        $testName = $test.GetAttribute("name")
        $testResult = $test.GetAttribute("result")
        $testTime = [double]$test.GetAttribute("time")
        $testType = $test.GetAttribute("type")
        $testMethod = $test.GetAttribute("method")
        
        # Extract class name from type
        $className = if ($testType) { 
            $testType.Split('.')[-2] 
        } else { 
            "Unknown" 
        }
        
        # Extract method name for display
        $displayName = if ($testMethod) {
            $testMethod -replace '_', ' ' -replace '([a-z])([A-Z])', '$1 $2'
        } else {
            $testName.Split('.')[-1] -replace '_', ' ' -replace '([a-z])([A-Z])', '$1 $2'
        }
        
        # Count results
        switch ($testResult) {
            "Pass" { $passedTests++ }
            "Fail" { $failedTests++ }
            "Skip" { $skippedTests++ }
        }
        
        # Add to test details
        $testDetails += [PSCustomObject]@{
            Name = $displayName
            FullName = $testName
            Class = $className
            Result = $testResult
            Duration = $testTime
            DurationMs = [math]::Round($testTime * 1000, 2)
            StatusIcon = if ($testResult -eq "Pass") { "✅" } elseif ($testResult -eq "Fail") { "❌" } else { "⏭️" }
        }
    }
    
    # Calculate success rate
    $successRate = if ($totalTests -gt 0) { 
        [math]::Round(($passedTests / $totalTests) * 100, 1) 
    } else { 
        0 
    }
    
    Write-Host "📊 Test Statistics:" -ForegroundColor Green
    Write-Host "   Total Tests: $totalTests" -ForegroundColor White
    Write-Host "   Passed: $passedTests" -ForegroundColor Green
    Write-Host "   Failed: $failedTests" -ForegroundColor Red
    Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
    Write-Host "   Success Rate: ${successRate}%" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Error parsing XML file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Generate HTML content
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$ProjectName - Test Report</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 3em;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.2em;
            opacity: 0.9;
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
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card.passed {
            border-top: 4px solid #28a745;
        }
        
        .stat-card.failed {
            border-top: 4px solid #dc3545;
        }
        
        .stat-card.skipped {
            border-top: 4px solid #ffc107;
        }
        
        .stat-card.total {
            border-top: 4px solid #007bff;
        }
        
        .stat-card.success-rate {
            border-top: 4px solid #6f42c1;
        }
        
        .stat-number {
            font-size: 3em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .stat-label {
            color: #666;
            font-size: 1.1em;
            font-weight: 500;
        }
        
        .passed .stat-number { color: #28a745; }
        .failed .stat-number { color: #dc3545; }
        .skipped .stat-number { color: #ffc107; }
        .total .stat-number { color: #007bff; }
        .success-rate .stat-number { color: #6f42c1; }
        
        .content {
            padding: 30px;
        }
        
        .section-title {
            font-size: 2em;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }
        
        .test-table-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .test-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95em;
        }
        
        .test-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .test-table th {
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            font-size: 1em;
        }
        
        .test-table tbody tr {
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s ease;
        }
        
        .test-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .test-table tbody tr:last-child {
            border-bottom: none;
        }
        
        .test-table td {
            padding: 12px;
            vertical-align: middle;
        }
        
        .test-name {
            font-weight: 600;
            color: #333;
        }
        
        .test-class {
            color: #666;
            font-size: 0.9em;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .test-status {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .status-icon {
            font-size: 1.2em;
        }
        
        .status-text {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
        }
        
        .status-passed {
            color: #28a745;
        }
        
        .status-failed {
            color: #dc3545;
        }
        
        .status-skipped {
            color: #ffc107;
        }
        
        .duration {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: #666;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .duration.fast {
            color: #28a745;
        }
        
        .duration.medium {
            color: #ffc107;
        }
        
        .duration.slow {
            color: #dc3545;
        }
        
        .summary-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .summary-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .summary-label {
            font-weight: 600;
            color: #666;
            margin-bottom: 5px;
        }
        
        .summary-value {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
        }
        
        .footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            border-top: 1px solid #dee2e6;
        }
        
        .performance-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 5px;
        }
        
        .performance-fast {
            background-color: #28a745;
        }
        
        .performance-medium {
            background-color: #ffc107;
        }
        
        .performance-slow {
            background-color: #dc3545;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 8px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                padding: 20px;
            }
            
            .test-table {
                font-size: 0.85em;
            }
            
            .test-table th,
            .test-table td {
                padding: 8px 6px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 $ProjectName</h1>
            <p>Comprehensive Test Execution Report</p>
            <p>Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card passed">
                <div class="stat-number">$passedTests</div>
                <div class="stat-label">✅ Passed</div>
            </div>
            <div class="stat-card failed">
                <div class="stat-number">$failedTests</div>
                <div class="stat-label">❌ Failed</div>
            </div>
            <div class="stat-card skipped">
                <div class="stat-number">$skippedTests</div>
                <div class="stat-label">⏭️ Skipped</div>
            </div>
            <div class="stat-card total">
                <div class="stat-number">$totalTests</div>
                <div class="stat-label">📊 Total</div>
            </div>
            <div class="stat-card success-rate">
                <div class="stat-number">$successRate%</div>
                <div class="stat-label">🎯 Success Rate</div>
            </div>
        </div>
        
        <div class="content">
            <div class="summary-section">
                <h2 class="section-title">📊 Execution Summary</h2>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="summary-label">Total Tests</div>
                        <div class="summary-value">$totalTests</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Passed</div>
                        <div class="summary-value" style="color: #28a745;">$passedTests</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Failed</div>
                        <div class="summary-value" style="color: #dc3545;">$failedTests</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Skipped</div>
                        <div class="summary-value" style="color: #ffc107;">$skippedTests</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Success Rate</div>
                        <div class="summary-value" style="color: #6f42c1;">$successRate%</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Report Generated</div>
                        <div class="summary-value">$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</div>
                    </div>
                </div>
            </div>
            
            <h2 class="section-title">📋 Detailed Test Results</h2>
            <div class="test-table-container">
                <table class="test-table">
                    <thead>
                        <tr>
                            <th>Status</th>
                            <th>Test Name</th>
                            <th>Class</th>
                            <th>Duration</th>
                            <th>Performance</th>
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
    
    $durationClass = if ($test.DurationMs -lt 100) { "fast" } 
                     elseif ($test.DurationMs -lt 1000) { "medium" } 
                     else { "slow" }
    
    $performanceClass = if ($test.DurationMs -lt 100) { "performance-fast" } 
                       elseif ($test.DurationMs -lt 1000) { "performance-medium" } 
                       else { "performance-slow" }
    
    $htmlContent += @"
                        <tr>
                            <td>
                                <div class="test-status">
                                    <span class="status-icon">$($test.StatusIcon)</span>
                                    <span class="status-text $statusClass">$($test.Result)</span>
                                </div>
                            </td>
                            <td>
                                <div class="test-name">$($test.Name)</div>
                            </td>
                            <td>
                                <span class="test-class">$($test.Class)</span>
                            </td>
                            <td>
                                <span class="duration $durationClass">$($test.DurationMs)ms</span>
                            </td>
                            <td>
                                <span class="performance-indicator $performanceClass"></span>
                                <span>$($test.DurationMs)ms</span>
                            </td>
                        </tr>
"@
}

$htmlContent += @"
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="footer">
            <p>📊 Report generated by $ProjectName | $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
            <p>🔧 Enhanced HTML Report with Beautiful Table Layout</p>
        </div>
    </div>
</body>
</html>
"@

# Write HTML content to file
try {
    $htmlContent | Out-File -FilePath $htmlReportPath -Encoding UTF8
    Write-Host "✅ Enhanced HTML report generated: $htmlReportPath" -ForegroundColor Green
    Write-Host "📊 Report Statistics:" -ForegroundColor Cyan
    Write-Host "   📄 File: $htmlReportPath" -ForegroundColor White
    Write-Host "   📊 Tests: $totalTests" -ForegroundColor White
    Write-Host "   ✅ Passed: $passedTests" -ForegroundColor Green
    Write-Host "   ❌ Failed: $failedTests" -ForegroundColor Red
    Write-Host "   ⏭️ Skipped: $skippedTests" -ForegroundColor Yellow
    Write-Host "   🎯 Success Rate: ${successRate}%" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error writing HTML file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Enhanced HTML report generation completed!" -ForegroundColor Green
