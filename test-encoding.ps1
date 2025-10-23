# Test XML encoding
param([string]$XmlFile = "TestReports/TestResults.xml")

Write-Host "Testing XML encoding methods..." -ForegroundColor Cyan

if (-not (Test-Path $XmlFile)) {
    Write-Host "XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

# Test different encoding methods
$encodings = @("UTF8", "ASCII", "Unicode", "Default")
foreach ($encoding in $encodings) {
    try {
        Write-Host "Testing $encoding encoding..." -ForegroundColor Yellow
        [xml]$xmlContent = Get-Content $XmlFile -Raw -Encoding $encoding
        Write-Host "✅ $encoding encoding works!" -ForegroundColor Green
        break
    } catch {
        Write-Host "❌ $encoding encoding failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Encoding test completed!" -ForegroundColor Green
