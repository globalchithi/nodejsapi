#!/usr/bin/env python3
"""
Verification script to check improved expected results in HTML reports
"""

import os
import glob
import re

def verify_expected_results_improvement():
    """Verify that expected results are more accurate and specific"""
    
    print("Verifying Improved Expected Results")
    print("=" * 40)
    
    # Find the latest HTML report
    html_files = glob.glob("TestReports/EnhancedTestReport_WithActualResults_*.html")
    if not html_files:
        print("❌ No HTML reports found")
        return
    
    latest_report = max(html_files, key=os.path.getmtime)
    print(f"📄 Checking latest report: {latest_report}")
    
    # Read the HTML content
    with open(latest_report, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check for improved expected results patterns
    improved_patterns = [
        "All required headers validated successfully",
        "Endpoint structure and format validated",
        "Date parameter formats validated",
        "Version parameter formats validated",
        "Clinic ID parameter formats validated",
        "Query parameters validated successfully",
        "Curl command structure validated",
        "Authentication headers handled correctly",
        "200 OK with inventory products data",
        "200 OK with lot numbers data",
        "200 OK with lot inventory data",
        "200 OK with clinic data",
        "200 OK with insurance data",
        "200 OK with providers data",
        "200 OK with shot administrators data",
        "200 OK with users partner level data",
        "200 OK with location data",
        "200 OK with check data response",
        "200 OK with appointment data",
        "200 OK with appointment ID returned",
        "200 OK with unique patient appointment created",
        "400 Bad Request or appropriate error for invalid appointment ID",
        "Response logging demonstrated successfully"
    ]
    
    print(f"\n🔍 Checking for Improved Expected Results:")
    found_improvements = 0
    for pattern in improved_patterns:
        if pattern in content:
            found_improvements += 1
            print(f"   ✅ Found: {pattern}")
        else:
            print(f"   ❌ Missing: {pattern}")
    
    # Check for old generic patterns that should be replaced
    old_patterns = [
        "Validation passed",
        "200 OK with data returned",
        "Proper handling of scenario"
    ]
    
    print(f"\n🔍 Checking for Old Generic Patterns:")
    found_old_patterns = 0
    for pattern in old_patterns:
        if pattern in content:
            found_old_patterns += 1
            print(f"   ⚠️  Still found: {pattern}")
        else:
            print(f"   ✅ Replaced: {pattern}")
    
    # Count total expected results
    expected_result_count = content.count("Expected Result:")
    print(f"\n📊 Statistics:")
    print(f"   Total Expected Results: {expected_result_count}")
    print(f"   Improved Patterns Found: {found_improvements}")
    print(f"   Old Generic Patterns: {found_old_patterns}")
    
    # Calculate improvement percentage
    if expected_result_count > 0:
        improvement_percentage = (found_improvements / expected_result_count) * 100
        print(f"   Improvement Rate: {improvement_percentage:.1f}%")
    
    print(f"\n🎯 Summary:")
    if found_improvements > 0:
        print("✅ Expected results have been improved with more specific descriptions!")
        print("✅ Test information now shows detailed expected outcomes")
        print("✅ Better understanding of what each test should accomplish")
    else:
        print("❌ No improved expected results found")
        print("   This indicates the enhancement may not have been applied")
    
    if found_old_patterns == 0:
        print("✅ All old generic patterns have been replaced!")
    else:
        print(f"⚠️  {found_old_patterns} old generic patterns still present")

if __name__ == "__main__":
    verify_expected_results_improvement()
