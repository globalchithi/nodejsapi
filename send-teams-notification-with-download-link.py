#!/usr/bin/env python3
"""
Microsoft Teams Notification Script with HTML Download Link
Sends test results with direct download link to HTML report
"""

import os
import sys
import json
import urllib.request
import urllib.parse
import urllib.error
import ssl
import argparse
from datetime import datetime
import xml.etree.ElementTree as ET
import re
import time
import webbrowser
import http.server
import socketserver
import threading
import shutil

def safe_print(text):
    """Safely print text that may contain Unicode characters"""
    try:
        print(text)
    except UnicodeEncodeError:
        print(text.encode('ascii', 'replace').decode('ascii'))

def create_ssl_context():
    """Create SSL context that handles certificate issues"""
    try:
        # Create SSL context with relaxed certificate verification
        ssl_context = ssl.create_default_context()
        
        # Disable certificate verification (for corporate networks)
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        return ssl_context
    except Exception as e:
        safe_print(f"⚠️ SSL context creation failed: {e}")
        return None

def find_html_report(output_dir):
    """Find the most recent HTML report file"""
    try:
        html_files = []
        
        # Look for HTML files in the output directory
        for file in os.listdir(output_dir):
            if file.endswith('.html') and 'EnhancedTestReport' in file:
                file_path = os.path.join(output_dir, file)
                # Get file modification time
                mtime = os.path.getmtime(file_path)
                html_files.append((file_path, mtime))
        
        if not html_files:
            safe_print("⚠️ No HTML report files found")
            return None
        
        # Sort by modification time (most recent first)
        html_files.sort(key=lambda x: x[1], reverse=True)
        latest_html = html_files[0][0]
        
        safe_print(f"📄 Found HTML report: {os.path.basename(latest_html)}")
        return latest_html
        
    except Exception as e:
        safe_print(f"⚠️ Error finding HTML report: {e}")
        return None

def start_local_server(html_file_path, port=8080):
    """Start a local HTTP server to serve the HTML file"""
    try:
        # Create a simple HTTP server
        class HTMLHandler(http.server.SimpleHTTPRequestHandler):
            def __init__(self, *args, **kwargs):
                super().__init__(*args, directory=os.path.dirname(html_file_path), **kwargs)
            
            def do_GET(self):
                if self.path == '/' or self.path == f'/{os.path.basename(html_file_path)}':
                    self.path = f'/{os.path.basename(html_file_path)}'
                super().do_GET()
        
        # Start server in a separate thread
        server = socketserver.TCPServer(("", port), HTMLHandler)
        server_thread = threading.Thread(target=server.serve_forever)
        server_thread.daemon = True
        server_thread.start()
        
        safe_print(f"🌐 Local server started on port {port}")
        return server, f"http://localhost:{port}/{os.path.basename(html_file_path)}"
        
    except Exception as e:
        safe_print(f"⚠️ Error starting local server: {e}")
        return None, None

def create_teams_payload_with_download_link(test_data, environment="Development", browser="N/A", html_file_path=None, download_url=None):
    """Create Microsoft Teams Adaptive Card payload with HTML download link"""
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
    
    # Create base payload
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
                                    "title": "Skipped",
                                    "value": str(test_data['skipped_tests'])
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
                                    "title": "Browser",
                                    "value": browser
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
    
    # Add HTML download link if file exists
    if html_file_path and os.path.exists(html_file_path):
        try:
            safe_print(f"🔗 Adding HTML download link: {os.path.basename(html_file_path)}")
            
            # Get file size
            file_size = os.path.getsize(html_file_path)
            
            # Create download link
            if download_url:
                download_link = download_url
            else:
                # Use file path as download link
                download_link = f"file://{os.path.abspath(html_file_path)}"
            
            # Add download link to the card
            download_info = {
                "type": "TextBlock",
                "text": f"📎 **HTML Report Available:** [Download {os.path.basename(html_file_path)}]({download_link}) ({file_size:,} bytes)",
                "wrap": True,
                "size": "Small",
                "color": "Accent"
            }
            
            payload["attachments"][0]["content"]["body"].append(download_info)
            
            # Add action button for download
            download_action = {
                "type": "ActionSet",
                "actions": [
                    {
                        "type": "Action.OpenUrl",
                        "title": "📥 Download HTML Report",
                        "url": download_link
                    }
                ]
            }
            
            payload["attachments"][0]["content"]["body"].append(download_action)
            
            safe_print(f"✅ HTML download link added successfully!")
            
        except Exception as e:
            safe_print(f"⚠️ Error adding HTML download link: {e}")
    else:
        safe_print("⚠️ No HTML report file found for download link")
    
    return payload

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

