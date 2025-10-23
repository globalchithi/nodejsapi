#!/usr/bin/env python3
"""
Enhanced HTML Report Generator - Robust XML Parser
This script handles malformed XML files and generates comprehensive HTML reports
"""

import os
import sys
import re
from datetime import datetime
import argparse

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
    print("Using regex parsing as fallback...")
    
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
            'duration_ms': round(duration * 1000, 2),
            'status_icon': '&#10004;' if test_result == 'Pass' else '&#10008;' if test_result == 'Fail' else '&#9193;'
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

def parse_xml_file(xml_file):
    """Parse XML file with multiple fallback methods"""
    print("Parsing XML file with robust methods...")
    
    # Try different encodings and methods
    encodings = ['utf-8', 'utf-8-sig', 'ascii', 'latin-1']
    
    for encoding in encodings:
        try:
            print(f"Trying encoding: {encoding}")
            with open(xml_file, 'r', encoding=encoding) as f:
                content = f.read()
            
            # Clean the content first
            content = clean_xml_content(content)
            
            # Try to parse as XML
            try:
                import xml.etree.ElementTree as ET
                tree = ET.fromstring(content)
                print(f"Successfully parsed XML with {encoding} encoding")
                
                # Extract data from XML tree
                return extract_from_xml_tree(tree)
            except Exception as xml_error:
                print(f"XML parsing failed with {encoding}: {xml_error}")
                # Fall back to regex parsing
                return parse_xml_with_regex(xml_file)
                
        except Exception as e:
            print(f"{encoding} encoding failed: {e}")
            continue
    
    # If all encodings fail, try regex parsing
    print("All XML parsing methods failed, using regex fallback...")
    return parse_xml_with_regex(xml_file)

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
            'duration_ms': round(test_time * 1000, 2),
            'status_icon': '&#10004;' if test_result == 'Pass' else '&#10008;' if test_result == 'Fail' else '&#9193;'
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

def generate_html_report(data, output_path):
    """Generate HTML report"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VaxCare API Test Report</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }}
        .container {{ max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        .header {{ background: #007bff; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }}
        .header h1 {{ margin: 0; font-size: 2em; }}
        .stats {{ display: flex; gap: 20px; margin: 20px 0; flex-wrap: wrap; }}
        .stat-card {{ background: #f8f9fa; padding: 15px; border-radius: 5px; text-align: center; flex: 1; min-width: 120px; }}
        .stat-number {{ font-size: 2em; font-weight: bold; margin-bottom: 5px; }}
        .stat-label {{ color: #666; }}
        .passed .stat-number {{ color: #28a745; }}
        .failed .stat-number {{ color: #dc3545; }}
        .skipped .stat-number {{ color: #ffc107; }}
        .total .stat-number {{ color: #007bff; }}
        .success-rate .stat-number {{ color: #6f42c1; }}
        .test-table {{ width: 100%; border-collapse: collapse; margin: 20px 0; }}
        .test-table th, .test-table td {{ padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }}
        .test-table th {{ background: #007bff; color: white; font-weight: bold; }}
        .test-table tbody tr:hover {{ background-color: #f5f5f5; }}
        .status-passed {{ color: #28a745; font-weight: bold; }}
        .status-failed {{ color: #dc3545; font-weight: bold; }}
        .status-skipped {{ color: #ffc107; font-weight: bold; }}
        .duration {{ font-family: monospace; background: #f8f9fa; padding: 2px 6px; border-radius: 3px; }}
        .footer {{ text-align: center; margin-top: 30px; color: #666; }}
        .warning {{ background: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 10px; border-radius: 4px; margin: 10px 0; }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>VaxCare API Test Report</h1>
            <p>Generated: {timestamp}</p>
        </div>
        
        <div class="stats">
            <div class="stat-card passed">
                <div class="stat-number">{data['passed_tests']}</div>
                <div class="stat-label">Passed</div>
            </div>
            <div class="stat-card failed">
                <div class="stat-number">{data['failed_tests']}</div>
                <div class="stat-label">Failed</div>
            </div>
            <div class="stat-card skipped">
                <div class="stat-number">{data['skipped_tests']}</div>
                <div class="stat-label">Skipped</div>
            </div>
            <div class="stat-card total">
                <div class="stat-number">{data['total_tests']}</div>
                <div class="stat-label">Total</div>
            </div>
            <div class="stat-card success-rate">
                <div class="stat-number">{data['success_rate']}%</div>
                <div class="stat-label">Success Rate</div>
            </div>
        </div>
        
        <h2>Test Results</h2>
        <table class="test-table">
            <thead>
                <tr>
                    <th>Status</th>
                    <th>Test Name</th>
                    <th>Class</th>
                    <th>Duration</th>
                </tr>
            </thead>
            <tbody>"""
    
    # Add test details to table
    for test in data['test_details']:
        status_class = f"status-{test['result'].lower()}" if test['result'] in ['Pass', 'Fail', 'Skip'] else 'status-unknown'
        
        html_content += f"""
                <tr>
                    <td class="{status_class}">{test['status_icon']} {test['result']}</td>
                    <td>{test['name']}</td>
                    <td>{test['class']}</td>
                    <td><span class="duration">{test['duration_ms']}ms</span></td>
                </tr>"""
    
    html_content += f"""
            </tbody>
        </table>
        
        <div class="footer">
            <p>Report generated by VaxCare API Test Suite | {timestamp}</p>
        </div>
    </div>
</body>
</html>"""
    
    # Write HTML content to file
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(html_content)
        print(f"HTML report generated: {output_path}")
        return True
    except Exception as e:
        print(f"Error writing HTML file: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Generate enhanced HTML test report with robust XML parsing')
    parser.add_argument('--xml', default='TestReports/TestResults.xml', help='XML file path')
    parser.add_argument('--output', default='TestReports', help='Output directory')
    
    args = parser.parse_args()
    
    # Create output directory if it doesn't exist
    os.makedirs(args.output, exist_ok=True)
    
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    html_report_path = os.path.join(args.output, f'EnhancedTestReport_{timestamp}.html')
    
    print("Generating enhanced HTML report with robust XML parsing...")
    
    # Check if XML file exists
    if not os.path.exists(args.xml):
        print(f"XML file not found: {args.xml}")
        sys.exit(1)
    
    # Parse XML and extract data
    data = parse_xml_file(args.xml)
    
    # Print statistics
    print("Test Statistics:")
    print(f"   Total Tests: {data['total_tests']}")
    print(f"   Passed: {data['passed_tests']}")
    print(f"   Failed: {data['failed_tests']}")
    print(f"   Skipped: {data['skipped_tests']}")
    print(f"   Success Rate: {data['success_rate']}%")
    
    # Generate HTML report
    if generate_html_report(data, html_report_path):
        print("Enhanced HTML report generation completed!")
    else:
        sys.exit(1)

if __name__ == "__main__":
    main()
