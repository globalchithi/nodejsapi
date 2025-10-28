#!/usr/bin/env python3
"""
Diagnostic script to identify issues with the test suite
This script checks common problems and provides solutions
"""

import os
import sys
import subprocess
import platform

def check_python():
    """Check Python installation and version"""
    print("=== Python Check ===")
    try:
        version = sys.version_info
        print(f"✅ Python {version.major}.{version.minor}.{version.micro} detected")
        if version.major < 3 or (version.major == 3 and version.minor < 6):
            print("⚠️  Warning: Python 3.6+ recommended")
        return True
    except Exception as e:
        print(f"❌ Python check failed: {e}")
        return False

def check_dotnet():
    """Check .NET installation"""
    print("\n=== .NET Check ===")
    try:
        result = subprocess.run(['dotnet', '--version'], capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print(f"✅ .NET {result.stdout.strip()} detected")
            return True
        else:
            print(f"❌ .NET not found: {result.stderr}")
            return False
    except FileNotFoundError:
        print("❌ .NET not found: dotnet command not available")
        return False
    except Exception as e:
        print(f"❌ .NET check failed: {e}")
        return False

def check_project_files():
    """Check if project files exist"""
    print("\n=== Project Files Check ===")
    required_files = [
        'VaxCareApiTests.csproj',
        'Services/HttpClientService.cs',
        'Tests/'
    ]
    
    all_good = True
    for file_path in required_files:
        if os.path.exists(file_path):
            print(f"✅ {file_path} found")
        else:
            print(f"❌ {file_path} missing")
            all_good = False
    
    return all_good

def check_test_reports_dir():
    """Check TestReports directory"""
    print("\n=== TestReports Directory Check ===")
    if not os.path.exists('TestReports'):
        print("📁 Creating TestReports directory...")
        os.makedirs('TestReports', exist_ok=True)
        print("✅ TestReports directory created")
    else:
        print("✅ TestReports directory exists")
    
    # Check for existing XML files
    xml_files = [f for f in os.listdir('TestReports') if f.endswith('.xml')]
    if xml_files:
        print(f"📄 Found {len(xml_files)} XML files: {xml_files}")
    else:
        print("⚠️  No XML test result files found")
    
    return True

def check_encoding():
    """Check encoding issues"""
    print("\n=== Encoding Check ===")
    try:
        # Test Unicode output
        test_text = "🧪 Test with emoji"
        print(f"✅ Unicode test: {test_text}")
        return True
    except UnicodeEncodeError as e:
        print(f"❌ Unicode encoding error: {e}")
        print("💡 Solution: Use generate-enhanced-html-report-windows.py")
        return False
    except Exception as e:
        print(f"❌ Encoding check failed: {e}")
        return False

def check_dependencies():
    """Check if dependencies can be restored"""
    print("\n=== Dependencies Check ===")
    try:
        result = subprocess.run(['dotnet', 'restore'], capture_output=True, text=True, timeout=60)
        if result.returncode == 0:
            print("✅ Dependencies restored successfully")
            return True
        else:
            print(f"❌ Dependency restore failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ Dependency check failed: {e}")
        return False

def check_build():
    """Check if project builds"""
    print("\n=== Build Check ===")
    try:
        result = subprocess.run(['dotnet', 'build'], capture_output=True, text=True, timeout=120)
        if result.returncode == 0:
            print("✅ Project builds successfully")
            return True
        else:
            print(f"❌ Build failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ Build check failed: {e}")
        return False

def run_simple_test():
    """Run a simple test to check for issues"""
    print("\n=== Simple Test Execution ===")
    try:
        # Try to run a simple test
        result = subprocess.run([
            'dotnet', 'test', 
            '--logger', 'xunit;LogFileName=TestResults_diagnostic.xml',
            '--verbosity', 'minimal'
        ], capture_output=True, text=True, timeout=300)
        
        if result.returncode == 0:
            print("✅ Tests executed successfully")
            return True
        else:
            print(f"❌ Test execution failed with exit code {result.returncode}")
            print(f"STDOUT: {result.stdout}")
            print(f"STDERR: {result.stderr}")
            return False
    except subprocess.TimeoutExpired:
        print("❌ Test execution timed out")
        return False
    except Exception as e:
        print(f"❌ Test execution failed: {e}")
        return False

def main():
    print("🔍 VaxCare API Test Suite - Diagnostic Tool")
    print("=" * 50)
    print(f"Platform: {platform.system()} {platform.release()}")
    print(f"Python: {sys.version}")
    print()
    
    checks = [
        ("Python", check_python),
        (".NET", check_dotnet),
        ("Project Files", check_project_files),
        ("TestReports Directory", check_test_reports_dir),
        ("Encoding", check_encoding),
        ("Dependencies", check_dependencies),
        ("Build", check_build),
        ("Simple Test", run_simple_test)
    ]
    
    results = {}
    for name, check_func in checks:
        try:
            results[name] = check_func()
        except Exception as e:
            print(f"❌ {name} check crashed: {e}")
            results[name] = False
    
    print("\n" + "=" * 50)
    print("📊 DIAGNOSTIC SUMMARY")
    print("=" * 50)
    
    all_passed = True
    for name, passed in results.items():
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{name:20} {status}")
        if not passed:
            all_passed = False
    
    print("\n" + "=" * 50)
    if all_passed:
        print("🎉 All checks passed! Your test suite should work correctly.")
        print("\n💡 Recommended commands:")
        print("   python3 run-all-tests.py")
        print("   python3 generate-enhanced-html-report-windows.py")
    else:
        print("⚠️  Some checks failed. Please address the issues above.")
        print("\n💡 Common solutions:")
        print("   - Install .NET SDK if missing")
        print("   - Use generate-enhanced-html-report-windows.py for encoding issues")
        print("   - Check file permissions for TestReports directory")
        print("   - Run 'dotnet restore' and 'dotnet build' first")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())
