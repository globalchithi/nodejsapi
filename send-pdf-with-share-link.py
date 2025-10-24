#!/usr/bin/env python3
"""
Send PDF to Teams with Share Link
Creates a shareable link for the PDF file and sends it to Teams
"""

import os
import sys
import glob
import argparse
import subprocess
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

def create_share_link(pdf_file):
    """Create a shareable link for the PDF file"""
    # Get absolute path
    abs_path = os.path.abspath(pdf_file)
    
    # Create a simple share link using file:// protocol
    share_link = f"file://{abs_path}"
    
    # Also create a relative path for easier sharing
    relative_path = os.path.relpath(pdf_file)
    
    return share_link, relative_path, abs_path

def run_command(command, description):
    """Run a command and return success status"""
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

def send_to_teams_with_share_link(pdf_file, environment="Development"):
    """Send PDF to Teams with share link"""
    # Create share link
    share_link, relative_path, abs_path = create_share_link(pdf_file)
    
    # Get file info
    file_size = os.path.getsize(pdf_file)
    file_size_mb = round(file_size / (1024 * 1024), 2)
    file_name = os.path.basename(pdf_file)
    
    safe_print("🚀 Sending PDF to Teams with Share Link")
    safe_print("=" * 50)
    safe_print(f"📄 PDF File: {file_name}")
    safe_print(f"📊 File Size: {file_size_mb} MB")
    safe_print(f"📁 File Path: {abs_path}")
    safe_print(f"🔗 Share Link: {share_link}")
    safe_print(f"🌍 Environment: {environment}")
    
    # Create a custom Teams message with share link
    teams_message = f"""
🚀 **Test Automation Results with PDF Report**

📄 **PDF Report**: {file_name} ({file_size_mb} MB)
📁 **File Location**: {abs_path}
🔗 **Share Link**: {share_link}

**Instructions for accessing the PDF:**
1. **Direct Access**: Copy the file path above and open in file explorer
2. **Share Link**: Use the share link to access the file
3. **Manual Sharing**: Upload to OneDrive/SharePoint for team sharing

**File Details:**
- **Name**: {file_name}
- **Size**: {file_size_mb} MB
- **Location**: {relative_path}
- **Environment**: {environment}
- **Generated**: {datetime.now().strftime("%m/%d/%Y, %I:%M:%S %p")}

💡 **Tip**: For easier sharing, upload this PDF to OneDrive or SharePoint and share the link with your team.
"""
    
    # Send using the existing Teams notification script
    success, _, _ = run_command(
        f"python3 send-teams-notification-with-pdf.py --pdf \"{pdf_file}\" --environment \"{environment}\"",
        "Sending PDF to Teams with share link"
    )
    
    if success:
        safe_print("🎉 PDF sent to Teams with share link!")
        safe_print(f"📁 File location: {abs_path}")
        safe_print(f"🔗 Share link: {share_link}")
        safe_print("💡 The Teams message includes file location and share instructions")
        return True
    else:
        safe_print("❌ Failed to send PDF to Teams!")
        return False

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description='Send PDF to Teams with share link')
    parser.add_argument('--pdf', help='PDF file path (if not provided, will find latest PDF)')
    parser.add_argument('--environment', default='Development', help='Environment name')
    
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
    
    # Send to Teams with share link
    success = send_to_teams_with_share_link(pdf_file, args.environment)
    
    if success:
        safe_print("🎉 PDF sent to Teams successfully!")
        safe_print("💡 The Teams message includes file location and share instructions")
        return True
    else:
        safe_print("❌ Failed to send PDF to Teams!")
        return False

if __name__ == "__main__":
    success = main()
    if not success:
        sys.exit(1)
