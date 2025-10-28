#!/usr/bin/env python3
"""
Verification script to confirm "..." has been removed from endpoint descriptions
"""

import os
import glob
import re

def verify_endpoints_clean():
    """Verify that endpoints no longer contain '...' ellipsis"""
    
    print("Verifying Clean Endpoint Descriptions")
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
    
    # Check for any remaining "..." in endpoints
    ellipsis_count = content.count('...')
    print(f"\n🔍 Analysis Results:")
    print(f"   Total '...' found: {ellipsis_count}")
    
    if ellipsis_count == 0:
        print("✅ SUCCESS: No '...' ellipsis found in the report!")
        print("✅ All endpoint descriptions are now clean and specific")
    else:
        print("❌ ISSUE: '...' ellipsis still found in the report")
        print("   This indicates the removal was not complete")
    
    # Extract all endpoint descriptions
    endpoints = re.findall(r'<div><strong>🔗 Endpoint:</strong> ([^<]+)</div>', content)
    
    print(f"\n📊 Found {len(endpoints)} Endpoint Descriptions:")
    print("-" * 50)
    
    clean_endpoints = 0
    for endpoint in endpoints:
        if '...' in endpoint:
            print(f"   ❌ Contains '...': {endpoint}")
        else:
            print(f"   ✅ Clean: {endpoint}")
            clean_endpoints += 1
    
    # Calculate cleanliness percentage
    if len(endpoints) > 0:
        cleanliness_rate = (clean_endpoints / len(endpoints)) * 100
        print(f"\n📈 Cleanliness Metrics:")
        print(f"   Total Endpoints: {len(endpoints)}")
        print(f"   Clean Endpoints: {clean_endpoints}")
        print(f"   Cleanliness Rate: {cleanliness_rate:.1f}%")
    
    # Check for specific endpoint patterns
    endpoint_patterns = [
        "GET /api/inventory",
        "POST /api/patients/appointment",
        "GET /api/patients/clinic",
        "GET /api/patients/insurance",
        "GET /api/patients/staffer",
        "GET /api/setup"
    ]
    
    print(f"\n🎯 Specific Endpoint Patterns:")
    for pattern in endpoint_patterns:
        if pattern in content:
            print(f"   ✅ Found: {pattern}")
        else:
            print(f"   ❌ Missing: {pattern}")
    
    print(f"\n🎉 Summary:")
    if ellipsis_count == 0 and clean_endpoints == len(endpoints):
        print("✅ PERFECT: All endpoint descriptions are clean and specific!")
        print("✅ No '...' ellipsis found anywhere in the report")
        print("✅ Professional, clean endpoint descriptions")
    elif ellipsis_count == 0:
        print("✅ EXCELLENT: No '...' ellipsis found in the report!")
        print("✅ Endpoint descriptions are clean and professional")
    else:
        print("❌ ISSUE: '...' ellipsis still present in the report")
        print("   This indicates the removal was not complete")

if __name__ == "__main__":
    verify_endpoints_clean()
