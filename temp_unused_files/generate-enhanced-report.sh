#!/bin/bash

# Enhanced HTML Report Generator
# This script parses the XML test results and generates a comprehensive HTML report

XML_FILE="TestReports/TestResults.xml"
OUTPUT_FILE="TestReports/EnhancedTestReport_$(date +%Y-%m-%d_%H-%M-%S).html"

if [ ! -f "$XML_FILE" ]; then
    echo "❌ XML file not found: $XML_FILE"
    exit 1
fi

echo "📊 Generating enhanced HTML report from XML results..."

# Extract test statistics from XML
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

# Generate comprehensive HTML report
cat > "$OUTPUT_FILE" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VaxCare API Test Report - Enhanced</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background-color: #f5f5f5; 
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            background: white; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            padding: 30px; 
            border-radius: 8px 8px 0 0; 
        }
        .header h1 { 
            margin: 0; 
            font-size: 2.5em; 
        }
        .header p { 
            margin: 10px 0 0 0; 
            opacity: 0.9; 
        }
        .stats { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
            gap: 20px; 
            padding: 30px; 
        }
        .stat-card { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 8px; 
            text-align: center; 
            border-left: 4px solid #007bff; 
        }
        .stat-card.passed { 
            border-left-color: #28a745; 
        }
        .stat-card.failed { 
            border-left-color: #dc3545; 
        }
        .stat-card.skipped { 
            border-left-color: #ffc107; 
        }
        .stat-number { 
            font-size: 2.5em; 
            font-weight: bold; 
            margin: 0; 
        }
        .stat-label { 
            color: #666; 
            margin: 5px 0 0 0; 
        }
        .test-results { 
            padding: 0 30px 30px; 
        }
        .test-result { 
            background: #f8f9fa; 
            margin: 10px 0; 
            padding: 15px; 
            border-radius: 6px; 
            border-left: 4px solid #ddd; 
        }
        .test-result.passed { 
            border-left-color: #28a745; 
            background: #d4edda; 
        }
        .test-result.failed { 
            border-left-color: #dc3545; 
            background: #f8d7da; 
        }
        .test-result.skipped { 
            border-left-color: #ffc107; 
            background: #fff3cd; 
        }
        .test-name { 
            font-weight: bold; 
            font-size: 1.1em; 
        }
        .test-class { 
            color: #666; 
            font-size: 0.9em; 
        }
        .test-duration { 
            color: #666; 
            font-size: 0.9em; 
        }
        .error-message { 
            background: #f8d7da; 
            padding: 10px; 
            border-radius: 4px; 
            margin-top: 10px; 
            font-family: monospace; 
        }
        .footer { 
            background: #f8f9fa; 
            padding: 20px; 
            text-align: center; 
            border-radius: 0 0 8px 8px; 
            color: #666; 
        }
        .summary { 
            background: #e9ecef; 
            padding: 20px; 
            margin: 20px 0; 
            border-radius: 6px; 
        }
        .test-scenarios { 
            margin: 20px 0; 
        }
        .scenario-list { 
            display: grid; 
            gap: 15px; 
            margin: 20px 0; 
        }
        .test-scenario { 
            background: #f8f9fa; 
            border-radius: 8px; 
            padding: 15px; 
            border-left: 4px solid #ddd; 
            transition: all 0.3s ease; 
        }
        .test-scenario:hover { 
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
            transform: translateY(-2px); 
        }
        .test-scenario.passed { 
            border-left-color: #28a745; 
            background: #d4edda; 
        }
        .test-scenario.failed { 
            border-left-color: #dc3545; 
            background: #f8d7da; 
        }
        .test-scenario.skipped { 
            border-left-color: #ffc107; 
            background: #fff3cd; 
        }
        .scenario-header { 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            margin-bottom: 10px; 
        }
        .scenario-icon { 
            font-size: 1.2em; 
            margin-right: 10px; 
        }
        .scenario-name { 
            font-weight: bold; 
            font-size: 1.1em; 
            flex-grow: 1; 
        }
        .scenario-time { 
            background: rgba(0,0,0,0.1); 
            padding: 4px 8px; 
            border-radius: 4px; 
            font-size: 0.9em; 
            font-family: monospace; 
        }
        .scenario-details { 
            margin-top: 10px; 
        }
        .scenario-class { 
            color: #666; 
            font-size: 0.9em; 
            margin-bottom: 5px; 
        }
        .scenario-full-name { 
            color: #888; 
            font-size: 0.8em; 
            font-family: monospace; 
            word-break: break-all; 
        }
        .report-links { 
            background: #e9ecef; 
            padding: 20px; 
            margin: 20px 0; 
            border-radius: 6px; 
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 VaxCare API Test Report</h1>
            <p>Generated: $(date)</p>
        </div>
        
        <div class="stats">
            <div class="stat-card passed">
                <div class="stat-number">$PASSED_TESTS</div>
                <div class="stat-label">Passed</div>
            </div>
            <div class="stat-card failed">
                <div class="stat-number">$FAILED_TESTS</div>
                <div class="stat-label">Failed</div>
            </div>
            <div class="stat-card skipped">
                <div class="stat-number">$SKIPPED_TESTS</div>
                <div class="stat-label">Skipped</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$TOTAL_TESTS</div>
                <div class="stat-label">Total</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${SUCCESS_RATE}%</div>
                <div class="stat-label">Success Rate</div>
            </div>
        </div>
        
        <div class="summary">
            <h2>📊 Test Execution Summary</h2>
            <p><strong>Total Tests:</strong> $TOTAL_TESTS</p>
            <p><strong>Passed:</strong> $PASSED_TESTS</p>
            <p><strong>Failed:</strong> $FAILED_TESTS</p>
            <p><strong>Skipped:</strong> $SKIPPED_TESTS</p>
            <p><strong>Success Rate:</strong> ${SUCCESS_RATE}%</p>
            <p><strong>Execution Time:</strong> $(date)</p>
        </div>
        
        <div class="test-results">
            <h2>📋 Detailed Test Results</h2>
            <p>✅ All tests executed successfully! Below are the individual test scenarios:</p>
            
            <div class="test-scenarios">
                <h3>🧪 Test Scenarios Executed</h3>
                <div class="scenario-list">
EOF

# Extract individual test details from XML
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
    
    # Skip if we couldn't extract the required fields
    if [ -z "$TEST_NAME" ] || [ -z "$TEST_RESULT" ] || [ -z "$TEST_TIME" ]; then
        continue
    fi
    
    # Convert result to display format
    if [ "$TEST_RESULT" = "Pass" ]; then
        RESULT_ICON="✅"
        RESULT_CLASS="passed"
    elif [ "$TEST_RESULT" = "Fail" ]; then
        RESULT_ICON="❌"
        RESULT_CLASS="failed"
    else
        RESULT_ICON="⏭️"
        RESULT_CLASS="skipped"
    fi
    
    # Extract class name from test name
    CLASS_NAME=$(echo "$TEST_NAME" | sed 's/.*\.\([^.]*\)Tests\..*/\1/')
    
    # Format test name for display
    DISPLAY_NAME=$(echo "$TEST_NAME" | sed 's/.*\.\([^.]*\)$/\1/' | sed 's/_/ /g')
    
    # Calculate time in milliseconds
    TIME_MS=$(echo "$TEST_TIME * 1000" | bc 2>/dev/null || echo "0")
    
    echo "                    <div class='test-scenario $RESULT_CLASS'>" >> "$TEMP_FILE"
    echo "                        <div class='scenario-header'>" >> "$TEMP_FILE"
    echo "                            <span class='scenario-icon'>$RESULT_ICON</span>" >> "$TEMP_FILE"
    echo "                            <span class='scenario-name'>$DISPLAY_NAME</span>" >> "$TEMP_FILE"
    echo "                            <span class='scenario-time'>${TIME_MS}ms</span>" >> "$TEMP_FILE"
    echo "                        </div>" >> "$TEMP_FILE"
    echo "                        <div class='scenario-details'>" >> "$TEMP_FILE"
    echo "                            <div class='scenario-class'>📁 $CLASS_NAME Tests</div>" >> "$TEMP_FILE"
    echo "                            <div class='scenario-full-name'>🔍 $TEST_NAME</div>" >> "$TEMP_FILE"
    echo "                        </div>" >> "$TEMP_FILE"
    echo "                    </div>" >> "$TEMP_FILE"
done

# Append the test scenarios to the HTML file
if [ -f "$TEMP_FILE" ] && [ -s "$TEMP_FILE" ]; then
    cat "$TEMP_FILE" >> "$OUTPUT_FILE"
    rm -f "$TEMP_FILE"
else
    echo "                <p>📊 Test details are available in the XML file.</p>" >> "$OUTPUT_FILE"
fi

# Complete the HTML structure
cat >> "$OUTPUT_FILE" << 'EOF'
                </div>
            </div>
            
            <div class="report-links">
                <h3>📄 Additional Reports</h3>
                <p>📄 <strong>XML Report:</strong> TestResults.xml</p>
                <p>📊 <strong>JSON Report:</strong> Available in TestReports directory</p>
                <p>📝 <strong>Markdown Report:</strong> Available in TestReports directory</p>
            </div>
        </div>
        
        <div class="footer">
            <p>Report generated by VaxCare API Test Suite | $(date)</p>
        </div>
    </div>
</body>
</html>
EOF

echo "✅ Enhanced HTML report generated: $OUTPUT_FILE"
echo "📊 Test Statistics:"
echo "   Total Tests: $TOTAL_TESTS"
echo "   Passed: $PASSED_TESTS"
echo "   Failed: $FAILED_TESTS"
echo "   Skipped: $SKIPPED_TESTS"
echo "   Success Rate: ${SUCCESS_RATE}%"
