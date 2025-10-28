#!/usr/bin/env python3
"""
Upload PDF to OneDrive/SharePoint
Uploads PDF test reports to OneDrive/SharePoint and shares the link
"""

import os
import sys
import json
import requests
import argparse
import glob
from datetime import datetime
import subprocess

def safe_print(message):
    """Safely print text that may contain Unicode characters"""
    try:
        print(message)
    except UnicodeEncodeError:
        print(message.encode('ascii', 'replace').decode('ascii'))

def install_required_packages():
    """Install required packages for OneDrive upload"""
    packages = [
        "requests",
        "msal",
        "python-dotenv"
    ]
    
    for package in packages:
        try:
            __import__(package.replace('-', '_'))
        except ImportError:
            safe_print(f"📦 Installing {package}...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])

def get_access_token(client_id, client_secret, tenant_id):
    """Get access token for Microsoft Graph API"""
    try:
        import msal
        
        # Create MSAL app
        app = msal.ConfidentialClientApplication(
            client_id,
            authority=f"https://login.microsoftonline.com/{tenant_id}",
            client_credential=client_id
        )
        
        # Get token
        result = app.acquire_token_for_client(scopes=["https://graph.microsoft.com/.default"])
        
        if "access_token" in result:
            return result["access_token"]
        else:
            safe_print(f"❌ Failed to get access token: {result.get('error_description', 'Unknown error')}")
            return None
            
    except Exception as e:
        safe_print(f"❌ Error getting access token: {e}")
        return None

def upload_file_to_onedrive(file_path, access_token, folder_path="TestReports"):
    """Upload file to OneDrive"""
    try:
        # Get file info
        file_name = os.path.basename(file_path)
        file_size = os.path.getsize(file_path)
        
        safe_print(f"📤 Uploading {file_name} ({file_size} bytes) to OneDrive...")
        
        # Create folder if it doesn't exist
        create_folder_url = "https://graph.microsoft.com/v1.0/me/drive/root/children"
        folder_data = {
            "name": folder_path,
            "folder": {},
            "@microsoft.graph.conflictBehavior": "rename"
        }
        
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        # Try to create folder
        response = requests.post(create_folder_url, headers=headers, json=folder_data)
        if response.status_code not in [200, 201, 409]:  # 409 = folder already exists
            safe_print(f"⚠️ Warning: Could not create folder {folder_path}: {response.status_code}")
        
        # Upload file
        upload_url = f"https://graph.microsoft.com/v1.0/me/drive/root:/{folder_path}/{file_name}:/content"
        
        with open(file_path, 'rb') as f:
            file_content = f.read()
        
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/pdf"
        }
        
        response = requests.put(upload_url, headers=headers, data=file_content)
        
        if response.status_code in [200, 201]:
            file_info = response.json()
            safe_print(f"✅ File uploaded successfully!")
            safe_print(f"📁 File ID: {file_info.get('id')}")
            safe_print(f"📄 File Name: {file_info.get('name')}")
            safe_print(f"📊 File Size: {file_info.get('size')} bytes")
            return file_info
        else:
            safe_print(f"❌ Upload failed: {response.status_code}")
            safe_print(f"Error: {response.text}")
            return None
            
    except Exception as e:
        safe_print(f"❌ Error uploading file: {e}")
        return None

def create_share_link(file_id, access_token, permission_type="view"):
    """Create share link for the uploaded file"""
    try:
        share_url = f"https://graph.microsoft.com/v1.0/me/drive/items/{file_id}/createLink"
        
        share_data = {
            "type": permission_type,
            "scope": "organization"
        }
        
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        response = requests.post(share_url, headers=headers, json=share_data)
        
        if response.status_code == 200:
            share_info = response.json()
            share_link = share_info.get('link', {}).get('webUrl')
            safe_print(f"✅ Share link created: {share_link}")
            return share_link
        else:
            safe_print(f"❌ Failed to create share link: {response.status_code}")
            safe_print(f"Error: {response.text}")
            return None
            
    except Exception as e:
        safe_print(f"❌ Error creating share link: {e}")
        return None

