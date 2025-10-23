# Teams PDF Integration Guide

This guide explains how to send PDF test reports to Microsoft Teams.

## 🚀 Quick Start

### 1. Send Latest PDF to Teams
```bash
python3 send-pdf-to-teams.py
```

### 2. Send Specific PDF to Teams
```bash
python3 send-pdf-to-teams.py --pdf TestReports/MyTestReport.pdf
```

### 3. Complete Workflow (Tests → HTML → PDF → Teams)
```bash
python3 run-tests-with-pdf-teams.py
```

## 📦 Available Scripts

### 1. `send-pdf-to-teams.py` - Simple PDF Sender
- **Purpose**: Send existing PDF files to Teams
- **Usage**: `python3 send-pdf-to-teams.py [--pdf file.pdf] [--environment ENV]`
- **Features**: Auto-finds latest PDF, includes file info in Teams message

### 2. `send-teams-notification-with-pdf.py` - Advanced PDF Sender
- **Purpose**: Send test results with PDF attachment info
- **Usage**: `python3 send-teams-notification-with-pdf.py --pdf file.pdf --environment ENV`
- **Features**: Includes test statistics, PDF file info, comprehensive Teams message

### 3. `run-tests-with-pdf-teams.py` - Complete Workflow
- **Purpose**: Run tests, generate HTML, convert to PDF, send to Teams
- **Usage**: `python3 run-tests-with-pdf-teams.py [--environment ENV]`
- **Features**: Full automation pipeline

## 🔧 Usage Examples

### Example 1: Send Latest PDF
```bash
# Find and send the latest PDF file
python3 send-pdf-to-teams.py
```

### Example 2: Send Specific PDF
```bash
# Send a specific PDF file
python3 send-pdf-to-teams.py --pdf TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf
```

### Example 3: Send with Environment
```bash
# Send PDF with specific environment
python3 send-pdf-to-teams.py --pdf report.pdf --environment "Production"
```

### Example 4: Complete Workflow
```bash
# Run everything: tests → HTML → PDF → Teams
python3 run-tests-with-pdf-teams.py --environment "Staging"
```

### Example 5: Advanced PDF Sender
```bash
# Send with test statistics
python3 send-teams-notification-with-pdf.py --pdf report.pdf --xml TestResults.xml --environment "Development"
```

## 📊 Teams Message Format

### Basic PDF Message
```
🚀 Test Automation Results with PDF Report

✅ All 15 tests passed successfully!

Environment: Development
Total Tests: 15
Passed: 15
Failed: 0
Success Rate: 100%
Duration: 2.3s
PDF Report: EnhancedTestReport_20251023_103356.pdf (1.2 MB)
Timestamp: 10/23/2025, 10:33:56 AM

📎 PDF Report Attached: EnhancedTestReport_20251023_103356.pdf
```

### Advanced PDF Message
```
🚀 Test Automation Results with PDF Report

⚠️ 12 passed, 3 failed

Environment: Production
Total Tests: 15
Passed: 12
Failed: 3
Success Rate: 80%
Duration: 5.7s
PDF Report: TestResults_20251023_103356.pdf (2.1 MB)
Timestamp: 10/23/2025, 10:33:56 AM

📎 PDF Report Attached: TestResults_20251023_103356.pdf
```

## 🔍 Troubleshooting

### Common Issues

#### 1. "No PDF files found"
```bash
# Generate a PDF first
python3 convert-html-to-pdf.py
```

#### 2. "PDF file not found"
```bash
# Check if file exists
ls -la TestReports/*.pdf
```

#### 3. "Teams notification failed"
```bash
# Test Teams connection
python3 send-teams-notification-with-pdf.py --test
```

#### 4. "Failed to encode PDF file"
```bash
# Check file permissions
chmod 644 TestReports/*.pdf
```

### Error Messages

#### "No PDF files found in TestReports directory"
- **Solution**: Generate a PDF first using `python3 convert-html-to-pdf.py`
- **Check**: Ensure TestReports directory exists and contains PDF files

#### "PDF file not found"
- **Solution**: Verify the file path is correct
- **Check**: Use `ls -la TestReports/` to list files

#### "Teams notification failed"
- **Solution**: Check webhook URL and network connection
- **Test**: Use `python3 send-teams-notification-with-pdf.py --test`

## 🎯 Best Practices

### 1. Use Latest PDF Files
```bash
# Always use the latest PDF file
python3 send-pdf-to-teams.py
```

### 2. Include Environment Information
```bash
# Specify environment for better tracking
python3 send-pdf-to-teams.py --environment "Production"
```

### 3. Test Teams Connection
```bash
# Test before sending actual PDFs
python3 send-teams-notification-with-pdf.py --test
```

### 4. Use Complete Workflow
```bash
# For automated pipelines
python3 run-tests-with-pdf-teams.py --environment "CI"
```

## 📁 File Structure

```
TestReports/
├── EnhancedTestReport_2025-10-23_10-33-56.html
├── EnhancedTestReport_2025-10-23_10-33-56_20251023_104512.pdf
├── TestResults_2025-10-23_10-33-56.html
└── TestResults_2025-10-23_10-33-56_20251023_104512.pdf
```

## 🔗 Integration with Existing Workflow

### Add to run-all-tests.py
```python
# Add PDF generation and Teams notification
if html_success:
    safe_print("📄 Generating PDF from HTML...")
    pdf_success, _, _ = run_command(
        "python3 convert-html-to-pdf.py",
        "Generating PDF from HTML"
    )
    
    if pdf_success:
        safe_print("📤 Sending PDF to Teams...")
        teams_success, _, _ = run_command(
            "python3 send-pdf-to-teams.py",
            "Sending PDF to Teams"
        )
```

### Add to CI/CD Pipeline
```bash
# Add to your CI/CD pipeline
python3 run-tests-with-pdf-teams.py --environment "CI"
```

## 📊 Teams Message Features

### ✅ What's Included
- **Test Statistics**: Total, passed, failed, success rate
- **Environment**: Development, Staging, Production, etc.
- **Duration**: Total test execution time
- **PDF Info**: File name and size
- **Timestamp**: When tests were run
- **Status**: Pass/fail summary

### 📎 PDF File Information
- **File Name**: Original PDF filename
- **File Size**: Size in MB
- **File Path**: Location in TestReports directory
- **Generation Time**: When PDF was created

## 🚀 Advanced Usage

### Custom Webhook URL
```bash
python3 send-pdf-to-teams.py --pdf report.pdf --webhook "https://your-webhook-url"
```

### Multiple PDFs
```bash
# Send multiple PDFs
for pdf in TestReports/*.pdf; do
    python3 send-pdf-to-teams.py --pdf "$pdf"
done
```

### Scheduled Sending
```bash
# Add to cron job
0 9 * * * cd /path/to/project && python3 run-tests-with-pdf-teams.py
```

## 🎉 Success!

Your PDF test reports are now automatically sent to Microsoft Teams with:
- 📊 **Test Statistics** - Complete test results
- 📄 **PDF Information** - File details and size
- 🌍 **Environment** - Where tests were run
- ⏰ **Timestamp** - When tests were executed
- 📎 **File Details** - PDF file information for sharing

## 💡 Tips

1. **Use Latest PDFs**: Always use the latest generated PDF files
2. **Include Environment**: Specify environment for better tracking
3. **Test Connection**: Test Teams webhook before sending actual PDFs
4. **Monitor File Sizes**: Large PDFs may need to be shared via OneDrive/SharePoint
5. **Use Complete Workflow**: For automated pipelines, use the complete workflow script

