param(
    [string]$WebhookUrl = "",
    [string]$Environment = "Development",
    [int]$TotalTests = 0,
    [int]$PassedTests = 0,
    [int]$FailedTests = 0,
    [int]$SkippedTests = 0,
    [string]$Duration = "N/A",
    [string]$Browser = "N/A",
    [string]$ProjectName = "VaxCare API Tests"
)

# Validate webhook URL
if ([string]::IsNullOrEmpty($WebhookUrl)) {
    Write-Host "❌ Teams webhook URL is required!" -ForegroundColor Red
    Write-Host "💡 Use -WebhookUrl parameter or set TEAMS_WEBHOOK_URL environment variable" -ForegroundColor Yellow
    exit 1
}

# Calculate success rate
$successRate = if ($TotalTests -gt 0) { [math]::Round(($PassedTests / $TotalTests) * 100, 1) } else { 0 }

# Determine status and emoji
$status = if ($FailedTests -eq 0) { "✅ All $TotalTests tests passed successfully!" } else { "❌ $FailedTests tests failed out of $TotalTests total tests" }
$statusEmoji = if ($FailedTests -eq 0) { "✅" } else { "❌" }

# Get current timestamp
$timestamp = Get-Date -Format "MM/dd/yyyy, h:mm:ss tt"

# Format duration
$formattedDuration = if ($Duration -ne "N/A" -and $Duration -ne "") {
    $seconds = [math]::Round([double]$Duration, 1)
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

Write-Host "📢 Sending Teams notification..." -ForegroundColor Yellow
Write-Host "   Environment: $Environment" -ForegroundColor Gray
Write-Host "   Total Tests: $TotalTests" -ForegroundColor Gray
Write-Host "   Passed: $PassedTests" -ForegroundColor Green
Write-Host "   Failed: $FailedTests" -ForegroundColor Red
Write-Host "   Success Rate: $successRate%" -ForegroundColor Cyan

# Create Teams message payload
$teamsPayload = @{
    text = "🚀 $ProjectName - Test Automation Results"
    attachments = @(
        @{
            contentType = "application/vnd.microsoft.card.adaptive"
            content = @{
                type = "AdaptiveCard"
                body = @(
                    @{
                        type = "TextBlock"
                        text = "$ProjectName - Test Results"
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
                                value = $TotalTests.ToString()
                            }
                            @{
                                title = "Passed"
                                value = $PassedTests.ToString()
                            }
                            @{
                                title = "Failed"
                                value = $FailedTests.ToString()
                            }
                            @{
                                title = "Skipped"
                                value = $SkippedTests.ToString()
                            }
                            @{
                                title = "Success Rate"
                                value = "$successRate%"
                            }
                            @{
                                title = "Duration"
                                value = $formattedDuration
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
    
    Write-Host "🔧 Curl command: $curlCommand" -ForegroundColor Gray
    
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
        exit 1
    }
    
} catch {
    Write-Host "❌ Failed to send Teams notification: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Check your webhook URL and network connectivity" -ForegroundColor Yellow
    exit 1
}

Write-Host "🎉 Teams notification process completed!" -ForegroundColor Green