def send_teams_notification_with_share_link(share_link, file_name, environment="Staging"):
    """Send Teams notification with OneDrive share link"""
    try:
        # Create Teams message
        teams_message = f"""
🚀 **Test Automation Results with PDF Report**

📄 **PDF Report**: {file_name}
🔗 **Download Link**: [Click here to download PDF]({share_link})
📁 **OneDrive Location**: {share_link}

**File Details:**
- **Name**: {file_name}
- **Location**: OneDrive/SharePoint
- **Environment**: {environment}
- **Generated**: {datetime.now().strftime("%m/%d/%Y, %I:%M:%S %p")}
- **Access**: Click the link above to download the PDF

💡 **Note**: The PDF is now stored in OneDrive and can be accessed by your team through the share link.
"""
        
        # Send using existing Teams notification script
        success, _, _ = run_command(
            f"python3 send-teams-notification-with-pdf.py --pdf \"{file_name}\" --environment \"{environment}\"",
            "Sending Teams notification with OneDrive share link"
        )
        
        if success:
            safe_print("🎉 Teams notification sent with OneDrive share link!")
            safe_print(f"🔗 Share link: {share_link}")
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
    parser = argparse.ArgumentParser(description='Upload PDF to OneDrive/SharePoint')
    parser.add_argument('--pdf', help='PDF file path (if not provided, will find latest PDF)')
    parser.add_argument('--client-id', help='Azure App Client ID')
    parser.add_argument('--client-secret', help='Azure App Client Secret')
    parser.add_argument('--tenant-id', help='Azure Tenant ID')
    parser.add_argument('--folder', default='TestReports', help='OneDrive folder name')
    parser.add_argument('--environment', default='Staging', help='Environment name')
    parser.add_argument('--teams', action='store_true', help='Send Teams notification with share link')
    
    args = parser.parse_args()
    
    # Check for required parameters
    if not args.client_id or not args.client_secret or not args.tenant_id:
        safe_print("❌ Missing required parameters!")
        safe_print("Usage: python3 upload-pdf-to-onedrive.py --client-id ID --client-secret SECRET --tenant-id TENANT")
        safe_print("")
        safe_print("💡 To get these values:")
        safe_print("1. Go to Azure Portal (portal.azure.com)")
        safe_print("2. Navigate to 'Azure Active Directory' > 'App registrations'")
        safe_print("3. Create a new app registration or use existing one")
        safe_print("4. Get Client ID, Client Secret, and Tenant ID")
        safe_print("5. Grant 'Files.ReadWrite' permission to Microsoft Graph API")
        return False
    
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
    
    safe_print("🚀 Uploading PDF to OneDrive/SharePoint")
    safe_print("=" * 50)
    safe_print(f"📄 PDF File: {os.path.basename(pdf_file)}")
    safe_print(f"📁 OneDrive Folder: {args.folder}")
    safe_print(f"🌍 Environment: {args.environment}")
    
    # Install required packages
    safe_print("📦 Installing required packages...")
    install_required_packages()
    
    # Get access token
    safe_print("🔐 Getting access token...")
    access_token = get_access_token(args.client_id, args.client_secret, args.tenant_id)
    if not access_token:
        safe_print("❌ Failed to get access token!")
        return False
    
    # Upload file to OneDrive
    safe_print("📤 Uploading file to OneDrive...")
    file_info = upload_file_to_onedrive(pdf_file, access_token, args.folder)
    if not file_info:
        safe_print("❌ Failed to upload file to OneDrive!")
        return False
    
    # Create share link
    safe_print("🔗 Creating share link...")
    share_link = create_share_link(file_info['id'], access_token)
    if not share_link:
        safe_print("❌ Failed to create share link!")
        return False
    
    # Send Teams notification if requested
    if args.teams:
        safe_print("📤 Sending Teams notification...")
        teams_success = send_teams_notification_with_share_link(
            share_link, 
            file_info['name'], 
            args.environment
        )
        if not teams_success:
            safe_print("⚠️ Teams notification failed, but file was uploaded successfully")
    
    # Success!
    safe_print("🎉 PDF uploaded to OneDrive successfully!")
    safe_print(f"📄 File Name: {file_info['name']}")
    safe_print(f"📊 File Size: {file_info['size']} bytes")
    safe_print(f"🔗 Share Link: {share_link}")
    safe_print(f"📁 OneDrive Location: {args.folder}/{file_info['name']}")
    
    return True

if __name__ == "__main__":
    success = main()
    if not success:
        sys.exit(1)
