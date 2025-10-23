#!/usr/bin/env python3
"""
Simple PDF Report Generator for VaxCare API Test Reports
Uses only reportlab (no external system dependencies)
"""

import os
import sys
import argparse
import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.colors import HexColor
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.units import inch
from reportlab.lib import colors

class SimplePdfGenerator:
    def __init__(self, output_dir="TestReports"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
    def parse_xml_results(self, xml_file):
        """Parse XML test results and extract test data"""
        try:
            tree = ET.parse(xml_file)
            root = tree.getroot()
            
            test_results = []
            total_tests = 0
            passed_tests = 0
            failed_tests = 0
            skipped_tests = 0
            
            # Find all test elements
            for test in root.findall('.//test'):
                test_name = test.get('name', 'Unknown')
                result = test.get('result', 'Unknown')
                time_taken = float(test.get('time', 0))
                
                # Extract class name from test name
                class_name = test_name.split('.')[-2] if '.' in test_name else 'Unknown'
                
                # Format test name for display
                display_name = test_name.split('.')[-1].replace('_', ' ')
                
                test_data = {
                    'name': display_name,
                    'full_name': test_name,
                    'class': class_name,
                    'result': result,
                    'time': time_taken,
                    'time_ms': int(time_taken * 1000)
                }
                
                test_results.append(test_data)
                total_tests += 1
                
                if result == 'Pass':
                    passed_tests += 1
                elif result == 'Fail':
                    failed_tests += 1
                else:
                    skipped_tests += 1
            
            return {
                'test_results': test_results,
                'total_tests': total_tests,
                'passed_tests': passed_tests,
                'failed_tests': failed_tests,
                'skipped_tests': skipped_tests,
                'success_rate': (passed_tests / total_tests * 100) if total_tests > 0 else 0
            }
            
        except Exception as e:
            print(f"❌ Error parsing XML: {e}")
            return None
    
    def create_pdf_report(self, xml_file, pdf_file):
        """Create a comprehensive PDF report from XML test results"""
        print(f"📄 Creating PDF report from: {xml_file}")
        
        # Parse XML results
        data = self.parse_xml_results(xml_file)
        if not data:
            return False
        
        # Create PDF document
        doc = SimpleDocTemplate(str(pdf_file), pagesize=A4)
        story = []
        styles = getSampleStyleSheet()
        
        # Custom styles
        title_style = ParagraphStyle(
            'CustomTitle',
            parent=styles['Title'],
            fontSize=24,
            textColor=HexColor('#2c3e50'),
            spaceAfter=20
        )
        
        heading_style = ParagraphStyle(
            'CustomHeading',
            parent=styles['Heading2'],
            fontSize=16,
            textColor=HexColor('#34495e'),
            spaceAfter=12
        )
        
        # Title
        story.append(Paragraph("🧪 VaxCare API Test Report", title_style))
        story.append(Paragraph(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", styles['Normal']))
        story.append(Spacer(1, 20))
        
        # Test Statistics
        story.append(Paragraph("📊 Test Statistics", heading_style))
        
        # Create statistics table
        stats_data = [
            ['Metric', 'Count', 'Percentage'],
            ['Total Tests', str(data['total_tests']), '100%'],
            ['Passed', str(data['passed_tests']), f"{data['passed_tests']/data['total_tests']*100:.1f}%" if data['total_tests'] > 0 else '0%'],
            ['Failed', str(data['failed_tests']), f"{data['failed_tests']/data['total_tests']*100:.1f}%" if data['total_tests'] > 0 else '0%'],
            ['Skipped', str(data['skipped_tests']), f"{data['skipped_tests']/data['total_tests']*100:.1f}%" if data['total_tests'] > 0 else '0%'],
            ['Success Rate', f"{data['success_rate']:.1f}%", '']
        ]
        
        stats_table = Table(stats_data)
        stats_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), HexColor('#3498db')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 12),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), HexColor('#ecf0f1')),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))
        
        story.append(stats_table)
        story.append(Spacer(1, 20))
        
        # Test Results
        story.append(Paragraph("🧪 Test Scenarios", heading_style))
        
        # Group tests by class
        test_classes = {}
        for test in data['test_results']:
            class_name = test['class']
            if class_name not in test_classes:
                test_classes[class_name] = []
            test_classes[class_name].append(test)
        
        # Create test results for each class
        for class_name, tests in test_classes.items():
            story.append(Paragraph(f"📁 {class_name} Tests", styles['Heading3']))
            story.append(Spacer(1, 10))
            
            # Create test table for this class
            test_data = [['Test Name', 'Status', 'Time (ms)']]
            
            for test in tests:
                status_icon = "✅" if test['result'] == 'Pass' else "❌" if test['result'] == 'Fail' else "⏭️"
                test_data.append([
                    test['name'],
                    f"{status_icon} {test['result']}",
                    str(test['time_ms'])
                ])
            
            test_table = Table(test_data)
            test_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), HexColor('#95a5a6')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 10),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
                ('BACKGROUND', (0, 1), (-1, -1), HexColor('#f8f9fa')),
                ('GRID', (0, 0), (-1, -1), 1, colors.black),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [HexColor('#ffffff'), HexColor('#f8f9fa')])
            ]))
            
            story.append(test_table)
            story.append(Spacer(1, 15))
        
        # Summary
        story.append(Paragraph("📋 Summary", heading_style))
        
        if data['failed_tests'] == 0:
            summary_text = f"✅ All {data['total_tests']} tests passed successfully! The VaxCare API test suite is functioning correctly."
        else:
            summary_text = f"⚠️ {data['failed_tests']} out of {data['total_tests']} tests failed. Please review the failed tests."
        
        story.append(Paragraph(summary_text, styles['Normal']))
        story.append(Spacer(1, 20))
        
        # Footer
        story.append(Paragraph("Report generated by VaxCare API Test Suite", styles['Normal']))
        story.append(Paragraph(f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", styles['Normal']))
        
        # Build PDF
        try:
            doc.build(story)
            return True
        except Exception as e:
            print(f"❌ Error building PDF: {e}")
            return False
    
    def convert_xml_to_pdf(self, xml_file, pdf_file=None):
        """Convert XML test results to PDF"""
        xml_path = Path(xml_file)
        
        if not xml_path.exists():
            print(f"❌ XML file not found: {xml_file}")
            return False
        
        if pdf_file is None:
            timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            pdf_file = self.output_dir / f"TestReport_{timestamp}.pdf"
        
        pdf_path = Path(pdf_file)
        
        print(f"📄 Converting XML to PDF...")
        print(f"   Input:  {xml_path}")
        print(f"   Output: {pdf_path}")
        
        if self.create_pdf_report(xml_path, pdf_path):
            print(f"✅ PDF generated successfully: {pdf_path}")
            print(f"📊 Size: {pdf_path.stat().st_size / 1024:.1f} KB")
            return True
        else:
            print("❌ Failed to generate PDF")
            return False
    
    def find_latest_xml(self):
        """Find the latest XML test results file"""
        xml_files = list(self.output_dir.glob("TestResults.xml"))
        
        if not xml_files:
            return None
        
        # Return the most recent XML file
        latest_file = max(xml_files, key=lambda f: f.stat().st_mtime)
        return latest_file

def main():
    parser = argparse.ArgumentParser(description="Generate PDF reports from XML test results")
    parser.add_argument("xml_file", nargs="?", help="XML file to convert")
    parser.add_argument("-o", "--output", default="TestReports", help="Output directory")
    parser.add_argument("-l", "--latest", action="store_true", help="Convert latest XML file")
    
    args = parser.parse_args()
    
    generator = SimplePdfGenerator(args.output)
    
    if args.latest:
        xml_file = generator.find_latest_xml()
        if not xml_file:
            print(f"❌ No XML reports found in {args.output}")
            sys.exit(1)
        print(f"📄 Using latest XML report: {xml_file}")
        success = generator.convert_xml_to_pdf(xml_file)
    elif args.xml_file:
        success = generator.convert_xml_to_pdf(args.xml_file)
    else:
        # Try to find the latest XML file
        xml_file = generator.find_latest_xml()
        if not xml_file:
            print("❌ No XML file specified and no reports found")
            print("💡 Use --help for usage information")
            sys.exit(1)
        print(f"📄 Using latest XML report: {xml_file}")
        success = generator.convert_xml_to_pdf(xml_file)
    
    if success:
        print("\n🎉 PDF Report Generation Completed!")
    else:
        print("\n❌ PDF Report Generation Failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()
