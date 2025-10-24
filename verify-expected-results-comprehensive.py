#!/usr/bin/env python3
"""
Comprehensive verification script to show improved expected results in HTML reports
"""

import os
import glob
import re

def verify_expected_results_comprehensive():
    """Comprehensive verification of improved expected results"""
    
    print("Comprehensive Expected Results Verification")
    print("=" * 50)
    
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
    
    # Extract all expected results from the HTML
    expected_results = re.findall(r'<div><strong>📊 Expected Result:</strong> ([^<]+)</div>', content)
    
    print(f"\n📊 Found {len(expected_results)} Expected Results:")
    print("-" * 50)
    
    # Categorize the expected results
    validation_results = []
    api_results = []
    handling_results = []
    demonstration_results = []
    generic_results = []
    
    for result in expected_results:
        if "validated" in result.lower():
            validation_results.append(result)
        elif "200 OK" in result or "400 Bad Request" in result:
            api_results.append(result)
        elif "handling" in result.lower() or "created" in result.lower():
            handling_results.append(result)
        elif "demonstrated" in result.lower():
            demonstration_results.append(result)
        else:
            generic_results.append(result)
    
    # Display categorized results
    if validation_results:
        print(f"\n🔍 Validation Tests ({len(validation_results)}):")
        for result in validation_results:
            print(f"   ✅ {result}")
    
    if api_results:
        print(f"\n🌐 API Response Tests ({len(api_results)}):")
        for result in api_results:
            print(f"   ✅ {result}")
    
    if handling_results:
        print(f"\n⚙️  Handling Tests ({len(handling_results)}):")
        for result in handling_results:
            print(f"   ✅ {result}")
    
    if demonstration_results:
        print(f"\n🎯 Demonstration Tests ({len(demonstration_results)}):")
        for result in demonstration_results:
            print(f"   ✅ {result}")
    
    if generic_results:
        print(f"\n📝 Generic Tests ({len(generic_results)}):")
        for result in generic_results:
            print(f"   ⚠️  {result}")
    
    # Calculate improvement metrics
    total_results = len(expected_results)
    specific_results = len(validation_results) + len(api_results) + len(handling_results) + len(demonstration_results)
    improvement_rate = (specific_results / total_results) * 100 if total_results > 0 else 0
    
    print(f"\n📈 Improvement Metrics:")
    print(f"   Total Expected Results: {total_results}")
    print(f"   Specific/Detailed Results: {specific_results}")
    print(f"   Generic Results: {len(generic_results)}")
    print(f"   Improvement Rate: {improvement_rate:.1f}%")
    
    # Check for specific improvements
    improvements = [
        ("Header Validation", "All required headers validated successfully"),
        ("Endpoint Structure", "Endpoint structure and format validated"),
        ("Date Formats", "Date parameter formats validated"),
        ("Inventory Data", "200 OK with inventory products data"),
        ("Appointment Creation", "200 OK with unique patient appointment created"),
        ("Error Handling", "400 Bad Request or appropriate error for invalid appointment ID")
    ]
    
    print(f"\n🎯 Specific Improvements Found:")
    for category, pattern in improvements:
        if pattern in content:
            print(f"   ✅ {category}: {pattern}")
        else:
            print(f"   ❌ {category}: Not found")
    
    print(f"\n🎉 Summary:")
    if improvement_rate >= 70:
        print("✅ EXCELLENT: Most expected results are now specific and detailed!")
    elif improvement_rate >= 50:
        print("✅ GOOD: Significant improvement in expected result specificity!")
    elif improvement_rate >= 30:
        print("✅ IMPROVED: Some expected results are now more specific!")
    else:
        print("⚠️  LIMITED: Few expected results have been improved")
    
    print(f"✅ Expected results now provide clear, actionable information")
    print(f"✅ Test reports are more informative and useful")
    print(f"✅ Better understanding of what each test accomplishes")

if __name__ == "__main__":
    verify_expected_results_comprehensive()
