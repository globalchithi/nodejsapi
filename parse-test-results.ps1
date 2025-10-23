param(
    [string]$XmlFile = "",
    [string]$OutputDir = "TestReports",
    [string]$WebhookUrl = "",
    [string]$Environment = "Development",
    [string]$Browser = "N/A"
)

Write-Host "📊 Parsing test results and sending to Teams..." -ForegroundColor Cyan

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

# Parse XML to extract test statistics
try {
    $xmlText = Get-Content $XmlFile -Raw -Encoding UTF8
    Write-Host "XML file read successfully, length: $($xmlText.Length) characters" -ForegroundColor Green
    
    # Clean up XML if needed
    $xmlText = $xmlText.Trim()
    if ($xmlText.Contains(">>ies>")) {
        $xmlText = $xmlText -replace ">>ies>", "</assemblies>"
        Write-Host "Fixed malformed XML ending" -ForegroundColor Green
    }
    if ($xmlText.Contains("</assemblies>s</assemblies>")) {
        $xmlText = $xmlText -replace "</assemblies>s</assemblies>", "</assemblies>"
        Write-Host "Fixed malformed XML ending" -ForegroundColor Green
    }
    if (-not $xmlText.EndsWith("</assemblies>")) {
        $xmlText = $xmlText + "</assemblies>"
        Write-Host "Added missing closing tag" -ForegroundColor Green
    }
    
    [xml]$xmlContent = $xmlText
    Write-Host "XML file parsed successfully" -ForegroundColor Green
} catch {
    Write-Host "Error parsing XML file: $($_.Exception.Message)" -ForegroundColor Red
    
    # Try regex fallback
    Write-Host "Attempting to extract data using regex fallback..." -ForegroundColor Yellow
    try {
        $totalMatch = [regex]::Match($xmlText, 'total="(\d+)"')
        $passedMatch = [regex]::Match($xmlText, 'passed="(\d+)"')
        $failedMatch = [regex]::Match($xmlText, 'failed="(\d+)"')
        $skippedMatch = [regex]::Match($xmlText, 'skipped="(\d+)"')
        
        if ($totalMatch.Success) {
            $totalTests = [int]$totalMatch.Groups[1].Value
            $passedTests = if ($passedMatch.Success) { [int]$passedMatch.Groups[1].Value } else { 0 }
            $failedTests = if ($failedMatch.Success) { [int]$failedMatch.Groups[1].Value } else { 0 }
            $skippedTests = if ($skippedMatch.Success) { [int]$skippedMatch.Groups[1].Value } else { 0 }
            Write-Host "Extracted data using regex: Total=$totalTests, Passed=$passedTests, Failed=$failedTests, Skipped=$skippedTests" -ForegroundColor Green
        } else {
            Write-Host "Could not extract test data from XML" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "Regex fallback also failed: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Extract test statistics
$totalTests = 0
$passedTests = 0
$failedTests = 0
$skippedTests = 0
$executionTime = "N/A"

if ($xmlContent.assemblies -and $xmlContent.assemblies.assembly) {
    $assembly = $xmlContent.assemblies.assembly
    $totalTests = [int]$assembly.total
    $passedTests = [int]$assembly.passed
    $failedTests = [int]$assembly.failed
    $skippedTests = [int]$assembly.skipped
    $executionTime = $assembly.time
    Write-Host "Using xunit format - Assembly: $($assembly.name)" -ForegroundColor Green
} elseif ($xmlContent.TestRun -and $xmlContent.TestRun.Results) {
    $results = $xmlContent.TestRun.Results.UnitTestResult
    $totalTests = $results.Count
    $passedTests = ($results | Where-Object { $_.outcome -eq "Passed" }).Count
    $failedTests = ($results | Where-Object { $_.outcome -eq "Failed" }).Count
    $skippedTests = ($results | Where-Object { $_.outcome -eq "NotExecuted" }).Count
    Write-Host "Using TRX format" -ForegroundColor Green
} else {
    Write-Host "Unknown XML format, using extracted values" -ForegroundColor Yellow
}

$successRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 1) } else { 0 }

# Format execution time
$formattedTime = if ($executionTime -ne "N/A" -and $executionTime -ne "") {
    $seconds = [math]::Round([double]$executionTime, 1)
    if ($seconds -lt 60) {
        "$seconds seconds"
    } else {
        $minutes = [math]::Floor($seconds / 60)
        $remainingSeconds = [math]::Round($seconds % 60)
        if ($remainingSeconds -eq 0) {
            "${minutes}m"
        } else {
            "${minutes}m ${remainingSeconds}s"
        }
    }
} else {
    "N/A"
}

# Get current timestamp
$timestamp = Get-Date -Format "MM/dd/yyyy, h:mm:ss tt"

# Determine status and emoji
$status = if ($failedTests -eq 0) { "✅ All $totalTests tests passed successfully!" } else { "❌ $failedTests tests failed out of $totalTests total tests" }
$statusEmoji = if ($failedTests -eq 0) { "✅" } else { "❌" }

Write-Host "📊 Test Statistics:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests" -ForegroundColor White
Write-Host "   Passed: $passedTests" -ForegroundColor Green
Write-Host "   Failed: $failedTests" -ForegroundColor Red
Write-Host "   Skipped: $skippedTests" -ForegroundColor Yellow
Write-Host "   Success Rate: $successRate percent" -ForegroundColor Cyan
Write-Host "   Execution Time: $formattedTime" -ForegroundColor Cyan

# Send to Teams if webhook URL provided
if (-not [string]::IsNullOrEmpty($WebhookUrl)) {
    Write-Host "📢 Sending results to Microsoft Teams..." -ForegroundColor Yellow
    
    # Create Teams message payload
    $teamsPayload = @{
        text = "🚀 VaxCare API Test Automation Results"
        attachments = @(
            @{
                contentType = "application/vnd.microsoft.card.adaptive"
                content = @{
                    type = "AdaptiveCard"
                    body = @(
                        @{
                            type = "TextBlock"
                            text = "VaxCare API Test Results"
                            weight = "Bolder"
                            size = "Medium"
                        }
                        @{
                            type = "TextBlock"
                            text = $status
                            wrap = $true
                        }
                        @{
                            type = "FactSet"
                            facts = @(
                                @{
                                    title = "Environment"
                                    value = $Environment
                                }
                                @{
                                    title = "Total Tests"
                                    value = $totalTests.ToString()
                                }
                                @{
                                    title = "Passed"
                                    value = $passedTests.ToString()
                                }
                                @{
                                    title = "Failed"
                                    value = $failedTests.ToString()
                                }
                                @{
                                    title = "Skipped"
                                    value = $skippedTests.ToString()
                                }
                                @{
                                    title = "Success Rate"
                                    value = "$successRate%"
                                }
                                @{
                                    title = "Duration"
                                    value = $formattedTime
                                }
                                @{
                                    title = "Browser"
                                    value = $Browser
                                }
                                @{
                                    title = "Timestamp"
                                    value = $timestamp
                                }
                            )
                        }
                    )
                    version = "1.0"
                }
            }
        )
    } | ConvertTo-Json -Depth 10

    # Send to Teams using curl
    try {
        Write-Host "📤 Sending notification via curl..." -ForegroundColor Yellow
        
        # Create temporary file for JSON payload
        $tempFile = [System.IO.Path]::GetTempFileName()
        $teamsPayload | Out-File -FilePath $tempFile -Encoding UTF8
        
        # Build curl command
        $curlCommand = "curl.exe `"$WebhookUrl`" -X POST -H `"Content-Type: application/json`" --data-raw `"@$tempFile`""
        
        # Execute curl command
        $result = Invoke-Expression $curlCommand
        
        # Clean up temp file
        Remove-Item $tempFile -Force
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Teams notification sent successfully!" -ForegroundColor Green
            Write-Host "📱 Check your Microsoft Teams channel for the test results" -ForegroundColor Cyan
        } else {
            Write-Host "❌ Failed to send Teams notification (curl exit code: $LASTEXITCODE)" -ForegroundColor Red
            Write-Host "💡 Check your webhook URL and network connectivity" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "❌ Failed to send Teams notification: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "💡 Check your webhook URL and network connectivity" -ForegroundColor Yellow
    }
} else {
    Write-Host "ℹ️  No Teams webhook URL provided - results not sent to Teams" -ForegroundColor Yellow
    Write-Host "💡 Use -WebhookUrl parameter to send results to Teams" -ForegroundColor Yellow
}

Write-Host "🎉 Test results parsing completed!" -ForegroundColor Green
