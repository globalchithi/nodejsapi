#!/usr/bin/env python3
"""
Microsoft Teams Notification Script
Sends test summary results to Microsoft Teams using Adaptive Cards
"""

import os
import sys
import json
import urllib.request
import urllib.parse
import urllib.error
import argparse
from datetime import datetime
import xml.etree.ElementTree as ET
import re
import ssl

def safe_print(text):
    """Safely print text that may contain Unicode characters"""
    try:
        print(text)
    except UnicodeEncodeError:
        # Fallback for Windows Command Prompt
        print(text.encode('ascii', 'replace').decode('ascii'))

def parse_xml_file(xml_file):
    """Parse XML file and extract test results"""
    try:
        # Try different encodings
        encodings = ['utf-8', 'utf-8-sig', 'ascii', 'latin-1']
        
        for encoding in encodings:
            try:
                with open(xml_file, 'r', encoding=encoding) as f:
                    content = f.read()
                
                # Clean the content first
                content = clean_xml_content(content)
                
                # Try to parse as XML
                tree = ET.fromstring(content)
                return extract_from_xml_tree(tree)
            except Exception as e:
                continue
        
        # If XML parsing fails, use regex
        return parse_xml_with_regex(xml_file)
        
    except Exception as e:
        safe_print(f"Error parsing XML file: {e}")
        return None

def clean_xml_content(xml_content):
    """Clean and fix malformed XML content"""
    # Remove any content after the closing </assemblies> tag
    if '</assemblies>' in xml_content:
        xml_content = xml_content[:xml_content.rfind('</assemblies>') + len('</assemblies>')]
    
    # Remove any extra content or junk
    lines = xml_content.split('\n')
    cleaned_lines = []
    in_xml = False
    
    for line in lines:
        line = line.strip()
        if line.startswith('<assemblies') or in_xml:
            in_xml = True
            cleaned_lines.append(line)
            if line.endswith('</assemblies>'):
                break
    
    return '\n'.join(cleaned_lines)

