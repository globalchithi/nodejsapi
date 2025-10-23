# Simple XML parsing test
param([string]$XmlFile = "TestReports/TestResults.xml")

Write-Host "Testing XML parsing..." -ForegroundColor Cyan

if (-not (Test-Path $XmlFile)) {
    Write-Host "XML file not found: $XmlFile" -ForegroundColor Red
    exit 1
}

try {
    Write-Host "Loading XML file: $XmlFile" -ForegroundColor Yellow
    
    # Try to load XML
    [xml]$xmlContent = Get-Content $XmlFile -Raw -Encoding UTF8
    
    if ($xmlContent -eq $null) {
        throw "Failed to load XML file"
    }
    
    Write-Host "XML loaded successfully" -ForegroundColor Green
    
    # Try to find test cases
    $testCases = $xmlContent.SelectNodes("//test")
    Write-Host "Found $($testCases.Count) test cases" -ForegroundColor Green
    
    if ($testCases.Count -gt 0) {
        $firstTest = $testCases[0]
        Write-Host "First test name: $($firstTest.GetAttribute('name'))" -ForegroundColor White
        Write-Host "First test result: $($firstTest.GetAttribute('result'))" -ForegroundColor White
    }
    
    Write-Host "XML parsing test completed successfully!" -ForegroundColor Green
    
} catch {
    Write-Host "Error parsing XML: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Stack trace: $($_.Exception.StackTrace)" -ForegroundColor Red
    exit 1
}
