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

def safe_print(text):
    """Safely print text that may contain Unicode characters"""
    try:
        print(text)
    except UnicodeEncodeError:
        # Fallback for Windows Command Prompt
        print(text.encode('ascii', 'replace').decode('ascii'))

def run_command(command, description):
    """Run a command and return the result"""
    safe_print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
        safe_print(f"✅ {description} completed successfully")
        return True, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        safe_print(f"❌ {description} failed with exit code {e.returncode}")
        safe_print(f"Error: {e.stderr}")
        return False, e.stdout, e.stderr

def run_command_with_env(command, description, env_vars=None):
    """Run a command with environment variables and return the result"""
    safe_print(f"🔄 {description}...")
    try:
        # Merge with current environment
        env = os.environ.copy()
        if env_vars:
            env.update(env_vars)
        
        result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True, env=env)
        safe_print(f"✅ {description} completed successfully")
        return True, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        safe_print(f"❌ {description} failed with exit code {e.returncode}")
        safe_print(f"Error: {e.stderr}")
        return False, e.stdout, e.stderr

def check_dotnet():
    """Check if .NET is available"""
    success, stdout, stderr = run_command("dotnet --version", "Checking .NET installation")
    if success:
        safe_print(f"📦 .NET version: {stdout.strip()}")
        return True
    else:
        safe_print("❌ .NET not found. Please install .NET SDK")
        return False

def clean_and_restore():
    """Clean and restore the project"""
    safe_print("🧹 Cleaning and restoring project...")
    
    # Clean
    run_command("dotnet clean", "Cleaning project")
    
    # Restore packages
    success, _, _ = run_command("dotnet restore", "Restoring packages")
    return success

