#!/bin/bash

# Enhanced HTML Report Generator with Beautiful Table
# This script parses XML test results and generates a comprehensive HTML report with test details in a table

XML_FILE="${1:-TestReports/TestResults.xml}"
OUTPUT_DIR="${2:-TestReports}"
PROJECT_NAME="${3:-VaxCare API Test Suite}"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
HTML_REPORT_PATH="$OUTPUT_DIR/EnhancedTestReport_$TIMESTAMP.html"

echo "📊 Generating enhanced HTML report with beautiful table..." -ForegroundColor Cyan

# Check if XML file exists
if [ ! -f "$XML_FILE" ]; then
    echo "❌ XML file not found: $XML_FILE" >&2
    exit 1
fi

# Extract test statistics
TOTAL_TESTS=$(grep -c '<test ' "$XML_FILE" || echo "0")
PASSED_TESTS=$(grep -c 'result="Pass"' "$XML_FILE" || echo "0")
FAILED_TESTS=$(grep -c 'result="Fail"' "$XML_FILE" || echo "0")
SKIPPED_TESTS=$(grep -c 'result="Skip"' "$XML_FILE" || echo "0")

# Calculate success rate
if [ "$TOTAL_TESTS" -gt 0 ]; then
    SUCCESS_RATE=$(echo "scale=1; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc)
else
    SUCCESS_RATE="0.0"
fi

echo "📊 Test Statistics:"
echo "   Total Tests: $TOTAL_TESTS"
echo "   Passed: $PASSED_TESTS"
echo "   Failed: $FAILED_TESTS"
echo "   Skipped: $SKIPPED_TESTS"
echo "   Success Rate: ${SUCCESS_RATE}%"

# Generate HTML content
cat > "$HTML_REPORT_PATH" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$PROJECT_NAME - Test Report</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 3em;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px;
            background: #f8f9fa;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card.passed {
            border-top: 4px solid #28a745;
        }
        
        .stat-card.failed {
            border-top: 4px solid #dc3545;
        }
        
        .stat-card.skipped {
            border-top: 4px solid #ffc107;
        }
        
        .stat-card.total {
            border-top: 4px solid #007bff;
        }
        
        .stat-card.success-rate {
            border-top: 4px solid #6f42c1;
        }
        
        .stat-number {
            font-size: 3em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .stat-label {
            color: #666;
            font-size: 1.1em;
            font-weight: 500;
        }
        
        .passed .stat-number { color: #28a745; }
        .failed .stat-number { color: #dc3545; }
        .skipped .stat-number { color: #ffc107; }
        .total .stat-number { color: #007bff; }
        .success-rate .stat-number { color: #6f42c1; }
        
        .content {
            padding: 30px;
        }
        
        .section-title {
            font-size: 2em;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }
        
        .test-table-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .test-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95em;
        }
        
        .test-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .test-table th {
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            font-size: 1em;
        }
        
        .test-table tbody tr {
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s ease;
        }
        
        .test-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .test-table tbody tr:last-child {
            border-bottom: none;
        }
        
        .test-table td {
            padding: 12px;
            vertical-align: middle;
        }
        
        .test-name {
            font-weight: 600;
            color: #333;
        }
        
        .test-class {
            color: #666;
            font-size: 0.9em;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .test-status {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .status-icon {
            font-size: 1.2em;
        }
        
        .status-text {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
        }
        
        .status-passed {
            color: #28a745;
        }
        
        .status-failed {
            color: #dc3545;
        }
        
        .status-skipped {
            color: #ffc107;
        }
        
        .duration {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: #666;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .duration.fast {
            color: #28a745;
        }
        
        .duration.medium {
            color: #ffc107;
        }
        
        .duration.slow {
            color: #dc3545;
        }
        
        .summary-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .summary-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .summary-label {
            font-weight: 600;
            color: #666;
            margin-bottom: 5px;
        }
        
        .summary-value {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
        }
        
        .footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            border-top: 1px solid #dee2e6;
        }
        
        /* Collapsible sections */
        .class-section { margin: 20px 0; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .class-header { background: #f8f9fa; padding: 15px; cursor: pointer; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center; }
        .class-header:hover { background: #e9ecef; }
        .class-name { font-weight: bold; font-size: 1.1em; color: #333; }
        .class-stats { color: #666; font-size: 0.9em; }
        .class-toggle { font-size: 1.2em; transition: transform 0.3s ease; }
        .class-toggle.expanded { transform: rotate(90deg); }
        .class-content { display: none; }
        .class-content.expanded { display: block; }
        .class-tests { padding: 0; }
        .class-test { padding: 12px 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .class-test:last-child { border-bottom: none; }
        .class-test:hover { background: #f8f9fa; }
        .test-info { flex-grow: 1; }
        .test-name { font-weight: 600; color: #333; margin-bottom: 5px; }
        .test-duration { color: #666; font-size: 0.9em; }
        .test-status { display: flex; align-items: center; gap: 8px; }
        .status-icon { font-size: 1.1em; }
        .status-text { font-weight: 600; text-transform: uppercase; font-size: 0.9em; }
        .status-passed { color: #28a745; }
        .status-failed { color: #dc3545; }
        .status-skipped { color: #ffc107; }
        
        .performance-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 5px;
        }
        
        .performance-fast {
            background-color: #28a745;
        }
        
        .performance-medium {
            background-color: #ffc107;
        }
        
        .performance-slow {
            background-color: #dc3545;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 8px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                padding: 20px;
            }
            
            .test-table {
                font-size: 0.85em;
            }
            
            .test-table th,
            .test-table td {
                padding: 8px 6px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 $PROJECT_NAME</h1>
            <p>Comprehensive Test Execution Report</p>
            <p>Generated: $(date)</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card passed">
                <div class="stat-number">$PASSED_TESTS</div>
                <div class="stat-label">✅ Passed</div>
            </div>
            <div class="stat-card failed">
                <div class="stat-number">$FAILED_TESTS</div>
                <div class="stat-label">❌ Failed</div>
            </div>
            <div class="stat-card skipped">
                <div class="stat-number">$SKIPPED_TESTS</div>
                <div class="stat-label">⏭️ Skipped</div>
            </div>
            <div class="stat-card total">
                <div class="stat-number">$TOTAL_TESTS</div>
                <div class="stat-label">📊 Total</div>
            </div>
            <div class="stat-card success-rate">
                <div class="stat-number">${SUCCESS_RATE}%</div>
                <div class="stat-label">🎯 Success Rate</div>
            </div>
        </div>
        
        <div class="content">
            <div class="summary-section">
                <h2 class="section-title">📊 Execution Summary</h2>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="summary-label">Total Tests</div>
                        <div class="summary-value">$TOTAL_TESTS</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Passed</div>
                        <div class="summary-value" style="color: #28a745;">$PASSED_TESTS</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Failed</div>
                        <div class="summary-value" style="color: #dc3545;">$FAILED_TESTS</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Skipped</div>
                        <div class="summary-value" style="color: #ffc107;">$SKIPPED_TESTS</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Success Rate</div>
                        <div class="summary-value" style="color: #6f42c1;">${SUCCESS_RATE}%</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Report Generated</div>
                        <div class="summary-value">$(date)</div>
                    </div>
                </div>
            </div>
            
            <h2 class="section-title">📋 Test Results by Class</h2>
            <div class="test-results-by-class">
EOF

# Extract individual test details from XML and add to table
echo "📋 Extracting individual test details..."

# Create a temporary file to store test details
TEMP_FILE=$(mktemp)

# Extract test names and details from XML
grep '<test ' "$XML_FILE" | while IFS= read -r line; do
    # Extract test name
    TEST_NAME=$(echo "$line" | sed 's/.*name="\([^"]*\)".*/\1/')
    # Extract result
    TEST_RESULT=$(echo "$line" | sed 's/.*result="\([^"]*\)".*/\1/')
    # Extract time
    TEST_TIME=$(echo "$line" | sed 's/.*time="\([^"]*\)".*/\1/')
    # Extract type
    TEST_TYPE=$(echo "$line" | sed 's/.*type="\([^"]*\)".*/\1/')
    
    # Skip if we couldn't extract the required fields
    if [ -z "$TEST_NAME" ] || [ -z "$TEST_RESULT" ] || [ -z "$TEST_TIME" ]; then
        continue
    fi
    
    # Extract class name from type
    if [ -n "$TEST_TYPE" ]; then
        # If type contains dots, get the last part, otherwise use the whole type
        if echo "$TEST_TYPE" | grep -q "\."; then
            CLASS_NAME=$(echo "$TEST_TYPE" | sed 's/.*\.\([^.]*\)$/\1/')
        else
            CLASS_NAME="$TEST_TYPE"
        fi
    else
        CLASS_NAME="Unknown"
    fi
    
    # Format test name for display
    DISPLAY_NAME=$(echo "$TEST_NAME" | sed 's/.*\.\([^.]*\)$/\1/' | sed 's/_/ /g')
    
    # Calculate time in milliseconds
    TIME_MS=$(echo "$TEST_TIME * 1000" | bc 2>/dev/null || echo "0")
    
    # Determine result styling
    if [ "$TEST_RESULT" = "Pass" ]; then
        RESULT_ICON="✅"
        RESULT_CLASS="status-passed"
    elif [ "$TEST_RESULT" = "Fail" ]; then
        RESULT_ICON="❌"
        RESULT_CLASS="status-failed"
    else
        RESULT_ICON="⏭️"
        RESULT_CLASS="status-skipped"
    fi
    
    # Determine duration styling
    if [ $(echo "$TIME_MS < 100" | bc 2>/dev/null || echo "0") -eq 1 ]; then
        DURATION_CLASS="fast"
        PERFORMANCE_CLASS="performance-fast"
    elif [ $(echo "$TIME_MS < 1000" | bc 2>/dev/null || echo "0") -eq 1 ]; then
        DURATION_CLASS="medium"
        PERFORMANCE_CLASS="performance-medium"
    else
        DURATION_CLASS="slow"
        PERFORMANCE_CLASS="performance-slow"
    fi
    
    echo "                        <tr>" >> "$TEMP_FILE"
    echo "                            <td>" >> "$TEMP_FILE"
    echo "                                <div class=\"test-status\">" >> "$TEMP_FILE"
    echo "                                    <span class=\"status-icon\">$RESULT_ICON</span>" >> "$TEMP_FILE"
    echo "                                    <span class=\"status-text $RESULT_CLASS\">$TEST_RESULT</span>" >> "$TEMP_FILE"
    echo "                                </div>" >> "$TEMP_FILE"
    echo "                            </td>" >> "$TEMP_FILE"
    echo "                            <td>" >> "$TEMP_FILE"
    echo "                                <div class=\"test-name\">$DISPLAY_NAME</div>" >> "$TEMP_FILE"
    echo "                            </td>" >> "$TEMP_FILE"
    echo "                            <td>" >> "$TEMP_FILE"
    echo "                                <span class=\"test-class\">$CLASS_NAME</span>" >> "$TEMP_FILE"
    echo "                            </td>" >> "$TEMP_FILE"
    echo "                            <td>" >> "$TEMP_FILE"
    echo "                                <span class=\"duration $DURATION_CLASS\">${TIME_MS}ms</span>" >> "$TEMP_FILE"
    echo "                            </td>" >> "$TEMP_FILE"
    echo "                            <td>" >> "$TEMP_FILE"
    echo "                                <span class=\"performance-indicator $PERFORMANCE_CLASS\"></span>" >> "$TEMP_FILE"
    echo "                                <span>${TIME_MS}ms</span>" >> "$TEMP_FILE"
    echo "                            </td>" >> "$TEMP_FILE"
    echo "                        </tr>" >> "$TEMP_FILE"
done

# Append the test scenarios to the HTML file
if [ -f "$TEMP_FILE" ] && [ -s "$TEMP_FILE" ]; then
    cat "$TEMP_FILE" >> "$HTML_REPORT_PATH"
    rm -f "$TEMP_FILE"
else
    echo "                        <tr><td colspan=\"5\">📊 Test details are available in the XML file.</td></tr>" >> "$HTML_REPORT_PATH"
fi

# Complete the HTML structure
cat >> "$HTML_REPORT_PATH" << 'EOF'
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="footer">
            <p>📊 Report generated by VaxCare API Test Suite | $(date)</p>
            <p>🔧 Enhanced HTML Report with Beautiful Table Layout</p>
        </div>
    </div>
</body>
</html>
EOF

echo "✅ Enhanced HTML report generated: $HTML_REPORT_PATH"
echo "📊 Report Statistics:"
echo "   📄 File: $HTML_REPORT_PATH"
echo "   📊 Tests: $TOTAL_TESTS"
echo "   ✅ Passed: $PASSED_TESTS"
echo "   ❌ Failed: $FAILED_TESTS"
echo "   ⏭️ Skipped: $SKIPPED_TESTS"
echo "   🎯 Success Rate: ${SUCCESS_RATE}%"
echo "🎉 Enhanced HTML report generation completed!"
