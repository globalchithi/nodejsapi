# 📤 Microsoft Teams Integration Guide

## Overview
The VaxCare API Test Suite now includes Microsoft Teams integration to automatically send test results as beautiful Adaptive Cards.

## 🚀 Quick Start

### **Option 1: Run Tests with Teams Notification**
```bash
# Run all tests and send results to Teams
python3 run-all-tests.py --teams

# Run specific tests and send to Teams
python3 run-all-tests.py --category inventory --teams

# Run with custom environment and browser info
python3 run-all-tests.py --teams --environment "Production" --browser "Chrome (Headless)"
```

### **Option 2: Send Teams Notification Only**
```bash
# Send notification for existing test results
python3 send-teams-notification.py --xml TestReports/TestResults.xml

# Send with custom environment
python3 send-teams-notification.py --environment "Staging" --browser "Firefox"

# Test Teams connection
python3 send-teams-notification.py --test
```

## 🔧 Configuration

### **Webhook URL**
The script uses a default webhook URL from your curl command. You can override it:

```bash
# Use custom webhook URL
python3 send-teams-notification.py --webhook "YOUR_WEBHOOK_URL"
```

### **Environment Variables**
You can set default values in your environment:

```bash
# Set default environment
export TEAMS_ENVIRONMENT="Production"

# Set default browser
export TEAMS_BROWSER="Chrome (Headless)"
```

## 📊 What Gets Sent to Teams

### **Adaptive Card Content:**
- ✅ **Test Status** - Pass/Fail summary with emojis
- 📊 **Statistics** - Total, Passed, Failed, Skipped counts
- 🎯 **Success Rate** - Percentage of passed tests
- ⏱️ **Duration** - Total test execution time
- 🌍 **Environment** - Development, Staging, Production
- 🌐 **Browser** - Chrome, Firefox, Safari, etc.
- 📅 **Timestamp** - When tests were executed

### **Example Teams Message:**
```
🚀 Test Automation Results

API Test Results
✅ All 14 tests passed successfully!

Environment: Development
Total Tests: 14
Passed: 12
Failed: 2
Skipped: 0
Success Rate: 85.7%
Duration: 2m 35s
Browser: Chrome (Headless)
Timestamp: 10/23/2025, 11:15:30 AM
```

## 🎯 Usage Examples

### **Run All Tests with Teams Notification**
```bash
# Basic usage
python3 run-all-tests.py --teams

# With custom environment
python3 run-all-tests.py --teams --environment "Staging"

# With custom browser info
python3 run-all-tests.py --teams --browser "Firefox (Headless)"
```

### **Run Specific Test Categories**
```bash
# Inventory tests
python3 run-all-tests.py --category inventory --teams

# Patient tests
python3 run-all-tests.py --category patients --teams

# Setup tests
python3 run-all-tests.py --category setup --teams
```

### **Send Notification for Existing Results**
```bash
# Send notification for existing XML file
python3 send-teams-notification.py

# Send with custom parameters
python3 send-teams-notification.py --environment "Production" --browser "Chrome"

# Test Teams connection
python3 send-teams-notification.py --test
```

## 🔧 Advanced Configuration

### **Custom Webhook URL**
```bash
# Use your own webhook URL
python3 send-teams-notification.py --webhook "https://your-webhook-url"
```

### **Environment-Specific Settings**
```bash
# Development environment
python3 run-all-tests.py --teams --environment "Development" --browser "Chrome"

# Staging environment
python3 run-all-tests.py --teams --environment "Staging" --browser "Firefox"

# Production environment
python3 run-all-tests.py --teams --environment "Production" --browser "Chrome (Headless)"
```

## 🛠️ Troubleshooting

### **Common Issues:**

#### **1. "Teams notification failed"**
- Check your webhook URL
- Verify internet connection
- Check if the webhook endpoint is accessible

#### **2. "XML file not found"**
- Make sure tests have run successfully
- Check if `TestResults.xml` exists in `TestReports/` directory

#### **3. "Failed to parse XML file"**
- The script uses robust XML parsing
- Should handle most XML issues automatically

### **Debug Steps:**
```bash
# Test Teams connection
python3 send-teams-notification.py --test

# Check XML file
ls -la TestReports/TestResults.xml

# Test XML parsing
python3 send-teams-notification.py --xml TestReports/TestResults.xml
```

## 🎨 Teams Card Features

### **Visual Elements:**
- 🎨 **Beautiful Adaptive Cards** - Rich formatting
- 📊 **Color-coded Status** - Green for success, yellow for warnings
- 📈 **Progress Indicators** - Visual test statistics
- 🕒 **Timestamps** - When tests were executed
- 🌍 **Environment Info** - Which environment was tested

### **Responsive Design:**
- 📱 **Mobile-friendly** - Works on all devices
- 💻 **Desktop optimized** - Great on large screens
- 🎯 **Clear hierarchy** - Easy to read information

## 🚀 CI/CD Integration

### **GitHub Actions:**
```yaml
- name: Run Tests with Teams Notification
  run: |
    python3 run-all-tests.py --teams --environment "CI" --browser "Chrome (Headless)"
```

### **Azure DevOps:**
```yaml
- script: |
    python3 run-all-tests.py --teams --environment "Azure DevOps" --browser "Chrome"
  displayName: 'Run Tests with Teams Notification'
```

## 🎉 Benefits

### **For Teams:**
- ✅ **Real-time notifications** - Know test results immediately
- 📊 **Visual reports** - Beautiful Adaptive Cards
- 🔔 **Automatic updates** - No manual checking needed
- 📱 **Mobile access** - Check results anywhere

### **For Developers:**
- ✅ **Automated reporting** - No manual work required
- 🎯 **Rich information** - Detailed test statistics
- 🌍 **Environment awareness** - Know which environment was tested
- 📈 **Progress tracking** - See test trends over time

## 📞 Support

### **If You Need Help:**
1. **Test Teams connection:** `python3 send-teams-notification.py --test`
2. **Check XML file:** `ls -la TestReports/TestResults.xml`
3. **Run diagnostic:** `python3 diagnose-issues.py`
4. **Check webhook URL** - Make sure it's correct and accessible

### **Success Indicators:**
- ✅ **"Teams notification sent successfully!"** message
- 📤 **Message appears in Teams channel**
- 📊 **Beautiful Adaptive Card with test results**
- 🎯 **All test statistics displayed correctly**

The Teams integration makes it easy to share test results with your team automatically! 🚀