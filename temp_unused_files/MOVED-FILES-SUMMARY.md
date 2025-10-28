# Files Moved to temp_unused_files

## 📁 **Files Moved Here**

This folder contains all the deprecated, unused, or redundant files that were cluttering the root directory.

### **Deprecated Report Generators (9 files)**
- `generate-enhanced-html-report.py` - Old version
- `generate-enhanced-html-report-windows.py` - Old Windows version
- `generate-enhanced-html-report-simple.ps1` - PowerShell version
- `generate-enhanced-html-report.ps1` - PowerShell version
- `generate-enhanced-html-report.sh` - Shell version
- `generate-enhanced-report-clean.ps1` - Clean version
- `generate-enhanced-report-minimal.ps1` - Minimal version
- `generate-enhanced-report.ps1` - Main PowerShell version
- `generate-enhanced-report.sh` - Main shell version

### **Deprecated Test Runners (8 files)**
- `run-all-tests-complete.py` - Complete version
- `run-complete-test-workflow.py` - Workflow version
- `run-tests-with-pdf.py` - PDF version
- `run-tests-with-pdf-teams.py` - PDF + Teams version
- `run-tests-with-reporting.bat` - Batch version
- `run-tests-with-reporting.ps1` - PowerShell version
- `run-tests-with-reporting.sh` - Shell version
- `run-tests.sh` - Shell version
- `run-tests-windows.bat` - Windows batch version

### **Deprecated Teams Integration (8 files)**
- `send-teams-notification-robust.py` - Robust version
- `send-teams-notification-simple.bat` - Simple batch version
- `send-teams-notification-ssl-fix.py` - SSL fix version
- `send-teams-notification-with-attachment.py` - Attachment version
- `send-teams-notification-with-download-link.py` - Download link version
- `send-teams-notification-with-pdf.py` - PDF version
- `send-teams-notification.ps1` - PowerShell version
- `send-teams-simple.ps1` - Simple PowerShell version

### **PDF Generation Scripts (6 files)**
- `convert-html-to-pdf.py` - HTML to PDF converter
- `generate-pdf-from-html.py` - PDF generator
- `send-pdf-to-teams.py` - PDF sender
- `send-pdf-with-share-link.py` - PDF with share link
- `upload-pdf-to-onedrive.py` - OneDrive uploader
- `upload-pdf-to-onedrive-simple.py` - Simple OneDrive uploader

### **Test and Diagnostic Scripts (12 files)**
- `demo-actual-results.py` - Demo script
- `diagnose-issues.py` - Issue diagnostic
- `diagnose-teams-issue.py` - Teams diagnostic
- `test-auto-open.py` - Auto-open test
- `test-encoding.ps1` - Encoding test
- `test-env-minimal.bat` - Minimal environment test
- `test-env.bat` - Environment test
- `test-parse-results.bat` - Parse results test
- `test-parse-results.sh` - Parse results test (shell)
- `test-skipped-exclusion.py` - Skipped exclusion test
- `test-syntax.ps1` - Syntax test
- `test-teams-integration.sh` - Teams integration test
- `test-teams-webhook.bat` - Teams webhook test
- `test-windows-compatibility.py` - Windows compatibility test
- `test-xml-parsing.ps1` - XML parsing test

### **Verification Scripts (8 files)**
- `verify-comprehensive-cleaning.py` - Comprehensive cleaning verification
- `verify-endpoints-clean.py` - Endpoints cleaning verification
- `verify-expected-results-comprehensive.py` - Expected results verification
- `verify-expected-results-improvement.py` - Expected results improvement verification
- `verify-skipped-removal.py` - Skipped removal verification
- `verify-test-reports-cleaning.py` - Test reports cleaning verification
- `verify-test-results-removal.py` - Test results removal verification
- `verify-test-type-removal.py` - Test type removal verification

### **Legacy Report Generators (7 files)**
- `generate-latest-html-report.py` - Latest HTML report generator
- `generate-test-report.ps1` - PowerShell test report generator
- `generate-test-report.sh` - Shell test report generator
- `parse-and-send-results.bat` - Parse and send results batch
- `parse-test-results.ps1` - PowerShell parse results
- `parse-test-results.sh` - Shell parse results
- `repair-xml.py` - XML repair script

### **Environment Setup Scripts (6 files)**
- `load-env-batch.bat` - Batch environment loader
- `load-env-simple.bat` - Simple batch environment loader
- `load-env-simple.ps1` - Simple PowerShell environment loader
- `load-env.ps1` - PowerShell environment loader
- `setup-environment.bat` - Environment setup batch
- `setup-teams-webhook.py` - Teams webhook setup

### **Example and Demo Scripts (5 files)**
- `example-run-tests.sh` - Example test runner
- `example-teams-integration.sh` - Example Teams integration
- `generate-enhanced-html-report-backup.sh` - Backup script
- `send-teams-curl.bat` - Teams curl batch
- `teams-notification-example.bat` - Teams notification example

## 🗑️ **Why These Files Were Moved**

### **Redundancy**
- Multiple versions of the same functionality
- Old implementations replaced by newer ones
- Duplicate scripts with slight variations

### **Deprecation**
- Scripts replaced by better implementations
- Legacy PowerShell scripts replaced by Python
- Old report generators replaced by enhanced versions

### **Testing/Debugging**
- Scripts used for testing specific features
- Diagnostic scripts for troubleshooting
- Verification scripts for validation

### **Experimental Features**
- PDF generation experiments
- OneDrive integration attempts
- Advanced Teams notification features

## 📋 **Current Active Files**

The following files are now the active, maintained versions:

### **Test Running**
- `TestRunner/run-all-tests.py` - Main test runner
- `TestRunner/generate-enhanced-html-report-with-actual-results.py` - Primary HTML generator
- `TestRunner/send-teams-notification.py` - Teams integration
- `TestRunner/open-html-report.py` - Report opener

### **Root Wrappers**
- `run-all-tests.py` - Wrapper for main test runner
- `open-html-report.py` - Wrapper for report opener

### **C# Project**
- `VaxCareApiTests.csproj` - Project file
- `Program.cs` - Main entry point
- `Models/` - Data models
- `Services/` - Service classes
- `Tests/` - Test files

## 🎯 **Benefits of This Organization**

1. **Clean Root Directory** - Only essential files visible
2. **Clear Separation** - Active vs deprecated files
3. **Easy Maintenance** - Related files grouped together
4. **Reduced Confusion** - No duplicate or conflicting scripts
5. **Better Structure** - Logical organization of functionality

## ⚠️ **Important Notes**

- **DO NOT DELETE** these files immediately - they may contain useful code snippets
- **Review before deletion** - Some files may have unique functionality
- **Archive if needed** - Consider archiving instead of deleting
- **Document dependencies** - Some files may be referenced elsewhere

This organization provides a clean, maintainable project structure! 🎉
