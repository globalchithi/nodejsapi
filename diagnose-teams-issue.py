#!/usr/bin/env python3
"""
Teams Notification Diagnostic Script
Helps troubleshoot Teams notification issues
"""

import os
import sys
import json
import urllib.request
import urllib.parse
import urllib.error
from datetime import datetime

def safe_print(text):
    """Safely print text that may contain Unicode characters"""
    try:
        print(text)
    except UnicodeEncodeError:
        print(text.encode('ascii', 'replace').decode('ascii'))

def test_basic_connectivity():
    """Test basic internet connectivity"""
    safe_print("🌐 Testing basic internet connectivity...")
    
    try:
        # Test with a simple HTTP request
        req = urllib.request.Request('https://httpbin.org/get')
        with urllib.request.urlopen(req, timeout=10) as response:
            if response.status == 200:
                safe_print("✅ Internet connectivity: OK")
                return True
            else:
                safe_print(f"❌ Internet connectivity: Failed (Status: {response.status})")
                return False
    except Exception as e:
        safe_print(f"❌ Internet connectivity: Failed ({e})")
        return False

def test_webhook_url(webhook_url):
    """Test webhook URL accessibility"""
    safe_print(f"🔗 Testing webhook URL accessibility...")
    safe_print(f"   URL: {webhook_url[:50]}...")
    
    try:
        # Test with a simple GET request first
        req = urllib.request.Request(webhook_url)
        with urllib.request.urlopen(req, timeout=10) as response:
            safe_print(f"✅ Webhook URL accessible (Status: {response.status})")
            return True
    except urllib.error.HTTPError as e:
        if e.code in [405, 400]:  # Method not allowed or bad request is expected for GET
            safe_print(f"✅ Webhook URL accessible (Expected error for GET: {e.code})")
            return True
        else:
            safe_print(f"❌ Webhook URL error: {e.code} - {e.reason}")
            return False
    except urllib.error.URLError as e:
        safe_print(f"❌ Webhook URL error: {e}")
        return False
    except Exception as e:
        safe_print(f"❌ Webhook URL error: {e}")
        return False

def test_webhook_payload(webhook_url):
    """Test webhook with a simple payload"""
    safe_print("📤 Testing webhook with simple payload...")
    
    try:
        # Create simple test payload
        payload = {
            "text": "🧪 Teams Diagnostic Test",
            "attachments": [
                {
                    "contentType": "application/vnd.microsoft.card.adaptive",
                    "content": {
                        "type": "AdaptiveCard",
                        "body": [
                            {
                                "type": "TextBlock",
                                "text": "Diagnostic Test",
                                "weight": "Bolder",
                                "size": "Medium"
                            },
                            {
                                "type": "TextBlock",
                                "text": "✅ Teams webhook is working correctly!",
                                "wrap": True
                            },
                            {
                                "type": "FactSet",
                                "facts": [
                                    {
                                        "title": "Status",
                                        "value": "Connected"
                                    },
                                    {
                                        "title": "Timestamp",
                                        "value": datetime.now().strftime("%m/%d/%Y, %I:%M:%S %p")
                                    }
                                ]
                            }
                        ],
                        "version": "1.0"
                    }
                }
            ]
        }
        
        # Convert to JSON
        json_data = json.dumps(payload).encode('utf-8')
        
        # Create request
        req = urllib.request.Request(
            webhook_url,
            data=json_data,
            headers={'Content-Type': 'application/json'}
        )
        
        # Send request
        with urllib.request.urlopen(req, timeout=30) as response:
            if response.status in [200, 202]:
                safe_print("✅ Webhook payload test: SUCCESS")
                return True
            else:
                safe_print(f"❌ Webhook payload test: FAILED (Status: {response.status})")
                return False
                
    except urllib.error.HTTPError as e:
        safe_print(f"❌ Webhook payload test: HTTP Error {e.code} - {e.reason}")
        try:
            error_body = e.read().decode('utf-8')
            safe_print(f"   Error details: {error_body}")
        except:
            pass
        return False
    except urllib.error.URLError as e:
        safe_print(f"❌ Webhook payload test: URL Error - {e}")
        return False
    except Exception as e:
        safe_print(f"❌ Webhook payload test: Unexpected error - {e}")
        return False