def run_tests_with_reporting(test_filter=None, output_dir="TestReports", args=None):
    """Run tests with comprehensive reporting"""
    safe_print("🧪 Running tests with enhanced reporting...")
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Set environment variable for tests
    if args and hasattr(args, 'environment'):
        environment = args.environment
        safe_print(f"🌍 Setting test environment to: {environment}")
        
        # Set environment variable for the test process
        if environment == 'QA':
            os.environ['ASPNETCORE_ENVIRONMENT'] = 'QA'
            safe_print("📋 Using QA configuration (vhapiqa.vaxcare.com)")
        elif environment == 'Production':
            os.environ['ASPNETCORE_ENVIRONMENT'] = 'Production'
            safe_print("📋 Using Production configuration")
        else:  # Staging (default)
            os.environ['ASPNETCORE_ENVIRONMENT'] = 'Staging'
            safe_print("📋 Using Staging configuration")
    else:
        os.environ['ASPNETCORE_ENVIRONMENT'] = 'Staging'
        safe_print("📋 Using default Staging configuration")
    
    # Build the project first
    safe_print("🔨 Building project...")
    build_success, _, _ = run_command("dotnet build", "Building project")
    if not build_success:
        safe_print("❌ Build failed. Please fix build errors first.")
        return False
    
    # Prepare test command
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    trx_file = os.path.join(output_dir, f"TestResults_{timestamp}.trx")
    xml_file = os.path.join(output_dir, f"TestResults_{timestamp}.xml")
    
    # Build test command
    environment = args.environment if args and hasattr(args, 'environment') else 'Staging'
    test_cmd = f"dotnet test --logger \"trx;LogFileName=TestResults_{timestamp}.trx\" --logger \"xunit;LogFileName=TestResults_{timestamp}.xml\" --verbosity normal --results-directory \"{output_dir}\""
    
    if test_filter:
        test_cmd += f" --filter \"{test_filter}\""
    
    # Set environment variables for the test process
    env_vars = {'ASPNETCORE_ENVIRONMENT': environment}
    
    # Run tests with environment variables
    success, stdout, stderr = run_command_with_env(test_cmd, "Running tests", env_vars)
    
    # Always try to generate reports and send notifications, even if some tests failed
    safe_print("📊 Test execution completed!")
    safe_print(stdout)
    if stderr:
        safe_print("STDERR:")
        safe_print(stderr)
    
    # Generate enhanced HTML report
    # First try to use TRX file for actual results
    trx_file_to_use = trx_file
    xml_file_to_use = xml_file
    
    # Check if TRX file exists, if not try to find any TRX file
    if not os.path.exists(trx_file):
        import glob
        trx_files = glob.glob(os.path.join(output_dir, "**", "TestResults_*.trx"), recursive=True)
        if trx_files:
            trx_file_to_use = max(trx_files, key=os.path.getmtime)
            safe_print(f"📄 Using latest TRX file: {trx_file_to_use}")
        else:
            safe_print("⚠️ No TRX test results file found, falling back to XML")
            trx_file_to_use = None
    
    # Try to generate report with actual results using TRX file
    if trx_file_to_use and os.path.exists(trx_file_to_use):
        safe_print("📄 Generating enhanced HTML report with actual results...")
        report_success, _, _ = run_command(
            f"python3 TestRunner/generate-enhanced-html-report-with-actual-results.py --trx \"{trx_file_to_use}\" --output \"{output_dir}\" --environment \"{environment}\"",
            "Generating HTML report with actual results"
        )
        
        # If actual results parser fails, try Windows-compatible actual results parser
        if not report_success:
            safe_print("⚠️ Actual results parser failed, trying Windows-compatible actual results parser...")
            report_success, _, _ = run_command(
                f"python3 TestRunner/generate-enhanced-html-report-with-actual-results-windows.py --trx \"{trx_file_to_use}\" --output \"{output_dir}\" --environment \"{environment}\"",
                "Generating HTML report with Windows-compatible actual results parser"
            )
    
    # Send Teams notification if requested
    if args and args.teams:
        safe_print("📤 Sending Teams notification...")
        # Teams notification script only works with XML files, not TRX files
        # Use XML file for Teams notification
        notification_file = xml_file_to_use
        if notification_file and os.path.exists(notification_file):
            # Use the simplified Teams notification script (no Skipped/Browser fields)
            teams_success, _, _ = run_command(
                f"python3 TestRunner/send-teams-notification.py --xml \"{notification_file}\" --environment \"{args.environment}\"",
                "Sending Teams notification"
            )
        else:
            safe_print("⚠️ No test results file found for Teams notification")
            teams_success = False
        
        if teams_success:
            safe_print("✅ Teams notification sent successfully!")
        else:
            safe_print("⚠️ Teams notification failed, but tests completed")
    
    # Open the HTML report automatically if requested
    if args and not args.no_open:
        open_html_report(output_dir)
    
    if not trx_file_to_use:
        # Fall back to XML file
        if not os.path.exists(xml_file):
            # Try to find any XML file in the output directory or subdirectories
            import glob
            xml_files = glob.glob(os.path.join(output_dir, "**", "TestResults_*.xml"), recursive=True)
            if xml_files:
                # Get the most recent XML file
                xml_file_to_use = max(xml_files, key=os.path.getmtime)
                safe_print(f"📄 Using latest XML file: {xml_file_to_use}")
            else:
                fallback_xml = os.path.join(output_dir, "TestResults.xml")
                if os.path.exists(fallback_xml):
                    safe_print(f"📄 Using existing XML file: {fallback_xml}")
                    xml_file_to_use = fallback_xml
                else:
                    safe_print("⚠️ No XML test results file found")
                    return success  # Return the test success status
        
        if os.path.exists(xml_file_to_use):
            safe_print("📄 Generating enhanced HTML report...")
            # Try robust parser first, then fallback to Windows-compatible version
            report_success, _, _ = run_command(
                f"python3 TestRunner/generate-enhanced-html-report-robust.py --xml \"{xml_file_to_use}\" --output \"{output_dir}\"",
                "Generating HTML report with robust parser"
            )
            
            # If robust parser fails, try Windows-compatible version
            if not report_success:
                safe_print("⚠️ Robust parser failed, trying Windows-compatible version...")
                report_success, _, _ = run_command(
                    f"python3 TestRunner/generate-enhanced-html-report-windows.py --xml \"{xml_file_to_use}\" --output \"{output_dir}\"",
                    "Generating HTML report with Windows-compatible parser"
                )
        
        if report_success:
            safe_print("✅ Enhanced HTML report generated successfully!")
        else:
            safe_print("⚠️ HTML report generation failed, but tests completed")
    
    return success

def open_html_report(output_dir):
    """Open the most recent HTML report in the default browser"""
    try:
        import glob
        import webbrowser
        from pathlib import Path
        
        # Find the most recent HTML report
        html_files = glob.glob(os.path.join(output_dir, "**", "EnhancedTestReport*.html"), recursive=True)
        
        if html_files:
            # Get the most recent HTML file
            latest_html = max(html_files, key=os.path.getmtime)
            safe_print(f"🌐 Opening HTML report: {latest_html}")
            
            # Convert to absolute path for better compatibility
            abs_path = os.path.abspath(latest_html)
            
            # Open in default browser
            webbrowser.open(f"file://{abs_path}")
            safe_print("✅ HTML report opened in default browser")
        else:
            safe_print("⚠️ No HTML report found to open")
            
    except Exception as e:
        safe_print(f"⚠️ Could not open HTML report: {e}")
        safe_print(f"📁 Reports are available in: {output_dir}")

def run_specific_test_categories():
    """Run tests by category"""
    categories = {
        "inventory": "FullyQualifiedName~Inventory",
        "patients": "FullyQualifiedName~Patients", 
        "setup": "FullyQualifiedName~Setup",
        "insurance": "FullyQualifiedName~Insurance",
        "appointment": "FullyQualifiedName~PatientsAppointmentCreate"
    }
    
    safe_print("📋 Available test categories:")
    for i, (name, filter_val) in enumerate(categories.items(), 1):
        safe_print(f"  {i}. {name.title()} ({filter_val})")
    
    return categories

