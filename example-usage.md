# 🧪 Example Usage of Test Reporting System

## Quick Start

### 1. Run Tests with Automatic Report Generation

```bash
# Using the bash script (Linux/macOS)
./run-tests-with-reporting.sh

# Using PowerShell (Windows)
.\run-tests-with-reporting.ps1
```

### 2. Run Specific Test Categories

```bash
# Run only inventory tests
./run-tests-with-reporting.sh "FullyQualifiedName~Inventory"

# Run only patient tests
./run-tests-with-reporting.sh "FullyQualifiedName~Patients"

# Run only setup tests
./run-tests-with-reporting.sh "FullyQualifiedName~Setup"
```

### 3. Run with Verbose Output and Open Reports

```bash
# Verbose output with automatic report opening
./run-tests-with-reporting.sh --verbose --open-reports
```

## Generated Reports

After running tests, you'll find these files in the `TestReports` directory:

```
TestReports/
├── TestReport_2024-01-15_14-30-25.html    # Beautiful HTML report
├── TestReport_2024-01-15_14-30-25.json   # JSON data for automation
├── TestReport_2024-01-15_14-30-25.md      # Markdown documentation
├── TestResults.xml                        # Standard xUnit format
└── TestResults.trx                        # Visual Studio format
```

## Sample HTML Report

The HTML report includes:
- 📊 **Test Summary Dashboard** with pass/fail statistics
- 🎯 **Individual Test Results** with timing and status
- ❌ **Error Details** with full stack traces
- 📈 **Performance Metrics** and execution times
- 🎨 **Beautiful Styling** with responsive design

## Sample JSON Report

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

## Integration Examples

### Modify Existing Test Class

```csharp
// Before
public class InventoryApiTests : IDisposable
{
    [Fact]
    public async Task GetInventoryProducts_ShouldReturnInventoryProducts()
    {
        // Test logic
    }
}

// After - Option 1: Use BaseTestClass
public class InventoryApiTests : BaseTestClass
{
    [ReportingFact]
    public async Task GetInventoryProducts_ShouldReturnInventoryProducts()
    {
        try
        {
            // Test logic
            OnTestCompleted(TestStatus.Passed);
        }
        catch (Exception ex)
        {
            OnTestCompleted(TestStatus.Failed, ex.Message, ex.StackTrace);
            throw;
        }
    }
}

// After - Option 2: Use Custom Attributes
public class InventoryApiTests : IDisposable
{
    [ReportingFact]
    public async Task GetInventoryProducts_ShouldReturnInventoryProducts()
    {
        // Test logic (automatic reporting)
    }
}
```

### CI/CD Integration

```yaml
# GitHub Actions
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

## Advanced Usage

### Custom Report Generation

```csharp
// Generate custom reports programmatically
var reportService = new TestReportService(logger);
await reportService.GenerateReportsAsync();
```

### Filter Tests by Category

```bash
# Run tests with specific naming pattern
./run-tests-with-reporting.sh "Name~Authentication"

# Run tests in specific namespace
./run-tests-with-reporting.sh "FullyQualifiedName~VaxCareApiTests.Tests.Inventory"

# Run tests with specific trait
./run-tests-with-reporting.sh "Category=Integration"
```

### Multiple Output Formats

```bash
# Generate specific report formats
./run-tests-with-reporting.sh --format "html,json"
```

## Troubleshooting

### Common Issues

1. **Script not executable**: `chmod +x run-tests-with-reporting.sh`
2. **Reports directory not created**: Check write permissions
3. **HTML report not opening**: Use `--open-reports` flag
4. **JSON parsing errors**: Verify JSON format in generated files

### Debug Information

```bash
# Run with verbose output
./run-tests-with-reporting.sh --verbose

# Check generated files
ls -la TestReports/
```

## Next Steps

1. **Review Generated Reports**: Open the HTML report in your browser
2. **Integrate with CI/CD**: Add report generation to your pipeline
3. **Customize Reports**: Modify templates for your needs
4. **Monitor Performance**: Track test execution times over time
5. **Share Results**: Use reports for stakeholder communication

---

**Happy Testing! 🧪✨**

