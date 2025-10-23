# PowerShell script to generate PDF reports (Windows)
param(
    [string]$HtmlFile = "",
    [string]$OutputDir = "TestReports",
    [switch]$Latest = $false,
    [switch]$All = $false
)

Write-Host "📄 PDF Report Generator for VaxCare API Test Reports (Windows)" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan

# Function to check if required tools are available
function Test-PdfDependencies {
    $missingTools = @()
    
    # Check for wkhtmltopdf
    try {
        $null = Get-Command wkhtmltopdf -ErrorAction Stop
    } catch {
        $missingTools += "wkhtmltopdf"
    }
    
    # Check for Python
    try {
        $null = Get-Command python -ErrorAction Stop
    } catch {
        try {
            $null = Get-Command python3 -ErrorAction Stop
        } catch {
            $missingTools += "python"
        }
    }
    
    if ($missingTools.Count -gt 0) {
        Write-Host "❌ Missing required tools: $($missingTools -join ', ')" -ForegroundColor Red
        Write-Host ""
        Write-Host "📦 Installation options:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Option 1 - wkhtmltopdf (Recommended):" -ForegroundColor Green
        Write-Host "  Download from: https://wkhtmltopdf.org/downloads.html" -ForegroundColor White
        Write-Host "  Or use Chocolatey: choco install wkhtmltopdf" -ForegroundColor White
        Write-Host ""
        Write-Host "Option 2 - Python with reportlab:" -ForegroundColor Green
        Write-Host "  pip install reportlab beautifulsoup4" -ForegroundColor White
        Write-Host ""
        return $false
    }
    
    return $true
}

# Function to convert HTML to PDF using wkhtmltopdf
function Convert-WithWkhtmltopdf {
    param($HtmlFile, $PdfFile)
    
    Write-Host "🔄 Converting with wkhtmltopdf..." -ForegroundColor Yellow
    
    $arguments = @(
        "--page-size", "A4",
        "--margin-top", "20mm",
        "--margin-bottom", "20mm",
        "--margin-left", "15mm",
        "--margin-right", "15mm",
        "--encoding", "UTF-8",
        "--enable-local-file-access",
        "--print-media-type",
        "--disable-smart-shrinking",
        "--zoom", "0.8",
        $HtmlFile,
        $PdfFile
    )
    
    try {
        & wkhtmltopdf @arguments
        return $LASTEXITCODE -eq 0
    } catch {
        Write-Host "❌ wkhtmltopdf conversion failed: $_" -ForegroundColor Red
        return $false
    }
}

