# Test script to verify syntax
param(
    [string]$TestParam = "test"
)

try {
    Write-Host "Testing syntax..." -ForegroundColor Green
    $testVar = "test"
    Write-Host "Variable: $testVar" -ForegroundColor White
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Syntax test completed!" -ForegroundColor Green
