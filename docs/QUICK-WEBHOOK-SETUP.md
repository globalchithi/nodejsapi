# 🔗 Quick Teams Webhook Setup

## 🚀 **Where to Set Up Your Webhook**

### **Step 1: Open Microsoft Teams**
1. **Go to Microsoft Teams** (teams.microsoft.com or desktop app)
2. **Navigate to your team** (or create a new team)
3. **Create a new channel** for test notifications

### **Step 2: Create a Channel**
1. **Click the "+" next to channels**
2. **Name it**: `#test-results` or `#api-testing`
3. **Set as Standard channel** (not private)

### **Step 3: Add Webhook Connector**
1. **In your channel**, click the **"..."** (more options)
2. **Select "Connectors"**
3. **Find "Incoming Webhook"**
4. **Click "Configure"**

### **Step 4: Configure Webhook**
1. **Name**: "VaxCare API Test Results"
2. **Upload icon** (optional): Test-related icon
3. **Click "Create"**
4. **Copy the webhook URL** - This is your webhook URL!

## 🔧 **Your Current Webhook URL**

Based on your curl command, you already have a webhook URL:
```
https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0d24a9464a6a49bfb869e82691dcba5e/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=GfEveRKN8pJuVa0-xWnNp5-EHLU0Oygkh53ZhvdENjM
```

**This webhook is already configured in the script!** You don't need to set up a new one.

## 🧪 **Test Your Webhook**

### **Option 1: Test with Default Webhook**
```bash
# Test the default webhook (already configured)
python3 send-teams-notification.py --test
```

### **Option 2: Test with Custom Webhook**
```bash
# Test with your own webhook URL
python3 send-teams-notification.py --webhook "YOUR_WEBHOOK_URL" --test
```

### **Option 3: Use Setup Helper**
```bash
# Interactive setup helper
python3 setup-teams-webhook.py
```

## 🎯 **Quick Start Commands**

### **Test Webhook Connection:**
```bash
python3 send-teams-notification.py --test
```

### **Send Test Results:**
```bash
python3 send-teams-notification.py
```

### **Run Tests with Teams Notification:**
```bash
python3 run-all-tests.py --teams
```

## 📱 **What You'll See in Teams**

When you run the test, you should see a message like this in your Teams channel:

```
🧪 Webhook Test

Webhook Test
✅ Your webhook is working correctly!

Status: Connected
Timestamp: 10/23/2025, 11:30:00 AM
```

## 🔧 **Configuration Options**

### **Use Default Webhook (Recommended)**
The script already includes your webhook URL, so you can use it immediately:
```bash
python3 send-teams-notification.py --test
```

### **Use Custom Webhook**
If you want to use a different webhook:
```bash
python3 send-teams-notification.py --webhook "YOUR_WEBHOOK_URL" --test
```

### **Set Environment Variable**
```bash
export TEAMS_WEBHOOK_URL="YOUR_WEBHOOK_URL"
python3 send-teams-notification.py --test
```

## 🚀 **Ready to Use!**

Your webhook is already configured and ready to use! Just run:

```bash
# Test the connection
python3 send-teams-notification.py --test

# Send test results
python3 send-teams-notification.py

# Run tests with Teams notification
python3 run-all-tests.py --teams
```

## 🎉 **Summary**

- ✅ **Your webhook is already configured** in the script
- ✅ **No additional setup needed** - just run the commands
- ✅ **Test the connection** with `python3 send-teams-notification.py --test`
- ✅ **Start using** with `python3 run-all-tests.py --teams`

The webhook setup is complete and ready to use! 🚀
