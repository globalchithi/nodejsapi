# PDF Generation Guide

This guide explains how to generate PDF files from HTML test reports using Python.

## 🚀 Quick Start

### 1. Convert Latest HTML to PDF
```bash
python3 convert-html-to-pdf.py
```

### 2. Convert Specific HTML File
```bash
python3 convert-html-to-pdf.py TestReports/EnhancedTestReport_2025-10-23_10-33-56.html
```

### 3. Convert with Custom Output Name
```bash
python3 convert-html-to-pdf.py TestReports/EnhancedTestReport_2025-10-23_10-33-56.html MyTestReport.pdf
```

## 📦 Installation

### Install PDF Dependencies
```bash
pip install -r requirements-pdf.txt
```

### Or Install Manually
```bash
pip install weasyprint pdfkit playwright
playwright install chromium
```

## 🔧 Advanced Usage

### 1. Run Tests and Generate PDF
```bash
python3 run-tests-with-pdf.py
```

### 2. Use Different PDF Generation Methods
```bash
# Using weasyprint (recommended)
python3 generate-pdf-from-html.py --html TestReports/report.html --method weasyprint

# Using pdfkit (requires wkhtmltopdf)
python3 generate-pdf-from-html.py --html TestReports/report.html --method pdfkit

# Using playwright
python3 generate-pdf-from-html.py --html TestReports/report.html --method playwright

# Auto-detect best method
python3 generate-pdf-from-html.py --html TestReports/report.html --method auto
```

### 3. Find and Convert Latest HTML
```bash
python3 generate-pdf-from-html.py --latest
```

## 📊 Available Scripts

### 1. `convert-html-to-pdf.py` - Simple Converter
- **Purpose**: Quick HTML to PDF conversion
- **Usage**: `python3 convert-html-to-pdf.py [html_file] [output_pdf]`
- **Features**: Auto-finds latest HTML, installs dependencies automatically

### 2. `generate-pdf-from-html.py` - Advanced Converter
- **Purpose**: Full-featured HTML to PDF conversion
- **Usage**: `python3 generate-pdf-from-html.py --html file.html --output file.pdf --method weasyprint`
- **Features**: Multiple conversion methods, error handling, auto-fallback

### 3. `run-tests-with-pdf.py` - Complete Workflow
- **Purpose**: Run tests and generate PDF reports
- **Usage**: `python3 run-tests-with-pdf.py`
- **Features**: Installs dependencies, runs tests, generates HTML, converts to PDF

## 🛠️ PDF Generation Methods

### 1. WeasyPrint (Recommended)
- **Pros**: Pure Python, no external dependencies, good CSS support
- **Cons**: Slower for large documents
- **Install**: `pip install weasyprint`

### 2. PDFKit (Requires wkhtmltopdf)
- **Pros**: Fast, good HTML/CSS support
- **Cons**: Requires external binary (wkhtmltopdf)
- **Install**: `pip install pdfkit` + install wkhtmltopdf

### 3. Playwright
- **Pros**: Excellent rendering, handles complex layouts
- **Cons**: Larger installation size
- **Install**: `pip install playwright && playwright install chromium`

## 📁 Output Files

Generated PDF files are saved in the `TestReports/` directory with timestamps:
- `EnhancedTestReport_20251023_103356_20251023_104512.pdf`
- `TestResults_20251023_103356_20251023_104512.pdf`

## 🔍 Troubleshooting

### Common Issues

#### 1. "weasyprint not installed"
```bash
pip install weasyprint
```

#### 2. "pdfkit not found"
```bash
pip install pdfkit
# Also install wkhtmltopdf binary
```

#### 3. "playwright not found"
```bash
pip install playwright
playwright install chromium
```

#### 4. "No HTML files found"
- Run tests first: `dotnet test --logger html`
- Generate HTML report: `python3 generate-enhanced-html-report-robust.py`

### Error Messages

#### "Failed to install weasyprint"
- Check Python version (requires 3.7+)
- Try: `pip install --upgrade pip`
- Try: `pip install weasyprint --no-cache-dir`

#### "PDF generation failed"
- Check HTML file exists and is valid
- Try different conversion method
- Check file permissions

## 🎯 Best Practices

### 1. Use Latest HTML Files
```bash
# Always use the latest HTML file
python3 convert-html-to-pdf.py
```

### 2. Specify Output Names
```bash
# Use descriptive names
python3 convert-html-to-pdf.py report.html "TestResults_$(date +%Y%m%d).pdf"
```

### 3. Test Different Methods
```bash
# Try multiple methods for best results
python3 generate-pdf-from-html.py --html report.html --method auto
```

### 4. Include in CI/CD
```bash
# Add to your test pipeline
python3 run-tests-with-pdf.py
```

## 📋 Examples

### Example 1: Basic Conversion
```bash
# Find latest HTML and convert to PDF
python3 convert-html-to-pdf.py
```

### Example 2: Specific File
```bash
# Convert specific HTML file
python3 convert-html-to-pdf.py TestReports/EnhancedTestReport_2025-10-23_10-33-56.html
```

### Example 3: Custom Output
```bash
# Convert with custom PDF name
python3 convert-html-to-pdf.py TestReports/report.html "MyTestReport.pdf"
```

### Example 4: Complete Workflow
```bash
# Run tests and generate PDF
python3 run-tests-with-pdf.py
```

### Example 5: Advanced Options
```bash
# Use specific conversion method
python3 generate-pdf-from-html.py --html TestReports/report.html --output "TestReport.pdf" --method weasyprint
```

## 🚀 Integration with Existing Workflow

### Add to run-all-tests.py
```python
# Add PDF generation after HTML report generation
if html_success:
    safe_print("📄 Generating PDF from HTML...")
    pdf_success, _, _ = run_command(
        "python3 convert-html-to-pdf.py",
        "Generating PDF from HTML"
    )
```

### Add to Teams Notification
```python
# Include PDF in Teams notification
if pdf_success:
    safe_print("📎 PDF report generated and ready for download")
```

## 📊 File Structure

```
TestReports/
├── EnhancedTestReport_2025-10-23_10-33-56.html
├── EnhancedTestReport_2025-10-23_10-33-56_20251023_104512.pdf
├── TestResults_2025-10-23_10-33-56.html
└── TestResults_2025-10-23_10-33-56_20251023_104512.pdf
```

## 🎉 Success!

Your HTML test reports are now converted to professional PDF files that can be:
- 📧 Emailed to stakeholders
- 📁 Archived for compliance
- 🖨️ Printed for offline review
- 📊 Shared with management
- 🔗 Attached to Teams notifications
