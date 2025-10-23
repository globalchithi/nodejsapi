#!/usr/bin/env python3
"""
Complete Test Workflow
Runs tests, generates HTML, creates PDF, and sends to Teams
"""

import os
import sys
import subprocess
import glob
from datetime import datetime

def safe_print(message):
    """Safely print text that may contain Unicode characters"""
    try:
        print(message)
    except UnicodeEncodeError:
        print(message.encode('ascii', 'replace').decode('ascii'))

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

def install_dependencies():
    """Install required dependencies"""
    safe_print("📦 Installing dependencies...")
    
    dependencies = [
        "weasyprint",
        "pdfkit", 
        "playwright"
    ]
    
    for dep in dependencies:
        success, _, _ = run_command(
            f"{sys.executable} -m pip install {dep}",
            f"Installing {dep}"
        )
        if not success:
            safe_print(f"⚠️ Failed to install {dep}, continuing...")
    
    # Install playwright browsers
    run_command(
        f"{sys.executable} -m playwright install chromium",
        "Installing playwright browsers"
    )

def run_tests(test_filter=None):
    """Run .NET tests with optional filter"""
    safe_print("🧪 Step 1: Running .NET tests...")
    
    # Build test command
    test_command = "dotnet test --logger trx --logger html --results-directory TestReports"
    if test_filter:
        test_command += f" --filter \"{test_filter}\""
        safe_print(f"🔍 Filtering tests: {test_filter}")
    
    success, _, _ = run_command(
        test_command,
        "Running .NET tests"
    )
    return success

def generate_html_report():
    """Generate enhanced HTML report"""
    safe_print("📊 Step 2: Generating enhanced HTML report...")
    success, _, _ = run_command(
        "python3 generate-enhanced-html-report-robust.py",
        "Generating enhanced HTML report"
    )
    return success

def convert_html_to_pdf():
    """Convert HTML to PDF"""
    safe_print("📄 Step 3: Converting HTML to PDF...")
    success, _, _ = run_command(
        "python3 convert-html-to-pdf.py",
        "Converting HTML to PDF"
    )
    return success

def find_latest_pdf():
    """Find the latest PDF file"""
    pdf_files = glob.glob("TestReports/**/*.pdf", recursive=True)
    if not pdf_files:
        return None
    return max(pdf_files, key=os.path.getmtime)

def send_to_teams_with_pdf(pdf_file, environment="Development"):
    """Send test results with PDF to Teams"""
    safe_print("📤 Step 4: Sending to Microsoft Teams...")
    success, _, _ = run_command(
        f"python3 send-pdf-with-share-link.py --pdf \"{pdf_file}\" --environment \"{environment}\"",
        "Sending PDF to Teams with share link"
    )
    return success

def send_to_teams_with_onedrive(pdf_file, environment="Development"):
    """Send test results with OneDrive upload instructions"""
    safe_print("📤 Step 4: Sending to Microsoft Teams with OneDrive instructions...")
    success, _, _ = run_command(
        f"python3 upload-pdf-to-onedrive-simple.py --pdf \"{pdf_file}\" --environment \"{environment}\" --teams",
        "Sending PDF to Teams with OneDrive instructions"
    )
    return success

def main():
    """Main workflow"""
    safe_print("🚀 Complete Test Workflow")
    safe_print("=" * 50)
    safe_print("This script will:")
    safe_print("1. 🧪 Run .NET tests")
    safe_print("2. 📊 Generate enhanced HTML report")
    safe_print("3. 📄 Convert HTML to PDF")
    safe_print("4. 📤 Send results to Teams")
    safe_print("=" * 50)
    
    # Parse command line arguments
    environment = "Development"
    use_onedrive = False
    test_filter = None
    
    if len(sys.argv) > 1:
        for i, arg in enumerate(sys.argv[1:]):
            if arg == "--environment" and i + 1 < len(sys.argv):
                environment = sys.argv[i + 2]
            elif arg == "--onedrive":
                use_onedrive = True
            elif arg == "--filter" and i + 1 < len(sys.argv):
                test_filter = sys.argv[i + 2]
            elif arg == "--help":
                safe_print("Usage: python3 run-complete-test-workflow.py [--environment ENV] [--onedrive] [--filter FILTER]")
                safe_print("")
                safe_print("Options:")
                safe_print("  --environment ENV    Environment name (default: Development)")
                safe_print("  --onedrive           Use OneDrive upload instructions")
                safe_print("  --filter FILTER      Filter tests by class, method, or category")
                safe_print("  --help              Show this help message")
                safe_print("")
                safe_print("Filter Examples:")
                safe_print("  --filter \"ClassName=PatientsAppointmentCheckoutTests\"")
                safe_print("  --filter \"FullyQualifiedName~CheckoutAppointment\"")
                safe_print("  --filter \"Category=Integration\"")
                return
    
    # Step 1: Install dependencies
    safe_print("📦 Installing dependencies...")
    install_dependencies()
    
    # Step 2: Run tests
    test_success = run_tests(test_filter)
    if not test_success:
        safe_print("⚠️ Tests failed, but continuing with report generation...")
    
    # Step 3: Generate HTML report
    html_success = generate_html_report()
    if not html_success:
        safe_print("⚠️ HTML report generation failed, trying to find existing HTML files...")
    
    # Step 4: Convert to PDF
    pdf_success = convert_html_to_pdf()
    if not pdf_success:
        safe_print("❌ PDF conversion failed!")
        return False
    
    # Step 5: Find PDF file
    pdf_file = find_latest_pdf()
    if not pdf_file:
        safe_print("❌ No PDF file found!")
        return False
    
    safe_print(f"📄 Found PDF file: {pdf_file}")
    
    # Step 6: Send to Teams
    if use_onedrive:
        teams_success = send_to_teams_with_onedrive(pdf_file, environment)
    else:
        teams_success = send_to_teams_with_pdf(pdf_file, environment)
    
    if not teams_success:
        safe_print("❌ Teams notification failed!")
        return False
    
    # Success!
    safe_print("🎉 Complete workflow finished successfully!")
    safe_print(f"📄 PDF file: {pdf_file}")
    safe_print("📤 Teams notification sent!")
    
    if use_onedrive:
        safe_print("💡 Check Teams for OneDrive upload instructions")
    else:
        safe_print("💡 Check Teams for PDF file information and share instructions")
    
    return True

if __name__ == "__main__":
    success = main()
    if not success:
        sys.exit(1)
