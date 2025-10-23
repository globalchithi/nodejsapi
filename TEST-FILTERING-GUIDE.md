# Test Filtering Guide

This guide explains how to filter tests by class, method, or category in the complete test workflow.

## 🚀 Quick Start

### Filter by Class
```bash
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests"
```

### Filter by Method
```bash
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CheckoutAppointment"
```

### Filter by Category
```bash
python3 run-all-tests-complete.py --filter "Category=Integration"
```

## 🔧 Available Filter Options

### 1. Class Name Filter
```bash
# Run only checkout tests
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests"

# Run only create tests
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCreateTests"

# Run only sync tests
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentSyncTests"
```

### 2. Method Name Filter
```bash
# Run only specific test methods
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CheckoutAppointment_Success_SingleVaccine"

# Run tests containing specific text
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CheckoutAppointment"

# Run tests with specific pattern
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CreateAppointment"
```

### 3. Category Filter
```bash
# Run only integration tests
python3 run-all-tests-complete.py --filter "Category=Integration"

# Run only unit tests
python3 run-all-tests-complete.py --filter "Category=Unit"

# Run only smoke tests
python3 run-all-tests-complete.py --filter "Category=Smoke"
```

### 4. Combined Filters
```bash
# Run checkout tests in specific environment
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests" --environment "Production"

# Run with OneDrive and filter
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CheckoutAppointment" --onedrive
```

## 📋 Filter Examples

### Example 1: Run Only Checkout Tests
```bash
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests"
```

### Example 2: Run Only Create Tests
```bash
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCreateTests"
```

### Example 3: Run Only Sync Tests
```bash
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentSyncTests"
```

### Example 4: Run Specific Test Method
```bash
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CheckoutAppointment_Success_SingleVaccine"
```

### Example 5: Run Tests with Pattern
```bash
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CheckoutAppointment"
```

### Example 6: Run with Environment
```bash
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests" --environment "Staging"
```

### Example 7: Run with OneDrive
```bash
python3 run-all-tests-complete.py --filter "FullyQualifiedName~CheckoutAppointment" --onedrive
```

## 🎯 Common Filter Patterns

### By Test Class
```bash
# All checkout tests
--filter "ClassName=PatientsAppointmentCheckoutTests"

# All create tests
--filter "ClassName=PatientsAppointmentCreateTests"

# All sync tests
--filter "ClassName=PatientsAppointmentSyncTests"

# All inventory tests
--filter "ClassName=InventoryApiTests"
```

### By Test Method
```bash
# Specific test method
--filter "FullyQualifiedName~CheckoutAppointment_Success_SingleVaccine"

# All checkout methods
--filter "FullyQualifiedName~CheckoutAppointment"

# All create methods
--filter "FullyQualifiedName~CreateAppointment"

# All sync methods
--filter "FullyQualifiedName~SyncAppointment"
```

### By Test Category
```bash
# Integration tests
--filter "Category=Integration"

# Unit tests
--filter "Category=Unit"

# Smoke tests
--filter "Category=Smoke"

# API tests
--filter "Category=API"
```

## 🔍 Advanced Filtering

### Multiple Conditions
```bash
# Run tests with multiple conditions
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests&FullyQualifiedName~Success"
```

### Exclude Tests
```bash
# Exclude specific tests
python3 run-all-tests-complete.py --filter "FullyQualifiedName!~Skip"
```

### Priority Tests
```bash
# Run high priority tests
python3 run-all-tests-complete.py --filter "Priority=High"
```

## 📊 Filter Results

### What Gets Generated
When you filter tests, the workflow still generates:
- ✅ **HTML Report** - For filtered test results
- ✅ **PDF Report** - For filtered test results
- ✅ **Teams Notification** - With filtered test statistics
- ✅ **Test Results** - Only for filtered tests

