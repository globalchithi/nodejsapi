#!/bin/bash

# Simple wrapper script to run tests with Python
# This script provides easy access to the Python test runner

echo "🚀 VaxCare API Test Suite - Python Test Runner"
echo "=============================================="

# Check if Python is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Python 3 is required but not installed"
    echo "Please install Python 3 and try again"
    exit 1
fi

# Check if .NET is available
if ! command -v dotnet >/dev/null 2>&1; then
    echo "❌ .NET SDK is required but not installed"
    echo "Please install .NET SDK and try again"
    exit 1
fi

# Run the Python test runner with all arguments
python3 run-all-tests.py "$@"
