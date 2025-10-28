#!/bin/bash

# Example script showing how to use the Python test runner
# This demonstrates various ways to run tests

echo "🚀 VaxCare API Test Suite - Example Usage"
echo "========================================"

# Check if Python is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Python 3 is required but not installed"
    exit 1
fi

# Check if .NET is available
if ! command -v dotnet >/dev/null 2>&1; then
    echo "❌ .NET SDK is required but not installed"
    exit 1
fi

echo ""
echo "📋 Available commands:"
echo ""

echo "1. Run all tests:"
echo "   python3 run-all-tests.py"
echo ""

echo "2. Run tests by category:"
echo "   python3 run-all-tests.py --category inventory"
echo "   python3 run-all-tests.py --category patients"
echo "   python3 run-all-tests.py --category setup"
echo "   python3 run-all-tests.py --category insurance"
echo ""

echo "3. Run tests with custom filter:"
echo "   python3 run-all-tests.py --filter \"FullyQualifiedName~InventoryApiTests\""
echo "   python3 run-all-tests.py --filter \"FullyQualifiedName~GetInventoryProducts\""
echo ""

echo "4. Clean and run tests:"
echo "   python3 run-all-tests.py --clean"
echo ""

echo "5. Custom output directory:"
echo "   python3 run-all-tests.py --output \"MyReports\""
echo ""

echo "6. List available categories:"
echo "   python3 run-all-tests.py --list-categories"
echo ""

echo "7. Get help:"
echo "   python3 run-all-tests.py --help"
echo ""

echo "🎯 Quick start - run all tests:"
echo "python3 run-all-tests.py"
echo ""

# Ask user if they want to run tests
read -p "Would you like to run all tests now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Running all tests..."
    python3 run-all-tests.py
else
    echo "👋 Use the commands above to run tests when ready!"
fi
