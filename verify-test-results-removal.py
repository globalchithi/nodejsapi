#!/usr/bin/env python3
"""
Verification script to confirm "Test Results" text is removed from HTML reports
"""

import os
import glob

def verify_test_results_removal():
    """Verify that 'Test Results' text is removed from HTML reports"""
    
    print("Verifying 'Test Results' Text Removal")
    print("=" * 40)
    
    # Find the latest HTML report
    html_files = glob.glob("TestReports/EnhancedTestReport_WithActualResults_*.html")
    if not html_files:
        print("❌ No HTML reports found")
        return
    
    latest_report = max(html_files, key=os.path.getmtime)
    print(f"📄 Checking latest report: {latest_report}")
    
    # Check for any mention of "Test Results" in the HTML
    with open(latest_report, 'r', encoding='utf-8') as f:
        content = f.read()
    
    test_results_mentions = content.lower().count('test results')
    
    print(f"\n🔍 Analysis Results:")
    print(f"   Mentions of 'Test Results': {test_results_mentions}")
    
    if test_results_mentions == 0:
        print("✅ SUCCESS: 'Test Results' text removed from HTML report!")
        print("✅ Report now goes directly from statistics to test table")
    else:
        print("❌ ISSUE: 'Test Results' text still found in HTML report")
        print("   This indicates the removal was not complete")
    
    # Check for specific elements that should be removed
    elements_to_check = [
        '<h2>Test Results</h2>',
        '<h2>📋 Test Results</h2>',
        'Test Results'
    ]
    
    print(f"\n🔍 Checking for removed elements:")
    for element in elements_to_check:
        if element in content:
            print(f"   ❌ Found: {element}")
        else:
            print(f"   ✅ Removed: {element}")
    
    print(f"\n📊 Report Structure:")
    # Check that the table still exists
    if '<table class="test-table">' in content:
        print("   ✅ Test table present")
    if '<thead>' in content:
        print("   ✅ Table header present")
    if '<tbody>' in content:
        print("   ✅ Table body present")
    
    print(f"\n🎯 Summary:")
    if test_results_mentions == 0:
        print("✅ 'Test Results' text completely removed from HTML reports!")
        print("✅ Reports now flow directly from statistics to test table")
        print("✅ Cleaner, more streamlined report layout")
    else:
        print("❌ 'Test Results' text still present - removal incomplete")

if __name__ == "__main__":
    verify_test_results_removal()