### Teams Message Example
```
🚀 Test Automation Results with PDF Report

📄 PDF Report: EnhancedTestReport_2025-10-23_10-33-56.pdf (1.2 MB)
📁 File Location: /path/to/TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf
🔗 Share Link: file:///path/to/TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf

Filter Applied: ClassName=PatientsAppointmentCheckoutTests
Tests Run: 5
Tests Passed: 5
Tests Failed: 0
Success Rate: 100%

Instructions for accessing the PDF:
1. Direct Access: Copy the file path above and open in file explorer
2. Share Link: Use the share link to access the file
3. Manual Sharing: Upload to OneDrive/SharePoint for team sharing

File Details:
- Name: EnhancedTestReport_2025-10-23_10-33-56.pdf
- Size: 1.2 MB
- Location: TestReports/EnhancedTestReport_2025-10-23_10-33-56.pdf
- Environment: Development
- Generated: 10/23/2025, 10:33:56 AM
- Filter: ClassName=PatientsAppointmentCheckoutTests

💡 Tip: For easier sharing, upload this PDF to OneDrive or SharePoint and share the link with your team.
```

## 🛠️ Troubleshooting

### Common Issues

#### 1. "No tests found matching filter"
- **Solution**: Check the filter syntax and test class names
- **Check**: Use `dotnet test --list-tests` to see available tests

#### 2. "Filter not working"
- **Solution**: Ensure proper filter syntax
- **Check**: Use quotes around filter values

#### 3. "Tests not running"
- **Solution**: Check test project structure
- **Check**: Ensure tests are properly tagged

### Error Messages

#### "No tests found"
- **Solution**: Check filter syntax and test names
- **Alternative**: Run without filter to see all tests

#### "Filter syntax error"
- **Solution**: Use proper filter syntax
- **Check**: Use quotes around filter values

#### "Tests not discovered"
- **Solution**: Check test project configuration
- **Check**: Ensure tests are properly built

## 🎯 Best Practices

### 1. Use Specific Filters
```bash
# Good: Specific class filter
--filter "ClassName=PatientsAppointmentCheckoutTests"

# Good: Specific method filter
--filter "FullyQualifiedName~CheckoutAppointment_Success_SingleVaccine"
```

### 2. Test Filter Syntax
```bash
# Test filter before running complete workflow
dotnet test --filter "ClassName=PatientsAppointmentCheckoutTests" --list-tests
```

### 3. Use Environment with Filters
```bash
# Always specify environment
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests" --environment "Production"
```

### 4. Document Filter Usage
```bash
# Document what tests are being run
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests" --environment "CI"
```

## 📋 Integration Examples

### Add to CI/CD Pipeline
```bash
# Run specific tests in CI
python3 run-all-tests-complete.py --filter "Category=Integration" --environment "CI"
```

### Add to Scheduled Jobs
```bash
# Run smoke tests daily
python3 run-all-tests-complete.py --filter "Category=Smoke" --environment "Daily"
```

### Add to Build Script
```bash
#!/bin/bash
# Build script with filtered tests
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests" --environment "Build"
```

## 🚀 Advanced Usage

### Custom Filter Combinations
```bash
# Multiple conditions
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests&FullyQualifiedName~Success"

# Exclude specific tests
python3 run-all-tests-complete.py --filter "FullyQualifiedName!~Skip"
```

### Environment-Specific Filters
```bash
# Different filters for different environments
python3 run-all-tests-complete.py --filter "Category=Smoke" --environment "Development"
python3 run-all-tests-complete.py --filter "Category=Integration" --environment "Staging"
python3 run-all-tests-complete.py --filter "Category=Full" --environment "Production"
```

### Filter with OneDrive
```bash
# Filter with OneDrive upload
python3 run-all-tests-complete.py --filter "ClassName=PatientsAppointmentCheckoutTests" --onedrive
```

## 🎉 Success!

Your test filtering is now fully integrated with the complete workflow:

- 🧪 **Filtered Tests** - Run only specific tests
- 📊 **HTML Report** - For filtered test results
- 📄 **PDF Report** - For filtered test results
- 📤 **Teams Notification** - With filtered test statistics
- 🔍 **Filter Information** - Included in Teams message

## 💡 Tips

1. **Test Filter First**: Use `dotnet test --filter` to test filters
2. **Use Specific Filters**: Be specific about what tests to run
3. **Document Filters**: Document what each filter does
4. **Test Combinations**: Test filter combinations before automation
5. **Environment Specific**: Use different filters for different environments

