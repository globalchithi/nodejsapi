# Complete Test Workflow Guide

This guide explains how to run the complete test workflow: Tests → HTML → PDF → Teams.

## 🚀 Quick Start

### One Command - Everything
```bash
python3 run-all-tests-complete.py
```

### With Environment
```bash
python3 run-all-tests-complete.py --environment "Production"
```

### With OneDrive Instructions
```bash
python3 run-all-tests-complete.py --onedrive
```

## 📋 What the Complete Workflow Does

### 1. 🧪 **Run .NET Tests**
- Executes all test projects
- Generates TRX and HTML test results
- Saves results to `TestReports/` directory

### 2. 📊 **Generate Enhanced HTML Report**
- Creates comprehensive HTML test report
- Includes test statistics, results, and details
- Saves to `TestReports/` directory

### 3. 📄 **Convert HTML to PDF**
- Converts HTML report to PDF format
- Creates timestamped PDF file
- Saves to `TestReports/` directory

### 4. 📤 **Send to Microsoft Teams**
- Sends test results with PDF information
- Includes file location and share instructions
- Notifies team of test completion

## 🔧 Available Scripts

### 1. `run-all-tests-complete.py` - One Command (Recommended)
- **Purpose**: Single command to run everything
- **Usage**: `python3 run-all-tests-complete.py [--environment ENV] [--onedrive]`
- **Features**: Simple, one-command execution

### 2. `run-complete-test-workflow.py` - Detailed Workflow
- **Purpose**: Detailed step-by-step execution
- **Usage**: `python3 run-complete-test-workflow.py [--environment ENV] [--onedrive]`
- **Features**: Detailed logging, step-by-step execution

## 🚀 Usage Examples

### Example 1: Basic Workflow
```bash
# Run everything with default settings
python3 run-all-tests-complete.py
```

### Example 2: With Environment
```bash
# Run with specific environment
python3 run-all-tests-complete.py --environment "Production"
```

### Example 3: With OneDrive Instructions
```bash
# Run with OneDrive upload instructions
python3 run-all-tests-complete.py --onedrive
```

### Example 4: Detailed Workflow
```bash
# Run detailed workflow with logging
python3 run-complete-test-workflow.py --environment "Staging"
```

## 📊 Output Files Generated

### Test Results
```
TestReports/
├── TestResults_2025-10-23_10-33-56.trx
├── TestResults_2025-10-23_10-33-56.html
└── TestResults_2025-10-23_10-33-56.pdf
```

### Enhanced HTML Report
```
TestReports/
├── EnhancedTestReport_2025-10-23_10-33-56.html
└── EnhancedTestReport_2025-10-23_10-33-56_20251023_104512.pdf
```

## 📤 Teams Messages

### Standard Teams Message
```
🚀 Test Automation Results with PDF Report

📄 PDF Report: EnhancedTestReport_2025-10-23_10-33-56.pdf (1.2 MB)
📁 File Location: /path/to/TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf
🔗 Share Link: file:///path/to/TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf

Instructions for accessing the PDF:
1. Direct Access: Copy the file path above and open in file explorer
2. Share Link: Use the share link to access the file
3. Manual Sharing: Upload to OneDrive/SharePoint for team sharing

File Details:
- Name: EnhancedTestReport_2025-10-23_10-33-56.pdf
- Size: 1.2 MB
- Location: TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf
- Environment: Staging
- Generated: 10/23/2025, 10:33:56 AM

💡 Tip: For easier sharing, upload this PDF to OneDrive or SharePoint and share the link with your team.
```

