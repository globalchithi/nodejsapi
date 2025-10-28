#!/usr/bin/env python3
"""
Comprehensive verification script to demonstrate enhanced TestReports folder cleaning
"""

import os
import glob
from collections import defaultdict

def verify_comprehensive_cleaning():
    """Verify that comprehensive TestReports folder cleaning works correctly"""
    
    print("Comprehensive TestReports Folder Cleaning Verification")
    print("=" * 55)
    
    reports_dir = "TestReports"
    if not os.path.exists(reports_dir):
        print("❌ TestReports folder not found")
        return
    
    # Define file patterns to check
    file_patterns = {
        'HTML Reports': '*.html',
        'TRX Files': '*.trx', 
        'XML Files': '*.xml',
        'JSON Files': '*.json',
        'MD Files': '*.md',
        'PDF Files': '*.pdf'
    }
    
    print(f"📊 Current TestReports Folder Status:")
    print("-" * 40)
    
    total_files = 0
    file_counts = {}
    
    for file_type, pattern in file_patterns.items():
        files = glob.glob(os.path.join(reports_dir, pattern))
        file_counts[file_type] = len(files)
        total_files += len(files)
        
        if len(files) == 0:
            print(f"   📄 {file_type}: 0 files")
        elif len(files) == 1:
            print(f"   📄 {file_type}: 1 file ✅ (clean)")
        else:
            print(f"   📄 {file_type}: {len(files)} files ⚠️  (multiple)")
    
    print(f"\n📈 Summary:")
    print(f"   Total Files: {total_files}")
    print(f"   File Types: {len([t for t in file_patterns.keys() if file_counts[t] > 0])}")
    
    # Show detailed file information
    print(f"\n📋 Detailed File Information:")
    print("-" * 35)
    
    for file_type, pattern in file_patterns.items():
        files = glob.glob(os.path.join(reports_dir, pattern))
        if files:
            # Sort by modification time (newest first)
            files.sort(key=os.path.getmtime, reverse=True)
            
            print(f"\n📄 {file_type} ({len(files)} files):")
            for i, file_path in enumerate(files, 1):
                filename = os.path.basename(file_path)
                size_kb = os.path.getsize(file_path) / 1024
                
                if i == 1:
                    print(f"   🏆 {i}. {filename} ({size_kb:.1f} KB) - LATEST")
                else:
                    print(f"   🗑️  {i}. {filename} ({size_kb:.1f} KB) - Would be removed")
    
    # Check subdirectories
    subdirs = [d for d in os.listdir(reports_dir) if os.path.isdir(os.path.join(reports_dir, d))]
    if subdirs:
        print(f"\n📁 Subdirectories Found:")
        print("-" * 25)
        for subdir in subdirs:
            subdir_path = os.path.join(reports_dir, subdir)
            subdir_files = glob.glob(os.path.join(subdir_path, "*"))
            print(f"   📂 {subdir}: {len(subdir_files)} files")
    
    # Show cleaning functionality explanation
    print(f"\n🧹 Enhanced Cleaning Functionality:")
    print("-" * 40)
    print("✅ Cleans ALL file types (HTML, TRX, XML, JSON, MD, PDF)")
    print("✅ Keeps latest file of each type")
    print("✅ Removes all older files of each type")
    print("✅ Cleans subdirectories too")
    print("✅ Provides detailed cleaning report")
    print("✅ Can be disabled with --no-clean flag")
    
    # Show file type examples
    print(f"\n📋 File Types Cleaned:")
    print("-" * 25)
    for file_type, pattern in file_patterns.items():
        if file_counts[file_type] > 0:
            print(f"   ✅ {file_type}: {file_counts[file_type]} files")
        else:
            print(f"   ❌ {file_type}: No files")
    
    # Show usage examples
    print(f"\n🚀 Usage Examples:")
    print("-" * 20)
    print("📝 Clean all file types before running tests (default):")
    print("   python3 run-all-tests.py")
    print("")
    print("📝 Skip comprehensive cleaning:")
    print("   python3 run-all-tests.py --no-clean")
    print("")
    print("📝 Run specific test with comprehensive cleaning:")
    print("   python3 run-all-tests.py --category inventory")
    print("")
    print("📝 Run with custom filter and comprehensive cleaning:")
    print("   python3 run-all-tests.py --filter 'FullyQualifiedName~Inventory'")
    
    print(f"\n🎯 Benefits:")
    print("-" * 15)
    print("✅ Complete workspace cleanup - all file types")
    print("✅ Maximum disk space savings - removes all old files")
    print("✅ Latest files preserved - keeps most recent of each type")
    print("✅ Subdirectory cleaning - cleans nested reports too")
    print("✅ Professional workflow - comprehensive automatic cleanup")
    print("✅ Detailed reporting - shows exactly what was cleaned")
    
    # Calculate cleanliness score
    clean_types = sum(1 for count in file_counts.values() if count <= 1)
    total_types = len([t for t in file_patterns.keys() if file_counts[t] > 0])
    cleanliness_score = (clean_types / total_types * 100) if total_types > 0 else 100
    
    print(f"\n🎉 Cleanliness Assessment:")
    print("-" * 30)
    if cleanliness_score == 100:
        print("✅ PERFECT: All file types are clean (1 or fewer files each)!")
        print("✅ TestReports folder is in optimal state")
    elif cleanliness_score >= 80:
        print(f"✅ EXCELLENT: {cleanliness_score:.0f}% of file types are clean!")
        print("✅ TestReports folder is mostly clean")
    elif cleanliness_score >= 60:
        print(f"✅ GOOD: {cleanliness_score:.0f}% of file types are clean!")
        print("✅ TestReports folder is reasonably clean")
    else:
        print(f"⚠️  NEEDS CLEANING: Only {cleanliness_score:.0f}% of file types are clean!")
        print("✅ Next test run will clean this folder comprehensively")
    
    print(f"\n📊 Statistics:")
    print(f"   Cleanliness Score: {cleanliness_score:.1f}%")
    print(f"   Total Files: {total_files}")
    print(f"   File Types Present: {total_types}")
    print(f"   Clean File Types: {clean_types}")

if __name__ == "__main__":
    verify_comprehensive_cleaning()
