# 🪟 Windows Setup Guide for VaxCare API Test Reporting

## Overview

This guide provides step-by-step instructions for setting up automated test reporting with PDF generation on Windows machines.

## 📋 Prerequisites

### Required Software
- **.NET 8.0 SDK** - [Download from Microsoft](https://dotnet.microsoft.com/download/dotnet/8.0)
- **PowerShell 5.1+** (included with Windows 10/11)
- **Python 3.7+** (optional, for PDF generation)

### Optional Software
- **wkhtmltopdf** - For high-quality PDF generation
- **Chocolatey** - For easy package management

## 🚀 Quick Start

### Method 1: PowerShell Scripts (Recommended)

```powershell
# Run all tests with comprehensive reporting
.\run-tests-with-reporting.ps1

# Run specific test categories
.\run-tests-with-reporting.ps1 "FullyQualifiedName~Inventory"
.\run-tests-with-reporting.ps1 "FullyQualifiedName~Patients"

# Run with verbose output and open reports
.\run-tests-with-reporting.ps1 --Verbose --OpenReports

# Run without PDF generation
.\run-tests-with-reporting.ps1 --NoPdf
```

### Method 2: Batch File (Command Prompt)

```cmd
REM Run all tests with comprehensive reporting
run-tests-with-reporting.bat

REM Run specific test categories
run-tests-with-reporting.bat "FullyQualifiedName~Inventory"
run-tests-with-reporting.bat "FullyQualifiedName~Patients"

REM Run with verbose output and open reports
run-tests-with-reporting.bat --open --verbose

REM Run without PDF generation
run-tests-with-reporting.bat --no-pdf
```

## 📦 Installation Steps

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
