#!/usr/bin/env python3
"""
Microsoft Teams Notification with PDF Download Link
Sends test results with PDF download link to Microsoft Teams
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
import base64
import mimetypes
import shutil

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
    
    # Find all test elements using regex
    test_pattern = r'<test[^>]*name="([^"]*)"[^>]*result="([^"]*)"[^>]*time="([^"]*)"[^>]*type="([^"]*)"[^>]*>'
    test_matches = re.findall(test_pattern, content)
    
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
    
    # Find all test elements
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

def create_download_link(pdf_file, web_server_url="http://localhost:8080"):
    """Create a download link for the PDF file"""
    # Copy PDF to a web-accessible directory
    web_dir = "web-downloads"
    if not os.path.exists(web_dir):
        os.makedirs(web_dir)
    
    # Copy PDF file to web directory
    pdf_filename = os.path.basename(pdf_file)
    web_pdf_path = os.path.join(web_dir, pdf_filename)
    shutil.copy2(pdf_file, web_pdf_path)
    
    # Create download link
    download_url = f"{web_server_url}/{pdf_filename}"
    return download_url, web_pdf_path

def start_web_server(port=8080):
    """Start a simple web server to serve PDF files"""
    import http.server
    import socketserver
    import threading
    
    web_dir = "web-downloads"
    if not os.path.exists(web_dir):
        os.makedirs(web_dir)
    
    os.chdir(web_dir)
    
    handler = http.server.SimpleHTTPRequestHandler
    httpd = socketserver.TCPServer(("", port), handler)
    
    def run_server():
        safe_print(f"🌐 Starting web server on port {port}...")
        httpd.serve_forever()
    
    server_thread = threading.Thread(target=run_server, daemon=True)
    server_thread.start()
    
    return httpd

def create_teams_payload_with_download_link(test_data, pdf_file, download_url, environment="Staging"):
    """Create Microsoft Teams Adaptive Card payload with PDF download link"""
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
    
    # Get file info
    file_size = os.path.getsize(pdf_file)
    file_size_mb = round(file_size / (1024 * 1024), 2)
    file_name = os.path.basename(pdf_file)
    
    payload = {
        "text": "🚀 Test Automation Results with PDF Download",
        "attachments": [
            {
                "contentType": "application/vnd.microsoft.card.adaptive",
                "content": {
                    "type": "AdaptiveCard",
                    "body": [
                        {
                            "type": "TextBlock",
                            "text": "API Test Results with PDF Download",
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
                                    "title": "PDF Report",
                                    "value": f"{file_name} ({file_size_mb} MB)"
                                },
                                {
                                    "title": "Timestamp",
                                    "value": timestamp
                                }
                            ]
                        },
                        {
                            "type": "TextBlock",
                            "text": f"📎 **PDF Download Link**: [Click here to download {file_name}]({download_url})",
                            "wrap": True,
                            "weight": "Bolder"
                        },
                        {
                            "type": "TextBlock",
                            "text": f"🔗 **Direct Link**: {download_url}",
                            "wrap": True,
                            "size": "Small"
                        }
                    ],
                    "version": "1.0"
                }
            }
        ]
    }
    
    return payload

def send_teams_notification_with_download_link(webhook_url, payload):
    """Send notification to Microsoft Teams with PDF download link"""
    try:
        # Convert payload to JSON
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
                safe_print("✅ Teams notification with download link sent successfully!")
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

def find_latest_pdf_file(directory="TestReports"):
    """Find the latest PDF file in the directory"""
    import glob
    
    pdf_files = glob.glob(os.path.join(directory, "**", "*.pdf"), recursive=True)
    
    if not pdf_files:
        return None
    
    # Get the most recent PDF file
    latest_file = max(pdf_files, key=os.path.getmtime)
    return latest_file

def main():
    parser = argparse.ArgumentParser(description='Send test results with PDF download link to Microsoft Teams')
    parser.add_argument('--xml', default='TestReports/TestResults.xml', help='XML file path')
    parser.add_argument('--pdf', help='PDF file path (if not provided, will find latest PDF)')
    parser.add_argument('--webhook', help='Microsoft Teams webhook URL')
    parser.add_argument('--environment', default='Staging', help='Environment name')
    parser.add_argument('--web-server', default='http://localhost:8080', help='Web server URL for downloads')
    parser.add_argument('--port', type=int, default=8080, help='Web server port')
    parser.add_argument('--test', action='store_true', help='Send test notification')
    
    args = parser.parse_args()
    
    # Default webhook URL
    default_webhook = "https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0d24a9464a6a49bfb869e82691dcba5e/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=GfEveRKN8pJuVa0-xWnNp5-EHLU0Oygkh53ZhvdENjM"
    
    webhook_url = args.webhook or default_webhook
    
    safe_print("🚀 Microsoft Teams Test Notification with PDF Download")
    safe_print("=" * 60)
    
    if args.test:
        # Send test notification
        safe_print("📤 Sending test notification...")
        test_payload = {
            "text": "🧪 Test Notification with PDF Download",
            "attachments": [
                {
                    "contentType": "application/vnd.microsoft.card.adaptive",
                    "content": {
                        "type": "AdaptiveCard",
                        "body": [
                            {
                                "type": "TextBlock",
                                "text": "Test Notification with PDF Download",
                                "weight": "Bolder",
                                "size": "Medium"
                            },
                            {
                                "type": "TextBlock",
                                "text": "✅ Teams integration with PDF download is working correctly!",
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
                                        "title": "PDF Download",
                                        "value": "Ready"
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
        
        if send_teams_notification_with_download_link(webhook_url, test_payload):
            safe_print("🎉 Test notification sent successfully!")
        else:
            safe_print("❌ Test notification failed!")
            sys.exit(1)
        return
    
    # Determine PDF file
    if args.pdf:
        pdf_file = args.pdf
    else:
        pdf_file = find_latest_pdf_file()
        if not pdf_file:
            safe_print("❌ No PDF files found in TestReports directory")
            safe_print("💡 Generate a PDF first using: python3 convert-html-to-pdf.py")
            sys.exit(1)
        safe_print(f"📄 Using latest PDF file: {pdf_file}")
    
    # Check if PDF file exists
    if not os.path.exists(pdf_file):
        safe_print(f"❌ PDF file not found: {pdf_file}")
        sys.exit(1)
    
    # Create download link
    safe_print("🔗 Creating download link...")
    download_url, web_pdf_path = create_download_link(pdf_file, args.web_server)
    safe_print(f"📎 Download link created: {download_url}")
    
    # Start web server
    safe_print("🌐 Starting web server...")
    httpd = start_web_server(args.port)
    safe_print(f"🌐 Web server started on port {args.port}")
    safe_print(f"📁 Serving files from: {os.path.abspath('web-downloads')}")
    
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
    safe_print(f"   Success Rate: {test_data['success_rate']}%")
    safe_print(f"   PDF File: {os.path.basename(pdf_file)}")
    safe_print(f"   Download URL: {download_url}")
    
    # Create Teams payload
    safe_print("📤 Creating Teams notification with download link...")
    payload = create_teams_payload_with_download_link(test_data, pdf_file, download_url, args.environment)
    
    # Send notification
    safe_print("📤 Sending notification to Microsoft Teams...")
    if send_teams_notification_with_download_link(webhook_url, payload):
        safe_print("🎉 Teams notification with PDF download link sent successfully!")
        safe_print(f"🌐 Web server is running on port {args.port}")
        safe_print(f"📎 PDF download link: {download_url}")
        safe_print("💡 Keep this terminal open to maintain the download link")
    else:
        safe_print("❌ Teams notification failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()