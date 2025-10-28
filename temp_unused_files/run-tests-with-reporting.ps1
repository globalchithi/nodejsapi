# PowerShell script to run tests with automatic report generation (Windows)
param(
    [string]$Filter = "",
    [string]$OutputFormat = "html,json,markdown",
    [switch]$OpenReports = $false,
    [switch]$Verbose = $false,
    [switch]$GeneratePdf = $true
)

Write-Host "🧪 VaxCare API Test Suite - Running Tests with Reporting (Windows)" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# Set up variables
$ProjectPath = "VaxCareApiTests.csproj"
$ReportsDir = "TestReports"
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Create reports directory if it doesn't exist
if (!(Test-Path $ReportsDir)) {
    New-Item -ItemType Directory -Path $ReportsDir | Out-Null
    Write-Host "📁 Created reports directory: $ReportsDir" -ForegroundColor Green
}

# Build the project first
Write-Host "🔨 Building project..." -ForegroundColor Yellow
$buildResult = dotnet build $ProjectPath --configuration Release --verbosity minimal
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Build successful!" -ForegroundColor Green

# Prepare test command
$testCommand = "dotnet test $ProjectPath --configuration Release --logger trx --results-directory $ReportsDir"

if ($Filter) {
    $testCommand += " --filter `"$Filter`""
}

if ($Verbose) {
    $testCommand += " --verbosity normal"
} else {
    $testCommand += " --verbosity minimal"
}

# Add XML logger for detailed results
$testCommand += " --logger `"xunit;LogFilePath=$ReportsDir\TestResults.xml`""

Write-Host "🚀 Running tests..." -ForegroundColor Yellow
Write-Host "Command: $testCommand" -ForegroundColor Gray

# Execute tests
$testResult = Invoke-Expression $testCommand
$testExitCode = $LASTEXITCODE

# Check if tests ran successfully
if ($testExitCode -eq 0) {
    Write-Host "✅ All tests passed!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Some tests failed or were skipped" -ForegroundColor Yellow
}

# Generate enhanced HTML report
Write-Host "📊 Generating enhanced HTML report..." -ForegroundColor Yellow
& .\generate-enhanced-report.ps1

# Generate PDF report if requested
if ($GeneratePdf) {
    Write-Host "📄 Generating PDF report..." -ForegroundColor Yellow
    & .\generate-pdf-report.ps1 -Latest
}

# List all generated reports
Write-Host ""
Write-Host "📁 Generated Reports:" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan

# List HTML reports
$htmlReports = Get-ChildItem -Path $ReportsDir -Name "EnhancedTestReport_*.html" | Sort-Object -Descending
if ($htmlReports.Count -gt 0) {
    Write-Host "📄 HTML Reports:" -ForegroundColor Green
    foreach ($report in $htmlReports) {
        Write-Host "   $report" -ForegroundColor White
    }
}

# List PDF reports
$pdfReports = Get-ChildItem -Path $ReportsDir -Name "TestReport_*.pdf" | Sort-Object -Descending
if ($pdfReports.Count -gt 0) {
    Write-Host "📄 PDF Reports:" -ForegroundColor Green
    foreach ($report in $pdfReports) {
        $size = (Get-Item "$ReportsDir\$report").Length / 1KB
        Write-Host "   $report ($([math]::Round($size, 1)) KB)" -ForegroundColor White
    }
}

# List JSON reports
$jsonReports = Get-ChildItem -Path $ReportsDir -Name "TestReport_*.json" | Sort-Object -Descending
if ($jsonReports.Count -gt 0) {
    Write-Host "📄 JSON Reports:" -ForegroundColor Green
    foreach ($report in $jsonReports) {
        Write-Host "   $report" -ForegroundColor White
    }
}

# List Markdown reports
$mdReports = Get-ChildItem -Path $ReportsDir -Name "TestReport_*.md" | Sort-Object -Descending
if ($mdReports.Count -gt 0) {
    Write-Host "📄 Markdown Reports:" -ForegroundColor Green
    foreach ($report in $mdReports) {
        Write-Host "   $report" -ForegroundColor White
    }
}

# Open reports if requested
if ($OpenReports) {
    Write-Host "🌐 Opening reports..." -ForegroundColor Yellow
    
    # Open latest HTML report
    if ($htmlReports.Count -gt 0) {
        $latestHtml = "$ReportsDir\$($htmlReports[0])"
        Write-Host "   Opening HTML report: $($htmlReports[0])" -ForegroundColor White
        Start-Process $latestHtml
    }
    
    # Open latest PDF report
    if ($pdfReports.Count -gt 0) {
        $latestPdf = "$ReportsDir\$($pdfReports[0])"
        Write-Host "   Opening PDF report: $($pdfReports[0])" -ForegroundColor White
        Start-Process $latestPdf
    }
}

Write-Host ""
Write-Host "🎉 Test execution and report generation completed!" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan

exit $testExitCode