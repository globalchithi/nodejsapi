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
### Step 1: Install .NET 8.0 SDK

1. Download .NET 8.0 SDK from [Microsoft's website](https://dotnet.microsoft.com/download/dotnet/8.0)
2. Run the installer and follow the setup wizard
3. Verify installation:
   ```cmd
   dotnet --version
   ```

### Step 2: Install Python (for PDF generation)

#### Option A: Download from Python.org
1. Go to [python.org/downloads](https://www.python.org/downloads/)
2. Download Python 3.9+ for Windows
3. **Important**: Check "Add Python to PATH" during installation
4. Verify installation:
   ```cmd
   python --version
   ```

#### Option B: Using Chocolatey (if installed)
```cmd
choco install python
```

### Step 3: Install Python Dependencies

```cmd
# Install required Python packages
pip install reportlab beautifulsoup4

# Optional: Install additional PDF generation tools
pip install weasyprint pdfkit
```

### Step 4: Install wkhtmltopdf (Optional, for better PDF quality)

#### Option A: Download from Official Site
1. Go to [wkhtmltopdf.org/downloads.html](https://wkhtmltopdf.org/downloads.html)
2. Download the Windows installer
3. Install and add to PATH

#### Option B: Using Chocolatey
```cmd
choco install wkhtmltopdf
```

## 🛠️ Available Scripts

### PowerShell Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `run-tests-with-reporting.ps1` | Main test runner with all reports | `.\run-tests-with-reporting.ps1 [options]` |
| `generate-enhanced-report.ps1` | Generate HTML reports | `.\generate-enhanced-report.ps1` |
| `generate-pdf-report.ps1` | Generate PDF reports | `.\generate-pdf-report.ps1 -Latest` |

### Batch Files

| Script | Purpose | Usage |
|--------|---------|-------|
| `run-tests-with-reporting.bat` | Main test runner (CMD) | `run-tests-with-reporting.bat [options]` |

## 📊 Generated Reports

After running tests, you'll find these files in the `TestReports` directory:

### Report Types
- **📄 HTML Reports**: `EnhancedTestReport_YYYY-MM-DD_HH-mm-ss.html`
- **📄 PDF Reports**: `TestReport_YYYY-MM-DD_HH-mm-ss.pdf`
- **📄 JSON Reports**: `TestReport_YYYY-MM-DD_HH-mm-ss.json`
- **📄 Markdown Reports**: `TestReport_YYYY-MM-DD_HH-mm-ss.md`
- **📄 XML Reports**: `TestResults.xml`

### Report Features
- **📈 Test Statistics**: Pass/fail rates, execution times
- **🧪 Individual Test Scenarios**: Detailed test names and results
- **📁 Test Categories**: Grouped by test class
- **🎨 Professional Styling**: Colors, tables, and clean formatting
- **📱 Responsive Design**: Works on desktop and mobile

## 🔧 Configuration Options

### PowerShell Script Parameters

```powershell
# Basic usage
.\run-tests-with-reporting.ps1

# With filter
.\run-tests-with-reporting.ps1 "FullyQualifiedName~Inventory"

# With options
.\run-tests-with-reporting.ps1 -Filter "FullyQualifiedName~Patients" -Verbose -OpenReports

# Without PDF generation
.\run-tests-with-reporting.ps1 -NoPdf
```

### Batch File Parameters

```cmd
REM Basic usage
run-tests-with-reporting.bat

REM With filter
run-tests-with-reporting.bat "FullyQualifiedName~Inventory"

REM With options
run-tests-with-reporting.bat "FullyQualifiedName~Patients" --verbose --open

REM Without PDF generation
run-tests-with-reporting.bat --no-pdf
```

## 🚨 Troubleshooting

### Common Issues

#### 1. PowerShell Execution Policy
```powershell
# If you get execution policy errors, run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 2. Python Not Found
```cmd
# Add Python to PATH manually:
# 1. Open System Properties > Environment Variables
# 2. Add Python installation directory to PATH
# 3. Restart command prompt
```

#### 3. wkhtmltopdf Not Found
```cmd
# Download and install from:
# https://wkhtmltopdf.org/downloads.html
# Make sure to add to PATH during installation
```

#### 4. Missing Dependencies
```cmd
# Install missing Python packages:
pip install reportlab beautifulsoup4

# For better PDF generation:
pip install weasyprint pdfkit
```

### Debug Mode

```powershell
# Run with verbose output to see detailed information
.\run-tests-with-reporting.ps1 -Verbose
```

```cmd
# Run with verbose output
run-tests-with-reporting.bat --verbose
```

## 📈 Performance Tips

### 1. Use Specific Filters
```powershell
# Run only specific test categories
.\run-tests-with-reporting.ps1 "FullyQualifiedName~Inventory"
.\run-tests-with-reporting.ps1 "FullyQualifiedName~Patients"
```

### 2. Skip PDF Generation for Faster Execution
```powershell
# Run without PDF generation
.\run-tests-with-reporting.ps1 -NoPdf
```

### 3. Use Parallel Execution
```powershell
# Run tests in parallel (if supported by your test framework)
dotnet test --parallel
```

## 🔄 CI/CD Integration

### Azure DevOps Pipeline

```yaml
- task: DotNetCoreCLI@2
  displayName: 'Run tests with reporting'
  inputs:
    command: 'test'
    projects: '**/*Tests.csproj'
    arguments: '--logger trx --results-directory TestReports --configuration Release'

- task: PowerShell@2
  displayName: 'Generate reports'
  inputs:
    targetType: 'filePath'
    filePath: 'run-tests-with-reporting.ps1'
    arguments: '--NoPdf'

- task: PublishTestResults@2
  displayName: 'Publish test results'
  inputs:
    testResultsFormat: 'VSTest'
    testResultsFiles: '**/TestResults.trx'
    searchFolder: 'TestReports'
```

### GitHub Actions

```yaml
- name: Run tests with reporting
  run: |
    dotnet test --logger trx --results-directory TestReports --configuration Release
    powershell -ExecutionPolicy Bypass -File run-tests-with-reporting.ps1 --NoPdf

- name: Upload test reports
  uses: actions/upload-artifact@v3
  with:
    name: test-reports
    path: TestReports/
```

## 📞 Support

### Getting Help

1. **Check the logs**: Look for error messages in the console output
2. **Verify dependencies**: Ensure all required software is installed
3. **Test individual components**: Try running each script separately
4. **Check file permissions**: Ensure the script has permission to write to the TestReports directory

### Common Solutions

| Problem | Solution |
|---------|----------|
| PowerShell execution policy error | Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Python not found | Add Python to PATH or reinstall with "Add to PATH" checked |
| PDF generation fails | Install wkhtmltopdf or use Python-only mode |
| Build fails | Ensure .NET 8.0 SDK is installed and project builds correctly |

---

**Happy Testing on Windows! 🪟✨**

