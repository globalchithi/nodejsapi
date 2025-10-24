#!/usr/bin/env python3
"""
Run Tests with PDF Generation
Executes tests, generates HTML reports, and creates PDF files
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
        # Fallback for Windows Command Prompt
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
        safe_print(f"Error: {process.stderr}")
        return False, process.stdout, process.stderr

def install_pdf_dependencies():
    """Install PDF generation dependencies"""
    safe_print("📦 Installing PDF generation dependencies...")
    
    # Install weasyprint
    success1, _, _ = run_command(
        f"{sys.executable} -m pip install weasyprint",
        "Installing weasyprint"
    )
    
    # Install pdfkit
    success2, _, _ = run_command(
        f"{sys.executable} -m pip install pdfkit",
        "Installing pdfkit"
    )
    
    # Install playwright
    success3, _, _ = run_command(
        f"{sys.executable} -m pip install playwright",
        "Installing playwright"
    )
    
    # Install playwright browsers
    if success3:
        run_command(
            f"{sys.executable} -m playwright install chromium",
            "Installing playwright browsers"
        )
    
    return success1 or success2 or success3

def find_latest_html_file():
    """Find the latest HTML file in TestReports directory"""
    html_files = glob.glob("TestReports/**/*.html", recursive=True)
    
    if not html_files:
        return None
    
    # Get the most recent HTML file
    latest_file = max(html_files, key=os.path.getmtime)
    return latest_file

def generate_pdf_from_latest_html():
    """Generate PDF from the latest HTML file"""
    html_file = find_latest_html_file()
    
    if not html_file:
        safe_print("❌ No HTML files found in TestReports directory")
        return False
    
    safe_print(f"📄 Found latest HTML file: {html_file}")
    
    # Generate PDF filename
    base_name = os.path.splitext(os.path.basename(html_file))[0]
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    pdf_file = f"TestReports/{base_name}_{timestamp}.pdf"
    
    # Try different PDF generation methods
    methods = ["weasyprint", "pdfkit", "playwright"]
    
    for method in methods:
        safe_print(f"🔄 Trying PDF generation with {method}...")
        
        success, _, _ = run_command(
            f"{sys.executable} generate-pdf-from-html.py --html \"{html_file}\" --output \"{pdf_file}\" --method {method}",
            f"Generating PDF with {method}"
        )
        
        if success:
            safe_print(f"✅ PDF generated successfully: {pdf_file}")
            return True
    
    safe_print("❌ All PDF generation methods failed!")
    return False

def run_tests_with_pdf_generation():
    """Run tests and generate PDF reports"""
    safe_print("🚀 Running Tests with PDF Generation")
    safe_print("=" * 50)
    
    # Step 1: Install PDF dependencies
    safe_print("📦 Step 1: Installing PDF dependencies...")
    if not install_pdf_dependencies():
        safe_print("⚠️ Some PDF dependencies failed to install, but continuing...")
    
    # Step 2: Run tests
    safe_print("🧪 Step 2: Running tests...")
    test_success, _, _ = run_command(
        "dotnet test --logger trx --logger html --results-directory TestReports",
        "Running .NET tests"
    )
    
    if not test_success:
        safe_print("⚠️ Tests failed, but continuing with report generation...")
    
    # Step 3: Generate enhanced HTML report
    safe_print("📊 Step 3: Generating enhanced HTML report...")
    html_success, _, _ = run_command(
        "python3 generate-enhanced-html-report-robust.py",
        "Generating enhanced HTML report"
    )
    
    if not html_success:
        safe_print("⚠️ Enhanced HTML report generation failed, trying to find existing HTML files...")
    
    # Step 4: Generate PDF from HTML
    safe_print("📄 Step 4: Generating PDF from HTML...")
    pdf_success = generate_pdf_from_latest_html()
    
    if pdf_success:
        safe_print("🎉 PDF generation completed successfully!")
        safe_print("📁 Check the TestReports directory for the PDF file")
    else:
        safe_print("❌ PDF generation failed!")
        return False
    
    return True

def main():
    """Main function"""
    if len(sys.argv) > 1 and sys.argv[1] == "--help":
        safe_print("🚀 Run Tests with PDF Generation")
        safe_print("=" * 40)
        safe_print("Usage: python3 run-tests-with-pdf.py")
        safe_print("")
        safe_print("This script will:")
        safe_print("1. Install PDF generation dependencies")
        safe_print("2. Run .NET tests")
        safe_print("3. Generate enhanced HTML reports")
        safe_print("4. Convert HTML to PDF")
        safe_print("")
        safe_print("Output files will be saved in the TestReports directory")
        return
    
    run_tests_with_pdf_generation()

if __name__ == "__main__":
    main()
