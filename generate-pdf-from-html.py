#!/usr/bin/env python3
"""
HTML to PDF Converter
Converts HTML test reports to PDF files using weasyprint or pdfkit
"""

import os
import sys
import argparse
import subprocess
from datetime import datetime
import glob

def safe_print(message):
    """Safely print text that may contain Unicode characters"""
    try:
        print(message)
    except UnicodeEncodeError:
        # Fallback for Windows Command Prompt
        print(message.encode('ascii', 'replace').decode('ascii'))

def install_weasyprint():
    """Install weasyprint if not available"""
    try:
        import weasyprint
        return True
    except ImportError:
        safe_print("📦 Installing weasyprint...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "weasyprint"])
            safe_print("✅ weasyprint installed successfully!")
            return True
        except subprocess.CalledProcessError:
            safe_print("❌ Failed to install weasyprint")
            return False

def install_pdfkit():
    """Install pdfkit if not available"""
    try:
        import pdfkit
        return True
    except ImportError:
        safe_print("📦 Installing pdfkit...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "pdfkit"])
            safe_print("✅ pdfkit installed successfully!")
            return True
        except subprocess.CalledProcessError:
            safe_print("❌ Failed to install pdfkit")
            return False

def convert_with_weasyprint(html_file, output_file):
    """Convert HTML to PDF using weasyprint"""
    try:
        import weasyprint
        
        safe_print(f"🔄 Converting {html_file} to PDF using weasyprint...")
        
        # Read HTML content
        with open(html_file, 'r', encoding='utf-8') as f:
            html_content = f.read()
        
        # Create PDF
        html_doc = weasyprint.HTML(string=html_content)
        html_doc.write_pdf(output_file)
        
        safe_print(f"✅ PDF generated successfully: {output_file}")
        return True
        
    except Exception as e:
        safe_print(f"❌ weasyprint conversion failed: {e}")
        return False

def convert_with_pdfkit(html_file, output_file):
    """Convert HTML to PDF using pdfkit (requires wkhtmltopdf)"""
    try:
        import pdfkit
        
        safe_print(f"🔄 Converting {html_file} to PDF using pdfkit...")
        
        # Configure pdfkit options
        options = {
            'page-size': 'A4',
            'margin-top': '0.75in',
            'margin-right': '0.75in',
            'margin-bottom': '0.75in',
            'margin-left': '0.75in',
            'encoding': "UTF-8",
            'no-outline': None,
            'enable-local-file-access': None
        }
        
        # Convert HTML to PDF
        pdfkit.from_file(html_file, output_file, options=options)
        
        safe_print(f"✅ PDF generated successfully: {output_file}")
        return True
        
    except Exception as e:
        safe_print(f"❌ pdfkit conversion failed: {e}")
        return False

def convert_with_playwright(html_file, output_file):
    """Convert HTML to PDF using playwright"""
    try:
        from playwright.sync_api import sync_playwright
        
        safe_print(f"🔄 Converting {html_file} to PDF using playwright...")
        
        with sync_playwright() as p:
            browser = p.chromium.launch()
            page = browser.new_page()
            
            # Load HTML file
            page.goto(f"file://{os.path.abspath(html_file)}")
            
            # Generate PDF
            page.pdf(
                path=output_file,
                format='A4',
                margin={
                    'top': '0.75in',
                    'right': '0.75in',
                    'bottom': '0.75in',
                    'left': '0.75in'
                }
            )
            
            browser.close()
        
        safe_print(f"✅ PDF generated successfully: {output_file}")
        return True
        
    except Exception as e:
        safe_print(f"❌ playwright conversion failed: {e}")
        return False

def find_latest_html_file(directory="TestReports"):
    """Find the latest HTML file in the directory"""
    html_files = glob.glob(os.path.join(directory, "**", "*.html"), recursive=True)
    
    if not html_files:
        return None
    
    # Get the most recent HTML file
    latest_file = max(html_files, key=os.path.getmtime)
    return latest_file

def generate_pdf_from_html(html_file, output_file=None, method="auto"):
    """Generate PDF from HTML file"""
    
    if not os.path.exists(html_file):
        safe_print(f"❌ HTML file not found: {html_file}")
        return False
    
    # Generate output filename if not provided
    if not output_file:
        base_name = os.path.splitext(os.path.basename(html_file))[0]
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"{base_name}_{timestamp}.pdf"
    
    safe_print("🚀 HTML to PDF Converter")
    safe_print("=" * 40)
    safe_print(f"📄 Input HTML: {html_file}")
    safe_print(f"📄 Output PDF: {output_file}")
    safe_print(f"🔧 Method: {method}")
    
    success = False
    
    if method == "auto" or method == "weasyprint":
        if install_weasyprint():
            success = convert_with_weasyprint(html_file, output_file)
            if success:
                return True
    
    if method == "auto" or method == "pdfkit":
        if install_pdfkit():
            success = convert_with_pdfkit(html_file, output_file)
            if success:
                return True
    
    if method == "auto" or method == "playwright":
        try:
            from playwright.sync_api import sync_playwright
            success = convert_with_playwright(html_file, output_file)
            if success:
                return True
        except ImportError:
            safe_print("📦 playwright not available, skipping...")
    
    if not success:
        safe_print("❌ All conversion methods failed!")
        safe_print("💡 Try installing dependencies manually:")
        safe_print("   pip install weasyprint")
        safe_print("   pip install pdfkit")
        safe_print("   pip install playwright && playwright install chromium")
        return False
    
    return True

def main():
    parser = argparse.ArgumentParser(description='Convert HTML test reports to PDF')
    parser.add_argument('--html', help='HTML file path (if not provided, will find latest HTML in TestReports)')
    parser.add_argument('--output', help='Output PDF file path')
    parser.add_argument('--method', choices=['auto', 'weasyprint', 'pdfkit', 'playwright'], 
                       default='auto', help='Conversion method')
    parser.add_argument('--latest', action='store_true', help='Use latest HTML file from TestReports directory')
    
    args = parser.parse_args()
    
    # Determine HTML file
    if args.latest or not args.html:
        html_file = find_latest_html_file()
        if not html_file:
            safe_print("❌ No HTML files found in TestReports directory")
            sys.exit(1)
        safe_print(f"📄 Using latest HTML file: {html_file}")
    else:
        html_file = args.html
    
    # Generate PDF
    if generate_pdf_from_html(html_file, args.output, args.method):
        safe_print("🎉 PDF generation completed successfully!")
    else:
        safe_print("❌ PDF generation failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()

