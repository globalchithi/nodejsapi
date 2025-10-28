#!/usr/bin/env python3
"""
Teams Webhook Setup Helper
Helps you set up and test your Microsoft Teams webhook
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

def test_webhook(webhook_url):
    """Test webhook connection"""
    try:
        # Create test payload
        payload = {
            "text": "🧪 Webhook Test",
            "attachments": [
                {
                    "contentType": "application/vnd.microsoft.card.adaptive",
                    "content": {
                        "type": "AdaptiveCard",
                        "body": [
                            {
                                "type": "TextBlock",
                                "text": "Webhook Test",
                                "weight": "Bolder",
                                "size": "Medium"
                            },
                            {
                                "type": "TextBlock",
                                "text": "✅ Your webhook is working correctly!",
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
                return True, "Webhook test successful!"
            else:
                return False, f"Webhook test failed. Status: {response.status}"
                
    except urllib.error.HTTPError as e:
        return False, f"HTTP Error: {e}"
    except urllib.error.URLError as e:
        return False, f"URL Error: {e}"
    except Exception as e:
        return False, f"Unexpected error: {e}"

def get_webhook_url():
    """Get webhook URL from user input or environment"""
    # Check environment variable first
    webhook_url = os.environ.get('TEAMS_WEBHOOK_URL')
    
    if webhook_url:
        safe_print(f"📋 Found webhook URL in environment: {webhook_url[:50]}...")
        return webhook_url
    
    # Ask user for webhook URL
    safe_print("🔗 Please enter your Microsoft Teams webhook URL:")
    safe_print("   (You can get this from Teams > Channel > Connectors > Incoming Webhook)")
    safe_print("")
    
    webhook_url = input("Webhook URL: ").strip()
    
    if not webhook_url:
        safe_print("❌ No webhook URL provided!")
        return None
    
    return webhook_url

def save_webhook_url(webhook_url):
    """Save webhook URL to .env file"""
    env_file = '.env'
    
    # Read existing .env file
    env_content = ""
    if os.path.exists(env_file):
        with open(env_file, 'r') as f:
            env_content = f.read()
    
    # Update or add webhook URL
    if 'TEAMS_WEBHOOK_URL=' in env_content:
        # Update existing
        lines = env_content.split('\n')
        for i, line in enumerate(lines):
            if line.startswith('TEAMS_WEBHOOK_URL='):
                lines[i] = f'TEAMS_WEBHOOK_URL="{webhook_url}"'
                break
        env_content = '\n'.join(lines)
    else:
        # Add new
        if env_content and not env_content.endswith('\n'):
            env_content += '\n'
        env_content += f'TEAMS_WEBHOOK_URL="{webhook_url}"\n'
    
    # Write back to file
    with open(env_file, 'w') as f:
        f.write(env_content)
    
    safe_print(f"💾 Saved webhook URL to {env_file}")

def main():
    safe_print("🚀 Microsoft Teams Webhook Setup Helper")
    safe_print("=" * 50)
    safe_print("")
    
    # Get webhook URL
    webhook_url = get_webhook_url()
    
    if not webhook_url:
        safe_print("❌ Setup cancelled - no webhook URL provided")
        sys.exit(1)
    
    # Test webhook
    safe_print("")
    safe_print("🧪 Testing webhook connection...")
    success, message = test_webhook(webhook_url)
    
    if success:
        safe_print(f"✅ {message}")
        safe_print("")
        safe_print("🎉 Your webhook is working correctly!")
        safe_print("")
        
        # Ask if user wants to save the webhook URL
        save_choice = input("💾 Save this webhook URL to .env file? (y/n): ").strip().lower()
        
        if save_choice in ['y', 'yes']:
            save_webhook_url(webhook_url)
            safe_print("✅ Webhook URL saved to .env file")
        else:
            safe_print("ℹ️ Webhook URL not saved")
        
        safe_print("")
        safe_print("🚀 You can now use the Teams notification features:")
        safe_print("   python3 send-teams-notification.py --test")
        safe_print("   python3 run-all-tests.py --teams")
        
    else:
        safe_print(f"❌ {message}")
        safe_print("")
        safe_print("🔧 Troubleshooting tips:")
        safe_print("   1. Check your webhook URL is correct")
        safe_print("   2. Verify the Teams channel exists")
        safe_print("   3. Check internet connection")
        safe_print("   4. Ensure the webhook connector is enabled")
        safe_print("")
        safe_print("📖 See TEAMS-WEBHOOK-SETUP.md for detailed setup instructions")

if __name__ == "__main__":
    main()
