#!/usr/bin/env python3
"""
Simple OneDrive Upload
Uploads PDF files to OneDrive using web interface and creates share links
"""

import os
import sys
import glob
import argparse
import subprocess
from datetime import datetime
import webbrowser

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

def open_onedrive_upload(pdf_file):
    """Open OneDrive upload page in browser"""
    try:
        # Get absolute path
        abs_path = os.path.abspath(pdf_file)
        file_name = os.path.basename(pdf_file)
        
        safe_print(f"🌐 Opening OneDrive upload page...")
        safe_print(f"📄 File: {file_name}")
        safe_print(f"📁 Path: {abs_path}")
        
        # Open OneDrive in browser
        webbrowser.open("https://onedrive.live.com")
        
        safe_print("✅ OneDrive opened in browser")
        safe_print("💡 Instructions:")
        safe_print("1. Sign in to OneDrive if not already signed in")
        safe_print("2. Click 'Upload' button")
        safe_print("3. Select the PDF file from the path above")
        safe_print("4. After upload, right-click the file and select 'Share'")
        safe_print("5. Copy the share link and use it in Teams")
        
        return True
        
    except Exception as e:
        safe_print(f"❌ Error opening OneDrive: {e}")
        return False

def create_upload_instructions(pdf_file):
    """Create detailed upload instructions"""
    abs_path = os.path.abspath(pdf_file)
    file_name = os.path.basename(pdf_file)
    file_size = os.path.getsize(pdf_file)
    file_size_mb = round(file_size / (1024 * 1024), 2)
    
    instructions = f"""
🚀 **OneDrive Upload Instructions**

📄 **File Details:**
- **Name**: {file_name}
- **Size**: {file_size_mb} MB
- **Location**: {abs_path}

📋 **Upload Steps:**
1. **Open OneDrive**: Go to https://onedrive.live.com
2. **Sign In**: Use your Microsoft account
3. **Upload File**: Click 'Upload' button and select the PDF file
4. **Create Share Link**: Right-click the uploaded file and select 'Share'
5. **Copy Link**: Copy the share link for Teams

🔗 **Alternative Methods:**
- **OneDrive App**: Use the OneDrive desktop app
- **Drag & Drop**: Drag the PDF file to OneDrive web interface
- **Email**: Attach PDF to email and save to OneDrive

💡 **Tips:**
- Create a 'TestReports' folder in OneDrive for organization
- Set appropriate sharing permissions (view/edit)
- Test the share link before sending to Teams
"""
    
    return instructions

def send_teams_notification_with_instructions(pdf_file, environment="Development"):
    """Send Teams notification with upload instructions"""
    try:
        # Create instructions
        instructions = create_upload_instructions(pdf_file)
        
        # Get file info
        file_name = os.path.basename(pdf_file)
        file_size = os.path.getsize(pdf_file)
        file_size_mb = round(file_size / (1024 * 1024), 2)
        
        safe_print("📤 Sending Teams notification with upload instructions...")
        
        # Create Teams message
        teams_message = f"""
🚀 **Test Automation Results - PDF Upload Required**

📄 **PDF Report**: {file_name} ({file_size_mb} MB)
📁 **File Location**: {os.path.abspath(pdf_file)}
🌍 **Environment**: {environment}
⏰ **Generated**: {datetime.now().strftime("%m/%d/%Y, %I:%M:%S %p")}

**📋 Upload Instructions:**
1. **Open OneDrive**: Go to https://onedrive.live.com
2. **Sign In**: Use your Microsoft account
3. **Upload File**: Click 'Upload' button and select the PDF file
4. **Create Share Link**: Right-click the uploaded file and select 'Share'
5. **Copy Link**: Copy the share link and share it in this channel

**🔗 Alternative Methods:**
- **OneDrive App**: Use the OneDrive desktop app
- **Drag & Drop**: Drag the PDF file to OneDrive web interface
- **Email**: Attach PDF to email and save to OneDrive

💡 **Note**: Once uploaded, the PDF will be accessible to your team through the share link.
"""
        
        # Send using existing Teams notification script
        success, _, _ = run_command(
            f"python3 send-teams-notification-with-pdf.py --pdf \"{pdf_file}\" --environment \"{environment}\"",
            "Sending Teams notification with upload instructions"
        )
        
        if success:
            safe_print("🎉 Teams notification sent with upload instructions!")
            return True
        else:
            safe_print("❌ Failed to send Teams notification!")
            return False
            
    except Exception as e:
        safe_print(f"❌ Error sending Teams notification: {e}")
        return False

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

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description='Upload PDF to OneDrive (Simple Method)')
    parser.add_argument('--pdf', help='PDF file path (if not provided, will find latest PDF)')
    parser.add_argument('--environment', default='Development', help='Environment name')
    parser.add_argument('--teams', action='store_true', help='Send Teams notification with instructions')
    parser.add_argument('--open', action='store_true', help='Open OneDrive in browser')
    
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
    
    safe_print("🚀 OneDrive Upload Helper")
    safe_print("=" * 40)
    safe_print(f"📄 PDF File: {os.path.basename(pdf_file)}")
    safe_print(f"📁 File Path: {os.path.abspath(pdf_file)}")
    safe_print(f"🌍 Environment: {args.environment}")
    
    # Show instructions
    instructions = create_upload_instructions(pdf_file)
    safe_print(instructions)
    
    # Open OneDrive if requested
    if args.open:
        open_onedrive_upload(pdf_file)
    
    # Send Teams notification if requested
    if args.teams:
        send_teams_notification_with_instructions(pdf_file, args.environment)
    
    safe_print("🎉 OneDrive upload helper completed!")
    safe_print("💡 Follow the instructions above to upload the PDF to OneDrive")
    
    return True

if __name__ == "__main__":
    success = main()
    if not success:
        sys.exit(1)
