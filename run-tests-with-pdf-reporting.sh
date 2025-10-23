#!/bin/bash

# Comprehensive Test Reporting with PDF Generation
# This script runs tests and generates HTML, JSON, Markdown, and PDF reports

set -e

# Default values
FILTER=""
OPEN_REPORTS=false
VERBOSE=false
GENERATE_PDF=true
OUTPUT_FORMAT="html,json,markdown,pdf"

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
        --no-pdf)
            GENERATE_PDF=false
            shift
            ;;
        --format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -h|--help)
            echo "🧪 VaxCare API Test Suite - Comprehensive Reporting with PDF"
            echo "=============================================================="
            echo ""
            echo "Usage: $0 [OPTIONS] [FILTER]"
            echo ""
            echo "Options:"
            echo "  -h, --help          Show this help message"
            echo "  --open-reports      Open generated reports automatically"
            echo "  --verbose           Show verbose output"
            echo "  --no-pdf            Skip PDF generation"
            echo "  --format FORMAT     Output formats (html,json,markdown,pdf)"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Run all tests with all reports"
            echo "  $0 \"FullyQualifiedName~Inventory\"   # Run inventory tests with reports"
            echo "  $0 \"FullyQualifiedName~Patients\"     # Run patient tests with reports"
            echo "  $0 --no-pdf                          # Run tests without PDF generation"
            echo "  $0 --open-reports                    # Run tests and open reports"
            echo ""
            exit 0
            ;;
        *)
            if [[ -z "$FILTER" ]]; then
                FILTER="$1"
            fi
            shift
            ;;
    esac
done

echo "🧪 VaxCare API Test Suite - Comprehensive Reporting with PDF"
echo "=============================================================="

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

# Generate HTML report
echo "📊 Generating HTML report..."
./generate-enhanced-report.sh

# Generate PDF report if requested
if [ "$GENERATE_PDF" = true ]; then
    echo "📄 Generating PDF report..."
    if python3 Services/SimplePdfGenerator.py --latest; then
        echo "✅ PDF report generated successfully"
    else
        echo "⚠️  PDF generation failed, but other reports are available"
    fi
fi

# List all generated reports
echo ""
echo "📁 Generated Reports:"
echo "===================="

# List HTML reports
HTML_REPORTS=($(find "$REPORTS_DIR" -name "EnhancedTestReport_*.html" -type f | sort -r))
if [ ${#HTML_REPORTS[@]} -gt 0 ]; then
    echo "📄 HTML Reports:"
    for report in "${HTML_REPORTS[@]}"; do
        echo "   $(basename "$report")"
    done
fi

# List PDF reports
PDF_REPORTS=($(find "$REPORTS_DIR" -name "TestReport_*.pdf" -type f | sort -r))
if [ ${#PDF_REPORTS[@]} -gt 0 ]; then
    echo "📄 PDF Reports:"
    for report in "${PDF_REPORTS[@]}"; do
        echo "   $(basename "$report") ($(du -h "$report" | cut -f1))"
    done
fi

# List JSON reports
JSON_REPORTS=($(find "$REPORTS_DIR" -name "TestReport_*.json" -type f | sort -r))
if [ ${#JSON_REPORTS[@]} -gt 0 ]; then
    echo "📄 JSON Reports:"
    for report in "${JSON_REPORTS[@]}"; do
        echo "   $(basename "$report")"
    done
fi

# List Markdown reports
MD_REPORTS=($(find "$REPORTS_DIR" -name "TestReport_*.md" -type f | sort -r))
if [ ${#MD_REPORTS[@]} -gt 0 ]; then
    echo "📄 Markdown Reports:"
    for report in "${MD_REPORTS[@]}"; do
        echo "   $(basename "$report")"
    done
fi

# Open reports if requested
if [ "$OPEN_REPORTS" = true ]; then
    echo "🌐 Opening reports..."
    
    # Open latest HTML report
    if [ ${#HTML_REPORTS[@]} -gt 0 ]; then
        echo "   Opening HTML report: ${HTML_REPORTS[0]}"
        open "${HTML_REPORTS[0]}"
    fi
    
    # Open latest PDF report
    if [ ${#PDF_REPORTS[@]} -gt 0 ]; then
        echo "   Opening PDF report: ${PDF_REPORTS[0]}"
        open "${PDF_REPORTS[0]}"
    fi
fi

echo ""
echo "🎉 Comprehensive test reporting completed!"
echo "📊 Reports generated in: $REPORTS_DIR"
echo "=============================================================="

exit $TEST_EXIT_CODE
