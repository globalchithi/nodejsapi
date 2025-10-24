# PDF Sharing Guide

This guide explains how to share PDF test reports with your team through Microsoft Teams.

## 🚨 Important Note

**Teams webhooks don't support direct file attachments**, but there are several ways to share PDF files:

## 🚀 Quick Solutions

### 1. Send PDF with Share Link
```bash
python3 send-pdf-with-share-link.py
```

### 2. Send PDF with Download Link (Web Server)
```bash
python3 send-teams-notification-with-download-link.py --pdf TestReports/report.pdf
```

### 3. Manual Sharing Methods
- Upload to OneDrive/SharePoint
- Share via email
- Use file sharing services

## 📁 Available Sharing Methods

### Method 1: Share Link (Recommended)
```bash
# Send PDF with file location and share instructions
python3 send-pdf-with-share-link.py --pdf TestReports/report.pdf
```

**What it does:**
- ✅ Sends Teams message with PDF file information
- ✅ Includes file location and share link
- ✅ Provides instructions for accessing the PDF
- ✅ No additional setup required

### Method 2: Web Server Download Link
```bash
# Start web server and create download link
python3 send-teams-notification-with-download-link.py --pdf TestReports/report.pdf --port 8080
```

**What it does:**
- ✅ Starts a local web server
- ✅ Creates a download link for the PDF
- ✅ Sends Teams message with clickable download link
- ⚠️ Requires keeping the web server running

### Method 3: Manual Sharing
1. **Upload to OneDrive/SharePoint**
2. **Share via email**
3. **Use file sharing services** (Google Drive, Dropbox, etc.)

## 🔧 Usage Examples

### Example 1: Share Latest PDF
```bash
# Find and share the latest PDF file
python3 send-pdf-with-share-link.py
```

### Example 2: Share Specific PDF
```bash
# Share a specific PDF file
python3 send-pdf-with-share-link.py --pdf TestReports/MyReport.pdf
```

### Example 3: Share with Environment
```bash
# Share PDF with specific environment
python3 send-pdf-with-share-link.py --pdf report.pdf --environment "Production"
```

### Example 4: Web Server Method
```bash
# Start web server and create download link
python3 send-teams-notification-with-download-link.py --pdf report.pdf --port 8080
```

## 📊 Teams Message Format

### Share Link Message
```
🚀 Test Automation Results with PDF Report

📄 PDF Report: EnhancedTestReport_20251023_103356.pdf (1.2 MB)
📁 File Location: /path/to/TestReports/EnhancedTestReport_20251023_103356.pdf
🔗 Share Link: file:///path/to/TestReports/EnhancedTestReport_20251023_103356.pdf

Instructions for accessing the PDF:
1. Direct Access: Copy the file path above and open in file explorer
2. Share Link: Use the share link to access the file
3. Manual Sharing: Upload to OneDrive/SharePoint for team sharing

File Details:
- Name: EnhancedTestReport_20251023_103356.pdf
- Size: 1.2 MB
- Location: TestReports/EnhancedTestReport_20251023_103356.pdf
- Environment: Staging
- Generated: 10/23/2025, 10:33:56 AM

💡 Tip: For easier sharing, upload this PDF to OneDrive or SharePoint and share the link with your team.
```

### Download Link Message
```
🚀 Test Automation Results with PDF Download

✅ All 15 tests passed successfully!

Environment: Staging
Total Tests: 15
Passed: 15
Failed: 0
Success Rate: 100%
Duration: 2.3s
PDF Report: EnhancedTestReport_20251023_103356.pdf (1.2 MB)
Timestamp: 10/23/2025, 10:33:56 AM

📎 PDF Download Link: Click here to download EnhancedTestReport_20251023_103356.pdf
🔗 Direct Link: http://localhost:8080/EnhancedTestReport_20251023_103356.pdf
```

## 🛠️ Manual Sharing Methods

### 1. OneDrive/SharePoint (Recommended)
1. **Upload PDF to OneDrive/SharePoint**
2. **Get shareable link**
3. **Share link in Teams message**
4. **Set appropriate permissions**

### 2. Email Attachment
1. **Attach PDF to email**
2. **Send to team members**
3. **Include test results summary**

### 3. File Sharing Services
1. **Google Drive**: Upload and share
2. **Dropbox**: Upload and get share link
3. **Box**: Upload and share
4. **WeTransfer**: Send large files

## 🔍 Troubleshooting

### Common Issues

#### 1. "Teams webhook doesn't support file attachments"
- **Solution**: Use share link or manual sharing methods
- **Alternative**: Upload to OneDrive/SharePoint first

#### 2. "Download link not working"
- **Solution**: Ensure web server is running
- **Alternative**: Use share link method instead

#### 3. "File not accessible"
- **Solution**: Check file permissions and path
- **Alternative**: Use manual sharing methods

### Error Messages

#### "No PDF files found"
- **Solution**: Generate a PDF first using `python3 convert-html-to-pdf.py`
- **Check**: Ensure TestReports directory exists

#### "PDF file not found"
- **Solution**: Verify the file path is correct
- **Check**: Use `ls -la TestReports/` to list files

#### "Web server failed to start"
- **Solution**: Check if port is available
- **Alternative**: Use share link method instead

## 🎯 Best Practices

### 1. Use Share Link Method (Recommended)
```bash
# Simple and reliable
python3 send-pdf-with-share-link.py
```

### 2. Upload to OneDrive/SharePoint
1. **Upload PDF to OneDrive/SharePoint**
2. **Get shareable link**
3. **Share link in Teams message**

### 3. Use Web Server for Internal Teams
```bash
# For internal teams with access to your network
python3 send-teams-notification-with-download-link.py --pdf report.pdf
```

### 4. Combine with Email
1. **Send PDF via email**
2. **Send Teams notification with email reference**
3. **Include file information in Teams message**

## 📋 Integration Examples

### Add to run-all-tests.py
```python
# Add PDF sharing after generation
if pdf_success:
    safe_print("📤 Sharing PDF with team...")
    share_success, _, _ = run_command(
        "python3 send-pdf-with-share-link.py",
        "Sharing PDF with team"
    )
```

### Add to CI/CD Pipeline
```bash
# Add to your CI/CD pipeline
python3 send-pdf-with-share-link.py --environment "CI"
```

### Add to Scheduled Jobs
```bash
# Add to cron job
0 9 * * * cd /path/to/project && python3 send-pdf-with-share-link.py
```

## 🚀 Advanced Usage

### Custom Web Server
```bash
# Use custom web server URL
python3 send-teams-notification-with-download-link.py --pdf report.pdf --web-server "http://your-server.com" --port 8080
```

### Multiple PDFs
```bash
# Share multiple PDFs
for pdf in TestReports/*.pdf; do
    python3 send-pdf-with-share-link.py --pdf "$pdf"
done
```

### Environment-Specific Sharing
```bash
# Share with different environments
python3 send-pdf-with-share-link.py --pdf report.pdf --environment "Production"
```

## 🎉 Success!

Your PDF test reports can now be shared with your team through:

- 📊 **Teams Messages** - With file information and share instructions
- 🔗 **Share Links** - Direct file access links
- 🌐 **Download Links** - Web server-based downloads
- 📁 **Manual Sharing** - OneDrive/SharePoint/Email methods

## 💡 Tips

1. **Use Share Link Method**: Most reliable and simple
2. **Upload to OneDrive**: For easier team access
3. **Include File Info**: Always include file size and location
4. **Test Sharing**: Test the sharing method before automation
5. **Keep Web Server Running**: If using download link method
