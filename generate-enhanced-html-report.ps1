# Simple HTML Report Generator
# This script parses XML test results and generates a basic HTML report

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

Write-Host "Generating HTML report..." -ForegroundColor Cyan

# Check if XML file exists
if (-not (Test-Path $XmlFile)) {
    Write-Host "XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

# Load and parse XML
try {
    Write-Host "Loading XML file: $XmlFile" -ForegroundColor Yellow
    
    # Try different methods to load XML
    $xmlContent = $null
    try {
        # Try UTF8 first
        [xml]$xmlContent = Get-Content $XmlFile -Raw -Encoding UTF8
        Write-Host "XML loaded with UTF8 encoding" -ForegroundColor Green
    } catch {
        Write-Host "UTF8 encoding failed, trying UTF8 with BOM..." -ForegroundColor Yellow
        try {
            [xml]$xmlContent = Get-Content $XmlFile -Raw -Encoding UTF8 -NoNewline
        } catch {
            Write-Host "UTF8 with BOM failed, trying default encoding..." -ForegroundColor Yellow
            try {
                [xml]$xmlContent = Get-Content $XmlFile -Raw
            } catch {
                Write-Host "Default encoding failed, trying ASCII..." -ForegroundColor Yellow
                try {
                    [xml]$xmlContent = Get-Content $XmlFile -Raw -Encoding ASCII
                } catch {
                    Write-Host "ASCII failed, trying Unicode..." -ForegroundColor Yellow
                    [xml]$xmlContent = Get-Content $XmlFile -Raw -Encoding Unicode
                }
            }
        }
    }
    
    if ($xmlContent -eq $null) {
        throw "Failed to load XML file"
    }
    
    Write-Host "XML loaded successfully" -ForegroundColor Green
    
    # Extract test statistics
    $totalTests = 0
    $passedTests = 0
    $failedTests = 0
    $skippedTests = 0
    $testDetails = @()
    
    # Parse test results - try different XPath expressions
    $testCases = $null
    try {
        $testCases = $xmlContent.SelectNodes("//test")
    } catch {
        Write-Host "XPath '//test' failed, trying alternative..." -ForegroundColor Yellow
        $testCases = $xmlContent.assemblies.assembly.collection.test
    }
    
    if ($testCases -eq $null -or $testCases.Count -eq 0) {
        Write-Host "No test cases found in XML" -ForegroundColor Yellow
        $testCases = @()
    }
    foreach ($test in $testCases) {
        $totalTests++
        
        # Safely get attributes with fallbacks
        $testName = if ($test.GetAttribute("name")) { $test.GetAttribute("name") } else { "Unknown Test" }
        $testResult = if ($test.GetAttribute("result")) { $test.GetAttribute("result") } else { "Unknown" }
        $testTime = try { [double]$test.GetAttribute("time") } catch { 0.0 }
        $testType = if ($test.GetAttribute("type")) { $test.GetAttribute("type") } else { "Unknown" }
        
        # Extract class name from type
        $className = if ($testType) { 
            # If type contains dots, get the last part, otherwise use the whole type
            if ($testType.Contains('.')) {
                $testType.Split('.')[-1]
            } else {
                $testType
            }
        } else { 
            "Unknown" 
        }
        
        # Extract method name for display
        $displayName = if ($testName) {
            $testName.Split('.')[-1] -replace '_', ' '
        } else {
            "Unknown Test"
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
            StatusIcon = if ($testResult -eq "Pass") { "&#10004;" } elseif ($testResult -eq "Fail") { "&#10008;" } else { "&#9193;" }
        }
    }
    
    # Calculate success rate
    $successRate = if ($totalTests -gt 0) { 
        [math]::Round(($passedTests / $totalTests) * 100, 1) 
    } else { 
        0 
    }
    
    Write-Host "Test Statistics:" -ForegroundColor Green
    Write-Host "   Total Tests: $totalTests" -ForegroundColor White
    Write-Host "   Passed: $passedTests" -ForegroundColor Green
    Write-Host "   Failed: $failedTests" -ForegroundColor Red
    Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
    Write-Host "   Success Rate: $successRate%" -ForegroundColor Cyan
    
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
        
        /* Collapsible sections */
        .class-section { margin: 20px 0; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .class-header { background: #f8f9fa; padding: 15px; cursor: pointer; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center; }
        .class-header:hover { background: #e9ecef; }
        .class-name { font-weight: bold; font-size: 1.1em; color: #333; }
        .class-stats { color: #666; font-size: 0.9em; }
        .class-toggle { font-size: 1.2em; transition: transform 0.3s ease; }
        .class-toggle.expanded { transform: rotate(90deg); }
        .class-content { display: none; }
        .class-content.expanded { display: block; }
        .class-tests { padding: 0; }
        .class-test { padding: 12px 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .class-test:last-child { border-bottom: none; }
        .class-test:hover { background: #f8f9fa; }
        .test-info { flex-grow: 1; }
        .test-name { font-weight: 600; color: #333; margin-bottom: 5px; }
        .test-duration { color: #666; font-size: 0.9em; }
        .test-status { display: flex; align-items: center; gap: 8px; }
        .status-icon { font-size: 1.1em; }
        .status-text { font-weight: 600; text-transform: uppercase; font-size: 0.9em; }
        .status-passed { color: #28a745; }
        .status-failed { color: #dc3545; }
        .status-skipped { color: #ffc107; }
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
        
        <h2>&#128203; Test Results by Class</h2>
        <div class="test-results-by-class">
"@

# Group tests by class
$testsByClass = $testDetails | Group-Object -Property Class

# Add collapsible sections for each class
foreach ($classGroup in $testsByClass) {
    $className = $classGroup.Name
    $classTests = $classGroup.Group
    $classPassed = ($classTests | Where-Object { $_.Result -eq "Pass" }).Count
    $classFailed = ($classTests | Where-Object { $_.Result -eq "Fail" }).Count
    $classSkipped = ($classTests | Where-Object { $_.Result -eq "Skip" }).Count
    $classTotal = $classTests.Count
    
    $htmlContent += @"
            <div class="class-section">
                <div class="class-header" onclick="toggleClass('$className')">
                    <div>
                        <div class="class-name">$className</div>
                        <div class="class-stats">$classTotal tests | $classPassed passed, $classFailed failed, $classSkipped skipped</div>
                    </div>
                    <div class="class-toggle" id="toggle-$className">▶</div>
                </div>
                <div class="class-content" id="content-$className">
                    <div class="class-tests">
"@
    
    foreach ($test in $classTests) {
        $statusClass = switch ($test.Result) {
            "Pass" { "status-passed" }
            "Fail" { "status-failed" }
            default { "status-skipped" }
        }
        
        $htmlContent += @"
                        <div class="class-test">
                            <div class="test-info">
                                <div class="test-name">$($test.Name)</div>
                                <div class="test-duration">Duration: $($test.DurationMs)ms</div>
                            </div>
                            <div class="test-status">
                                <span class="status-icon">$($test.StatusIcon)</span>
                                <span class="status-text $statusClass">$($test.Result)</span>
                            </div>
                        </div>
"@
    }
    
    $htmlContent += @"
                    </div>
                </div>
            </div>
"@
}

$htmlContent += @"
        </div>
        
        <div class="footer">
            <p>Report generated by VaxCare API Test Suite | $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        </div>
    </div>
    
    <script>
        function toggleClass(className) {
            const content = document.getElementById('content-' + className);
            const toggle = document.getElementById('toggle-' + className);
            
            if (content.classList.contains('expanded')) {
                content.classList.remove('expanded');
                toggle.classList.remove('expanded');
            } else {
                content.classList.add('expanded');
                toggle.classList.add('expanded');
            }
        }
        
        // Optional: Add keyboard support
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                const target = e.target;
                if (target.classList.contains('class-header')) {
                    e.preventDefault();
                    target.click();
                }
            }
        });
    </script>
</body>
</html>
"@

# Write HTML content to file
try {
    # Try different encoding methods for output
    try {
        $htmlContent | Out-File -FilePath $htmlReportPath -Encoding UTF8 -NoNewline
        Write-Host "HTML file written with UTF8 encoding" -ForegroundColor Green
    } catch {
        Write-Host "UTF8 output failed, trying UTF8 with BOM..." -ForegroundColor Yellow
        try {
            $htmlContent | Out-File -FilePath $htmlReportPath -Encoding UTF8
        } catch {
            Write-Host "UTF8 with BOM failed, trying default encoding..." -ForegroundColor Yellow
            $htmlContent | Out-File -FilePath $htmlReportPath -Encoding Default
        }
    }
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
