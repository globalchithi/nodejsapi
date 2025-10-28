# 🔧 Troubleshooting Guide - Exit Code 1 Issues

## Overview
This guide helps you diagnose and fix "exit code 1" errors in the VaxCare API Test Suite.

## 🚀 Quick Diagnostic

### Run the Diagnostic Tool
```bash
# This will check all common issues
python3 diagnose-issues.py
```

## 🔍 Common Exit Code 1 Scenarios

### 1. **Test Execution Failures**

#### Symptoms:
- `dotnet test` returns exit code 1
- Build errors or test failures
- Missing dependencies

#### Solutions:
```bash
# Clean and restore
dotnet clean
dotnet restore
dotnet build

# Run tests with verbose output
dotnet test --verbosity normal

# Check for specific test failures
dotnet test --logger "console;verbosity=detailed"
```

### 2. **Python Script Failures**

#### Symptoms:
- Python scripts exit with code 1
- Import errors or missing modules
- File not found errors

#### Solutions:
```bash
# Check Python version
python3 --version

# Test individual components
python3 generate-enhanced-html-report-windows.py --help

# Use Windows-compatible version if on Windows
python3 generate-enhanced-html-report-windows.py
```

### 3. **XML File Issues**

#### Symptoms:
- "XML file not found" errors
- XML parsing failures
- No test results generated

#### Solutions:
```bash
# Check if XML file exists
ls -la TestReports/TestResults.xml

# Generate XML file first
dotnet test --logger "xunit;LogFileName=TestResults.xml"

# Use existing XML file
python3 generate-enhanced-html-report-windows.py --xml TestReports/TestResults.xml
```

### 4. **Encoding Issues (Windows)**

#### Symptoms:
- UnicodeEncodeError on Windows
- Emoji display issues
- Character encoding problems

#### Solutions:
```bash
# Use Windows-compatible version
python3 generate-enhanced-html-report-windows.py

# Or set encoding environment variable
set PYTHONIOENCODING=utf-8
python3 generate-enhanced-html-report.py
```

### 5. **Permission Issues**

#### Symptoms:
- Cannot write to TestReports directory
- File access denied errors
- Directory creation failures

#### Solutions:
```bash
# Create directory manually
mkdir -p TestReports

# Check permissions
ls -la TestReports/

# Fix permissions (Linux/Mac)
chmod 755 TestReports/
```

## 🛠️ Step-by-Step Troubleshooting

### Step 1: Run Diagnostic
```bash
python3 diagnose-issues.py
```

### Step 2: Check Prerequisites
```bash
# Check .NET
dotnet --version

# Check Python
python3 --version

# Check project files
ls -la *.csproj
```

### Step 3: Clean and Restore
```bash
# Clean everything
dotnet clean
rm -rf bin/ obj/

# Restore dependencies
dotnet restore

# Build project
dotnet build
```

### Step 4: Test Individual Components
```bash
# Test .NET build
dotnet build

# Test .NET tests
dotnet test --verbosity normal

# Test Python script
python3 generate-enhanced-html-report-windows.py --help
```

### Step 5: Generate Reports
```bash
# Generate XML results
dotnet test --logger "xunit;LogFileName=TestResults.xml" --results-directory TestReports

# Generate HTML report
python3 generate-enhanced-html-report-windows.py
```

## 🎯 Platform-Specific Solutions

### Windows
```cmd
# Use batch file (handles most issues)
run-tests-windows.bat

# Or use Windows-compatible Python script
python generate-enhanced-html-report-windows.py

# Set encoding if needed
set PYTHONIOENCODING=utf-8
```

### macOS/Linux
```bash
# Use full-featured scripts
python3 run-all-tests.py

# Or use bash scripts
./run-tests.sh
```

## 🔧 Advanced Troubleshooting

### Check Logs
```bash
# Check build logs
dotnet build --verbosity detailed

# Check test logs
dotnet test --logger "console;verbosity=detailed"

# Check Python errors
python3 -v generate-enhanced-html-report-windows.py
```

### Environment Variables
```bash
# Set Python encoding
export PYTHONIOENCODING=utf-8

# Set .NET verbosity
export DOTNET_CLI_UI_VERBOSITY=1

# Set console encoding (Windows)
chcp 65001
```

### File System Issues
```bash
# Check disk space
df -h

# Check file permissions
ls -la TestReports/

# Clean up old files
rm -rf TestReports/EnhancedTestReport_*.html
```

## 🚨 Emergency Solutions

### If Nothing Works
```bash
# 1. Use the simplest approach
dotnet test --logger "trx;LogFileName=TestResults.trx"

# 2. Generate HTML manually
python3 generate-enhanced-html-report-windows.py --xml TestReports/TestResults.xml

# 3. Use batch file (Windows)
run-tests-windows.bat
```

### Minimal Working Example
```bash
# Create minimal test
echo "Testing basic functionality..."

# Run tests
dotnet test --logger "xunit;LogFileName=TestResults.xml" --results-directory TestReports

# Generate report
python3 generate-enhanced-html-report-windows.py --xml TestReports/TestResults.xml --output TestReports

echo "Done!"
```

## 📊 Success Indicators

### ✅ Everything Working:
- Diagnostic tool shows all checks passed
- Tests run without errors
- HTML report generated successfully
- No exit code 1 errors

### ❌ Still Having Issues:
- Check specific error messages
- Try the emergency solutions
- Use the Windows-compatible scripts
- Check file permissions and disk space

## 🆘 Getting Help

### If You're Still Stuck:
1. **Run the diagnostic tool**: `python3 diagnose-issues.py`
2. **Check the error messages** carefully
3. **Try the Windows-compatible version**: `generate-enhanced-html-report-windows.py`
4. **Use the batch file** (Windows): `run-tests-windows.bat`
5. **Check file permissions** and disk space

### Common Solutions Summary:
- ✅ **Use Windows-compatible scripts** for encoding issues
- ✅ **Clean and restore** for build issues
- ✅ **Check file permissions** for access issues
- ✅ **Use batch files** for simple execution
- ✅ **Run diagnostic tool** for comprehensive checks

## 🎉 Success!

Once everything is working, you should see:
- ✅ Tests execute successfully
- ✅ HTML reports generated
- ✅ No exit code 1 errors
- ✅ Beautiful test results in browser

The test suite is designed to be robust and handle most issues automatically! 🚀
