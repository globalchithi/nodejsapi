#!/usr/bin/env python3
"""
Simple HTML to PDF Converter
Quick script to convert HTML files to PDF
"""

import os
import sys
import glob
from datetime import datetime

def safe_print(message):
    """Safely print text that may contain Unicode characters"""
    try:
        print(message)
    except UnicodeEncodeError:
        print(message.encode('ascii', 'replace').decode('ascii'))

def convert_html_to_pdf(html_file, output_file=None):
    """Convert HTML to PDF using weasyprint"""
    try:
        import weasyprint
        
        if not os.path.exists(html_file):
            safe_print(f"❌ HTML file not found: {html_file}")
            return False
        
        # Generate output filename if not provided
        if not output_file:
            base_name = os.path.splitext(os.path.basename(html_file))[0]
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_file = f"{base_name}_{timestamp}.pdf"
        
        safe_print(f"🔄 Converting {html_file} to {output_file}...")
        
        # Read HTML content
        with open(html_file, 'r', encoding='utf-8') as f:
            html_content = f.read()
        
        # Create PDF
        html_doc = weasyprint.HTML(string=html_content)
        html_doc.write_pdf(output_file)
        
        safe_print(f"✅ PDF generated successfully: {output_file}")
        return True
        
    except ImportError:
        safe_print("❌ weasyprint not installed. Installing...")
        import subprocess
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "weasyprint"])
            safe_print("✅ weasyprint installed successfully!")
            # Retry conversion
            return convert_html_to_pdf(html_file, output_file)
        except subprocess.CalledProcessError:
            safe_print("❌ Failed to install weasyprint")
            return False
    except Exception as e:
        safe_print(f"❌ Conversion failed: {e}")
        return False

def find_latest_html():
    """Find the latest HTML file in TestReports directory"""
    html_files = glob.glob("TestReports/**/*.html", recursive=True)
    
    if not html_files:
        return None
    
    # Get the most recent HTML file
    latest_file = max(html_files, key=os.path.getmtime)
    return latest_file

def main():
    """Main function"""
    if len(sys.argv) > 1:
        html_file = sys.argv[1]
        output_file = sys.argv[2] if len(sys.argv) > 2 else None
    else:
        # Find latest HTML file
        html_file = find_latest_html()
        if not html_file:
            safe_print("❌ No HTML files found in TestReports directory")
            safe_print("Usage: python3 convert-html-to-pdf.py [html_file] [output_pdf]")
            return
        output_file = None
    
    safe_print("🚀 HTML to PDF Converter")
    safe_print("=" * 30)
    safe_print(f"📄 Input: {html_file}")
    
    if convert_html_to_pdf(html_file, output_file):
        safe_print("🎉 Conversion completed successfully!")
    else:
        safe_print("❌ Conversion failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()

