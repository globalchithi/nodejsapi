# Project Structure

## 📁 **Clean Project Organization**

The project has been reorganized for better maintainability and clarity:

### **Root Directory (Essential Files Only)**
```
VaxCareApiTests/
├── VaxCareApiTests.csproj    # C# project file
├── Program.cs                 # Main application entry point
├── appsettings.json          # Configuration
├── appsettings.Development.json
├── TestInfo.json             # Test configuration
├── run-all-tests.py          # Main test runner (wrapper)
├── open-html-report.py       # Report opener (wrapper)
├── Models/                   # C# data models
├── Services/                 # C# services
├── Tests/                    # C# test files
├── TestRunner/               # Core test running scripts
├── TestReports/              # Generated test reports
├── TestResults/              # Raw test results
├── docs/                     # All documentation
└── temp_unused_files/        # Deprecated/unused files
```

## 📂 **Directory Descriptions**

### **Essential Files (Root)**
- **`VaxCareApiTests.csproj`** - C# project configuration
- **`Program.cs`** - Application entry point
- **`appsettings.json`** - Main configuration
- **`TestInfo.json`** - Test configuration
- **`run-all-tests.py`** - Main test runner wrapper
- **`open-html-report.py`** - Report opener wrapper

### **Core Directories**
- **`Models/`** - C# data models and DTOs
- **`Services/`** - C# service classes and utilities
- **`Tests/`** - C# test files (xUnit tests)
- **`TestRunner/`** - Python test running scripts
- **`TestReports/`** - Generated HTML reports
- **`TestResults/`** - Raw test result files (.trx, .xml)

### **Documentation**
- **`docs/`** - All documentation files
  - README.md
  - Setup guides
  - Integration guides
  - Troubleshooting guides
  - API documentation

### **Temporary Storage**
- **`temp_unused_files/`** - Deprecated scripts and files
  - Old report generators
  - Deprecated test runners
  - Unused PowerShell scripts
  - Legacy batch files

## 🎯 **Benefits of This Structure**

### **Clean Root Directory**
- Only essential files visible
- Easy to find main entry points
- Clear project purpose

### **Organized Documentation**
- All guides in one place
- Easy to find specific information
- Maintainable documentation

### **Separated Concerns**
- Test running logic in `TestRunner/`
- Documentation in `docs/`
- Deprecated files in `temp_unused_files/`
- Generated files in `TestReports/`

### **Maintainability**
- Related files grouped together
- Easy to update specific areas
- Clear separation of responsibilities

## 🚀 **Usage**

### **Running Tests**
```bash
# Main test runner
python3 run-all-tests.py

# With Teams notification
python3 run-all-tests.py --teams

# Open HTML report
python3 open-html-report.py
```

### **Finding Documentation**
- All guides are in `docs/` folder
- Main README is at `docs/README.md`
- Specific guides have descriptive names

### **Accessing Test Results**
- HTML reports: `TestReports/` folder
- Raw results: `TestResults/` folder
- Test runner scripts: `TestRunner/` folder

## 📋 **File Categories**

### **Active Files (Keep)**
- C# project files
- Configuration files
- Main entry points
- Current test runner scripts
- Generated reports

### **Documentation (Organized)**
- All .md files moved to `docs/`
- Requirements files moved to `docs/`
- Guides and tutorials organized

### **Deprecated Files (Moved)**
- Old report generators
- Deprecated test runners
- Legacy PowerShell scripts
- Unused batch files
- Test verification scripts

This structure provides a clean, maintainable, and organized project layout! 🎉
