# 🧪 VaxCare API Test Reporting System

## Overview

This comprehensive test reporting system automatically generates detailed reports after every test run, providing multiple output formats and rich visualizations for test results.

## 🚀 Features

### ✅ **Automatic Report Generation**
- **HTML Reports**: Beautiful, interactive reports with charts and detailed test information
- **JSON Reports**: Machine-readable format for CI/CD integration
- **Markdown Reports**: Human-readable format for documentation
- **Summary Reports**: Quick overview of test execution

### ✅ **Multiple Output Formats**
- **HTML**: Rich, interactive reports with styling
- **JSON**: Structured data for automation
- **Markdown**: Documentation-friendly format
- **XML**: Standard xUnit format for CI/CD tools

### ✅ **Comprehensive Test Tracking**
- Test execution time
- Pass/Fail/Skip status
- Error messages and stack traces
- Test categorization
- Performance metrics

## 📦 Packages Added

The following NuGet packages have been added to support test reporting:

```xml
<PackageReference Include="ReportGenerator" Version="5.2.0" />
<PackageReference Include="XunitXml.TestLogger" Version="3.0.0" />
<PackageReference Include="Microsoft.Extensions.Hosting" Version="6.0.0" />
<PackageReference Include="Microsoft.Extensions.Hosting.Abstractions" Version="6.0.0" />
<PackageReference Include="HtmlAgilityPack" Version="1.11.54" />
<PackageReference Include="System.Text.Json" Version="8.0.0" />
```

## 🛠️ Usage

### **Method 1: Using PowerShell Script (Windows)**

```powershell
# Run all tests with reporting
.\run-tests-with-reporting.ps1

# Run specific test category
.\run-tests-with-reporting.ps1 "FullyQualifiedName~Inventory"

# Run with verbose output and open reports
.\run-tests-with-reporting.ps1 --Verbose --OpenReports

# Run with custom filter
.\run-tests-with-reporting.ps1 "Name~Authentication"
```

### **Method 2: Using Bash Script (Linux/macOS)**

```bash
# Run all tests with reporting
./run-tests-with-reporting.sh

# Run specific test category
./run-tests-with-reporting.sh "FullyQualifiedName~Inventory"

# Run with verbose output and open reports
./run-tests-with-reporting.sh --verbose --open-reports

# Run with custom filter
./run-tests-with-reporting.sh "Name~Authentication"
```

### **Method 3: Using dotnet test directly**

```bash
# Basic test run with XML output
dotnet test --logger trx --results-directory TestReports

# With specific filter
dotnet test --filter "FullyQualifiedName~Inventory" --logger trx --results-directory TestReports

# With multiple loggers
dotnet test --logger trx --logger "xunit;LogFilePath=TestReports/TestResults.xml" --results-directory TestReports
```

## 📁 Generated Reports

After running tests, the following reports are generated in the `TestReports` directory:

### **HTML Report** (`TestReport_YYYY-MM-DD_HH-mm-ss.html`)
- **Rich Visual Interface**: Beautiful, responsive design
- **Interactive Charts**: Visual representation of test results
- **Detailed Test Information**: Individual test results with timing
- **Error Details**: Full error messages and stack traces
- **Performance Metrics**: Test execution times and statistics

### **JSON Report** (`TestReport_YYYY-MM-DD_HH-mm-ss.json`)
```json
{
  "GeneratedAt": "2024-01-15 14:30:25",
  "TotalTests": 38,
  "PassedTests": 38,
  "FailedTests": 0,
  "SkippedTests": 0,
  "SuccessRate": 100.0,
  "TestResults": [
    {
      "TestName": "GetInventoryProducts_ShouldReturnInventoryProducts",
      "ClassName": "InventoryApiTests",
      "Status": "Passed",
      "Duration": "00:00:02.4500000",
      "ErrorMessage": null,
      "StackTrace": null,
      "StartTime": "2024-01-15T14:30:22.1234567Z",
      "EndTime": "2024-01-15T14:30:24.5734567Z"
    }
  ]
}
```

### **Markdown Report** (`TestReport_YYYY-MM-DD_HH-mm-ss.md`)
- **Documentation Format**: Easy to read and share
- **Test Summary Tables**: Organized test results
- **Error Details**: Formatted error messages
- **Performance Data**: Execution times and statistics

### **XML Report** (`TestResults.xml`)
- **Standard xUnit Format**: Compatible with CI/CD tools
- **Detailed Test Information**: Full test execution details
- **Machine Readable**: Perfect for automation

## 🔧 Integration with Existing Tests

### **Option 1: Use the New Base Class**

Modify your existing test classes to inherit from `BaseTestClass`:

