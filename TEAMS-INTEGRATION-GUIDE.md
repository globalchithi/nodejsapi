# 🚀 Teams Integration Guide

This guide explains how to automatically parse test results and send them to Microsoft Teams.

## 📋 Overview

The system can automatically:
1. **Parse XML test results** from xUnit or TRX loggers
2. **Extract test statistics** (total, passed, failed, skipped, duration)
3. **Send formatted notifications** to Microsoft Teams with Adaptive Cards
4. **Handle malformed XML** with auto-repair and regex fallback

## 🔧 Setup

### 1. Configure Teams Webhook

Add your Teams webhook URL to the `.env` file:

```env
# Microsoft Teams Integration
TEAMS_WEBHOOK_URL=https://your-webhook-url-here
SEND_TEAMS_NOTIFICATION=true
```

### 2. Test Your Webhook

```cmd
# Test with your webhook URL
test-teams-webhook.bat "https://your-webhook-url"
```

## 🚀 Usage Options

### Option 1: Automatic Integration (Recommended)

The main test runner automatically parses results and sends to Teams:

```cmd
# Run tests with automatic Teams notification
run-tests-with-reporting.bat

# Or with specific test filter
run-tests-with-reporting.bat "FullyQualifiedName~Inventory"
```

### Option 2: Parse Existing Results

Parse existing test results and send to Teams:

```cmd
# Parse results from TestReports directory
parse-and-send-results.bat "https://your-webhook-url" "Development" "Chrome"

# Or use environment variables
parse-and-send-results.bat
```

### Option 3: Manual PowerShell

```powershell
# Parse specific XML file and send to Teams
powershell -ExecutionPolicy Bypass -File "parse-test-results.ps1" -XmlFile "TestReports\TestResults.xml" -WebhookUrl "https://your-webhook-url" -Environment "Staging" -Browser "Chrome"
```

## 📊 What Gets Sent to Teams

The Teams notification includes:

- **Test Status**: ✅ All passed or ❌ Some failed
- **Environment**: Development, Staging, Production, etc.
- **Total Tests**: Total number of tests run
- **Passed**: Number of successful tests
- **Failed**: Number of failed tests
- **Skipped**: Number of skipped tests
- **Success Rate**: Percentage of passed tests
- **Duration**: Total execution time
- **Browser**: Browser used (if applicable)
- **Timestamp**: When the tests were run

## 🧪 Testing the Integration

### Test with Sample Data

```cmd
# Create sample test results and test parsing
test-parse-results.bat
```

This creates sample XML with:
- 14 total tests
- 12 passed
- 2 failed
- 0 skipped
- 85.7% success rate

### Test Your Webhook

```cmd
# Test your actual webhook URL
test-teams-webhook.bat "https://your-webhook-url"
```

## 🔍 Troubleshooting

### Common Issues

1. **"No XML test results found"**
   - Make sure tests were run with `--logger xunit` or `--logger trx`
   - Check that `TestReports` directory exists

2. **"Teams notification failed"**
   - Verify your webhook URL is correct
   - Check network connectivity
   - Ensure `curl.exe` is available

3. **"XML parsing failed"**
   - The system includes auto-repair for malformed XML
   - Regex fallback is used if XML parsing fails
   - Check that the XML file is not corrupted

### Debug Mode

Enable verbose output by setting in `.env`:

```env
VERBOSE=true
DEBUG_MODE=true
```

## 📁 File Structure

```
nodejsapi/
├── parse-test-results.ps1          # Main parsing script
├── parse-and-send-results.bat      # Batch wrapper
├── test-parse-results.bat          # Test with sample data
├── test-teams-webhook.bat          # Test webhook URL
├── send-teams-simple.ps1           # Simple Teams sender
├── send-teams-curl.bat             # Direct curl approach
└── .env                           # Configuration file
```

## 🎯 Example Workflow

1. **Run Tests**: `run-tests-with-reporting.bat`
2. **Automatic Parsing**: System parses `TestResults.xml`
3. **Teams Notification**: Results sent to Teams channel
4. **Check Teams**: View the Adaptive Card in your Teams channel

## 💡 Tips

- **Environment Variables**: Use `.env` file for configuration
- **Multiple Formats**: Supports both xUnit and TRX XML formats
- **Auto-Repair**: Handles malformed XML automatically
- **Fallback**: Regex extraction if XML parsing fails
- **Flexible**: Works with existing test results or new test runs

## 🔗 Related Files

- `run-tests-with-reporting.bat` - Main test runner with Teams integration
- `parse-test-results.ps1` - Core parsing logic
- `generate-enhanced-report-minimal.ps1` - HTML report generation
- `.env` - Configuration file
- `load-env-batch.bat` - Environment variable loader
