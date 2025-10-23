#!/bin/bash

# Bash script to run tests with automatic report generation
# Usage: ./run-tests-with-reporting.sh [filter] [--open-reports] [--verbose]

set -e

# Default values
FILTER=""
OPEN_REPORTS=false
VERBOSE=false
OUTPUT_FORMAT="html,json,markdown"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --open-reports)
            OPEN_REPORTS=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        *)
            if [[ -z "$FILTER" ]]; then
                FILTER="$1"
            fi
            shift
            ;;
    esac
done

echo "🧪 VaxCare API Test Suite - Running Tests with Reporting"
echo "========================================================"

# Set up variables
PROJECT_PATH="VaxCareApiTests.csproj"
REPORTS_DIR="TestReports"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Create reports directory if it doesn't exist
if [ ! -d "$REPORTS_DIR" ]; then
    mkdir -p "$REPORTS_DIR"
    echo "📁 Created reports directory: $REPORTS_DIR"
fi

# Build the project first
echo "🔨 Building project..."
if ! dotnet build "$PROJECT_PATH" --configuration Release --verbosity minimal; then
    echo "❌ Build failed!"
    exit 1
fi
echo "✅ Build successful!"

# Prepare test command
TEST_COMMAND="dotnet test $PROJECT_PATH --configuration Release --logger trx --results-directory $REPORTS_DIR"

if [ -n "$FILTER" ]; then
    TEST_COMMAND="$TEST_COMMAND --filter \"$FILTER\""
fi

if [ "$VERBOSE" = true ]; then
    TEST_COMMAND="$TEST_COMMAND --verbosity normal"
else
    TEST_COMMAND="$TEST_COMMAND --verbosity minimal"
fi

# Add XML logger for detailed results
TEST_COMMAND="$TEST_COMMAND --logger \"xunit;LogFilePath=$REPORTS_DIR/TestResults.xml\""

echo "🚀 Running tests..."
echo "Command: $TEST_COMMAND"

# Execute tests
eval $TEST_COMMAND
TEST_EXIT_CODE=$?

# Check if tests ran successfully
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "⚠️  Some tests failed or were skipped"
fi

# Generate additional reports
echo "📊 Generating detailed reports..."

# Generate enhanced HTML report with beautiful table
echo "📊 Generating enhanced HTML report with beautiful table..."
./generate-enhanced-html-report.sh "$REPORTS_DIR/TestResults.xml" "$REPORTS_DIR"

# Generate additional reports
JSON_REPORT_PATH="$REPORTS_DIR/TestReport_$TIMESTAMP.json"
MARKDOWN_REPORT_PATH="$REPORTS_DIR/TestReport_$TIMESTAMP.md"

# Create JSON report
cat > "$JSON_REPORT_PATH" << EOF
{
  "GeneratedAt": "$(date -Iseconds)",
  "TestExecution": "Completed",
  "ReportsGenerated": [
    "$HTML_REPORT_PATH",
    "$JSON_REPORT_PATH",
    "$MARKDOWN_REPORT_PATH"
  ],
  "TestResultsFile": "$REPORTS_DIR/TestResults.xml"
}
EOF

# Create Markdown report
cat > "$MARKDOWN_REPORT_PATH" << EOF
# 🧪 VaxCare API Test Report

**Generated:** $(date)

## Test Execution Summary

- **Status:** $([ $TEST_EXIT_CODE -eq 0 ] && echo "✅ All tests passed" || echo "⚠️ Some tests failed or were skipped")
- **Exit Code:** $TEST_EXIT_CODE
- **Reports Generated:** 
  - HTML: $HTML_REPORT_PATH
  - JSON: $JSON_REPORT_PATH
  - Markdown: $MARKDOWN_REPORT_PATH

## Files Generated

- TestResults.xml: Detailed test results
- TestReport_$TIMESTAMP.html: HTML report
- TestReport_$TIMESTAMP.json: JSON report
- TestReport_$TIMESTAMP.md: Markdown report

## Next Steps

1. Review the generated reports
2. Check TestResults.xml for detailed test information
3. Use the HTML report for sharing with stakeholders
EOF

echo "📊 Reports generated successfully!"
echo "📁 Reports directory: $REPORTS_DIR"
echo "📄 HTML Report: $HTML_REPORT_PATH"
echo "📄 JSON Report: $JSON_REPORT_PATH"
echo "📄 Markdown Report: $MARKDOWN_REPORT_PATH"

# Open reports if requested
if [ "$OPEN_REPORTS" = true ]; then
    echo "🌐 Opening reports..."
    if command -v xdg-open > /dev/null; then
        xdg-open "$HTML_REPORT_PATH"
    elif command -v open > /dev/null; then
        open "$HTML_REPORT_PATH"
    else
        echo "⚠️  Cannot open reports automatically on this system"
    fi
fi

echo "🎉 Test execution and report generation completed!"
echo "========================================================"

exit $TEST_EXIT_CODE
