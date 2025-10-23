#!/usr/bin/env python3
"""
Generate HTML report for the latest test run
"""

import os
import glob
import subprocess
import sys

def find_latest_xml_file():
    """Find the most recent XML test results file"""
    xml_files = glob.glob("TestReports/TestReports/TestResults_*.xml")
    if not xml_files:
        print("❌ No XML test results files found")
        return None
    
    # Sort by modification time, get the most recent
    latest_file = max(xml_files, key=os.path.getmtime)
    return latest_file

def generate_html_report(xml_file):
    """Generate HTML report from XML file"""
    print(f"📄 Generating HTML report from: {xml_file}")
    
    try:
        result = subprocess.run([
            "python3", "generate-enhanced-html-report-robust.py",
            "--xml", xml_file,
            "--output", "TestReports"
        ], capture_output=True, text=True, check=True)
        
        print("✅ HTML report generated successfully!")
        print(result.stdout)
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to generate HTML report: {e}")
        print(f"Error: {e.stderr}")
        return False

def main():
    print("🚀 Generating HTML Report for Latest Test Run")
    print("=" * 50)
    
    # Find the latest XML file
    latest_xml = find_latest_xml_file()
    if not latest_xml:
        sys.exit(1)
    
    print(f"📊 Found latest test results: {latest_xml}")
    
    # Generate HTML report
    if generate_html_report(latest_xml):
        print("\n🎉 HTML report generation completed successfully!")
        print("📁 Check the TestReports directory for the HTML file")
    else:
        print("\n❌ HTML report generation failed")
        sys.exit(1)

if __name__ == "__main__":
    main()

