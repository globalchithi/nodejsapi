# OneDrive Integration Guide

This guide explains how to upload PDF test reports to OneDrive/SharePoint and share them with your team.

## 🚀 Quick Start

### 1. Simple OneDrive Upload (Recommended)
```bash
python3 upload-pdf-to-onedrive-simple.py --teams
```

### 2. Open OneDrive in Browser
```bash
python3 upload-pdf-to-onedrive-simple.py --open
```

### 3. Advanced OneDrive Upload (API)
```bash
python3 upload-pdf-to-onedrive.py --client-id YOUR_ID --client-secret YOUR_SECRET --tenant-id YOUR_TENANT --teams
```

## 📦 Available Methods

### Method 1: Simple OneDrive Upload (Recommended)
- **Purpose**: Easy OneDrive upload with instructions
- **Usage**: `python3 upload-pdf-to-onedrive-simple.py [--teams] [--open]`
- **Features**: Browser integration, detailed instructions, Teams notifications

### Method 2: Advanced OneDrive Upload (API)
- **Purpose**: Automated OneDrive upload using Microsoft Graph API
- **Usage**: `python3 upload-pdf-to-onedrive.py --client-id ID --client-secret SECRET --tenant-id TENANT`
- **Features**: Full automation, share link creation, Teams integration

## 🔧 Usage Examples

### Example 1: Simple Upload with Teams
```bash
# Upload PDF and send Teams notification with instructions
python3 upload-pdf-to-onedrive-simple.py --teams
```

### Example 2: Open OneDrive in Browser
```bash
# Open OneDrive and show upload instructions
python3 upload-pdf-to-onedrive-simple.py --open
```

### Example 3: Advanced API Upload
```bash
# Automated upload using Microsoft Graph API
python3 upload-pdf-to-onedrive.py --client-id YOUR_ID --client-secret YOUR_SECRET --tenant-id YOUR_TENANT --teams
```

### Example 4: Upload to Specific Folder
```bash
# Upload to specific OneDrive folder
python3 upload-pdf-to-onedrive.py --client-id ID --client-secret SECRET --tenant-id TENANT --folder "TestReports" --teams
```

## 🛠️ Setup Instructions

### Method 1: Simple OneDrive Upload (No Setup Required)
1. **Run the script**: `python3 upload-pdf-to-onedrive-simple.py --teams`
2. **Follow instructions**: The script will guide you through the upload process
3. **Share link**: Copy the share link from OneDrive and share it in Teams

### Method 2: Advanced API Upload (Requires Azure Setup)
1. **Go to Azure Portal**: https://portal.azure.com
2. **Navigate to**: Azure Active Directory > App registrations
3. **Create new app**: Click "New registration"
4. **Configure app**:
   - Name: "Test Report Uploader"
   - Supported account types: "Accounts in this organizational directory only"
   - Redirect URI: Leave blank
5. **Get credentials**:
   - Client ID: Copy from "Overview" page
   - Client Secret: Go to "Certificates & secrets" > "New client secret"
   - Tenant ID: Copy from "Overview" page
6. **Grant permissions**:
   - Go to "API permissions"
   - Add "Microsoft Graph" > "Application permissions"
   - Add "Files.ReadWrite" permission
   - Click "Grant admin consent"
7. **Use the script**: `python3 upload-pdf-to-onedrive.py --client-id ID --client-secret SECRET --tenant-id TENANT`

## 📊 Teams Message Format

### Simple Upload Message
```
🚀 Test Automation Results - PDF Upload Required

📄 PDF Report: EnhancedTestReport_20251023_103356.pdf (1.2 MB)
📁 File Location: /path/to/TestReports/EnhancedTestReport_20251023_103356.pdf
🌍 Environment: Development
⏰ Generated: 10/23/2025, 10:33:56 AM

📋 Upload Instructions:
1. Open OneDrive: Go to https://onedrive.live.com
2. Sign In: Use your Microsoft account
3. Upload File: Click 'Upload' button and select the PDF file
4. Create Share Link: Right-click the uploaded file and select 'Share'
5. Copy Link: Copy the share link and share it in this channel

🔗 Alternative Methods:
- OneDrive App: Use the OneDrive desktop app
- Drag & Drop: Drag the PDF file to OneDrive web interface
- Email: Attach PDF to email and save to OneDrive

💡 Note: Once uploaded, the PDF will be accessible to your team through the share link.
```

