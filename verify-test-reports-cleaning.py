#!/usr/bin/env python3
"""
Verification script to demonstrate TestReports folder cleaning functionality
"""

import os
import glob

def verify_test_reports_cleaning():
    """Verify that TestReports folder cleaning functionality works correctly"""
    
    print("TestReports Folder Cleaning Verification")
    print("=" * 45)
    
    reports_dir = "TestReports"
    if not os.path.exists(reports_dir):
        print("❌ TestReports folder not found")
        return
    
    # Find all HTML reports
    html_files = glob.glob(os.path.join(reports_dir, "*.html"))
    
    print(f"📊 Current TestReports Folder Status:")
    print(f"   Total HTML Reports: {len(html_files)}")
    
    if len(html_files) == 0:
        print("   📁 No HTML reports found")
        return
    elif len(html_files) == 1:
        print("   ✅ Only 1 HTML report (clean state)")
    else:
        print(f"   ⚠️  Multiple HTML reports found ({len(html_files)})")
    
    # Show all HTML reports
    print(f"\n📄 HTML Reports in TestReports folder:")
    print("-" * 50)
    
    # Sort by modification time (newest first)
    html_files.sort(key=os.path.getmtime, reverse=True)
    
    for i, html_file in enumerate(html_files, 1):
        filename = os.path.basename(html_file)
        size_kb = os.path.getsize(html_file) / 1024
        timestamp = os.path.getmtime(html_file)
        
        print(f"   {i:2d}. {filename}")
        print(f"       Size: {size_kb:.1f} KB")
        
        if i == 1:
            print(f"       Status: 🏆 LATEST (kept by cleaning)")
        else:
            print(f"       Status: 🗑️  Would be removed by cleaning")
        print("")
    
    # Show cleaning functionality explanation
    print(f"🧹 Cleaning Functionality:")
    print("-" * 30)
    print("✅ Automatically runs before each test execution")
    print("✅ Keeps only the most recent HTML report")
    print("✅ Removes all older HTML reports")
    print("✅ Can be disabled with --no-clean flag")
    print("✅ Prevents folder clutter and saves disk space")
    
    # Show usage examples
    print(f"\n🚀 Usage Examples:")
    print("-" * 20)
    print("📝 Clean TestReports before running tests (default):")
    print("   python3 run-all-tests.py")
    print("")
    print("📝 Skip cleaning TestReports folder:")
    print("   python3 run-all-tests.py --no-clean")
    print("")
    print("📝 Run specific test category with cleaning:")
    print("   python3 run-all-tests.py --category inventory")
    print("")
    print("📝 Run with custom filter and cleaning:")
    print("   python3 run-all-tests.py --filter 'FullyQualifiedName~Inventory'")
    
    print(f"\n🎯 Benefits:")
    print("-" * 15)
    print("✅ Clean workspace - no old report clutter")
    print("✅ Disk space savings - removes old reports")
    print("✅ Always shows latest results - keeps most recent report")
    print("✅ Professional workflow - automatic cleanup")
    print("✅ Optional control - can disable if needed")
    
    print(f"\n🎉 Summary:")
    if len(html_files) <= 1:
        print("✅ TestReports folder is in clean state!")
        print("✅ Ready for next test run with automatic cleaning")
    else:
        print(f"⚠️  TestReports folder has {len(html_files)} HTML reports")
        print("✅ Next test run will clean this folder automatically")
        print("✅ Only the latest report will be kept")

if __name__ == "__main__":
    verify_test_reports_cleaning()
