#!/usr/bin/env python3
"""
XML Repair Tool
This script fixes malformed XML files by removing junk content and ensuring proper structure
"""

import os
import sys
import re
from datetime import datetime

def repair_xml_file(input_file, output_file=None):
    """Repair a malformed XML file"""
    if output_file is None:
        output_file = input_file.replace('.xml', '_repaired.xml')
    
    print(f"Repairing XML file: {input_file}")
    
    try:
        # Read the file with different encodings
        content = None
        for encoding in ['utf-8', 'utf-8-sig', 'latin-1', 'ascii']:
            try:
                with open(input_file, 'r', encoding=encoding) as f:
                    content = f.read()
                print(f"Successfully read file with {encoding} encoding")
                break
            except UnicodeDecodeError:
                continue
        
        if content is None:
            print("Error: Could not read file with any encoding")
            return False
        
        # Clean the content
        print("Cleaning XML content...")
        
        # Remove any content after the closing </assemblies> tag
        if '</assemblies>' in content:
            content = content[:content.rfind('</assemblies>') + len('</assemblies>')]
            print("Removed content after </assemblies> tag")
        
        # Remove any extra whitespace and normalize
        content = re.sub(r'\s+', ' ', content)
        content = content.strip()
        
        # Ensure proper XML structure
        if not content.startswith('<assemblies'):
            print("Warning: File doesn't start with <assemblies>")
        
        if not content.endswith('</assemblies>'):
            print("Warning: File doesn't end with </assemblies>")
            # Try to find the last valid closing tag
            if '<assemblies>' in content:
                last_assemblies = content.rfind('<assemblies>')
                if last_assemblies > 0:
                    content = content[last_assemblies:]
                    content += '</assemblies>'
                    print("Reconstructed XML structure")
        
        # Write the repaired file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"Repaired XML saved to: {output_file}")
        return True
        
    except Exception as e:
        print(f"Error repairing XML: {e}")
        return False

def validate_xml_file(xml_file):
    """Validate XML file structure"""
    try:
        import xml.etree.ElementTree as ET
        tree = ET.parse(xml_file)
        print(f"✅ XML file is valid: {xml_file}")
        return True
    except Exception as e:
        print(f"❌ XML file is invalid: {e}")
        return False

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 repair-xml.py <xml_file> [output_file]")
        print("Example: python3 repair-xml.py TestReports/TestResults.xml")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    if not os.path.exists(input_file):
        print(f"Error: File not found: {input_file}")
        sys.exit(1)
    
    print("🔧 XML Repair Tool")
    print("=" * 30)
    
    # Check if file is already valid
    if validate_xml_file(input_file):
        print("XML file is already valid, no repair needed.")
        return
    
    # Repair the file
    if repair_xml_file(input_file, output_file):
        print("\n✅ XML repair completed!")
        
        # Validate the repaired file
        if output_file and validate_xml_file(output_file):
            print(f"✅ Repaired file is valid: {output_file}")
        else:
            print("⚠️  Repaired file may still have issues")
    else:
        print("\n❌ XML repair failed")
        sys.exit(1)

if __name__ == "__main__":
    main()