def check_xml_file():
    """Check if XML file exists and is readable"""
    safe_print("📄 Checking XML file...")
    
    xml_file = "TestReports/TestResults.xml"
    
    if not os.path.exists(xml_file):
        safe_print(f"❌ XML file not found: {xml_file}")
        safe_print("   Run tests first to generate XML file")
        return False
    
    try:
        with open(xml_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        if len(content) > 0:
            safe_print(f"✅ XML file exists and is readable ({len(content)} characters)")
            return True
        else:
            safe_print("❌ XML file is empty")
            return False
    except Exception as e:
        safe_print(f"❌ XML file error: {e}")
        return False

def get_webhook_url():
    """Get webhook URL from various sources"""
    safe_print("🔍 Looking for webhook URL...")
    
    # Check environment variable
    webhook_url = os.environ.get('TEAMS_WEBHOOK_URL')
    if webhook_url:
        safe_print("✅ Found webhook URL in environment variable")
        return webhook_url
    
    # Check .env file
    if os.path.exists('.env'):
        try:
            with open('.env', 'r') as f:
                for line in f:
                    if line.startswith('TEAMS_WEBHOOK_URL='):
                        webhook_url = line.split('=', 1)[1].strip().strip('"\'')
                        safe_print("✅ Found webhook URL in .env file")
                        return webhook_url
        except Exception as e:
            safe_print(f"⚠️ Error reading .env file: {e}")
    
    # Use default webhook from script
    default_webhook = "https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0d24a9464a6a49bfb869e82691dcba5e/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=GfEveRKN8pJuVa0-xWnNp5-EHLU0Oygkh53ZhvdENjM"
    safe_print("✅ Using default webhook URL from script")
    return default_webhook

def main():
    safe_print("🔧 Teams Notification Diagnostic Tool")
    safe_print("=" * 50)
    safe_print("")
    
    # Step 1: Check internet connectivity
    if not test_basic_connectivity():
        safe_print("❌ Cannot proceed without internet connectivity")
        return
    
    safe_print("")
    
    # Step 2: Get webhook URL
    webhook_url = get_webhook_url()
    if not webhook_url:
        safe_print("❌ No webhook URL found")
        safe_print("   Set TEAMS_WEBHOOK_URL environment variable or create .env file")
        return
    
    safe_print("")
    
    # Step 3: Test webhook URL accessibility
    if not test_webhook_url(webhook_url):
        safe_print("❌ Webhook URL is not accessible")
        safe_print("   Check your webhook URL and internet connection")
        return
    
    safe_print("")
    
    # Step 4: Test webhook with payload
    if not test_webhook_payload(webhook_url):
        safe_print("❌ Webhook payload test failed")
        safe_print("   Check your webhook URL and Teams channel")
        return
    
    safe_print("")
    
    # Step 5: Check XML file
    xml_ok = check_xml_file()
    
    safe_print("")
    safe_print("🎉 Diagnostic Summary:")
    safe_print("=" * 30)
    safe_print("✅ Internet connectivity: OK")
    safe_print("✅ Webhook URL: Accessible")
    safe_print("✅ Webhook payload: Working")
    
    if xml_ok:
        safe_print("✅ XML file: Available")
        safe_print("")
        safe_print("🚀 All systems are working! Try running:")
        safe_print("   python3 send-teams-notification.py --test")
        safe_print("   python3 run-all-tests.py --teams")
    else:
        safe_print("⚠️ XML file: Missing")
        safe_print("")
        safe_print("🔧 To fix: Run tests first to generate XML file")
        safe_print("   python3 run-all-tests.py --category inventory")

if __name__ == "__main__":
    main()
