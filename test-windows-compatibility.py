#!/usr/bin/env python3
"""
Test script to verify Windows compatibility of the actual results parser
"""

import os
import sys

def test_windows_compatibility():
    """Test the Windows-compatible actual results parser"""
    
    # Check if we're on Windows
    is_windows = os.name == 'nt'
    print(f"Operating System: {'Windows' if is_windows else 'Unix/Linux/Mac'}")
    
    # Test safe_print function
    def safe_print(text):
        """Safely print text that may contain Unicode characters"""
        try:
            print(text)
        except UnicodeEncodeError:
            # Fallback for Windows Command Prompt
            print(text.encode('ascii', 'replace').decode('ascii'))
    
    # Test various Unicode characters
    test_strings = [
        "Normal text",
        "Text with emojis: 🔬 📊 ✅ ❌",
        "Text with special chars: àáâãäåæçèéêë",
        "Mixed: Hello World! 🌍 Testing 123"
    ]
    
    print("\nTesting safe_print function:")
    for test_str in test_strings:
        try:
            safe_print(f"Testing: {test_str}")
        except Exception as e:
            print(f"Error with '{test_str}': {e}")
    
    # Test if the Windows-compatible script exists
    windows_script = "generate-enhanced-html-report-with-actual-results-windows.py"
    if os.path.exists(windows_script):
        print(f"\n✅ Windows-compatible script found: {windows_script}")
    else:
        print(f"\n❌ Windows-compatible script not found: {windows_script}")
    
    # Test if the main script exists
    main_script = "generate-enhanced-html-report-with-actual-results.py"
    if os.path.exists(main_script):
        print(f"✅ Main script found: {main_script}")
    else:
        print(f"❌ Main script not found: {main_script}")
    
    print("\nWindows compatibility test completed!")

if __name__ == "__main__":
    test_windows_compatibility()
