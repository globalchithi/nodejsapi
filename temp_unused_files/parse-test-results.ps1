param(
    [string]$XmlFile = "",
    [string]$OutputDir = "TestReports",
    [string]$WebhookUrl = "",
    [string]$Environment = "Staging",
    [string]$Browser = "N/A"
)

Write-Host "📊 Parsing test results and sending to Teams..." -ForegroundColor Cyan

# Find the XML file if not specified
if ([string]::IsNullOrEmpty($XmlFile)) {
    $testResultsXml = Join-Path $OutputDir "TestResults.xml"
    if (Test-Path $testResultsXml) {
        $XmlFile = $testResultsXml
        Write-Host "Found XML file: $XmlFile" -ForegroundColor Green
    } else {
        Write-Host "No XML test results found in $OutputDir" -ForegroundColor Red
        exit 1
    }
}

# Check if XML file exists
if (-not (Test-Path $XmlFile)) {
    Write-Host "XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

# Parse XML to extract test statistics
try {
    $xmlText = Get-Content $XmlFile -Raw -Encoding UTF8
    Write-Host "XML file read successfully" -ForegroundColor Green
    
    [xml]$xmlContent = $xmlText
    Write-Host "XML file parsed successfully" -ForegroundColor Green
} catch {
    Write-Host "Error parsing XML file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Extract test statistics
$totalTests = 0
$passedTests = 0
$failedTests = 0
$skippedTests = 0

if ($xmlContent.assemblies -and $xmlContent.assemblies.assembly) {
    $assembly = $xmlContent.assemblies.assembly
    $totalTests = [int]$assembly.total
    $passedTests = [int]$assembly.passed
    $failedTests = [int]$assembly.failed
    $skippedTests = [int]$assembly.skipped
    Write-Host "Using xunit format" -ForegroundColor Green
}

$successRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 1) } else { 0 }

Write-Host "📊 Test Statistics:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests" -ForegroundColor White
Write-Host "   Passed: $passedTests" -ForegroundColor Green
Write-Host "   Failed: $failedTests" -ForegroundColor Red
Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
Write-Host "   Success Rate: $successRate percent" -ForegroundColor Cyan

# Send to Teams if webhook URL provided
if (-not [string]::IsNullOrEmpty($WebhookUrl)) {
    Write-Host "📢 Sending results to Microsoft Teams..." -ForegroundColor Yellow
    
    # Create simple Teams message
    $message = "Test Results: $totalTests total, $passedTests passed, $failedTests failed"
    
    # Send to Teams using curl
    try {
        Write-Host "📤 Sending notification via curl..." -ForegroundColor Yellow
        
        $curlCommand = "curl.exe `"$WebhookUrl`" -X POST -H `"Content-Type: application/json`" --data-raw `"{\`"text\`":\`"$message\`"}`""
        
        $result = Invoke-Expression $curlCommand
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Teams notification sent successfully!" -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to send Teams notification" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "❌ Failed to send Teams notification: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️  No Teams webhook URL provided" -ForegroundColor Yellow
}

Write-Host "🎉 Test results parsing completed!" -ForegroundColor Green
