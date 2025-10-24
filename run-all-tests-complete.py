#!/usr/bin/env python3
"""
Run All Tests Complete
One-command script to run tests, generate HTML, create PDF, and send to Teams
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

def main():
    """Main workflow - everything in one command"""
    safe_print("🚀 Run All Tests Complete")
    safe_print("=" * 40)
    safe_print("🧪 Running tests...")
    safe_print("📊 Generating HTML report...")
    safe_print("📄 Creating PDF...")
    safe_print("📤 Sending to Teams...")
    safe_print("=" * 40)
    
    # Parse command line arguments
    environment = "Staging"
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
                safe_print("Usage: python3 run-all-tests-complete.py [--environment ENV] [--onedrive] [--filter FILTER]")
                safe_print("")
                safe_print("This script will:")
                safe_print("1. 🧪 Run .NET tests")
                safe_print("2. 📊 Generate enhanced HTML report")
                safe_print("3. 📄 Convert HTML to PDF")
                safe_print("4. 📤 Send results to Teams")
                safe_print("")
                safe_print("Options:")
                safe_print("  --environment ENV    Environment name (default: Staging)")
                safe_print("  --onedrive           Use OneDrive upload instructions")
                safe_print("  --filter FILTER      Filter tests by class, method, or category")
                safe_print("  --help              Show this help message")
                safe_print("")
                safe_print("Filter Examples:")
                safe_print("  --filter \"ClassName=PatientsAppointmentCheckoutTests\"")
                safe_print("  --filter \"FullyQualifiedName~CheckoutAppointment\"")
                safe_print("  --filter \"Category=Integration\"")
                return
    
    # Run the complete workflow
    filter_arg = f" --filter \"{test_filter}\"" if test_filter else ""
    success, _, _ = run_command(
        f"python3 run-complete-test-workflow.py --environment \"{environment}\" {'--onedrive' if use_onedrive else ''}{filter_arg}",
        "Running complete test workflow"
    )
    
    if success:
        safe_print("🎉 All tests completed successfully!")
        safe_print("📊 HTML report generated")
        safe_print("📄 PDF created")
        safe_print("📤 Teams notification sent")
    else:
        safe_print("❌ Test workflow failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()
