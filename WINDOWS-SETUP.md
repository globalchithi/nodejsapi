# Windows Setup Guide

This guide helps you set up the VaxCare API Test Suite on Windows.

## 🚀 Quick Start

### 1. Copy Environment File
```cmd
copy .env.example .env
```

### 2. Edit Your Configuration
Open `.env` in Notepad or your preferred editor:
```cmd
notepad .env
```

### 3. Set Your Teams Webhook URL
In the `.env` file, find this line:
```
TEAMS_WEBHOOK_URL=
```
And change it to:
```
TEAMS_WEBHOOK_URL=https://your-webhook-url-here
```

### 4. Test Environment Loading
```cmd
test-env-minimal.bat
```

### 5. Run Tests
```cmd
run-tests-with-reporting.bat
```

## 🔧 Troubleshooting

### "Syntax of the command is incorrect"
This usually means there's an issue with the `.env` file format.

**Check your .env file:**
```cmd
type .env
```

**Common issues:**
- Empty lines with just spaces
- Special characters in values
- Missing `=` signs
- Quotes around values (usually not needed)

**Fix:**
1. Open `.env` in Notepad
2. Make sure each line is either:
   - `KEY=VALUE` (no spaces around =)
   - `# Comment` (starts with #)
   - Empty line

### "Teams notification enabled but TEAMS_WEBHOOK_URL not configured"
This means the environment variable isn't being loaded.

**Debug steps:**
1. Run `test-env-minimal.bat`
2. Check if `TEAMS_WEBHOOK_URL` shows your URL
3. If empty, check your `.env` file format

### Environment Variables Not Loading
**Check .env file exists:**
```cmd
dir .env
```

**Check .env content:**
```cmd
type .env
```

**Test loading:**
```cmd
test-env-minimal.bat
```

## 📋 Example .env File

```bash
# Teams Integration
TEAMS_WEBHOOK_URL=https://your-webhook-url
SEND_TEAMS_NOTIFICATION=true

# Environment
ENVIRONMENT=Development
BROWSER=Chrome

# Test Settings
OPEN_REPORTS=false
VERBOSE=false
DEBUG_MODE=true
```

## 🎯 Common Commands

```cmd
# Run all tests
run-tests-with-reporting.bat

# Run specific tests
run-tests-with-reporting.bat "FullyQualifiedName~Inventory"

# Run with Teams notification
run-tests-with-reporting.bat --teams "https://your-webhook-url"

# Test environment loading
test-env-minimal.bat

# Setup environment
setup-environment.bat
```

## 💡 Tips

1. **Use Notepad**: Avoid Word or other rich text editors for `.env` file
2. **No Spaces**: Use `KEY=VALUE` not `KEY = VALUE`
3. **No Quotes**: Usually don't need quotes around values
4. **Test First**: Always run `test-env-minimal.bat` first
5. **Check Paths**: Make sure you're in the right directory

## 🆘 Still Having Issues?

1. **Check Windows Version**: Make sure you're on Windows 10/11
2. **Check PowerShell**: Make sure PowerShell is available
3. **Check Permissions**: Make sure you can run batch files
4. **Check Antivirus**: Some antivirus software blocks batch files

## 📞 Getting Help

If you're still having issues:
1. Run `test-env-minimal.bat` and share the output
2. Share your `.env` file content (remove sensitive URLs)
3. Check the error message carefully
