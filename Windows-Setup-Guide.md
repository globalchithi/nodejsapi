# 🪟 Windows Setup Guide - VaxCare API Test Suite

## Overview
This guide helps you set up and run the VaxCare API Test Suite on Windows with proper encoding handling.

## 🚀 Quick Start

### Option 1: Simple Batch File (Recommended)
```cmd
# Just double-click or run:
run-tests-windows.bat
```

### Option 2: Python Scripts
```cmd
# Run all tests with enhanced reporting
python run-all-tests.py

# Generate HTML report only
python generate-enhanced-html-report-windows.py
```

## 📋 Prerequisites

### 1. Python 3.6+ Installation
- **Download:** [Python.org](https://www.python.org/downloads/)
- **Install:** Make sure to check "Add Python to PATH" during installation
- **Verify:** Open Command Prompt and run `python --version`

### 2. .NET SDK Installation
- **Download:** [.NET SDK](https://dotnet.microsoft.com/download)
- **Install:** Download and install the latest .NET 8.0 SDK
- **Verify:** Open Command Prompt and run `dotnet --version`

### 3. Git (Optional)
- **Download:** [Git for Windows](https://git-scm.com/download/win)
- **Install:** Use default settings

## 🔧 Setup Steps

### Step 1: Clone/Download the Project
```cmd
# If using Git:
git clone <repository-url>
cd nodejsapi

# Or download and extract the ZIP file
```

### Step 2: Verify Prerequisites
```cmd
# Check Python
python --version
# Should show: Python 3.x.x

# Check .NET
dotnet --version
# Should show: 8.x.x

# Check if project files exist
dir *.csproj
# Should show: VaxCareApiTests.csproj
```

### Step 3: Restore Dependencies
```cmd
# Restore NuGet packages
dotnet restore
```

### Step 4: Run Tests
```cmd
# Option 1: Use the batch file (easiest)
run-tests-windows.bat

# Option 2: Use Python scripts
python run-all-tests.py

# Option 3: Use .NET directly
dotnet test --logger "trx;LogFileName=TestResults.trx" --logger "xunit;LogFileName=TestResults.xml"
```

## 🎯 Available Commands

### Test Execution
```cmd
# Run all tests
python run-all-tests.py

# Run tests by category
python run-all-tests.py --category inventory
python run-all-tests.py --category patients
python run-all-tests.py --category setup
python run-all-tests.py --category insurance

# Run tests with custom filter
python run-all-tests.py --filter "FullyQualifiedName~InventoryApiTests"

# Clean and run tests
python run-all-tests.py --clean
```

### HTML Report Generation
```cmd
# Generate HTML report from existing XML
python generate-enhanced-html-report-windows.py

# Generate with custom XML file
python generate-enhanced-html-report-windows.py --xml "TestReports/TestResults.xml"

# Generate with custom output directory
python generate-enhanced-html-report-windows.py --output "MyReports"
```

## 📁 File Structure

```
nodejsapi/
├── run-tests-windows.bat              # Windows batch file (easiest)
├── run-all-tests.py                   # Main Python test runner
├── generate-enhanced-html-report-windows.py  # Windows-compatible HTML generator
├── generate-enhanced-html-report.py   # Full-featured HTML generator
├── TestReports/                       # Generated reports directory
│   ├── EnhancedTestReport_*.html      # Beautiful HTML reports
│   ├── TestResults.xml                # XML test results
│   └── TestResults_*.trx              # TRX test results
└── WINDOWS-SETUP-GUIDE.md            # This guide
```

## 🛠️ Troubleshooting

### Common Issues

#### 1. "Python is not recognized"
**Solution:**
- Reinstall Python and check "Add Python to PATH"
- Or manually add Python to your PATH environment variable

#### 2. "dotnet is not recognized"
**Solution:**
- Install .NET SDK from Microsoft
- Restart Command Prompt after installation

#### 3. "UnicodeEncodeError" or emoji display issues
**Solution:**
- Use `generate-enhanced-html-report-windows.py` (no emojis)
- Or set environment variable: `set PYTHONIOENCODING=utf-8`

#### 4. "XML file not found"
**Solution:**
- Make sure tests ran successfully first
- Check if `TestResults.xml` exists in `TestReports/` directory

#### 5. "Build failed" errors
**Solution:**
```cmd
# Clean and restore
dotnet clean
dotnet restore
dotnet build
```

### Advanced Troubleshooting

#### Set Environment Variables
```cmd
# Set Python encoding
set PYTHONIOENCODING=utf-8

# Set console encoding
chcp 65001
```

#### Use PowerShell Instead of Command Prompt
```powershell
# PowerShell handles Unicode better
python run-all-tests.py
```

#### Check File Permissions
```cmd
# Make sure you have write permissions
icacls TestReports /grant Everyone:F
```

## 🎨 Generated Reports

### HTML Report Features
- **Beautiful styling** with responsive design
- **Test statistics** showing pass/fail rates
- **Detailed test results** with durations and class names
- **Color-coded status** (green for passed, red for failed)
- **Mobile-friendly** layout

### Report Locations
- **HTML Report:** `TestReports/EnhancedTestReport_YYYY-MM-DD_HH-MM-SS.html`
- **XML Results:** `TestReports/TestResults.xml`
- **TRX Results:** `TestReports/TestResults_YYYY-MM-DD_HH-MM-SS.trx`

## 🚀 CI/CD Integration

### GitHub Actions
```yaml
- name: Run Tests on Windows
  run: |
    python run-all-tests.py --output "TestReports"
    
- name: Upload Test Reports
  uses: actions/upload-artifact@v2
  with:
    name: test-reports
    path: TestReports/
```

### Azure DevOps
```yaml
- script: |
    python run-all-tests.py --output "$(Agent.TempDirectory)/TestReports"
  displayName: 'Run Tests with Enhanced Reporting'
  
- task: PublishTestResults@2
  inputs:
    testResultsFiles: '$(Agent.TempDirectory)/TestReports/*.trx'
```

## 📞 Support

### If You Encounter Issues:
1. **Check prerequisites** - Python 3.6+ and .NET SDK installed
2. **Verify file permissions** - Can write to TestReports directory
3. **Try the batch file** - `run-tests-windows.bat` handles most issues
4. **Use Windows-compatible scripts** - No Unicode emojis to avoid encoding issues

### Success Indicators:
- ✅ Tests run without errors
- ✅ HTML report generated in TestReports directory
- ✅ No Unicode encoding errors
- ✅ Beautiful HTML report opens in browser

## 🎉 You're All Set!

After following this guide, you should have:
- ✅ **Working test execution** on Windows
- ✅ **Beautiful HTML reports** with no encoding issues
- ✅ **Multiple execution options** (batch file, Python scripts, .NET commands)
- ✅ **CI/CD ready** setup for automated testing

Open the generated HTML report in your browser to see the beautiful test results! 🎨