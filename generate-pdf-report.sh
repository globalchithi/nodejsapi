#!/bin/bash

# PDF Report Generator for VaxCare API Test Reports
# This script converts HTML test reports to PDF format

HTML_FILE=""
OUTPUT_DIR="TestReports"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Function to show usage
show_usage() {
    echo "📄 PDF Report Generator for VaxCare API Test Reports"
    echo "=================================================="
    echo ""
    echo "Usage: $0 [OPTIONS] [HTML_FILE]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -o, --output DIR   Output directory (default: TestReports)"
    echo "  -a, --all          Convert all HTML reports to PDF"
    echo "  -l, --latest       Convert the latest HTML report to PDF"
    echo ""
    echo "Examples:"
    echo "  $0 TestReports/EnhancedTestReport_2025-10-22_23-20-34.html"
    echo "  $0 --latest"
    echo "  $0 --all"
    echo ""
}

# Function to check if required tools are installed
check_dependencies() {
    local missing_tools=()
    
    # Check for wkhtmltopdf (preferred)
    if ! command -v wkhtmltopdf &> /dev/null; then
        missing_tools+=("wkhtmltopdf")
    fi
    
    # Check for alternative tools
    if ! command -v weasyprint &> /dev/null && ! command -v pandoc &> /dev/null; then
        if [ ${#missing_tools[@]} -eq 1 ]; then
            missing_tools+=("weasyprint or pandoc")
        fi
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo "❌ Missing required tools: ${missing_tools[*]}"
        echo ""
        echo "📦 Installation options:"
        echo ""
        echo "Option 1 - wkhtmltopdf (Recommended):"
        echo "  macOS: brew install wkhtmltopdf"
        echo "  Ubuntu: sudo apt-get install wkhtmltopdf"
        echo "  CentOS: sudo yum install wkhtmltopdf"
        echo ""
        echo "Option 2 - weasyprint:"
        echo "  pip install weasyprint"
        echo ""
        echo "Option 3 - pandoc:"
        echo "  macOS: brew install pandoc"
        echo "  Ubuntu: sudo apt-get install pandoc"
        echo ""
        return 1
    fi
    
    return 0
}

# Function to convert HTML to PDF using wkhtmltopdf
convert_with_wkhtmltopdf() {
    local html_file="$1"
    local pdf_file="$2"
    
    echo "🔄 Converting with wkhtmltopdf..."
    
    wkhtmltopdf \
        --page-size A4 \
        --margin-top 20mm \
        --margin-bottom 20mm \
        --margin-left 15mm \
        --margin-right 15mm \
        --encoding UTF-8 \
        --enable-local-file-access \
        --print-media-type \
        --disable-smart-shrinking \
        --zoom 0.8 \
        "$html_file" \
        "$pdf_file"
    
    return $?
}

# Function to convert HTML to PDF using weasyprint
convert_with_weasyprint() {
    local html_file="$1"
    local pdf_file="$2"
    
    echo "🔄 Converting with weasyprint..."
    
    weasyprint "$html_file" "$pdf_file"
    
    return $?
}

# Function to convert HTML to PDF using pandoc
convert_with_pandoc() {
    local html_file="$1"
    local pdf_file="$2"
    
    echo "🔄 Converting with pandoc..."
    
    # First convert HTML to markdown, then to PDF
    local temp_md=$(mktemp)
    pandoc -f html -t markdown "$html_file" -o "$temp_md"
    pandoc -f markdown -t pdf "$temp_md" -o "$pdf_file"
    rm -f "$temp_md"
    
    return $?
}

# Function to convert HTML to PDF
convert_html_to_pdf() {
    local html_file="$1"
    local pdf_file="$2"
    
    if [ ! -f "$html_file" ]; then
        echo "❌ HTML file not found: $html_file"
        return 1
    fi
    
    echo "📄 Converting HTML to PDF..."
    echo "   Input:  $html_file"
    echo "   Output: $pdf_file"
    
    # Try different conversion methods in order of preference
    if command -v wkhtmltopdf &> /dev/null; then
        convert_with_wkhtmltopdf "$html_file" "$pdf_file"
    elif command -v weasyprint &> /dev/null; then
        convert_with_weasyprint "$html_file" "$pdf_file"
    elif command -v pandoc &> /dev/null; then
        convert_with_pandoc "$html_file" "$pdf_file"
    else
        echo "❌ No PDF conversion tool available"
        return 1
    fi
    
    if [ $? -eq 0 ] && [ -f "$pdf_file" ]; then
        echo "✅ PDF generated successfully: $pdf_file"
        return 0
    else
        echo "❌ Failed to generate PDF"
        return 1
    fi
}

# Function to find the latest HTML report
find_latest_html() {
    find "$OUTPUT_DIR" -name "EnhancedTestReport_*.html" -type f -printf '%T@ %p\n' 2>/dev/null | \
    sort -n | tail -1 | cut -d' ' -f2-
}

# Function to convert all HTML reports
convert_all_html() {
    local html_files=($(find "$OUTPUT_DIR" -name "*.html" -type f))
    
    if [ ${#html_files[@]} -eq 0 ]; then
        echo "❌ No HTML files found in $OUTPUT_DIR"
        return 1
    fi
    
    echo "📄 Found ${#html_files[@]} HTML files to convert"
    
    local success_count=0
    for html_file in "${html_files[@]}"; do
        local basename=$(basename "$html_file" .html)
        local pdf_file="$OUTPUT_DIR/${basename}_${TIMESTAMP}.pdf"
        
        echo ""
        echo "🔄 Converting: $html_file"
        if convert_html_to_pdf "$html_file" "$pdf_file"; then
            ((success_count++))
        fi
    done
    
    echo ""
    echo "📊 Conversion Summary:"
    echo "   Total files: ${#html_files[@]}"
    echo "   Successful: $success_count"
    echo "   Failed: $((${#html_files[@]} - success_count))"
}

# Main script logic
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -o|--output)
                OUTPUT_DIR="$2"
                shift 2
                ;;
            -a|--all)
                convert_all_html
                exit $?
                ;;
            -l|--latest)
                HTML_FILE=$(find_latest_html)
                if [ -z "$HTML_FILE" ]; then
                    echo "❌ No HTML reports found in $OUTPUT_DIR"
                    exit 1
                fi
                shift
                ;;
            -*)
                echo "❌ Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                HTML_FILE="$1"
                shift
                ;;
        esac
    done
    
    # Check dependencies
    if ! check_dependencies; then
        exit 1
    fi
    
    # If no HTML file specified, try to find the latest
    if [ -z "$HTML_FILE" ]; then
        HTML_FILE=$(find_latest_html)
        if [ -z "$HTML_FILE" ]; then
            echo "❌ No HTML file specified and no reports found in $OUTPUT_DIR"
            echo "💡 Use --help for usage information"
            exit 1
        fi
        echo "📄 Using latest HTML report: $HTML_FILE"
    fi
    
    # Create output directory if it doesn't exist
    mkdir -p "$OUTPUT_DIR"
    
    # Generate PDF filename
    local basename=$(basename "$HTML_FILE" .html)
    local pdf_file="$OUTPUT_DIR/${basename}_${TIMESTAMP}.pdf"
    
    # Convert HTML to PDF
    if convert_html_to_pdf "$HTML_FILE" "$pdf_file"; then
        echo ""
        echo "🎉 PDF Report Generated Successfully!"
        echo "📄 File: $pdf_file"
        echo "📊 Size: $(du -h "$pdf_file" | cut -f1)"
        
        # Try to open the PDF if on macOS
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "🌐 Opening PDF in default viewer..."
            open "$pdf_file"
        fi
    else
        echo "❌ Failed to generate PDF report"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
