#!/bin/bash
# Parse test results and send to Teams (macOS/Linux version)
# Usage: ./parse-test-results.sh [webhook-url] [environment] [browser]

set -e

# Default values
WEBHOOK_URL="${1:-}"
ENVIRONMENT="${2:-Development}"
BROWSER="${3:-N/A}"
OUTPUT_DIR="${4:-TestReports}"

echo "📊 Parsing test results and sending to Teams..." 

# Find the XML file
XML_FILE=""
if [ -f "$OUTPUT_DIR/TestResults.xml" ]; then
    XML_FILE="$OUTPUT_DIR/TestResults.xml"
    echo "Found XML file: $XML_FILE"
elif [ -n "$(find "$OUTPUT_DIR" -name "*.trx" -type f 2>/dev/null)" ]; then
    XML_FILE=$(find "$OUTPUT_DIR" -name "*.trx" -type f | head -1)
    echo "Found TRX file: $XML_FILE"
else
    echo "❌ No XML test results found in $OUTPUT_DIR"
    echo "💡 Make sure tests have been run with --logger xunit or --logger trx"
    exit 1
fi

# Check if XML file exists
if [ ! -f "$XML_FILE" ]; then
    echo "❌ XML file not found: $XML_FILE"
    exit 1
fi

echo "📄 Reading XML file: $XML_FILE"

# Extract test statistics using grep and sed
TOTAL_TESTS=$(grep -o 'total="[0-9]*"' "$XML_FILE" | head -1 | sed 's/total="\([0-9]*\)"/\1/')
PASSED_TESTS=$(grep -o 'passed="[0-9]*"' "$XML_FILE" | head -1 | sed 's/passed="\([0-9]*\)"/\1/')
FAILED_TESTS=$(grep -o 'failed="[0-9]*"' "$XML_FILE" | head -1 | sed 's/failed="\([0-9]*\)"/\1/')
SKIPPED_TESTS=$(grep -o 'skipped="[0-9]*"' "$XML_FILE" | head -1 | sed 's/skipped="\([0-9]*\)"/\1/')
EXECUTION_TIME=$(grep -o 'time="[0-9.]*"' "$XML_FILE" | head -1 | sed 's/time="\([0-9.]*\)"/\1/')

# Set defaults if not found
TOTAL_TESTS=${TOTAL_TESTS:-0}
PASSED_TESTS=${PASSED_TESTS:-0}
FAILED_TESTS=${FAILED_TESTS:-0}
SKIPPED_TESTS=${SKIPPED_TESTS:-0}
EXECUTION_TIME=${EXECUTION_TIME:-N/A}

# Calculate success rate
if [ "$TOTAL_TESTS" -gt 0 ]; then
    SUCCESS_RATE=$(echo "scale=1; ($PASSED_TESTS * 100) / $TOTAL_TESTS" | bc)
else
    SUCCESS_RATE=0
fi

# Format execution time
if [ "$EXECUTION_TIME" != "N/A" ] && [ -n "$EXECUTION_TIME" ]; then
    SECONDS=$(echo "$EXECUTION_TIME" | cut -d. -f1)
    if [ "$SECONDS" -lt 60 ]; then
        FORMATTED_TIME="${SECONDS} seconds"
    else
        MINUTES=$((SECONDS / 60))
        REMAINING_SECONDS=$((SECONDS % 60))
        if [ "$REMAINING_SECONDS" -eq 0 ]; then
            FORMATTED_TIME="${MINUTES}m"
        else
            FORMATTED_TIME="${MINUTES}m ${REMAINING_SECONDS}s"
        fi
    fi
else
    FORMATTED_TIME="N/A"
fi

# Get current timestamp
TIMESTAMP=$(date "+%m/%d/%Y, %I:%M:%S %p")

# Determine status
if [ "$FAILED_TESTS" -eq 0 ]; then
    STATUS="✅ All $TOTAL_TESTS tests passed successfully!"
    STATUS_EMOJI="✅"
else
    STATUS="❌ $FAILED_TESTS tests failed out of $TOTAL_TESTS total tests"
    STATUS_EMOJI="❌"
fi

echo "📊 Test Statistics:"
echo "   Total Tests: $TOTAL_TESTS"
echo "   Passed: $PASSED_TESTS"
echo "   Failed: $FAILED_TESTS"
echo "   Skipped: $SKIPPED_TESTS"
echo "   Success Rate: $SUCCESS_RATE%"
echo "   Execution Time: $FORMATTED_TIME"

# Send to Teams if webhook URL provided
if [ -n "$WEBHOOK_URL" ]; then
    echo "📢 Sending results to Microsoft Teams..."
    
    # Create JSON payload
    JSON_PAYLOAD=$(cat << EOF
{
  "text": "🚀 VaxCare API Test Automation Results",
  "attachments": [
    {
      "contentType": "application/vnd.microsoft.card.adaptive",
      "content": {
        "type": "AdaptiveCard",
        "body": [
          {
            "type": "TextBlock",
            "text": "VaxCare API Test Results",
            "weight": "Bolder",
            "size": "Medium"
          },
          {
            "type": "TextBlock",
            "text": "$STATUS",
            "wrap": true
          },
          {
            "type": "FactSet",
            "facts": [
              {
                "title": "Environment",
                "value": "$ENVIRONMENT"
              },
              {
                "title": "Total Tests",
                "value": "$TOTAL_TESTS"
              },
              {
                "title": "Passed",
                "value": "$PASSED_TESTS"
              },
              {
                "title": "Failed",
                "value": "$FAILED_TESTS"
              },
              {
                "title": "Skipped",
                "value": "$SKIPPED_TESTS"
              },
              {
                "title": "Success Rate",
                "value": "$SUCCESS_RATE%"
              },
              {
                "title": "Duration",
                "value": "$FORMATTED_TIME"
              },
              {
                "title": "Browser",
                "value": "$BROWSER"
              },
              {
                "title": "Timestamp",
                "value": "$TIMESTAMP"
              }
            ]
          }
        ],
        "version": "1.0"
      }
    }
  ]
}
EOF
)
    
    # Send to Teams using curl
    echo "📤 Sending notification via curl..."
    if curl -s -X POST -H "Content-Type: application/json" --data-raw "$JSON_PAYLOAD" "$WEBHOOK_URL"; then
        echo "✅ Teams notification sent successfully!"
        echo "📱 Check your Microsoft Teams channel for the test results"
    else
        echo "❌ Failed to send Teams notification"
        echo "💡 Check your webhook URL and network connectivity"
        exit 1
    fi
else
    echo "ℹ️  No Teams webhook URL provided - results not sent to Teams"
    echo "💡 Use: ./parse-test-results.sh \"your-webhook-url\" \"Development\" \"Chrome\""
fi

echo "🎉 Test results parsing completed!"
