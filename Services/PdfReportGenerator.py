#!/usr/bin/env python3
"""
PDF Report Generator for VaxCare API Test Reports
Converts HTML test reports to PDF format using Python libraries
"""

import os
import sys
import argparse
import subprocess
from pathlib import Path
from datetime import datetime

class PdfReportGenerator:
    def __init__(self, output_dir="TestReports"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
    def check_dependencies(self):
        """Check if required Python packages are available"""
        missing_packages = []
        
        try:
            import weasyprint
        except ImportError:
            missing_packages.append("weasyprint")
            
        try:
            import pdfkit
        except ImportError:
            missing_packages.append("pdfkit")
            
        try:
            import reportlab
        except ImportError:
            missing_packages.append("reportlab")
            
        if missing_packages:
            print("❌ Missing Python packages:", ", ".join(missing_packages))
            print("\n📦 Install with:")
            print("  pip install weasyprint")
            print("  pip install pdfkit")
            print("  pip install reportlab")
            return False
            
        return True
    
    def convert_with_weasyprint(self, html_file, pdf_file):
        """Convert HTML to PDF using weasyprint"""
        try:
            import weasyprint
            
            print("🔄 Converting with weasyprint...")
            
            # Create CSS for better PDF formatting
            css = """
            @page {
                size: A4;
                margin: 20mm;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.4;
            }
            .container {
                max-width: none;
                box-shadow: none;
            }
            .stats {
                page-break-inside: avoid;
            }
            .test-scenario {
                page-break-inside: avoid;
                margin-bottom: 10px;
            }
            """
            
            # Convert HTML to PDF
            html_doc = weasyprint.HTML(filename=str(html_file))
            css_doc = weasyprint.CSS(string=css)
            html_doc.write_pdf(str(pdf_file), stylesheets=[css_doc])
            
            return True
            
        except Exception as e:
            print(f"❌ Weasyprint conversion failed: {e}")
            return False
    
    def convert_with_pdfkit(self, html_file, pdf_file):
        """Convert HTML to PDF using pdfkit (requires wkhtmltopdf)"""
        try:
            import pdfkit
            
            print("🔄 Converting with pdfkit...")
            
            options = {
                'page-size': 'A4',
                'margin-top': '20mm',
                'margin-bottom': '20mm',
                'margin-left': '15mm',
                'margin-right': '15mm',
                'encoding': 'UTF-8',
                'enable-local-file-access': None,
                'print-media-type': None,
                'disable-smart-shrinking': None,
                'zoom': '0.8'
            }
            
            pdfkit.from_file(str(html_file), str(pdf_file), options=options)
            return True
            
        except Exception as e:
            print(f"❌ Pdfkit conversion failed: {e}")
            return False
    
    def convert_with_reportlab(self, html_file, pdf_file):
        """Convert HTML to PDF using reportlab (basic implementation)"""
        try:
            from reportlab.lib.pagesizes import A4
            from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
            from reportlab.lib.styles import getSampleStyleSheet
            from bs4 import BeautifulSoup
            
            print("🔄 Converting with reportlab...")
            
            # Parse HTML content
            with open(html_file, 'r', encoding='utf-8') as f:
                soup = BeautifulSoup(f.read(), 'html.parser')
            
            # Create PDF document
            doc = SimpleDocTemplate(str(pdf_file), pagesize=A4)
            styles = getSampleStyleSheet()
            story = []
            
            # Add title
            title = Paragraph("🧪 VaxCare API Test Report", styles['Title'])
            story.append(title)
            story.append(Spacer(1, 12))
            
            # Add timestamp
            timestamp = Paragraph(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", styles['Normal'])
            story.append(timestamp)
            story.append(Spacer(1, 20))
            
            # Add test statistics
            stats_para = Paragraph("📊 Test Statistics", styles['Heading2'])
            story.append(stats_para)
            story.append(Spacer(1, 12))
            
            # Extract and add test scenarios
            test_scenarios = soup.find_all('div', class_='test-scenario')
            for scenario in test_scenarios:
                scenario_name = scenario.find('span', class_='scenario-name')
                if scenario_name:
                    scenario_text = f"✅ {scenario_name.get_text()}"
                    para = Paragraph(scenario_text, styles['Normal'])
                    story.append(para)
                    story.append(Spacer(1, 6))
            
            # Build PDF
            doc.build(story)
            return True
            
        except Exception as e:
            print(f"❌ Reportlab conversion failed: {e}")
            return False
    
    def convert_html_to_pdf(self, html_file, pdf_file=None):
        """Convert HTML file to PDF using available methods"""
        html_path = Path(html_file)
        
        if not html_path.exists():
            print(f"❌ HTML file not found: {html_file}")
            return False
        
        if pdf_file is None:
            timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            pdf_file = self.output_dir / f"{html_path.stem}_{timestamp}.pdf"
        
        pdf_path = Path(pdf_file)
        
        print(f"📄 Converting HTML to PDF...")
        print(f"   Input:  {html_path}")
        print(f"   Output: {pdf_path}")
        
        # Try different conversion methods
        methods = [
            self.convert_with_weasyprint,
            self.convert_with_pdfkit,
            self.convert_with_reportlab
        ]
        
        for method in methods:
            try:
                if method(html_path, pdf_path):
                    print(f"✅ PDF generated successfully: {pdf_path}")
                    print(f"📊 Size: {pdf_path.stat().st_size / 1024:.1f} KB")
                    return True
            except Exception as e:
                print(f"⚠️  Method failed: {e}")
                continue
        
        print("❌ All conversion methods failed")
        return False
    
    def convert_all_html(self):
        """Convert all HTML files in the output directory to PDF"""
        html_files = list(self.output_dir.glob("*.html"))
        
        if not html_files:
            print(f"❌ No HTML files found in {self.output_dir}")
            return False
        
        print(f"📄 Found {len(html_files)} HTML files to convert")
        
        success_count = 0
        for html_file in html_files:
            print(f"\n🔄 Converting: {html_file.name}")
            if self.convert_html_to_pdf(html_file):
                success_count += 1
        
        print(f"\n📊 Conversion Summary:")
        print(f"   Total files: {len(html_files)}")
        print(f"   Successful: {success_count}")
        print(f"   Failed: {len(html_files) - success_count}")
        
        return success_count > 0
    
    def find_latest_html(self):
        """Find the latest HTML report file"""
        html_files = list(self.output_dir.glob("EnhancedTestReport_*.html"))
        
        if not html_files:
            return None
        
        # Sort by modification time and return the latest
        latest_file = max(html_files, key=lambda f: f.stat().st_mtime)
        return latest_file

def main():
    parser = argparse.ArgumentParser(description="Generate PDF reports from HTML test reports")
    parser.add_argument("html_file", nargs="?", help="HTML file to convert")
    parser.add_argument("-o", "--output", default="TestReports", help="Output directory")
    parser.add_argument("-a", "--all", action="store_true", help="Convert all HTML files")
    parser.add_argument("-l", "--latest", action="store_true", help="Convert latest HTML file")
    
    args = parser.parse_args()
    
    generator = PdfReportGenerator(args.output)
    
    # Check dependencies
    if not generator.check_dependencies():
        sys.exit(1)
    
    if args.all:
        success = generator.convert_all_html()
    elif args.latest:
        html_file = generator.find_latest_html()
        if not html_file:
            print(f"❌ No HTML reports found in {args.output}")
            sys.exit(1)
        print(f"📄 Using latest HTML report: {html_file}")
        success = generator.convert_html_to_pdf(html_file)
    elif args.html_file:
        success = generator.convert_html_to_pdf(args.html_file)
    else:
        # Try to find the latest HTML file
        html_file = generator.find_latest_html()
        if not html_file:
            print("❌ No HTML file specified and no reports found")
            print("💡 Use --help for usage information")
            sys.exit(1)
        print(f"📄 Using latest HTML report: {html_file}")
        success = generator.convert_html_to_pdf(html_file)
    
    if success:
        print("\n🎉 PDF Report Generation Completed!")
    else:
        print("\n❌ PDF Report Generation Failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()
