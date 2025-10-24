#!/usr/bin/env python3
"""
Verification script to confirm skipped tests are completely removed from reports
"""

import os
import glob

def verify_skipped_removal():
    """Verify that skipped tests are completely removed from HTML reports"""
    
    print("Verifying Skipped Test Removal")
    print("=" * 35)
    
    # Find the latest HTML report
    html_files = glob.glob("TestReports/EnhancedTestReport_WithActualResults_*.html")
    if not html_files:
        print("❌ No HTML reports found")
        return
    
    latest_report = max(html_files, key=os.path.getmtime)
    print(f"📄 Checking latest report: {latest_report}")
    
    # Check for any mention of "skipped" in the HTML
    with open(latest_report, 'r', encoding='utf-8') as f:
        content = f.read()
    
    skipped_mentions = content.lower().count('skipped')
    
    print(f"\n🔍 Analysis Results:")
    print(f"   Mentions of 'skipped': {skipped_mentions}")
    
    if skipped_mentions == 0:
        print("✅ SUCCESS: No skipped tests found in HTML report!")
        print("✅ Skipped tests are completely removed from the report")
    else:
        print("❌ ISSUE: Skipped tests still found in HTML report")
        print("   This indicates the removal was not complete")
    
    # Check for specific elements that should be removed
    elements_to_check = [
        'stat-card skipped',
        'stat-label.*Skipped',
        'status-skipped',
        'skipped .stat-number'
    ]
    
    print(f"\n🔍 Checking for removed elements:")
    for element in elements_to_check:
        if element in content:
            print(f"   ❌ Found: {element}")
        else:
            print(f"   ✅ Removed: {element}")
    
    print(f"\n📊 Report Statistics:")
    # Extract statistics from the HTML
    if 'stat-card passed' in content:
        print("   ✅ Passed tests section present")
    if 'stat-card failed' in content:
        print("   ✅ Failed tests section present")
    if 'stat-card total' in content:
        print("   ✅ Total tests section present")
    if 'stat-card success-rate' in content:
        print("   ✅ Success rate section present")
    
    print(f"\n🎯 Summary:")
    if skipped_mentions == 0:
        print("✅ Skipped tests are completely removed from HTML reports!")
        print("✅ Reports now show only Passed, Failed, Total, and Success Rate")
        print("✅ Clean, focused reports without skipped test clutter")
    else:
        print("❌ Skipped tests still present - removal incomplete")

if __name__ == "__main__":
    verify_skipped_removal()
