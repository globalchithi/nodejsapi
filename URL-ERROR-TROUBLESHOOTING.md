# 🔧 URL Error Troubleshooting Guide

## 🚨 **"URL Error sending Teams" - Solutions**

### **✅ Good News: No Python Libraries Needed!**

The script uses only **built-in Python libraries**:
- `urllib.request` - For HTTP requests
- `urllib.parse` - For URL parsing  
- `urllib.error` - For error handling
- `json` - For JSON processing
- `xml.etree.ElementTree` - For XML parsing

**You don't need to install any additional Python libraries!** 🎉

## 🔍 **Common URL Error Causes & Solutions**

### **1. Network Connectivity Issues**

#### **Symptoms:**
- "URLError: [Errno 11001] getaddrinfo failed"
- "URLError: [Errno 11002] Name or service not known"
- "Connection timeout"

#### **Solutions:**
```bash
# Test basic connectivity
ping google.com

# Test HTTPS connectivity
curl -I https://www.google.com

# Test with robust script
python3 send-teams-notification-robust.py --test
```

### **2. DNS Resolution Issues**

#### **Symptoms:**
- "URLError: [Errno 11001] getaddrinfo failed"
- "Name or service not known"

#### **Solutions:**
```bash
# Clear DNS cache (Windows)
ipconfig /flushdns

# Clear DNS cache (Mac)
sudo dscacheutil -flushcache

# Clear DNS cache (Linux)
sudo systemctl restart systemd-resolved

# Test DNS resolution
nslookup default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com
```

### **3. Firewall/Proxy Issues**

#### **Symptoms:**
- "URLError: [Errno 11001] getaddrinfo failed"
- "Connection refused"
- "SSL: CERTIFICATE_VERIFY_FAILED"

#### **Solutions:**
```bash
# Test with different timeout
python3 send-teams-notification-robust.py --test

# Check firewall settings
netstat -an | grep 443

# Test with curl
curl -I https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com
```

### **4. Webhook URL Issues**

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

# Use robust script with retries
python3 send-teams-notification-robust.py --test
```

## 🚀 **Quick Fixes**

### **Fix 1: Use Robust Script**
```bash
# Use the robust version with retries and better error handling
python3 send-teams-notification-robust.py --test

# Send test results with robust error handling
python3 send-teams-notification-robust.py --xml TestReports/TestResults.xml
```

### **Fix 2: Test Network Step by Step**
```bash
# 1. Test basic connectivity
python3 -c "import urllib.request; urllib.request.urlopen('https://www.google.com')"

# 2. Test webhook domain
python3 -c "import urllib.request; urllib.request.urlopen('https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com')"

# 3. Test with robust script
python3 send-teams-notification-robust.py --test
```

### **Fix 3: Use Alternative Methods**
```bash
# Use PowerShell instead (Windows)
powershell -ExecutionPolicy Bypass -File "send-teams-notification.ps1"

# Use curl directly
curl -X POST "YOUR_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{"text": "Test message"}'
```

## 🔧 **Advanced Troubleshooting**

### **Test with Python (Step by Step)**
```python
import urllib.request
import urllib.error

# Test 1: Basic connectivity
try:
    urllib.request.urlopen('https://www.google.com')
    print("✅ Basic connectivity: OK")
except Exception as e:
    print(f"❌ Basic connectivity: {e}")

# Test 2: Webhook URL
webhook_url = "YOUR_WEBHOOK_URL"
try:
    urllib.request.urlopen(webhook_url)
    print("✅ Webhook URL: OK")
except urllib.error.HTTPError as e:
    if e.code in [405, 400]:
        print(f"✅ Webhook URL: OK (Expected error: {e.code})")
    else:
        print(f"❌ Webhook URL: {e.code}")
except Exception as e:
    print(f"❌ Webhook URL: {e}")
```

### **Check System Configuration**
```bash
# Check Python version
python3 --version

# Check available libraries
python3 -c "import urllib.request, urllib.parse, urllib.error; print('✅ Libraries available')"

# Check network configuration
ipconfig /all  # Windows
ifconfig      # Mac/Linux
```

## 🎯 **Recommended Solutions**

### **1. Use Robust Script (Recommended)**
```bash
# Use the robust version with retries
python3 send-teams-notification-robust.py --test

# Send test results with robust error handling
python3 send-teams-notification-robust.py --xml TestReports/TestResults.xml
```

### **2. Check Network Settings**
```bash
# Test basic connectivity
ping google.com

# Test HTTPS connectivity
curl -I https://www.google.com

# Test webhook domain
curl -I https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com
```

### **3. Use Alternative Scripts**
```bash
# Use PowerShell version (Windows)
powershell -ExecutionPolicy Bypass -File "send-teams-notification.ps1"

# Use bash version (Mac/Linux)
./send-teams-notification.sh
```

## 🎉 **Summary**

### **What You Need:**
- ✅ **No additional Python libraries** - Uses built-in libraries only
- ✅ **Internet connectivity** - Basic network access
- ✅ **Valid webhook URL** - Teams webhook configured

### **What to Try:**
1. **Use robust script** - `python3 send-teams-notification-robust.py --test`
2. **Check network** - Test basic connectivity
3. **Clear DNS cache** - Refresh DNS resolution
4. **Use alternative methods** - PowerShell, curl, bash

### **Success Indicators:**
- ✅ "Teams notification sent successfully!"
- ✅ Message appears in Teams channel
- ✅ No URL errors in output

The robust script handles URL errors automatically with retries and better error messages! 🚀
