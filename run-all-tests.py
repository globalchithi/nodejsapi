#!/usr/bin/env python3
"""
Comprehensive Test Runner with Enhanced HTML Report Generation
This script runs all .NET tests and generates beautiful HTML reports
"""

import os
import sys
import subprocess
import argparse
from datetime import datetime
import shutil

def run_command(command, description):
    """Run a command and return the result"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
        print(f"✅ {description} completed successfully")
        return True, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed with exit code {e.returncode}")
        print(f"Error: {e.stderr}")
        return False, e.stdout, e.stderr

def check_dotnet():
    """Check if .NET is available"""
    success, stdout, stderr = run_command("dotnet --version", "Checking .NET installation")
    if success:
        print(f"📦 .NET version: {stdout.strip()}")
        return True
    else:
        print("❌ .NET not found. Please install .NET SDK")
        return False

def clean_and_restore():
    """Clean and restore the project"""
    print("🧹 Cleaning and restoring project...")
    
    # Clean
    run_command("dotnet clean", "Cleaning project")
    
    # Restore packages
    success, _, _ = run_command("dotnet restore", "Restoring packages")
    return success

def run_tests_with_reporting(test_filter=None, output_dir="TestReports"):
    """Run tests with comprehensive reporting"""
    print("🧪 Running tests with enhanced reporting...")
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Build the project first
    print("🔨 Building project...")
    build_success, _, _ = run_command("dotnet build", "Building project")
    if not build_success:
        print("❌ Build failed. Please fix build errors first.")
        return False
    
    # Prepare test command
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    xml_file = os.path.join(output_dir, f"TestResults_{timestamp}.xml")
    
    # Build test command
    test_cmd = f"dotnet test --logger \"trx;LogFileName=TestResults_{timestamp}.trx\" --logger \"xunit;LogFileName={xml_file}\" --verbosity normal --results-directory \"{output_dir}\""
    
    if test_filter:
        test_cmd += f" --filter \"{test_filter}\""
    
    # Run tests
    success, stdout, stderr = run_command(test_cmd, "Running tests")
    
    if success:
        print("📊 Test execution completed!")
        print(stdout)
        
        # Generate enhanced HTML report
        xml_file_to_use = xml_file
        if not os.path.exists(xml_file):
            # Try to find any XML file in the output directory
            fallback_xml = os.path.join(output_dir, "TestResults.xml")
            if os.path.exists(fallback_xml):
                print(f"📄 Using existing XML file: {fallback_xml}")
                xml_file_to_use = fallback_xml
            else:
                print("⚠️ No XML test results file found")
                return True  # Tests completed but no XML file
        
        if os.path.exists(xml_file_to_use):
            print("📄 Generating enhanced HTML report...")
            report_success, _, _ = run_command(
                f"python3 generate-enhanced-html-report.py --xml \"{xml_file_to_use}\" --output \"{output_dir}\"",
                "Generating HTML report"
            )
            
            if report_success:
                print("✅ Enhanced HTML report generated successfully!")
            else:
                print("⚠️ HTML report generation failed, but tests completed")
        
        return True
    else:
        print("❌ Test execution failed")
        print("STDOUT:", stdout)
        print("STDERR:", stderr)
        return False

def run_specific_test_categories():
    """Run tests by category"""
    categories = {
        "inventory": "FullyQualifiedName~Inventory",
        "patients": "FullyQualifiedName~Patients", 
        "setup": "FullyQualifiedName~Setup",
        "insurance": "FullyQualifiedName~Insurance"
    }
    
    print("📋 Available test categories:")
    for i, (name, filter_val) in enumerate(categories.items(), 1):
        print(f"  {i}. {name.title()} ({filter_val})")
    
    return categories

def main():
    parser = argparse.ArgumentParser(description='Run all tests with enhanced HTML reporting')
    parser.add_argument('--filter', help='Test filter (e.g., "FullyQualifiedName~Inventory")')
    parser.add_argument('--category', choices=['inventory', 'patients', 'setup', 'insurance'], 
                       help='Run tests by category')
    parser.add_argument('--output', default='TestReports', help='Output directory for reports')
    parser.add_argument('--clean', action='store_true', help='Clean and restore before running')
    parser.add_argument('--list-categories', action='store_true', help='List available test categories')
    
    args = parser.parse_args()
    
    print("🚀 VaxCare API Test Suite - Enhanced Test Runner")
    print("=" * 50)
    
    # List categories if requested
    if args.list_categories:
        run_specific_test_categories()
        return
    
    # Check prerequisites
    if not check_dotnet():
        sys.exit(1)
    
    # Clean and restore if requested
    if args.clean:
        if not clean_and_restore():
            sys.exit(1)
    
    # Determine test filter
    test_filter = None
    if args.filter:
        test_filter = args.filter
    elif args.category:
        categories = run_specific_test_categories()
        test_filter = categories[args.category]
    
    # Run tests
    success = run_tests_with_reporting(test_filter, args.output)
    
    if success:
        print("\n🎉 Test execution completed successfully!")
        print(f"📁 Reports saved in: {args.output}")
        print("📄 Open the HTML report to view detailed results")
    else:
        print("\n❌ Test execution failed")
        sys.exit(1)

if __name__ == "__main__":
    main()