def clean_test_reports():
    """Clean TestReports folder, keeping only the latest files of each type"""
    try:
        import glob
        
        reports_dir = "TestReports"
        if not os.path.exists(reports_dir):
            return
        
        # Define file patterns to clean (keep latest of each type)
        file_patterns = {
            'HTML Reports': '*.html',
            'TRX Files': '*.trx', 
            'XML Files': '*.xml',
            'JSON Files': '*.json',
            'MD Files': '*.md',
            'PDF Files': '*.pdf'
        }
        
        total_removed = 0
        safe_print(f"🧹 Cleaning TestReports folder...")
        safe_print(f"📁 Cleaning all file types, keeping latest of each...")
        
        for file_type, pattern in file_patterns.items():
            # Find all files matching this pattern
            files = glob.glob(os.path.join(reports_dir, pattern))
            
            if len(files) <= 1:
                # Keep all if 1 or fewer files
                continue
            
            # Sort by modification time (newest first)
            files.sort(key=os.path.getmtime, reverse=True)
            
            # Keep only the latest file
            latest_file = files[0]
            files_to_delete = files[1:]
            
            safe_print(f"📄 {file_type}: Keeping {os.path.basename(latest_file)}")
            
            for file_to_delete in files_to_delete:
                try:
                    os.remove(file_to_delete)
                    safe_print(f"🗑️  Removed: {os.path.basename(file_to_delete)}")
                    total_removed += 1
                except Exception as e:
                    safe_print(f"⚠️  Could not remove {os.path.basename(file_to_delete)}: {e}")
        
        # Also clean any subdirectories that might contain old reports
        subdirs = [d for d in os.listdir(reports_dir) if os.path.isdir(os.path.join(reports_dir, d))]
        for subdir in subdirs:
            subdir_path = os.path.join(reports_dir, subdir)
            
            # Clean all file types in subdirectories too
            for file_type, pattern in file_patterns.items():
                subdir_files = glob.glob(os.path.join(subdir_path, pattern))
                if len(subdir_files) > 1:
                    subdir_files.sort(key=os.path.getmtime, reverse=True)
                    files_to_delete = subdir_files[1:]
                    for file_to_delete in files_to_delete:
                        try:
                            os.remove(file_to_delete)
                            safe_print(f"🗑️  Removed from {subdir}: {os.path.basename(file_to_delete)}")
                            total_removed += 1
                        except Exception as e:
                            safe_print(f"⚠️  Could not remove {os.path.basename(file_to_delete)}: {e}")
            
            # If the subdirectory is empty after cleaning, remove it
            try:
                remaining_files = os.listdir(subdir_path)
                if not remaining_files:
                    os.rmdir(subdir_path)
                    safe_print(f"🗑️  Removed empty subdirectory: {subdir}")
            except Exception as e:
                safe_print(f"⚠️  Could not remove subdirectory {subdir}: {e}")
        
        safe_print(f"✅ TestReports folder cleaned successfully!")
        safe_print(f"📊 Total files removed: {total_removed}")
        
    except Exception as e:
        safe_print(f"⚠️  Error cleaning TestReports folder: {e}")


def main():
    parser = argparse.ArgumentParser(description='Run all tests with enhanced HTML reporting')
    parser.add_argument('--filter', help='Test filter (e.g., "FullyQualifiedName~Inventory")')
    parser.add_argument('--category', choices=['inventory', 'patients', 'setup', 'insurance', 'appointment'], 
                       help='Run tests by category')
    parser.add_argument('--output', default='TestReports', help='Output directory for reports')
    parser.add_argument('--clean', action='store_true', help='Clean and restore before running')
    parser.add_argument('--list-categories', action='store_true', help='List available test categories')
    parser.add_argument('--teams', action='store_true', help='Send results to Microsoft Teams')
    parser.add_argument('--webhook', help='Microsoft Teams webhook URL')
    parser.add_argument('--environment', choices=['Staging', 'QA', 'Production'], default='Staging', 
                       help='Environment to run tests against (Staging, QA, Production)')
    parser.add_argument('--browser', default='N/A', help='Browser information for Teams notification')
    parser.add_argument('--open-report', action='store_true', default=True, help='Open HTML report in browser after completion (default: True)')
    parser.add_argument('--no-open', action='store_true', help='Do not open HTML report automatically')
    
    args = parser.parse_args()
    
    safe_print("🚀 VaxCare API Test Suite - Enhanced Test Runner")
    safe_print("=" * 50)
    
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
    success = run_tests_with_reporting(test_filter, args.output, args)
    
    if success:
        safe_print("\n🎉 Test execution completed successfully!")
        safe_print(f"📁 Reports saved in: {args.output}")
        safe_print("📄 HTML report contains detailed results with actual results and failure reasons")
        
        # If report wasn't opened automatically, show how to open it
        if args.no_open:
            safe_print("💡 To open the HTML report manually, navigate to the reports directory and open the HTML file")
    else:
        safe_print("\n❌ Test execution failed")
        sys.exit(1)

if __name__ == "__main__":
    main()
