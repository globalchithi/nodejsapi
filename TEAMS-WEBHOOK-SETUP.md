# 🔗 Microsoft Teams Webhook Setup Guide

## Overview
This guide will walk you through setting up a Microsoft Teams webhook to receive test result notifications.

## 🚀 **Step-by-Step Setup**

### **Step 1: Create a Teams Channel**
1. **Open Microsoft Teams**
2. **Navigate to your team** (or create a new team if needed)
3. **Create a new channel** for test notifications:
   - Click the **"+"** next to channels
   - Name it something like **"Test Results"** or **"API Testing"**
   - Set it as **Standard channel** (not private)

### **Step 2: Add Incoming Webhook Connector**
1. **In your Teams channel**, click the **"..."** (more options) next to the channel name
2. **Select "Connectors"**
3. **Find "Incoming Webhook"** in the list
4. **Click "Configure"**

### **Step 3: Configure the Webhook**
1. **Give it a name**: "VaxCare API Test Results"
2. **Upload an icon** (optional): Use a test-related icon
3. **Click "Create"**
4. **Copy the webhook URL** - This is your webhook URL!

### **Step 4: Test the Webhook**
```bash
# Test the webhook connection
python3 send-teams-notification.py --test
```

## 🔧 **Configuration Options**

### **Option 1: Use Default Webhook (Recommended)**
The script already includes your webhook URL from the curl command:
```bash
# This will use the default webhook URL
python3 send-teams-notification.py --test
```

### **Option 2: Use Custom Webhook**
```bash
# Use your own webhook URL
python3 send-teams-notification.py --webhook "YOUR_WEBHOOK_URL" --test
```

### **Option 3: Set Environment Variable**
```bash
# Set webhook URL as environment variable
export TEAMS_WEBHOOK_URL="YOUR_WEBHOOK_URL"
python3 send-teams-notification.py --test
```

## 📱 **Teams Channel Setup Examples**

### **Channel Name Suggestions:**
- `#test-results`
- `#api-testing`
- `#automation`
- `#qa-notifications`
- `#dev-alerts`

### **Channel Description:**
```
Automated test result notifications for VaxCare API Test Suite.
Receives real-time updates on test execution, pass/fail rates, and performance metrics.
```

## 🎯 **Webhook URL Format**

Your webhook URL should look like this:
```
https://your-organization.webhook.office.com/webhookb2/...
```

Or for Power Automate (like your current one):
```
https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com/...
```

## 🔧 **Advanced Configuration**

### **Multiple Environments Setup**
You can create different channels for different environments:

#### **Development Channel:**
- Channel: `#test-results-dev`
- Webhook: `DEV_WEBHOOK_URL`
- Usage: `python3 run-all-tests.py --teams --environment "Development"`

#### **Staging Channel:**
- Channel: `#test-results-staging`
- Webhook: `STAGING_WEBHOOK_URL`
- Usage: `python3 run-all-tests.py --teams --environment "Staging"`

#### **Production Channel:**
- Channel: `#test-results-prod`
- Webhook: `PROD_WEBHOOK_URL`
- Usage: `python3 run-all-tests.py --teams --environment "Production"`

### **Environment Variables Setup**
Create a `.env` file in your project root:
```bash
# Development
DEV_TEAMS_WEBHOOK_URL="https://your-dev-webhook-url"
DEV_ENVIRONMENT="Development"
DEV_BROWSER="Chrome (Headless)"

# Staging
STAGING_TEAMS_WEBHOOK_URL="https://your-staging-webhook-url"
STAGING_ENVIRONMENT="Staging"
STAGING_BROWSER="Firefox"

# Production
PROD_TEAMS_WEBHOOK_URL="https://your-prod-webhook-url"
PROD_ENVIRONMENT="Production"
PROD_BROWSER="Chrome (Headless)"
```

## 🚀 **Quick Start Commands**

### **Test Your Webhook:**
```bash
# Test with default webhook
python3 send-teams-notification.py --test

# Test with custom webhook
python3 send-teams-notification.py --webhook "YOUR_WEBHOOK_URL" --test
```

### **Send Test Results:**
```bash
# Send existing test results
python3 send-teams-notification.py

# Send with custom environment
python3 send-teams-notification.py --environment "Production" --browser "Chrome"
```

### **Run Tests with Notifications:**
```bash
# Run all tests with Teams notification
python3 run-all-tests.py --teams

# Run specific tests with Teams notification
python3 run-all-tests.py --category inventory --teams
```

## 🛠️ **Troubleshooting**

### **Common Issues:**

#### **1. "Teams notification failed"**
- ✅ Check your webhook URL is correct
- ✅ Verify the Teams channel exists
- ✅ Check internet connection
- ✅ Ensure the webhook connector is enabled

#### **2. "Webhook URL not found"**
- ✅ Make sure you copied the complete URL
- ✅ Check for any missing characters
- ✅ Verify the URL starts with `https://`

#### **3. "No message appears in Teams"**
- ✅ Check the Teams channel for the message
- ✅ Look for any error messages in the channel
- ✅ Verify the webhook connector is working

### **Debug Steps:**
```bash
# Test webhook connection
python3 send-teams-notification.py --test

# Check webhook URL
echo $TEAMS_WEBHOOK_URL

# Test with verbose output
python3 send-teams-notification.py --test --verbose
```

## 📊 **What You'll See in Teams**

### **Test Notification Example:**
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

### **Visual Features:**
- 🎨 **Beautiful Adaptive Cards** - Rich formatting
- 📊 **Color-coded Status** - Green for success, yellow for warnings
- 📈 **Progress Indicators** - Visual test statistics
- 🕒 **Timestamps** - When tests were executed
- 🌍 **Environment Info** - Which environment was tested

## 🎯 **Best Practices**

### **Channel Organization:**
- ✅ **Create dedicated channels** for test results
- ✅ **Use descriptive names** like `#test-results` or `#api-testing`
- ✅ **Set appropriate permissions** for team members
- ✅ **Pin important messages** for quick reference

### **Notification Management:**
- ✅ **Use different channels** for different environments
- ✅ **Set up filters** to avoid notification spam
- ✅ **Configure quiet hours** if needed
- ✅ **Use mentions** for critical failures

### **Security:**
- ✅ **Keep webhook URLs secure** - Don't commit to version control
- ✅ **Use environment variables** for webhook URLs
- ✅ **Rotate webhook URLs** periodically
- ✅ **Monitor webhook usage** for security

## 🚀 **Next Steps**

### **1. Set Up Your Webhook:**
1. Create a Teams channel
2. Add Incoming Webhook connector
3. Copy the webhook URL
4. Test the connection

### **2. Configure Your Environment:**
```bash
# Set webhook URL
export TEAMS_WEBHOOK_URL="YOUR_WEBHOOK_URL"

# Test connection
python3 send-teams-notification.py --test
```

### **3. Start Using:**
```bash
# Run tests with Teams notification
python3 run-all-tests.py --teams

# Send notification for existing results
python3 send-teams-notification.py
```

## 🎉 **Summary**

### **What You Need:**
1. **Microsoft Teams access** - To create channels and webhooks
2. **Webhook URL** - From the Incoming Webhook connector
3. **Python script** - Already created and ready to use

### **What You Get:**
- 🎉 **Beautiful test notifications** in Teams
- 📊 **Real-time test results** with detailed statistics
- 🔔 **Automatic notifications** after test runs
- 📱 **Mobile access** to test results
- 🌍 **Environment-specific** notifications

The webhook setup is straightforward - just create a Teams channel, add the Incoming Webhook connector, and you're ready to receive beautiful test result notifications! 🚀
