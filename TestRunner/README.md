# TestRunner Directory

This directory contains all the core test running and reporting scripts.

## Files in this directory:

### Core Test Runner
- **`run-all-tests.py`** - Main test runner script that executes all tests and generates reports

### HTML Report Generators
- **`generate-enhanced-html-report-with-actual-results.py`** - Primary HTML report generator with actual results
- **`generate-enhanced-html-report-with-actual-results-windows.py`** - Windows-compatible version of the HTML report generator
- **`generate-enhanced-html-report-robust.py`** - Fallback HTML report generator for XML files

### Teams Integration
- **`send-teams-notification.py`** - Sends test results to Microsoft Teams

### Report Management
- **`open-html-report.py`** - Opens HTML reports in the default browser

## Usage

These scripts are called by the wrapper scripts in the root directory:

```bash
# Run all tests
python3 run-all-tests.py

# Open HTML report
python3 open-html-report.py

# List available reports
python3 open-html-report.py --list
```

## File Organization

The TestRunner directory keeps all test execution logic organized and separate from:
- Documentation files (root directory)
- Configuration files (root directory)
- Test source code (Tests/ directory)
- Generated reports (TestReports/ directory)

This structure makes it easier to:
- Maintain test running logic
- Update reporting features
- Keep the root directory clean
- Organize related functionality
