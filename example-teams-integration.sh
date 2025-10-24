#!/bin/bash

# Example Teams Integration Script
# Demonstrates how to use the Teams notification feature

echo "🚀 VaxCare API Test Suite - Teams Integration Examples"
echo "====================================================="
echo

# Example 1: Test Teams connection
echo "📤 Example 1: Test Teams connection"
echo "Command: python3 send-teams-notification.py --test"
echo
python3 send-teams-notification.py --test
echo

# Example 2: Send notification for existing test results
echo "📤 Example 2: Send notification for existing test results"
echo "Command: python3 send-teams-notification.py --xml TestReports/TestResults.xml"
echo
if [ -f "TestReports/TestResults.xml" ]; then
    python3 send-teams-notification.py --xml TestReports/TestResults.xml --environment "Staging" --browser "Chrome (Headless)"
else
    echo "⚠️ No existing test results found. Run tests first."
fi
echo

# Example 3: Run tests with Teams notification
echo "📤 Example 3: Run tests with Teams notification"
echo "Command: python3 run-all-tests.py --teams --environment 'Staging' --browser 'Firefox'"
echo
echo "Note: This would run actual tests. Uncomment the line below to execute:"
echo "# python3 run-all-tests.py --teams --environment 'Staging' --browser 'Firefox'"
echo

# Example 4: Run specific test category with Teams notification
echo "📤 Example 4: Run specific test category with Teams notification"
echo "Command: python3 run-all-tests.py --category inventory --teams"
echo
echo "Note: This would run inventory tests. Uncomment the line below to execute:"
echo "# python3 run-all-tests.py --category inventory --teams"
echo

echo "🎉 Teams integration examples completed!"
echo "Check your Teams channel for notifications!"
