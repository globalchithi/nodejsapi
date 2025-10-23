# Environment Configuration Guide

This guide explains how to configure the VaxCare API Test Suite using environment variables.

## 📁 Environment Files

### `.env` - Active Configuration
This is your main environment configuration file. It contains all the settings for your test suite.

### `.env.example` - Template
A template file showing all available configuration options with examples.

### `.env.local` - Local Overrides (Optional)
Create this file to override settings for your local development environment without affecting the main `.env` file.

## 🔧 Configuration Options

### Microsoft Teams Integration
```bash
# Teams webhook URL for notifications
TEAMS_WEBHOOK_URL=https://your-org.webhook.office.com/webhookb2/your-webhook-id

# Enable/disable Teams notifications
SEND_TEAMS_NOTIFICATION=true
```

### Test Environment
```bash
# Environment name (appears in reports and Teams notifications)
ENVIRONMENT=Development
# Options: Development, Staging, Production, Testing

# Browser information (for reporting purposes)
BROWSER=Chrome
# Options: Chrome, Firefox, Edge, Safari, N/A
```

### Test Execution
```bash
# Automatically open generated reports
OPEN_REPORTS=false

# Show detailed test output
VERBOSE=false

# Output formats for reports
OUTPUT_FORMAT=html,json,markdown
# Available: html, json, markdown

# Test filter (optional)
# TEST_FILTER=FullyQualifiedName~Inventory
```

### Report Configuration
```bash
# Directory for test reports
REPORTS_DIR=TestReports

# Project name
PROJECT_NAME=VaxCareApiTests

# XML logger format
XML_LOGGER_FORMAT=xunit
# Options: xunit, trx
```

### Advanced Settings
```bash
# CI/CD mode
CI_MODE=false

# Debug mode for additional information
DEBUG_MODE=false
```

## 🚀 Quick Setup

### 1. Copy the Example File
```bash
cp .env.example .env
```

### 2. Edit Your Configuration
Open `.env` and customize the values for your environment:

```bash
# Example configuration
TEAMS_WEBHOOK_URL=https://your-teams-webhook-url
ENVIRONMENT=Staging
BROWSER=Chrome
SEND_TEAMS_NOTIFICATION=true
OPEN_REPORTS=true
VERBOSE=false
```

### 3. Run Tests
```bash
# Run with your configuration
run-tests-with-reporting.bat

# Or run specific tests
run-tests-with-reporting.bat "FullyQualifiedName~Inventory"
```

## 🔄 Environment Priority

Settings are loaded in this order (later overrides earlier):

1. **Default values** (hardcoded in batch file)
2. **`.env` file** (main configuration)
3. **`.env.local` file** (local overrides)
4. **Command line arguments** (highest priority)

## 💡 Tips

### Teams Integration
- Get your webhook URL from Microsoft Teams channel settings
- Test your webhook URL with a simple curl command first
- Use different webhook URLs for different environments

### Local Development
- Create `.env.local` for your personal settings
- Add `.env.local` to `.gitignore` to keep it private
- Use `.env` for team-shared settings

### CI/CD Integration
- Set `CI_MODE=true` for automated environments
- Use environment variables in your CI/CD pipeline
- Configure different settings for different environments

## 🛠️ Troubleshooting

### Environment Variables Not Loading
- Check that `.env` file exists and is readable
- Verify PowerShell execution policy allows script execution
- Check for syntax errors in `.env` file

### Teams Notifications Not Working
- Verify `TEAMS_WEBHOOK_URL` is set correctly
- Check that `SEND_TEAMS_NOTIFICATION=true`
- Test webhook URL independently

### Reports Not Generating
- Check `REPORTS_DIR` path is correct
- Verify `OUTPUT_FORMAT` includes desired formats
- Ensure test execution completed successfully

## 📋 Example Configurations

### Development Environment
```bash
ENVIRONMENT=Development
BROWSER=N/A
SEND_TEAMS_NOTIFICATION=false
OPEN_REPORTS=true
VERBOSE=true
DEBUG_MODE=true
```

### Staging Environment
```bash
ENVIRONMENT=Staging
BROWSER=Chrome
SEND_TEAMS_NOTIFICATION=true
TEAMS_WEBHOOK_URL=https://staging-teams-webhook
OPEN_REPORTS=false
VERBOSE=false
```

### Production Environment
```bash
ENVIRONMENT=Production
BROWSER=Chrome
SEND_TEAMS_NOTIFICATION=true
TEAMS_WEBHOOK_URL=https://production-teams-webhook
OPEN_REPORTS=false
VERBOSE=false
CI_MODE=true
```

