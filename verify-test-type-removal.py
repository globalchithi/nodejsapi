#!/usr/bin/env python3
"""
Verification script to confirm "Test Type" field is removed from HTML reports
"""

import os
import glob

def verify_test_type_removal():
    """Verify that 'Test Type' field is removed from HTML reports"""
    
    print("Verifying 'Test Type' Field Removal")
    print("=" * 40)
    
    # Find the latest HTML report
    html_files = glob.glob("TestReports/EnhancedTestReport_WithActualResults_*.html")
    if not html_files:
        print("❌ No HTML reports found")
        return
    
    latest_report = max(html_files, key=os.path.getmtime)
    print(f"📄 Checking latest report: {latest_report}")
    
    # Check for any mention of "Test Type" in the HTML
    with open(latest_report, 'r', encoding='utf-8') as f:
        content = f.read()
    
    test_type_mentions = content.lower().count('test type')
    
    print(f"\n🔍 Analysis Results:")
    print(f"   Mentions of 'Test Type': {test_type_mentions}")
    
    if test_type_mentions == 0:
        print("✅ SUCCESS: 'Test Type' field removed from HTML report!")
        print("✅ Test info section now shows only Description, Endpoint, and Expected Result")
    else:
        print("❌ ISSUE: 'Test Type' field still found in HTML report")
        print("   This indicates the removal was not complete")
    
    # Check for specific elements that should be removed
    elements_to_check = [
        'Test Type:',
        '🎯 Test Type:',
        'Test Type</strong>',
        'test_type'
    ]
    
    print(f"\n🔍 Checking for removed elements:")
    for element in elements_to_check:
        if element in content:
            print(f"   ❌ Found: {element}")
        else:
            print(f"   ✅ Removed: {element}")
    
    print(f"\n📊 Test Info Section Structure:")
    # Check that the remaining fields are still present
    if 'Description:' in content:
        print("   ✅ Description field present")
    if 'Endpoint:' in content:
        print("   ✅ Endpoint field present")
    if 'Expected Result:' in content:
        print("   ✅ Expected Result field present")
    
    print(f"\n🎯 Summary:")
    if test_type_mentions == 0:
        print("✅ 'Test Type' field completely removed from HTML reports!")
        print("✅ Test info section now shows only essential information")
        print("✅ Cleaner, more focused test information display")
    else:
        print("❌ 'Test Type' field still present - removal incomplete")

if __name__ == "__main__":
    verify_test_type_removal()
