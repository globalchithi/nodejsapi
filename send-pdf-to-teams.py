#!/usr/bin/env python3
"""
Send PDF to Teams
Simple script to send existing PDF files to Microsoft Teams
"""

import os
import sys
import glob
import argparse
from datetime import datetime

def safe_print(message):
    """Safely print text that may contain Unicode characters"""
    try:
        print(message)
    except UnicodeEncodeError:
        print(message.encode('ascii', 'replace').decode('ascii'))

def find_latest_pdf(directory="TestReports"):
    """Find the latest PDF file in the directory"""
    pdf_files = glob.glob(os.path.join(directory, "**", "*.pdf"), recursive=True)
    
    if not pdf_files:
        return None
    
    # Get the most recent PDF file
    latest_file = max(pdf_files, key=os.path.getmtime)
    return latest_file

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description='Send PDF to Microsoft Teams')
    parser.add_argument('--pdf', help='PDF file path (if not provided, will find latest PDF)')
    parser.add_argument('--environment', default='Staging', help='Environment name')
    parser.add_argument('--webhook', help='Microsoft Teams webhook URL')
    
    args = parser.parse_args()
    
    # Determine PDF file
    if args.pdf:
        pdf_file = args.pdf
    else:
        pdf_file = find_latest_pdf()
        if not pdf_file:
            safe_print("❌ No PDF files found in TestReports directory")
            safe_print("💡 Generate a PDF first using: python3 convert-html-to-pdf.py")
            return False
        safe_print(f"📄 Using latest PDF file: {pdf_file}")
    
    # Check if PDF file exists
    if not os.path.exists(pdf_file):
        safe_print(f"❌ PDF file not found: {pdf_file}")
        return False
    
    # Get file info
    file_size = os.path.getsize(pdf_file)
    file_size_mb = round(file_size / (1024 * 1024), 2)
    file_name = os.path.basename(pdf_file)
    
    safe_print("🚀 Sending PDF to Microsoft Teams")
    safe_print("=" * 40)
    safe_print(f"📄 PDF File: {file_name}")
    safe_print(f"📊 File Size: {file_size_mb} MB")
    safe_print(f"🌍 Environment: {args.environment}")
    
    # Send to Teams
    success, _, _ = run_command(
        f"python3 send-teams-notification-with-pdf.py --pdf \"{pdf_file}\" --environment \"{args.environment}\"",
        "Sending PDF to Teams"
    )
    
    if success:
        safe_print("🎉 PDF sent to Teams successfully!")
        return True
    else:
        safe_print("❌ Failed to send PDF to Teams!")
        return False

def run_command(command, description):
    """Run a command and return success status"""
    import subprocess
    safe_print(f"🔄 {description}...")
    process = subprocess.run(command, shell=True, capture_output=True, text=True)
    if process.returncode == 0:
        safe_print(f"✅ {description} completed successfully")
        return True, process.stdout, process.stderr
    else:
        safe_print(f"❌ {description} failed with exit code {process.returncode}")
        if process.stderr:
            safe_print(f"Error: {process.stderr}")
        return False, process.stdout, process.stderr

if __name__ == "__main__":
    success = main()
    if not success:
        sys.exit(1)