### OneDrive Teams Message
```
🚀 Test Automation Results - PDF Upload Required

📄 PDF Report: EnhancedTestReport_2025-10-23_10-33-56.pdf (1.2 MB)
📁 File Location: /path/to/TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf
🌍 Environment: Staging
⏰ Generated: 10/23/2025, 10:33:56 AM

📋 Upload Instructions:
1. Open OneDrive: Go to https://onedrive.live.com
2. Sign In: Use your Microsoft account
3. Upload File: Click 'Upload' button and select the PDF file
4. Create Share Link: Right-click the uploaded file and select 'Share'
5. Copy Link: Copy the share link and share it in this channel

🔗 Alternative Methods:
- OneDrive App: Use the OneDrive desktop app
- Drag & Drop: Drag the PDF file to OneDrive web interface
- Email: Attach PDF to email and save to OneDrive

💡 Note: Once uploaded, the PDF will be accessible to your team through the share link.
```

## 🔍 Troubleshooting

### Common Issues

#### 1. "Tests failed"
- **Solution**: Check test code and dependencies
- **Continue**: Workflow continues with report generation

#### 2. "HTML report generation failed"
- **Solution**: Check XML test results exist
- **Continue**: Workflow tries to find existing HTML files

#### 3. "PDF conversion failed"
- **Solution**: Install PDF dependencies
- **Check**: Ensure HTML files exist

#### 4. "Teams notification failed"
- **Solution**: Check Teams webhook URL
- **Alternative**: Check file location and permissions

### Error Messages

#### "No PDF files found"
- **Solution**: Ensure PDF conversion completed successfully
- **Check**: Look in TestReports directory for PDF files

#### "Teams webhook failed"
- **Solution**: Check webhook URL and network connection
- **Test**: Use `python3 send-teams-notification-with-pdf.py --test`

#### "Dependencies not installed"
- **Solution**: Install required packages
- **Check**: Run `pip install weasyprint pdfkit playwright`

## 🎯 Best Practices

### 1. Use One Command (Recommended)
```bash
# Simple and reliable
python3 run-all-tests-complete.py
```

### 2. Specify Environment
```bash
# For better tracking
python3 run-all-tests-complete.py --environment "Production"
```

### 3. Use OneDrive for Team Sharing
```bash
# For easier team access
python3 run-all-tests-complete.py --onedrive
```

### 4. Test the Workflow
```bash
# Test before automation
python3 run-complete-test-workflow.py --environment "Staging"
```

## 📋 Integration Examples

### Add to CI/CD Pipeline
```bash
# Add to your CI/CD pipeline
python3 run-all-tests-complete.py --environment "CI"
```

### Add to Scheduled Jobs
```bash
# Add to cron job
0 9 * * * cd /path/to/project && python3 run-all-tests-complete.py --environment "Daily"
```

### Add to Build Script
```bash
#!/bin/bash
# Build script
python3 run-all-tests-complete.py --environment "Build"
```

## 🚀 Advanced Usage

### Custom Environment
```bash
# Use custom environment
python3 run-all-tests-complete.py --environment "Staging"
```

### OneDrive Integration
```bash
# Use OneDrive upload instructions
python3 run-all-tests-complete.py --onedrive --environment "Production"
```

### Detailed Logging
```bash
# Use detailed workflow for debugging
python3 run-complete-test-workflow.py --environment "Staging"
```

## 📁 File Structure After Workflow

```
TestReports/
├── TestResults_2025-10-23_10-33-56.trx
├── TestResults_2025-10-23_10-33-56.html
├── TestResults_2025-10-23_10-33-56_20251023_104512.pdf
├── EnhancedTestReport_2025-10-23_10-33-56.html
└── EnhancedTestReport_2025-10-23_10-33-56_20251023_104512.pdf
```

## 🎉 Success!

Your complete test workflow now:

- 🧪 **Runs all tests** automatically
- 📊 **Generates HTML reports** with detailed results
- 📄 **Creates PDF files** for easy sharing
- 📤 **Sends to Teams** with file information and instructions
- 🔗 **Provides share links** for team access
- 💡 **Includes instructions** for file sharing

## 💡 Tips

1. **Use One Command**: `python3 run-all-tests-complete.py`
2. **Specify Environment**: Always use `--environment` for tracking
3. **Use OneDrive**: Use `--onedrive` for easier team sharing
4. **Test First**: Test the workflow before automation
5. **Check Teams**: Verify Teams notifications are working
