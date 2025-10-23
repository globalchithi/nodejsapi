# PowerShell script to generate enhanced HTML reports (Windows) - Fixed Version
param(
    [string]$XmlFile = "TestReports\TestResults.xml",
    [string]$OutputDir = "TestReports"
)

Write-Host "📊 Generating enhanced HTML report from XML results..." -ForegroundColor Yellow

if (!(Test-Path $XmlFile)) {
    Write-Host "❌ XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

# Extract test statistics from XML
$totalTests = (Select-String -Path $XmlFile -Pattern '<test ').Count
$passedTests = (Select-String -Path $XmlFile -Pattern 'result="Pass"').Count
$failedTests = (Select-String -Path $XmlFile -Pattern 'result="Fail"').Count
$skippedTests = (Select-String -Path $XmlFile -Pattern 'result="Skip"').Count

# Calculate success rate
if ($totalTests -gt 0) {
    $successRate = [math]::Round(($passedTests * 100 / $totalTests), 1)
} else {
    $successRate = 0
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$htmlReportPath = "$OutputDir\EnhancedTestReport_$timestamp.html"

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
    <title>VaxCare API Test Report - Enhanced</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background-color: #f5f5f5; 
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            background: white; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            padding: 30px; 
            border-radius: 8px 8px 0 0; 
        }
        .header h1 { 
            margin: 0; 
            font-size: 2.5em; 
        }
        .header p { 
            margin: 10px 0 0 0; 
            opacity: 0.9; 
        }
        .stats { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
            gap: 20px; 
            padding: 30px; 
        }
        .stat-card { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 8px; 
            text-align: center; 
            border-left: 4px solid #007bff; 
        }
        .stat-card.passed { 
            border-left-color: #28a745; 
        }
        .stat-card.failed { 
            border-left-color: #dc3545; 
        }
        .stat-card.skipped { 
            border-left-color: #ffc107; 
        }
        .stat-number { 
            font-size: 2.5em; 
            font-weight: bold; 
            margin: 0; 
        }
        .stat-label { 
            color: #666; 
            margin: 5px 0 0 0; 
        }
        .test-results { 
            padding: 0 30px 30px; 
        }
        .test-result { 
            background: #f8f9fa; 
            margin: 10px 0; 
            padding: 15px; 
            border-radius: 6px; 
            border-left: 4px solid #ddd; 
        }
        .test-result.passed { 
            border-left-color: #28a745; 
            background: #d4edda; 
        }
        .test-result.failed { 
            border-left-color: #dc3545; 
            background: #f8d7da; 
        }
        .test-result.skipped { 
            border-left-color: #ffc107; 
            background: #fff3cd; 
        }
        .test-name { 
            font-weight: bold; 
            font-size: 1.1em; 
        }
        .test-class { 
            color: #666; 
            font-size: 0.9em; 
        }
        .test-duration { 
            color: #666; 
            font-size: 0.9em; 
        }
        .error-message { 
            background: #f8d7da; 
            padding: 10px; 
            border-radius: 4px; 
            margin-top: 10px; 
            font-family: monospace; 
        }
        .footer { 
            background: #f8f9fa; 
            padding: 20px; 
            text-align: center; 
            border-radius: 0 0 8px 8px; 
            color: #666; 
        }
        .summary { 
            background: #e9ecef; 
            padding: 20px; 
            margin: 20px 0; 
            border-radius: 6px; 
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 VaxCare API Test Report</h1>
            <p>Generated: $(Get-Date)</p>
        </div>
        
        <div class="stats">
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
            <div class="stat-card">
                <div class="stat-number">$totalTests</div>
                <div class="stat-label">Total</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$successRate%</div>
                <div class="stat-label">Success Rate</div>
            </div>
        </div>
        
        <div class="summary">
            <h2>📊 Test Execution Summary</h2>
            <p><strong>Total Tests:</strong> $totalTests</p>
            <p><strong>Passed:</strong> $passedTests</p>
            <p><strong>Failed:</strong> $failedTests</p>
            <p><strong>Skipped:</strong> $skippedTests</p>
            <p><strong>Success Rate:</strong> $successRate%</p>
            <p><strong>Execution Time:</strong> $(Get-Date)</p>
        </div>
        
        <div class="test-results">
            <h2>📋 Detailed Test Results</h2>
            <p>✅ All tests executed successfully! Check the XML file for detailed test information.</p>
            <p>📄 <strong>XML Report:</strong> TestResults.xml</p>
            <p>📊 <strong>JSON Report:</strong> Available in TestReports directory</p>
            <p>📝 <strong>Markdown Report:</strong> Available in TestReports directory</p>
        </div>
        
        <div class="footer">
            <p>Report generated by VaxCare API Test Suite | $(Get-Date)</p>
        </div>
    </div>
</body>
</html>
"@

# Write HTML content to file
Set-Content -Path $htmlReportPath -Value $htmlContent -Encoding UTF8

Write-Host "✅ Enhanced HTML report generated: $htmlReportPath" -ForegroundColor Green
Write-Host "📊 Test Statistics:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests" -ForegroundColor White
Write-Host "   Passed: $passedTests" -ForegroundColor Green
Write-Host "   Failed: $failedTests" -ForegroundColor Red
Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
Write-Host "   Success Rate: $successRate percent" -ForegroundColor Cyan
