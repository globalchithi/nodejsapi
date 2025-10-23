#!/bin/bash

# Test Teams Integration Script
# Verifies that Teams notifications are working correctly

echo "🧪 Testing Teams Integration"
echo "============================"
echo

# Test 1: Test webhook connection
echo "📤 Test 1: Testing webhook connection..."
python3 send-teams-notification.py --test
if [ $? -eq 0 ]; then
    echo "✅ Webhook connection: SUCCESS"
else
    echo "❌ Webhook connection: FAILED"
    exit 1
fi
echo

# Test 2: Test with existing XML file
echo "📤 Test 2: Testing with existing XML file..."
if [ -f "TestReports/TestResults.xml" ]; then
    python3 send-teams-notification.py --xml TestReports/TestResults.xml --environment "Development" --browser "Chrome (Headless)"
    if [ $? -eq 0 ]; then
        echo "✅ XML notification: SUCCESS"
    else
        echo "❌ XML notification: FAILED"
        exit 1
    fi
else
    echo "⚠️ No XML file found - run tests first"
fi
echo

# Test 3: Test integrated runner
echo "📤 Test 3: Testing integrated runner..."
python3 run-all-tests.py --teams --list-categories
if [ $? -eq 0 ]; then
    echo "✅ Integrated runner: SUCCESS"
else
    echo "❌ Integrated runner: FAILED"
    exit 1
fi
echo

echo "🎉 All Teams integration tests passed!"
echo "✅ Your Teams notifications are working correctly!"
echo
echo "🚀 You can now use:"
echo "   python3 run-all-tests.py --teams"
echo "   python3 send-teams-notification.py"
echo
echo "📱 Check your Teams channel for notifications!"
