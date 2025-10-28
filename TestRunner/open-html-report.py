#!/usr/bin/env python3
"""
Standalone script to open HTML test reports
This script finds and opens the most recent HTML test report
"""

import os
import sys
import glob
import webbrowser
import argparse
from datetime import datetime

def safe_print(text):
    """Safely print text that may contain Unicode characters"""
    try:
        print(text)
    except UnicodeEncodeError:
        # Fallback for Windows Command Prompt
        print(text.encode('ascii', 'replace').decode('ascii'))

def find_latest_html_report(reports_dir="TestReports"):
    """Find the most recent HTML report in the specified directory"""
    try:
        # Look for EnhancedTestReport files
        pattern = os.path.join(reports_dir, "**", "EnhancedTestReport*.html")
        html_files = glob.glob(pattern, recursive=True)
        
        if html_files:
            # Get the most recent file
            latest_file = max(html_files, key=os.path.getmtime)
            return latest_file
        
        # If no EnhancedTestReport found, look for any HTML files
        pattern = os.path.join(reports_dir, "**", "*.html")
        html_files = glob.glob(pattern, recursive=True)
        
        if html_files:
            latest_file = max(html_files, key=os.path.getmtime)
            return latest_file
            
        return None
        
    except Exception as e:
        safe_print(f"Error finding HTML reports: {e}")
        return None

def open_html_report(reports_dir="TestReports", specific_file=None):
    """Open HTML report in the default browser"""
    try:
        # Use specific file if provided, otherwise find the latest
        if specific_file:
            if os.path.exists(specific_file):
                html_file = specific_file
            else:
                safe_print(f"ERROR: Specified file not found: {specific_file}")
                return False
        else:
            html_file = find_latest_html_report(reports_dir)
            if not html_file:
                safe_print(f"ERROR: No HTML reports found in {reports_dir}")
                return False
        
        # Convert to absolute path for better compatibility
        abs_path = os.path.abspath(html_file)
        
        safe_print(f"Opening HTML report: {html_file}")
        safe_print(f"Full path: {abs_path}")
        
        # Open in default browser
        webbrowser.open(f"file://{abs_path}")
        safe_print("SUCCESS: HTML report opened in default browser")
        return True
        
    except Exception as e:
        safe_print(f"ERROR: Could not open HTML report: {e}")
        return False

def list_html_reports(reports_dir="TestReports"):
    """List all available HTML reports"""
    try:
        pattern = os.path.join(reports_dir, "**", "*.html")
        html_files = glob.glob(pattern, recursive=True)
        
        if not html_files:
            safe_print(f"No HTML reports found in {reports_dir}")
            return
        
        safe_print(f"Available HTML reports in {reports_dir}:")
        safe_print("-" * 50)
        
        # Sort by modification time (newest first)
        html_files.sort(key=os.path.getmtime, reverse=True)
        
        for i, html_file in enumerate(html_files, 1):
            # Get file info
            mtime = os.path.getmtime(html_file)
            size = os.path.getsize(html_file)
            size_kb = size / 1024
            
            # Format timestamp
            timestamp = datetime.fromtimestamp(mtime).strftime('%Y-%m-%d %H:%M:%S')
            
            # Get relative path
            rel_path = os.path.relpath(html_file, reports_dir)
            
            safe_print(f"{i:2d}. {rel_path}")
            safe_print(f"    Modified: {timestamp}")
            safe_print(f"    Size: {size_kb:.1f} KB")
            safe_print("")
            
    except Exception as e:
        safe_print(f"ERROR: Could not list HTML reports: {e}")

def main():
    parser = argparse.ArgumentParser(description='Open HTML test reports')
    parser.add_argument('--dir', default='TestReports', help='Reports directory (default: TestReports)')
    parser.add_argument('--file', help='Specific HTML file to open')
    parser.add_argument('--list', action='store_true', help='List all available HTML reports')
    parser.add_argument('--latest', action='store_true', help='Open the most recent HTML report (default)')
    
    args = parser.parse_args()
    
    safe_print("HTML Test Report Opener")
    safe_print("=" * 30)
    
    # Create reports directory if it doesn't exist
    if not os.path.exists(args.dir):
        safe_print(f"ERROR: Reports directory not found: {args.dir}")
        sys.exit(1)
    
    if args.list:
        list_html_reports(args.dir)
    elif args.file:
        open_html_report(args.dir, args.file)
    else:
        # Default: open latest report
        open_html_report(args.dir)

if __name__ == "__main__":
    main()