def send_teams_notification_with_download_link(webhook_url, payload):
    """Send notification to Microsoft Teams with download link"""
    safe_print("📤 Sending Teams notification with HTML download link...")
    
    max_retries = 3
    retry_delay = 2
    ssl_context = create_ssl_context()
    
    for attempt in range(max_retries):
        try:
            safe_print(f"   Attempt {attempt + 1}/{max_retries}...")
            
            # Convert payload to JSON
            json_data = json.dumps(payload).encode('utf-8')
            
            # Create request with proper headers
            req = urllib.request.Request(
                webhook_url,
                data=json_data,
                headers={
                    'Content-Type': 'application/json',
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                    'Accept': 'application/json'
                }
            )
            
            # Send request with SSL context
            with urllib.request.urlopen(req, timeout=30, context=ssl_context) as response:
                if response.status in [200, 202]:
                    safe_print("✅ Teams notification with download link sent successfully!")
                    return True
                else:
                    safe_print(f"⚠️ Unexpected status: {response.status}")
                    if attempt < max_retries - 1:
                        safe_print(f"   Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                        continue
                    else:
                        safe_print(f"❌ Failed after {max_retries} attempts (Status: {response.status})")
                        return False
                        
        except urllib.error.HTTPError as e:
            safe_print(f"⚠️ HTTP Error {e.code}: {e.reason}")
            try:
                error_body = e.read().decode('utf-8')
                safe_print(f"   Error details: {error_body[:200]}...")
            except:
                pass
            
            if attempt < max_retries - 1:
                safe_print(f"   Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
                continue
            else:
                safe_print(f"❌ HTTP Error after {max_retries} attempts: {e.code}")
                return False
                
        except urllib.error.URLError as e:
            safe_print(f"⚠️ URL Error: {e}")
            if attempt < max_retries - 1:
                safe_print(f"   Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
                continue
            else:
                safe_print(f"❌ URL Error after {max_retries} attempts: {e}")
                return False
                
        except Exception as e:
            safe_print(f"⚠️ Unexpected error: {e}")
            if attempt < max_retries - 1:
                safe_print(f"   Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
                continue
            else:
                safe_print(f"❌ Error after {max_retries} attempts: {e}")
                return False
    
    return False

def main():
    parser = argparse.ArgumentParser(description='Send test results to Microsoft Teams with HTML download link')
    parser.add_argument('--xml', default='TestReports/TestResults.xml', help='XML file path')
    parser.add_argument('--html', help='HTML report file path (auto-detected if not specified)')
    parser.add_argument('--output', default='TestReports', help='Output directory for HTML reports')
    parser.add_argument('--webhook', help='Microsoft Teams webhook URL')
    parser.add_argument('--environment', default='Development', help='Environment name')
    parser.add_argument('--browser', default='N/A', help='Browser information')
    parser.add_argument('--test', action='store_true', help='Send test notification')
    parser.add_argument('--server', action='store_true', help='Start local server for HTML file')
    parser.add_argument('--port', type=int, default=8080, help='Port for local server')
    parser.add_argument('--verbose', action='store_true', help='Verbose output')
    
    args = parser.parse_args()
    
    # Default webhook URL (from your curl command)
    default_webhook = "https://default809ba6beb3bb4f08a26065732b2a2b.36.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0d24a9464a6a49bfb869e82691dcba5e/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=GfEveRKN8pJuVa0-xWnNp5-EHLU0Oygkh53ZhvdENjM"
    
    webhook_url = args.webhook or default_webhook
    
    safe_print("🚀 Microsoft Teams Test Notification with HTML Download Link")
    safe_print("=" * 70)
    
    if args.test:
        # Send test notification
        safe_print("📤 Sending test notification...")
        test_payload = {
            "text": "🧪 Test Notification with Download Link",
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
                                "text": "✅ Teams integration with HTML download link is working correctly!",
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
        
        if send_teams_notification_with_download_link(webhook_url, test_payload):
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
    
    # Find HTML report file
    html_file_path = args.html
    if not html_file_path:
        safe_print(f"🔍 Looking for HTML report in: {args.output}")
        html_file_path = find_html_report(args.output)
    
    # Start local server if requested
    download_url = None
    server = None
    
    if args.server and html_file_path:
        safe_print("🌐 Starting local server for HTML file...")
        server, download_url = start_local_server(html_file_path, args.port)
        if server:
            safe_print(f"🔗 HTML file available at: {download_url}")
        else:
            safe_print("⚠️ Failed to start local server, using file path instead")
    
    # Create Teams payload with download link
    safe_print("📤 Creating Teams notification with HTML download link...")
    payload = create_teams_payload_with_download_link(test_data, args.environment, args.browser, html_file_path, download_url)
    
    # Send notification
    safe_print("📤 Sending notification to Microsoft Teams...")
    if send_teams_notification_with_download_link(webhook_url, payload):
        safe_print("🎉 Teams notification with HTML download link sent successfully!")
        
        if server:
            safe_print("🌐 Local server is running. Press Ctrl+C to stop.")
            try:
                server.serve_forever()
            except KeyboardInterrupt:
                safe_print("🛑 Stopping local server...")
                server.shutdown()
    else:
        safe_print("❌ Teams notification failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()