### Advanced Upload Message
```
🚀 Test Automation Results with PDF Report

📄 PDF Report: EnhancedTestReport_20251023_103356.pdf
🔗 Download Link: Click here to download PDF
📁 OneDrive Location: https://onedrive.live.com/...

File Details:
- Name: EnhancedTestReport_20251023_103356.pdf
- Location: OneDrive/SharePoint
- Environment: Development
- Generated: 10/23/2025, 10:33:56 AM
- Access: Click the link above to download the PDF

💡 Note: The PDF is now stored in OneDrive and can be accessed by your team through the share link.
```

## 🔍 Troubleshooting

### Common Issues

#### 1. "No PDF files found"
- **Solution**: Generate a PDF first using `python3 convert-html-to-pdf.py`
- **Check**: Ensure TestReports directory exists

#### 2. "OneDrive upload failed"
- **Solution**: Check internet connection and OneDrive access
- **Alternative**: Use simple upload method with browser

#### 3. "Access token failed"
- **Solution**: Check Azure app configuration and permissions
- **Alternative**: Use simple upload method

#### 4. "Share link creation failed"
- **Solution**: Check OneDrive permissions and file access
- **Alternative**: Create share link manually in OneDrive

### Error Messages

#### "Missing required parameters"
- **Solution**: Provide client-id, client-secret, and tenant-id
- **Alternative**: Use simple upload method

#### "Failed to get access token"
- **Solution**: Check Azure app configuration and permissions
- **Alternative**: Use simple upload method

#### "Upload failed"
- **Solution**: Check file permissions and OneDrive access
- **Alternative**: Use browser upload method

## 🎯 Best Practices

### 1. Use Simple Upload Method (Recommended)
```bash
# Easy and reliable
python3 upload-pdf-to-onedrive-simple.py --teams
```

### 2. Organize Files in OneDrive
- Create a "TestReports" folder in OneDrive
- Use consistent naming conventions
- Set appropriate sharing permissions

### 3. Test Upload Process
```bash
# Test the upload process
python3 upload-pdf-to-onedrive-simple.py --open
```

### 4. Use Advanced Method for Automation
```bash
# For automated pipelines
python3 upload-pdf-to-onedrive.py --client-id ID --client-secret SECRET --tenant-id TENANT --teams
```

## 📋 Integration Examples

### Add to run-all-tests.py
```python
# Add OneDrive upload after PDF generation
if pdf_success:
    safe_print("📤 Uploading PDF to OneDrive...")
    onedrive_success, _, _ = run_command(
        "python3 upload-pdf-to-onedrive-simple.py --teams",
        "Uploading PDF to OneDrive"
    )
```

### Add to CI/CD Pipeline
```bash
# Add to your CI/CD pipeline
python3 upload-pdf-to-onedrive-simple.py --teams --environment "CI"
```

### Add to Scheduled Jobs
```bash
# Add to cron job
0 9 * * * cd /path/to/project && python3 upload-pdf-to-onedrive-simple.py --teams
```

## 🚀 Advanced Usage

### Custom OneDrive Folder
```bash
# Upload to specific folder
python3 upload-pdf-to-onedrive.py --client-id ID --client-secret SECRET --tenant-id TENANT --folder "TestReports" --teams
```

### Multiple PDFs
```bash
# Upload multiple PDFs
for pdf in TestReports/*.pdf; do
    python3 upload-pdf-to-onedrive-simple.py --pdf "$pdf" --teams
done
```

### Environment-Specific Upload
```bash
# Upload with different environments
python3 upload-pdf-to-onedrive-simple.py --pdf report.pdf --environment "Production" --teams
```

## 📁 File Structure

```
TestReports/
├── EnhancedTestReport_2025-10-23_10-33-56.html
├── EnhancedTestReport_2025-10-23_10-33-56_20251023_104512.pdf
├── TestResults_2025-10-23_10-33-56.html
└── TestResults_2025-10-23_10-33-56_20251023_104512.pdf

OneDrive/
└── TestReports/
    ├── EnhancedTestReport_2025-10-23_10-33-56_20251023_104512.pdf
    └── TestResults_2025-10-23_10-33-56_20251023_104512.pdf
```

## 🎉 Success!

Your PDF test reports can now be uploaded to OneDrive and shared with your team through:

- 📊 **Teams Messages** - With upload instructions and share links
- 🔗 **OneDrive Links** - Direct access to PDF files
- 📁 **Organized Storage** - Files stored in OneDrive for easy access
- 👥 **Team Sharing** - Share links for team collaboration

## 💡 Tips

1. **Use Simple Method**: Most reliable and easy to use
2. **Organize Files**: Create folders in OneDrive for better organization
3. **Test Upload**: Test the upload process before automation
4. **Share Links**: Always test share links before sending to Teams
5. **Permissions**: Set appropriate sharing permissions for your team
