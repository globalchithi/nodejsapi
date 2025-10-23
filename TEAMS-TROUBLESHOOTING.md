# 🔧 Teams Notification Troubleshooting Guide

## 🚨 **Common Issues and Solutions**

### **Issue 1: "Teams notification failed"**

#### **Possible Causes:**
1. **Internet connectivity issues**
2. **Webhook URL problems**
3. **Teams channel/connector issues**
4. **Firewall/proxy blocking**
5. **XML file missing**

#### **Solutions:**

### **🔍 Step 1: Run Diagnostic Script**
```bash
# Run comprehensive diagnostic
python3 diagnose-teams-issue.py
```

### **🌐 Step 2: Check Internet Connectivity**
```bash
# Test basic connectivity
curl -I https://httpbin.org/get

# Test Teams webhook domain
curl -I https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com
```

### **🔗 Step 3: Test Webhook URL**
```bash
# Test with simple payload
python3 send-teams-notification.py --test

# Test with verbose output
python3 send-teams-notification.py --test --verbose
```

### **📄 Step 4: Check XML File**
```bash
# Check if XML file exists
ls -la TestReports/TestResults.xml

# Check XML file content
head -20 TestReports/TestResults.xml
```

## 🛠️ **Detailed Troubleshooting Steps**

### **1. Internet Connectivity Issues**

#### **Symptoms:**
- "HTTP Error 503: Service Temporarily Unavailable"
- "URLError: [Errno 11001] getaddrinfo failed"
- "Connection timeout"

#### **Solutions:**
```bash
# Test basic connectivity
ping google.com

# Test HTTPS connectivity
curl -I https://www.google.com

# Test with different DNS
nslookup default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com
```

#### **If Internet is Down:**
- Wait for connectivity to restore
- Check your network settings
- Try a different network

### **2. Webhook URL Issues**

#### **Symptoms:**
- "HTTP Error 404: Not Found"
- "HTTP Error 401: Unauthorized"
- "HTTP Error 403: Forbidden"

#### **Solutions:**
```bash
# Test webhook URL directly
curl -X POST "YOUR_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{"text": "Test message"}'

# Check webhook URL format
echo "Your webhook should start with: https://"
```

#### **If Webhook URL is Wrong:**
1. **Get new webhook URL from Teams:**
   - Go to Teams channel
   - Click "..." → "Connectors"
   - Find "Incoming Webhook"
   - Click "Configure"
   - Copy the new URL

2. **Update webhook URL:**
   ```bash
   # Set environment variable
   export TEAMS_WEBHOOK_URL="YOUR_NEW_WEBHOOK_URL"
   
   # Or update .env file
   echo 'TEAMS_WEBHOOK_URL="YOUR_NEW_WEBHOOK_URL"' >> .env
   ```

### **3. Teams Channel Issues**

#### **Symptoms:**
- "HTTP Error 400: Bad Request"
- "HTTP Error 500: Internal Server Error"

#### **Solutions:**
1. **Check Teams channel exists**
2. **Verify webhook connector is enabled**
3. **Check channel permissions**
4. **Try a different channel**

### **4. XML File Issues**

#### **Symptoms:**
- "XML file not found"
- "Failed to parse XML file"
- "No test results found"

#### **Solutions:**
```bash
# Run tests to generate XML file
python3 run-all-tests.py --category inventory

# Check if XML file was created
ls -la TestReports/

# Test XML parsing
python3 send-teams-notification.py --xml TestReports/TestResults.xml
```

### **5. Firewall/Proxy Issues**

#### **Symptoms:**
- "Connection timeout"
- "URLError: [Errno 11001] getaddrinfo failed"
- "SSL: CERTIFICATE_VERIFY_FAILED"

#### **Solutions:**
```bash
# Test with different timeout
python3 send-teams-notification.py --test --timeout 60

# Test with different user agent
python3 send-teams-notification.py --test --user-agent "Custom Agent"
```

## 🔧 **Advanced Troubleshooting**

### **Test with curl (Direct HTTP)**
```bash
# Test webhook with curl
curl -X POST "YOUR_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Test message",
    "attachments": [
      {
        "contentType": "application/vnd.microsoft.card.adaptive",
        "content": {
          "type": "AdaptiveCard",
          "body": [
            {
              "type": "TextBlock",
              "text": "Test Card",
              "weight": "Bolder"
            }
          ],
          "version": "1.0"
        }
      }
    ]
  }'
```

### **Test with Python (Direct)**
```python
import urllib.request
import json

webhook_url = "YOUR_WEBHOOK_URL"
payload = {"text": "Test message"}

req = urllib.request.Request(
    webhook_url,
    data=json.dumps(payload).encode('utf-8'),
    headers={'Content-Type': 'application/json'}
)

try:
    with urllib.request.urlopen(req) as response:
        print(f"Success: {response.status}")
except Exception as e:
    print(f"Error: {e}")
```

### **Check Network Configuration**
```bash
# Check DNS resolution
nslookup default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com

# Check SSL certificate
openssl s_client -connect default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com:443

# Check firewall rules
netstat -an | grep 443
```

## 🚀 **Quick Fixes**

### **Fix 1: Restart Network**
```bash
# Restart network service (Linux/Mac)
sudo systemctl restart NetworkManager

# Or restart network interface
sudo ifdown eth0 && sudo ifup eth0
```

### **Fix 2: Clear DNS Cache**
```bash
# Clear DNS cache (Mac)
sudo dscacheutil -flushcache

# Clear DNS cache (Linux)
sudo systemctl restart systemd-resolved

# Clear DNS cache (Windows)
ipconfig /flushdns
```

### **Fix 3: Use Different Webhook**
```bash
# Create new webhook in Teams
# Update webhook URL
export TEAMS_WEBHOOK_URL="NEW_WEBHOOK_URL"
python3 send-teams-notification.py --test
```

### **Fix 4: Use Alternative Method**
```bash
# Use PowerShell instead of Python
powershell -ExecutionPolicy Bypass -File "send-teams-notification.ps1"

# Use curl directly
curl -X POST "YOUR_WEBHOOK_URL" -H "Content-Type: application/json" -d '{"text": "Test"}'
```

## 📞 **Getting Help**

### **If Nothing Works:**
1. **Check Teams channel** - Look for error messages
2. **Check network logs** - Look for connection errors
3. **Try different network** - Mobile hotspot, different WiFi
4. **Contact IT support** - Network/firewall issues
5. **Check Teams status** - https://status.office.com

### **Debug Information to Collect:**
```bash
# Run diagnostic and save output
python3 diagnose-teams-issue.py > teams-debug.log 2>&1

# Check system information
uname -a
python3 --version
curl --version
```

## 🎯 **Success Indicators**

### **When Everything is Working:**
- ✅ "Teams notification sent successfully!"
- ✅ Message appears in Teams channel
- ✅ Beautiful Adaptive Card with test results
- ✅ All test statistics displayed correctly

### **Test Commands:**
```bash
# Test basic connection
python3 send-teams-notification.py --test

# Test with existing results
python3 send-teams-notification.py

# Test with new results
python3 run-all-tests.py --teams
```

## 🎉 **Summary**

The most common causes of Teams notification failures are:
1. **Internet connectivity issues** (most common)
2. **Webhook URL problems**
3. **Missing XML file**
4. **Firewall/proxy blocking**

Start with the diagnostic script and work through the solutions step by step! 🚀