def parse_xml_with_regex(xml_file):
    """Parse XML using regex as fallback when XML parsing fails"""
    try:
        with open(xml_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        try:
            with open(xml_file, 'r', encoding='latin-1') as f:
                content = f.read()
        except:
            with open(xml_file, 'r', encoding='ascii', errors='ignore') as f:
                content = f.read()
    
    # Clean the content
    content = clean_xml_content(content)
    
    # Extract test data using regex
    test_details = []
    
    # Try xUnit format first - more flexible pattern that doesn't depend on attribute order
    test_pattern = r'<test[^>]*name="([^"]*)"[^>]*result="([^"]*)"[^>]*time="([^"]*)"[^>]*type="([^"]*)"[^>]*>'
    test_matches = re.findall(test_pattern, content)
    
    # If the above pattern doesn't work, try a simpler approach
    if not test_matches:
        # Extract name, result, time, and type separately
        name_pattern = r'<test[^>]*name="([^"]*)"'
        result_pattern = r'<test[^>]*result="([^"]*)"'
        time_pattern = r'<test[^>]*time="([^"]*)"'
        type_pattern = r'<test[^>]*type="([^"]*)"'
        
        names = re.findall(name_pattern, content)
        results = re.findall(result_pattern, content)
        times = re.findall(time_pattern, content)
        types = re.findall(type_pattern, content)
        
        # Combine them if we have the same number of each
        if len(names) == len(results) == len(times) == len(types):
            test_matches = list(zip(names, results, times, types))
    
    for match in test_matches:
        test_name, test_result, test_time, test_type = match
        
        # Extract class name from type
        if test_type and '.' in test_type:
            class_name = test_type.split('.')[-1]
        else:
            class_name = test_type if test_type else 'Unknown'
        
        # Format display name
        display_name = test_name.split('.')[-1].replace('_', ' ')
        
        # Parse time
        try:
            duration = float(test_time)
        except ValueError:
            duration = 0.0
        
        test_details.append({
            'name': display_name,
            'full_name': test_name,
            'class': class_name,
            'result': test_result,
            'duration': duration,
            'duration_ms': round(duration * 1000, 2)
        })
    
    # If no xUnit tests found, try TRX format
    if not test_details:
        trx_pattern = r'<UnitTestResult[^>]*testName="([^"]*)"[^>]*outcome="([^"]*)"[^>]*duration="([^"]*)"[^>]*>'
        trx_matches = re.findall(trx_pattern, content)
        
        for match in trx_matches:
            test_name, test_result, test_duration = match
            
            # Extract class name from test name
            if '.' in test_name:
                parts = test_name.split('.')
                class_name = parts[-2] if len(parts) > 1 else 'Unknown'
                display_name = parts[-1].replace('_', ' ')
            else:
                class_name = 'Unknown'
                display_name = test_name.replace('_', ' ')
            
            # Map TRX outcome to standard result
            if test_result == 'Passed':
                test_result = 'Pass'
            elif test_result == 'Failed':
                test_result = 'Fail'
            elif test_result == 'Skipped':
                test_result = 'Skip'
            
            # Parse duration (TRX format: HH:MM:SS.fffffff)
            try:
                duration_parts = test_duration.split(':')
                if len(duration_parts) >= 3:
                    duration = float(duration_parts[-1])  # Get seconds part
                else:
                    duration = 0.0
            except ValueError:
                duration = 0.0
            
            test_details.append({
                'name': display_name,
                'full_name': test_name,
                'class': class_name,
                'result': test_result,
                'duration': duration,
                'duration_ms': round(duration * 1000, 2)
            })
    
    # Calculate statistics
    total_tests = len(test_details)
    passed_tests = len([t for t in test_details if t['result'] == 'Pass'])
    failed_tests = len([t for t in test_details if t['result'] == 'Fail'])
    skipped_tests = len([t for t in test_details if t['result'] == 'Skip'])
    success_rate = round((passed_tests / total_tests) * 100, 1) if total_tests > 0 else 0
    
    
    return {
        'total_tests': total_tests,
        'passed_tests': passed_tests,
        'failed_tests': failed_tests,
        'skipped_tests': skipped_tests,
        'success_rate': success_rate,
        'test_details': test_details
    }

def extract_from_xml_tree(tree):
    """Extract test data from XML tree"""
    test_details = []
    
    # Try xUnit format first (assemblies > assembly > collection > test)
    for test in tree.findall('.//test'):
        test_name = test.get('name', 'Unknown Test')
        test_result = test.get('result', 'Unknown')
        test_time = float(test.get('time', 0))
        test_type = test.get('type', 'Unknown')
        
        # Extract class name from type
        if test_type and '.' in test_type:
            class_name = test_type.split('.')[-1]
        else:
            class_name = test_type if test_type else 'Unknown'
        
        # Format display name
        display_name = test_name.split('.')[-1].replace('_', ' ')
        
        test_details.append({
            'name': display_name,
            'full_name': test_name,
            'class': class_name,
            'result': test_result,
            'duration': test_time,
            'duration_ms': round(test_time * 1000, 2)
        })
    
    # If no tests found in xUnit format, try TRX format
    if not test_details:
        for test in tree.findall('.//UnitTestResult'):
            test_name = test.get('testName', 'Unknown Test')
            test_result = test.get('outcome', 'Unknown')
            test_time = float(test.get('duration', '00:00:00.0000000').split(':')[-1])
            
            # Extract class name from test name
            if '.' in test_name:
                parts = test_name.split('.')
                class_name = parts[-2] if len(parts) > 1 else 'Unknown'
                display_name = parts[-1].replace('_', ' ')
            else:
                class_name = 'Unknown'
                display_name = test_name.replace('_', ' ')
            
            # Map TRX outcome to standard result
            if test_result == 'Passed':
                test_result = 'Pass'
            elif test_result == 'Failed':
                test_result = 'Fail'
            elif test_result == 'Skipped':
                test_result = 'Skip'
            
            test_details.append({
                'name': display_name,
                'full_name': test_name,
                'class': class_name,
                'result': test_result,
                'duration': test_time,
                'duration_ms': round(test_time * 1000, 2)
            })
    
    # Calculate statistics
    total_tests = len(test_details)
    passed_tests = len([t for t in test_details if t['result'] == 'Pass'])
    failed_tests = len([t for t in test_details if t['result'] == 'Fail'])
    skipped_tests = len([t for t in test_details if t['result'] == 'Skip'])
    success_rate = round((passed_tests / total_tests) * 100, 1) if total_tests > 0 else 0
    
    
    return {
        'total_tests': total_tests,
        'passed_tests': passed_tests,
        'failed_tests': failed_tests,
        'skipped_tests': skipped_tests,
        'success_rate': success_rate,
        'test_details': test_details
    }

def format_duration(seconds):
    """Format duration in a human-readable way"""
    if seconds < 60:
        return f"{seconds:.1f}s"
    elif seconds < 3600:
        minutes = int(seconds // 60)
        remaining_seconds = int(seconds % 60)
        return f"{minutes}m {remaining_seconds}s"
    else:
        hours = int(seconds // 3600)
        minutes = int((seconds % 3600) // 60)
        return f"{hours}h {minutes}m"

def create_teams_payload(test_data, environment="Staging"):
    """Create Microsoft Teams Adaptive Card payload"""
    timestamp = datetime.now().strftime("%m/%d/%Y, %I:%M:%S %p")
    
    # Calculate total duration from test details
    total_duration = sum(test['duration'] for test in test_data['test_details'])
    duration_formatted = format_duration(total_duration)
    
    # Determine status message and color
    if test_data['failed_tests'] == 0:
        status_message = f"✅ All {test_data['total_tests']} tests passed successfully!"
        status_color = "Good"
    else:
        status_message = f"⚠️ {test_data['passed_tests']} passed, {test_data['failed_tests']} failed"
        status_color = "Warning"
    
    payload = {
        "text": "🚀 Test Automation Results",
        "attachments": [
            {
                "contentType": "application/vnd.microsoft.card.adaptive",
                "content": {
                    "type": "AdaptiveCard",
                    "body": [
                        {
                            "type": "TextBlock",
                            "text": "API Test Results",
                            "weight": "Bolder",
                            "size": "Medium"
                        },
                        {
                            "type": "TextBlock",
                            "text": status_message,
                            "wrap": True
                        },
                        {
                            "type": "FactSet",
                            "facts": [
                                {
                                    "title": "Environment",
                                    "value": environment
                                },
                                {
                                    "title": "Total Tests",
                                    "value": str(test_data['total_tests'])
                                },
                                {
                                    "title": "Passed",
                                    "value": str(test_data['passed_tests'])
                                },
                                {
                                    "title": "Failed",
                                    "value": str(test_data['failed_tests'])
                                },
                                {
                                    "title": "Success Rate",
                                    "value": f"{test_data['success_rate']}%"
                                },
                                {
                                    "title": "Duration",
                                    "value": duration_formatted
                                },
                                {
                                    "title": "Timestamp",
                                    "value": timestamp
                                }
                            ]
                        }
                    ],
                    "version": "1.0"
                }
            }
        ]
    }
    
    return payload

def send_teams_notification(webhook_url, payload):
    """Send notification to Microsoft Teams"""
    try:
        # Convert payload to JSON
        json_data = json.dumps(payload).encode('utf-8')
        
        # Create request
        req = urllib.request.Request(
            webhook_url,
            data=json_data,
            headers={'Content-Type': 'application/json'}
        )
        
        # Create SSL context that doesn't verify certificates (for Teams webhooks)
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        # Send request with SSL context
        with urllib.request.urlopen(req, timeout=30, context=ssl_context) as response:
            if response.status in [200, 202]:
                safe_print("✅ Teams notification sent successfully!")
                return True
            else:
                safe_print(f"❌ Failed to send Teams notification. Status: {response.status}")
                return False
                
    except urllib.error.HTTPError as e:
        safe_print(f"❌ HTTP Error sending Teams notification: {e}")
        return False
    except urllib.error.URLError as e:
        safe_print(f"❌ URL Error sending Teams notification: {e}")
        return False
    except Exception as e:
        safe_print(f"❌ Unexpected error: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Send test results to Microsoft Teams')
    parser.add_argument('--xml', default='TestReports/TestResults.xml', help='XML file path')
    parser.add_argument('--webhook', help='Microsoft Teams webhook URL')
    parser.add_argument('--environment', default='Staging', help='Environment name')
    parser.add_argument('--test', action='store_true', help='Send test notification')
    
    args = parser.parse_args()
    
    
    # Default webhook URL (from your curl command)
    default_webhook = "https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0d24a9464a6a49bfb869e82691dcba5e/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=GfEveRKN8pJuVa0-xWnNp5-EHLU0Oygkh53ZhvdENjM"
    
    webhook_url = args.webhook or default_webhook
    
    safe_print("🚀 Microsoft Teams Test Notification")
    safe_print("=" * 40)
    
    if args.test:
        # Send test notification
        safe_print("📤 Sending test notification...")
        test_payload = {
            "text": "🧪 Test Notification",
            "attachments": [
                {
                    "contentType": "application/vnd.microsoft.card.adaptive",
                    "content": {
                        "type": "AdaptiveCard",
                        "body": [
                            {
                                "type": "TextBlock",
                                "text": "Test Notification",
                                "weight": "Bolder",
                                "size": "Medium"
                            },
                            {
                                "type": "TextBlock",
                                "text": "✅ Teams integration is working correctly!",
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
        
        if send_teams_notification(webhook_url, test_payload):
            safe_print("🎉 Test notification sent successfully!")
        else:
            safe_print("❌ Test notification failed!")
            sys.exit(1)
        return
    
    # Parse XML file
    if not os.path.exists(args.xml):
        safe_print(f"❌ XML file not found: {args.xml}")
        sys.exit(1)
    
    safe_print(f"📄 Parsing XML file: {args.xml}")
    test_data = parse_xml_file(args.xml)
    
    if test_data is None:
        safe_print("❌ Failed to parse XML file")
        sys.exit(1)
    
    # Print test statistics
    safe_print("📊 Test Statistics:")
    safe_print(f"   Total Tests: {test_data['total_tests']}")
    safe_print(f"   Passed: {test_data['passed_tests']}")
    safe_print(f"   Failed: {test_data['failed_tests']}")
    safe_print(f"   Skipped: {test_data['skipped_tests']}")
    safe_print(f"   Success Rate: {test_data['success_rate']}%")
    
    # Create Teams payload
    safe_print("📤 Creating Teams notification...")
    payload = create_teams_payload(test_data, args.environment)
    
    # Send notification
    safe_print("📤 Sending notification to Microsoft Teams...")
    if send_teams_notification(webhook_url, payload):
        safe_print("🎉 Teams notification sent successfully!")
    else:
        safe_print("❌ Teams notification failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()