# Function to convert HTML to PDF using Python
function Convert-WithPython {
    param($HtmlFile, $PdfFile)
    
    Write-Host "🔄 Converting with Python..." -ForegroundColor Yellow
    
    $pythonScript = @"
import sys
import os
from pathlib import Path
from datetime import datetime
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.colors import HexColor
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.units import inch
from reportlab.lib import colors
import xml.etree.ElementTree as ET

def create_pdf_from_xml(xml_file, pdf_file):
    # Parse XML results
    tree = ET.parse(xml_file)
    root = tree.getroot()
    
    test_results = []
    total_tests = 0
    passed_tests = 0
    failed_tests = 0
    skipped_tests = 0
    
    # Find all test elements
    for test in root.findall('.//test'):
        test_name = test.get('name', 'Unknown')
        result = test.get('result', 'Unknown')
        time_taken = float(test.get('time', 0))
        
        # Extract class name from test name
        class_name = test_name.split('.')[-2] if '.' in test_name else 'Unknown'
        
        # Format test name for display
        display_name = test_name.split('.')[-1].replace('_', ' ')
        
        test_data = {
            'name': display_name,
            'full_name': test_name,
            'class': class_name,
            'result': result,
            'time': time_taken,
            'time_ms': int(time_taken * 1000)
        }
        
        test_results.append(test_data)
        total_tests += 1
        
        if result == 'Pass':
            passed_tests += 1
        elif result == 'Fail':
            failed_tests += 1
        else:
            skipped_tests += 1
    
    success_rate = (passed_tests / total_tests * 100) if total_tests > 0 else 0
    
    # Create PDF document
    doc = SimpleDocTemplate(pdf_file, pagesize=A4)
    story = []
    styles = getSampleStyleSheet()
    
    # Custom styles
    title_style = ParagraphStyle(
        'CustomTitle',
        parent=styles['Title'],
        fontSize=24,
        textColor=HexColor('#2c3e50'),
        spaceAfter=20
    )
    
    heading_style = ParagraphStyle(
        'CustomHeading',
        parent=styles['Heading2'],
        fontSize=16,
        textColor=HexColor('#34495e'),
        spaceAfter=12
    )
    
    # Title
    story.append(Paragraph("🧪 VaxCare API Test Report", title_style))
    story.append(Paragraph(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", styles['Normal']))
    story.append(Spacer(1, 20))
    
    # Test Statistics
    story.append(Paragraph("📊 Test Statistics", heading_style))
    
    # Create statistics table
    stats_data = [
        ['Metric', 'Count', 'Percentage'],
        ['Total Tests', str(total_tests), '100%'],
        ['Passed', str(passed_tests), f"{passed_tests/total_tests*100:.1f}%" if total_tests > 0 else '0%'],
        ['Failed', str(failed_tests), f"{failed_tests/total_tests*100:.1f}%" if total_tests > 0 else '0%'],
        ['Skipped', str(skipped_tests), f"{skipped_tests/total_tests*100:.1f}%" if total_tests > 0 else '0%'],
        ['Success Rate', f"{success_rate:.1f}%", '']
    ]
    
    stats_table = Table(stats_data)
    stats_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), HexColor('#3498db')),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 12),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('BACKGROUND', (0, 1), (-1, -1), HexColor('#ecf0f1')),
        ('GRID', (0, 0), (-1, -1), 1, colors.black)
    ]))
    
    story.append(stats_table)
    story.append(Spacer(1, 20))
    
    # Test Results
    story.append(Paragraph("🧪 Test Scenarios", heading_style))
    
    # Group tests by class
    test_classes = {}
    for test in test_results:
        class_name = test['class']
        if class_name not in test_classes:
            test_classes[class_name] = []
        test_classes[class_name].append(test)
    
    # Create test results for each class
    for class_name, tests in test_classes.items():
        story.append(Paragraph(f"📁 {class_name} Tests", styles['Heading3']))
        story.append(Spacer(1, 10))
        
        # Create test table for this class
        test_data = [['Test Name', 'Status', 'Time (ms)']]
        
        for test in tests:
            status_icon = "✅" if test['result'] == 'Pass' else "❌" if test['result'] == 'Fail' else "⏭️"
            test_data.append([
                test['name'],
                f"{status_icon} {test['result']}",
                str(test['time_ms'])
            ])
        
        test_table = Table(test_data)
        test_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), HexColor('#95a5a6')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
            ('BACKGROUND', (0, 1), (-1, -1), HexColor('#f8f9fa')),
            ('GRID', (0, 0), (-1, -1), 1, colors.black),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [HexColor('#ffffff'), HexColor('#f8f9fa')])
        ]))
        
        story.append(test_table)
        story.append(Spacer(1, 15))
    
    # Summary
    story.append(Paragraph("📋 Summary", heading_style))
    
    if failed_tests == 0:
        summary_text = f"✅ All {total_tests} tests passed successfully! The VaxCare API test suite is functioning correctly."
    else:
        summary_text = f"⚠️ {failed_tests} out of {total_tests} tests failed. Please review the failed tests."
    
    story.append(Paragraph(summary_text, styles['Normal']))
    story.append(Spacer(1, 20))
    
    # Footer
    story.append(Paragraph("Report generated by VaxCare API Test Suite", styles['Normal']))
    story.append(Paragraph(f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", styles['Normal']))
    
    # Build PDF
    try:
        doc.build(story)
        return True
    except Exception as e:
        print(f"❌ Error building PDF: {e}")
        return False

if __name__ == "__main__":
    xml_file = "$OutputDir\TestResults.xml"
    pdf_file = "$PdfFile"
    
    if create_pdf_from_xml(xml_file, pdf_file):
        print("✅ PDF generated successfully")
        sys.exit(0)
    else:
        print("❌ Failed to generate PDF")
        sys.exit(1)
"@
    
    $tempScript = [System.IO.Path]::GetTempFileName() + ".py"
    Set-Content -Path $tempScript -Value $pythonScript -Encoding UTF8
    
    try {
        $env:OutputDir = $OutputDir
        $env:PdfFile = $PdfFile
        & python $tempScript
        $result = $LASTEXITCODE -eq 0
    } catch {
        Write-Host "❌ Python conversion failed: $_" -ForegroundColor Red
        $result = $false
    } finally {
        Remove-Item $tempScript -ErrorAction SilentlyContinue
    }
    
    return $result
}

# Function to find the latest HTML report
function Get-LatestHtmlReport {
    $htmlFiles = Get-ChildItem -Path $OutputDir -Name "EnhancedTestReport_*.html" | Sort-Object -Descending
    if ($htmlFiles.Count -gt 0) {
        return "$OutputDir\$($htmlFiles[0])"
    }
    return $null
}

# Function to convert HTML to PDF
function Convert-HtmlToPdf {
    param($HtmlFile, $PdfFile)
    
    if (!(Test-Path $HtmlFile)) {
        Write-Host "❌ HTML file not found: $HtmlFile" -ForegroundColor Red
        return $false
    }
    
    Write-Host "📄 Converting HTML to PDF..." -ForegroundColor Yellow
    Write-Host "   Input:  $HtmlFile" -ForegroundColor White
    Write-Host "   Output: $PdfFile" -ForegroundColor White
    
    # Try different conversion methods
    $success = $false
    
    # Try wkhtmltopdf first
    try {
        if (Get-Command wkhtmltopdf -ErrorAction SilentlyContinue) {
            $success = Convert-WithWkhtmltopdf $HtmlFile $PdfFile
        }
    } catch {
        Write-Host "⚠️  wkhtmltopdf not available, trying Python..." -ForegroundColor Yellow
    }
    
    # Try Python if wkhtmltopdf failed
    if (!$success) {
        try {
            if (Get-Command python -ErrorAction SilentlyContinue) {
                $success = Convert-WithPython $HtmlFile $PdfFile
            }
        } catch {
            Write-Host "⚠️  Python not available" -ForegroundColor Yellow
        }
    }
    
    if ($success -and (Test-Path $PdfFile)) {
        $size = (Get-Item $PdfFile).Length / 1KB
        Write-Host "✅ PDF generated successfully: $PdfFile" -ForegroundColor Green
        Write-Host "📊 Size: $([math]::Round($size, 1)) KB" -ForegroundColor Cyan
        return $true
    } else {
        Write-Host "❌ Failed to generate PDF" -ForegroundColor Red
        return $false
    }
}

# Main script logic
if (!(Test-PdfDependencies)) {
    exit 1
}

# Create output directory if it doesn't exist
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

if ($All) {
    # Convert all HTML files
    $htmlFiles = Get-ChildItem -Path $OutputDir -Name "*.html"
    
    if ($htmlFiles.Count -eq 0) {
        Write-Host "❌ No HTML files found in $OutputDir" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "📄 Found $($htmlFiles.Count) HTML files to convert" -ForegroundColor Cyan
    
    $successCount = 0
    foreach ($htmlFile in $htmlFiles) {
        $basename = [System.IO.Path]::GetFileNameWithoutExtension($htmlFile)
        $pdfFile = "$OutputDir\${basename}_${timestamp}.pdf"
        
        Write-Host ""
        Write-Host "🔄 Converting: $htmlFile" -ForegroundColor Yellow
        if (Convert-HtmlToPdf "$OutputDir\$htmlFile" $pdfFile) {
            $successCount++
        }
    }
    
    Write-Host ""
    Write-Host "📊 Conversion Summary:" -ForegroundColor Cyan
    Write-Host "   Total files: $($htmlFiles.Count)" -ForegroundColor White
    Write-Host "   Successful: $successCount" -ForegroundColor Green
    Write-Host "   Failed: $($htmlFiles.Count - $successCount)" -ForegroundColor Red
    
} elseif ($Latest) {
    # Convert latest HTML file
    $htmlFile = Get-LatestHtmlReport
    if (!$htmlFile) {
        Write-Host "❌ No HTML reports found in $OutputDir" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "📄 Using latest HTML report: $htmlFile" -ForegroundColor Cyan
    $pdfFile = "$OutputDir\TestReport_${timestamp}.pdf"
    $success = Convert-HtmlToPdf $htmlFile $pdfFile
    
} elseif ($HtmlFile) {
    # Convert specified HTML file
    $pdfFile = "$OutputDir\TestReport_${timestamp}.pdf"
    $success = Convert-HtmlToPdf $HtmlFile $pdfFile
    
} else {
    # Try to find the latest HTML file
    $htmlFile = Get-LatestHtmlReport
    if (!$htmlFile) {
        Write-Host "❌ No HTML file specified and no reports found in $OutputDir" -ForegroundColor Red
        Write-Host "💡 Use -Help for usage information" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "📄 Using latest HTML report: $htmlFile" -ForegroundColor Cyan
    $pdfFile = "$OutputDir\TestReport_${timestamp}.pdf"
    $success = Convert-HtmlToPdf $htmlFile $pdfFile
}

if ($success) {
    Write-Host ""
    Write-Host "🎉 PDF Report Generation Completed!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ PDF Report Generation Failed!" -ForegroundColor Red
    exit 1
}