```csharp
public class InventoryApiTests : BaseTestClass
{
    // Your existing test methods
    [ReportingFact]
    public async Task GetInventoryProducts_ShouldReturnInventoryProducts()
    {
        try
        {
            // Your test logic
            OnTestCompleted(TestStatus.Passed);
        }
        catch (Exception ex)
        {
            OnTestCompleted(TestStatus.Failed, ex.Message, ex.StackTrace);
            throw;
        }
    }
}
```

### **Option 2: Use Custom Attributes**

Replace `[Fact]` with `[ReportingFact]` in your existing tests:

```csharp
[ReportingFact]
public void GetInventoryProducts_ShouldHandleAuthenticationHeaders()
{
    // Your existing test logic
}
```

### **Option 3: Manual Integration**

Use the `GlobalTestExecutionHandler` in your tests:

```csharp
[Fact]
public async Task MyTest()
{
    await GlobalTestExecutionHandler.ExecuteTest(async () =>
    {
        // Your test logic
    }, "MyTest", "MyTestClass");
}
```

## 📊 Report Features

### **HTML Report Features**
- **Responsive Design**: Works on desktop and mobile
- **Interactive Elements**: Expandable test details
- **Color Coding**: Green for passed, red for failed, yellow for skipped
- **Performance Charts**: Visual representation of test execution times
- **Error Highlighting**: Clear error messages and stack traces

### **JSON Report Features**
- **Structured Data**: Easy to parse programmatically
- **Complete Test Information**: All test details in one place
- **CI/CD Integration**: Perfect for automated systems
- **Extensible Format**: Easy to add custom fields

### **Markdown Report Features**
- **Documentation Ready**: Perfect for sharing in documentation
- **GitHub Compatible**: Renders beautifully on GitHub
- **Easy to Read**: Human-friendly format
- **Version Control Friendly**: Text-based format

## 🚀 CI/CD Integration

### **Azure DevOps**

```yaml
- task: DotNetCoreCLI@2
  displayName: 'Run tests with reporting'
  inputs:
    command: 'test'
    projects: '**/*Tests.csproj'
    arguments: '--logger trx --results-directory TestReports --configuration Release'

- task: PublishTestResults@2
  displayName: 'Publish test results'
  inputs:
    testResultsFormat: 'VSTest'
    testResultsFiles: '**/TestResults.trx'
    searchFolder: 'TestReports'
```

### **GitHub Actions**

```yaml
- name: Run tests with reporting
  run: |
    dotnet test --logger trx --results-directory TestReports --configuration Release
    dotnet test --logger "xunit;LogFilePath=TestReports/TestResults.xml" --results-directory TestReports

- name: Upload test reports
  uses: actions/upload-artifact@v3
  with:
    name: test-reports
    path: TestReports/
```

### **Jenkins**

```groovy
stage('Test') {
    steps {
        sh 'dotnet test --logger trx --results-directory TestReports --configuration Release'
        publishTestResults testResultsPattern: 'TestReports/*.trx'
    }
}
```

## 📈 Advanced Features

### **Custom Report Templates**

You can customize the HTML report template by modifying the `GenerateHtmlContent()` method in `TestReportService.cs`.

### **Additional Report Formats**

Add new report formats by extending the `TestReportService` class:

```csharp
private async Task GenerateCustomReportAsync(string timestamp)
{
    // Your custom report generation logic
}
```

### **Report Scheduling**

Set up automated report generation using cron jobs or scheduled tasks:

```bash
# Run tests and generate reports every hour
0 * * * * cd /path/to/project && ./run-tests-with-reporting.sh
```

## 🔍 Troubleshooting

### **Common Issues**

1. **Reports not generated**: Check that the `TestReports` directory exists and is writable
2. **HTML report not displaying**: Ensure you have a modern web browser
3. **JSON parsing errors**: Verify the JSON format is valid
4. **Permission issues**: Ensure the script has execute permissions

### **Debug Mode**

Run with verbose output to see detailed information:

```bash
./run-tests-with-reporting.sh --verbose
```

### **Manual Report Generation**

If automatic generation fails, you can manually generate reports:

```csharp
var reportService = new TestReportService(logger);
await reportService.GenerateReportsAsync();
```

## 📞 Support

For issues or questions about the test reporting system:

1. Check the generated log files
2. Verify all required packages are installed
3. Ensure proper permissions for report generation
4. Review the test execution output for errors

## 🎯 Best Practices

1. **Regular Report Review**: Check reports after each test run
2. **Version Control**: Commit report templates but not generated reports
3. **CI/CD Integration**: Use reports in your deployment pipeline
4. **Performance Monitoring**: Track test execution times over time
5. **Error Analysis**: Use reports to identify patterns in test failures

---

**Happy Testing! 🧪✨**
