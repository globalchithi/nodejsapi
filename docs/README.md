# VaxCare API Testing Project - C# Version

A comprehensive API testing suite for the VaxCare inventory API, converted from curl commands to C# using xUnit, FluentAssertions, and HttpClient. This project provides robust testing capabilities with detailed validation, error handling, and debugging features.

## 🚀 **C# Version Features**

- ✅ **Complete curl-to-C# conversion** - Faithful reproduction of original curl command
- ✅ **xUnit test framework** - Industry-standard C# testing framework
- ✅ **FluentAssertions** - Readable and expressive test assertions
- ✅ **HttpClient integration** - Native .NET HTTP client with configuration
- ✅ **Dependency injection** - Clean architecture with service registration
- ✅ **Configuration management** - JSON-based configuration with environment support
- ✅ **Comprehensive logging** - Structured logging with Microsoft.Extensions.Logging
- ✅ **Model validation** - Strongly-typed models for API responses
- ✅ **Error handling** - Graceful network error handling and timeouts
- ✅ **Automated test reporting** - Cross-platform HTML, JSON, Markdown reports
- ✅ **Microsoft Teams integration** - Real-time notifications with Adaptive Cards
- ✅ **XML parsing** - Automatic extraction of test statistics from xUnit/TRX logs
- ✅ **Environment configuration** - .env file support for Teams webhooks
- ✅ **Cross-platform scripts** - Windows (PowerShell/Batch) and macOS/Linux (Bash)
- ✅ **Clean project organization** - Organized structure with separated concerns
- ✅ **Comprehensive documentation** - All guides organized in docs/ folder
- ✅ **Maintainable codebase** - Related files grouped together for easy maintenance

## 📁 Project Structure

```
VaxCareApiTests/
├── VaxCareApiTests.csproj    # C# project file with dependencies
├── Program.cs                 # Main application entry point
├── appsettings.json          # Configuration file
├── appsettings.Development.json # Staging configuration
├── TestInfo.json             # Test configuration
├── run-all-tests.py          # Main test runner (wrapper)
├── open-html-report.py       # Report opener (wrapper)
├── Models/                   # C# data models
│   ├── ApiConfiguration.cs   # Configuration models
│   ├── CheckoutModels.cs     # Checkout-related models
│   ├── TestPatients.cs       # Test patient models
│   └── VaxHubIdentifier.cs   # API response models
├── Services/                 # C# services
│   ├── BaseTestClass.cs      # Base test class
│   ├── EnhancedHtmlReportGenerator.cs # HTML report generator
│   ├── HttpClientService.cs  # HTTP client service
│   ├── TestExecutionWrapper.cs # Test execution wrapper
│   ├── TestReportService.cs  # Test report service
│   ├── TestResultCollector.cs # Test result collector
│   └── TestUtilities.cs      # Test utility functions
├── Tests/                    # C# test files
│   ├── InventoryApiTests.cs  # Inventory API tests
│   ├── PatientsAppointmentCreateTests.cs # Appointment creation tests
│   ├── PatientsAppointmentCheckoutTests.cs # Appointment checkout tests
│   └── [11 other test files] # Additional test suites
├── TestRunner/               # Core test running scripts
│   ├── run-all-tests.py      # Main test runner
│   ├── generate-enhanced-html-report-with-actual-results.py
│   ├── generate-enhanced-html-report-with-actual-results-windows.py
│   ├── generate-enhanced-html-report-robust.py
│   ├── send-teams-notification.py
│   ├── open-html-report.py
│   └── README.md             # TestRunner documentation
├── TestReports/              # Generated test reports (auto-created)
├── TestResults/              # Raw test results (.trx, .xml)
├── docs/                     # All documentation
│   ├── README.md             # This documentation
│   ├── PROJECT-STRUCTURE.md  # Project structure guide
│   ├── CLEANUP-SUMMARY.md    # Cleanup summary
│   ├── TEAMS-INTEGRATION-GUIDE.md # Teams integration guide
│   ├── TEST-RUNNER-GUIDE.md  # Test runner guide
│   └── [25+ other guides]    # Additional documentation
└── temp_unused_files/        # Deprecated/unused files (73 files)
    ├── MOVED-FILES-SUMMARY.md # Summary of moved files
    └── [72 deprecated files]  # Old scripts and utilities
```

## 🎯 **Project Organization Benefits**

### **Clean Root Directory**
- **Only 8 essential files** visible in root directory
- **Easy to find main entry points** (run-all-tests.py, open-html-report.py)
- **Professional project appearance** with clear structure
- **Reduced confusion** from cluttered files

### **Organized Documentation**
- **All guides in `docs/` folder** for easy access
- **30+ documentation files** properly organized
- **Clear separation** between code and documentation
- **Easy to find specific information**

### **Separated Concerns**
- **Test running logic in `TestRunner/`** - All Python scripts together
- **Documentation in `docs/`** - All guides and documentation
- **Deprecated files in `temp_unused_files/`** - Old scripts preserved but hidden
- **Generated files in `TestReports/`** - All reports in one place

### **Maintainability**
- **Related files grouped together** for easy updates
- **Clear separation of responsibilities** between different areas
- **Easy to add new features** without cluttering root directory
- **Better code organization** for team collaboration

## 🛠️ Setup & Installation

### Prerequisites
- .NET 8.0 SDK or higher
- Visual Studio 2022 or VS Code with C# extension
- Windows, macOS, or Linux

### Installation Steps

1. **Navigate to the project:**
   ```bash
   cd /Users/asadzaman/Documents/GitHub/nodejsapi
   ```

2. **Restore dependencies:**
   ```bash
   dotnet restore
   ```

3. **Build the project:**
   ```bash
   dotnet build
   ```

4. **Run tests:**
   ```bash
   dotnet test
   ```

5. **Run the application:**
   ```bash
   dotnet run
   ```

## 🧪 Running Tests

### Basic Test Commands

```bash
# Run all tests once
dotnet test

# Run tests with detailed output
dotnet test --verbosity normal

# Run tests with coverage report
dotnet test --collect:"XPlat Code Coverage"

# Run specific test class
dotnet test --filter "FullyQualifiedName~InventoryApiTests"

# Run tests in watch mode (requires dotnet-watch)
dotnet watch test

# Run the application (for manual testing)
dotnet run
```

### 🚀 **Automated Test Reporting & Teams Integration**

The project includes comprehensive automated test reporting with Microsoft Teams integration:

#### **Cross-Platform Test Reporting**
- **Python-based**: Unified Python scripts for all platforms
- **Automatic XML parsing** from xUnit and TRX loggers
- **Real-time Teams notifications** with Adaptive Cards
- **Enhanced HTML reports** with actual results and failure reasons

#### **Quick Start - Automated Reporting**

**All Platforms:**
```bash
# Run all tests with automatic HTML report generation
python3 run-all-tests.py

# Run tests with Teams notification
python3 run-all-tests.py --teams

# Run specific test categories
python3 run-all-tests.py --category inventory
python3 run-all-tests.py --category patients

# Open HTML report in browser
python3 open-html-report.py

# List available reports
python3 open-html-report.py --list
```

#### **Teams Notification Features**
- **Real test statistics**: Total, passed, failed, skipped tests
- **Success rate calculation**: Automatic percentage calculation
- **Execution time formatting**: Human-readable duration
- **Environment details**: Staging, Staging, Production
- **Adaptive Cards**: Rich Teams notifications with test data
- **Error handling**: Robust XML parsing with auto-repair

#### **Generated Reports**
- **HTML Reports**: Enhanced with detailed test scenarios
- **JSON Reports**: Machine-readable test data
- **Markdown Reports**: Documentation-friendly format
- **XML Reports**: xUnit and TRX format support

#### **Environment Configuration**
Create `.env` file for Teams integration:
```env
# Microsoft Teams Integration
TEAMS_WEBHOOK_URL=https://your-webhook-url
SEND_TEAMS_NOTIFICATION=true

# Test Environment Configuration
ENVIRONMENT=Staging
BROWSER=Chrome

# Report Directory
REPORTS_DIR=TestReports
```

#### **Sample Teams Notification**
The system sends rich Adaptive Cards to Teams with:
- **Test Status**: ✅ All 14 tests passed successfully!
- **Environment**: Staging
- **Total Tests**: 14
- **Passed**: 12
- **Failed**: 2
- **Success Rate**: 85.7%
- **Duration**: 8 seconds
- **Timestamp**: 10/23/2025, 5:00:00 PM

#### **Advanced Usage**
```bash
# Test webhook URL
test-teams-webhook.bat "https://your-webhook-url"

# Parse specific XML file
powershell -ExecutionPolicy Bypass -File "parse-test-results.ps1" -XmlFile "TestReports\TestResults.xml" -WebhookUrl "https://your-webhook-url"

# Generate enhanced HTML report
powershell -ExecutionPolicy Bypass -File "generate-enhanced-report-minimal.ps1"
```

### Test Output Examples

**Successful Test Run:**
```
Starting test execution, please wait...
A total of 1 test files matched the specified pattern.

Passed!  - Failed:     0, Passed:     5, Skipped:     0, Total:     5, Duration: 1 s - VaxCareApiTests.dll (net8.0)

Test Run Successful.
Total tests: 5
     Passed: 5
     Failed: 0
     Skipped: 0
Total time: 1.2345 Seconds
```

## 📋 Test Suite Details

### Main Test File: `Tests/InventoryApiTests.cs`

The test suite includes five comprehensive test cases:

#### 1. **Basic API Test**
- **Purpose**: Tests the main GET endpoint with all headers from the curl command
- **Validates**: Response status (200), content-type, response structure
- **Features**: 60-second timeout (increased for reliability), insecure HTTPS, comprehensive logging, retry logic

#### 2. **Authentication Test**
- **Purpose**: Validates the X-VaxHub-Identifier header and decodes the JWT
- **Validates**: JWT structure, decoded payload, required fields (clinicId, partnerId, version)
- **Features**: Base64 decoding, JSON parsing, field validation

#### 3. **Header Validation Test**
- **Purpose**: Ensures all required headers are present and correct
- **Validates**: Required headers presence, specific header values
- **Features**: Header enumeration, value validation

#### 4. **Error Handling Test**
- **Purpose**: Tests network error scenarios and graceful error handling
- **Validates**: Error response codes, error handling mechanisms
- **Features**: Invalid endpoint testing, error code validation

#### 5. **Curl Command Structure Validation**
- **Purpose**: Validates the complete curl command conversion
- **Validates**: URL matching, header presence, format validation
- **Features**: Base64 token validation, traceparent format validation

#### 6. **Retry Logic and Timeout Tests**
- **Purpose**: Tests the enhanced retry mechanism and increased timeout settings
- **Validates**: Retry configuration loading, timeout settings, transient failure handling
- **Features**: Exponential backoff, configurable retry attempts, improved reliability

### Test Configuration: `VaxCareApiTests.csproj`

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>
  
  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.0" />
    <PackageReference Include="xunit" Version="2.6.1" />
    <PackageReference Include="FluentAssertions" Version="6.12.0" />
    <PackageReference Include="Microsoft.Extensions.Http" Version="8.0.0" />
    <PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
  </ItemGroup>
</Project>
```

### Configuration: `appsettings.json`

```json
{
  "ApiConfiguration": {
    "BaseUrl": "https://vhapistg.vaxcare.com",  // Configured per environment
    "Timeout": 60000,  // Increased from 30s to 60s for better reliability
    "InsecureHttps": true,
    "RetryConfiguration": {
      "MaxRetryAttempts": 3,
      "RetryDelayMs": 2000,
      "ExponentialBackoff": true,
      "MaxRetryDelayMs": 10000
    }
  },
  "Headers": {
    "IsCalledByJob": "true",
    "X-VaxHub-Identifier": "eyJhbmRyb2lkU2RrIjoyOSwiYW5kcm9pZFZlcnNpb24iOiIxMCIsImFzc2V0VGFnIjotMSwiY2xpbmljSWQiOjg5NTM0LCJkZXZpY2VTZXJpYWxOdW1iZXIiOiJOT19QRVJNSVNTSU9OIiwicGFydG5lcklkIjoxNzg3NjQsInVzZXJJZCI6MCwidXNlck5hbWUiOiAiIiwidmVyc2lvbiI6MTQsInZlcnNpb25OYW1lIjoiMy4wLjAtMC1TVEciLCJtb2RlbFR5cGUiOiJNb2JpbGVIdWIifQ==",
    "traceparent": "00-3140053e06f8472dbe84f9feafcdb447-55674bbd17d441fe-01",
    "MobileData": "false",
    "UserSessionId": "NO USER LOGGED IN",
    "MessageSource": "VaxMobile",
    "Host": "vhapistg.vaxcare.com",  // Configured per environment
    "Connection": "Keep-Alive",
    "User-Agent": "okhttp/4.12.0"
  }
}
```

## 🔧 Original Curl Command

The tests are based on this curl command:

```bash
curl --insecure "https://vhapistg.vaxcare.com/api/inventory/product/v2" \  # URL configured per environment
-X GET \
-H "IsCalledByJob: true" \
-H "X-VaxHub-Identifier: eyJhbmRyb2lkU2RrIjoyOSwiYW5kcm9pZFZlcnNpb24iOiIxMCIsImFzc2V0VGFnIjotMSwiY2xpbmljSWQiOjg5NTM0LCJkZXZpY2VTZXJpYWxOdW1iZXIiOiJOT19QRVJNSVNTSU9OIiwicGFydG5lcklkIjoxNzg3NjQsInVzZXJJZCI6MCwidXNlck5hbWUiOiAiIiwidmVyc2lvbiI6MTQsInZlcnNpb25OYW1lIjoiMy4wLjAtMC1TVEciLCJtb2RlbFR5cGUiOiJNb2JpbGVIdWIifQ==" \
-H "traceparent: 00-3140053e06f8472dbe84f9feafcdb447-55674bbd17d441fe-01" \
-H "MobileData: false" \
-H "UserSessionId: NO USER LOGGED IN" \
-H "MessageSource: VaxMobile" \
-H "Host: vhapistg.vaxcare.com" \  # Configured per environment
-H "Connection: Keep-Alive" \
-H "User-Agent: okhttp/4.12.0"
```

## 🔍 Key Technical Features

### **Retry Logic and Timeout Configuration**
```csharp
// Automatic retry with exponential backoff
"RetryConfiguration": {
  "MaxRetryAttempts": 3,        // Maximum retry attempts
  "RetryDelayMs": 2000,         // Base delay between retries
  "ExponentialBackoff": true,   // Use exponential backoff
  "MaxRetryDelayMs": 10000      // Maximum delay cap
}

// Increased timeout for better reliability
"Timeout": 60000  // 60 seconds (increased from 30s)
```

### **Insecure HTTPS Support**
```csharp
// Configure insecure HTTPS (equivalent to curl --insecure)
if (_apiConfig.InsecureHttps)
{
    ServicePointManager.ServerCertificateValidationCallback = 
        (sender, certificate, chain, sslPolicyErrors) => true;
}
```

### **Complete Header Replication**
All headers from the curl command are faithfully reproduced:
- `IsCalledByJob: true`
- `X-VaxHub-Identifier: [JWT Token]`
- `traceparent: [Trace ID]`
- `MobileData: false`
- `UserSessionId: NO USER LOGGED IN`
- `MessageSource: VaxMobile`
- `Host: vhapistg.vaxcare.com` (configured per environment)
- `Connection: Keep-Alive`
- `User-Agent: okhttp/4.12.0`

### **JWT Token Validation**
The X-VaxHub-Identifier header is automatically decoded and validated:
```csharp
public VaxHubIdentifier DecodeVaxHubIdentifier(string base64Token)
{
    var jsonBytes = Convert.FromBase64String(base64Token);
    var jsonString = Encoding.UTF8.GetString(jsonBytes);
    return JsonConvert.DeserializeObject<VaxHubIdentifier>(jsonString);
}
```

### **Comprehensive Error Handling**
- Network timeout handling (30 seconds)
- HTTP error status code validation
- Response structure validation
- Detailed error logging with status codes and response data

## 📊 Coverage Reports

The test suite generates comprehensive coverage reports:

```bash
dotnet test --collect:"XPlat Code Coverage"
```

**Coverage Output:**
- **Console**: Coverage percentages in test output
- **XML**: Machine-readable format for CI/CD integration
- **HTML**: Interactive web-based coverage report (with additional tools)

## 🐛 Debugging & Troubleshooting

### **Comprehensive Logging**
The tests include detailed logging for debugging:

```csharp
_logger.LogInformation($"Response Status: {response.StatusCode}");
_logger.LogInformation($"Response Headers: {string.Join(", ", response.Headers)}");
Console.WriteLine($"Response Data: {content}");
```

### **Error Debugging**
When tests fail, detailed error information is logged:
- API error messages
- Response status codes
- Response data
- Response headers
- Network error details

### **Common Issues & Solutions**

1. **Timeout Errors**
   - Increase timeout in appsettings.json
   - Check network connectivity
   - Verify API endpoint availability

2. **Authentication Errors**
   - Validate X-VaxHub-Identifier token
   - Check token expiration
   - Verify base64 encoding

3. **Network Errors**
   - Verify HTTPS certificate handling
   - Check firewall settings
   - Validate proxy configuration

## 🔧 Customization & Extension

### **Adding New Tests**
```csharp
[Fact]
public async Task CustomTest()
{
    var customHeaders = _testUtilities.CreateTestHeaders(new Dictionary<string, string>
    {
        ["Custom-Header"] = "custom-value"
    });
    
    var response = await _httpClientService.GetAsync("/custom/endpoint");
    response.StatusCode.Should().Be(HttpStatusCode.OK);
}
```

### **Environment Configuration**
Create environment-specific appsettings files:
```json
// appsettings.Production.json
{
  "ApiConfiguration": {
    "BaseUrl": "https://production-api.com",
    "Timeout": 60000
  }
}
```

### **Test Utilities**
Use the test utilities for consistent test creation:
```csharp
// Create custom headers
var headers = _testUtilities.CreateTestHeaders(new Dictionary<string, string>
{
    ["Custom-Header"] = "value"
});

// Decode JWT tokens
var identifier = _testUtilities.DecodeVaxHubIdentifier(token);
```

## 📦 Dependencies

### **Core Dependencies**
- **xUnit**: Test framework with comprehensive features
- **FluentAssertions**: Readable assertion library
- **HttpClient**: Native .NET HTTP client
- **Microsoft.Extensions.Http**: HTTP client factory
- **Newtonsoft.Json**: JSON serialization

### **Staging Dependencies**
- **Microsoft.NET.Test.Sdk**: Test SDK
- **coverlet.collector**: Code coverage collection
- **Microsoft.Extensions.Logging**: Structured logging

## 🚀 Advanced Usage

### **CI/CD Integration**
```yaml
# GitHub Actions example
- name: Run API Tests
  run: |
    dotnet restore
    dotnet build
    dotnet test --collect:"XPlat Code Coverage"
```

### **Docker Integration**
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .
RUN dotnet restore
RUN dotnet build
RUN dotnet test

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/bin/Debug/net8.0 .
CMD ["dotnet", "VaxCareApiTests.dll"]
```

### **Performance Testing**
```csharp
[Fact]
public async Task ApiPerformanceTest()
{
    var stopwatch = Stopwatch.StartNew();
    
    var response = await _httpClientService.GetAsync(_endpoint);
    
    stopwatch.Stop();
    stopwatch.ElapsedMilliseconds.Should().BeLessThan(5000); // 5 second max
    response.StatusCode.Should().Be(HttpStatusCode.OK);
}
```

## 📈 Best Practices

1. **Use strongly-typed models** for API responses
2. **Implement proper dependency injection** for testability
3. **Use configuration files** for environment-specific settings
4. **Include comprehensive error handling** in all tests
5. **Use structured logging** for better debugging
6. **Implement proper cleanup** in test teardown
7. **Document test assumptions** and expected behavior

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add your tests
4. Run the test suite
5. Submit a pull request

## 🚀 **Quick Reference - Test Reporting & Teams Integration**

### **All Platforms (Python-based)**
```bash
# Run all tests with automatic HTML report generation
python3 run-all-tests.py

# Run tests with Teams notification
python3 run-all-tests.py --teams

# Run specific test categories
python3 run-all-tests.py --category inventory
python3 run-all-tests.py --category patients
python3 run-all-tests.py --category appointment

# Run with custom filter
python3 run-all-tests.py --filter "FullyQualifiedName~Inventory"

# Open HTML report in browser
python3 open-html-report.py

# List available reports
python3 open-html-report.py --list

# Open specific report
python3 open-html-report.py --file "EnhancedTestReport_2025-10-24.html"
```

### **Environment Setup**
Create `.env` file:
```env
TEAMS_WEBHOOK_URL=https://your-webhook-url
SEND_TEAMS_NOTIFICATION=true
ENVIRONMENT=Staging
BROWSER=Chrome
```

### **Generated Reports**
- **HTML**: Enhanced with detailed test scenarios
- **JSON**: Machine-readable test data  
- **Markdown**: Documentation-friendly format
- **Teams**: Rich Adaptive Cards with test statistics

### **Documentation**
All documentation is organized in the `docs/` folder:

- **`README.md`** - This main documentation
- **`PROJECT-STRUCTURE.md`** - Detailed project structure guide
- **`CLEANUP-SUMMARY.md`** - Project cleanup summary
- **`TEAMS-INTEGRATION-GUIDE.md`** - Teams integration documentation
- **`TEST-RUNNER-GUIDE.md`** - Test runner usage guide
- **`APPOINTMENT-TESTS-GUIDE.md`** - Appointment testing guide
- **`ENVIRONMENT-SETUP.md`** - Environment setup guide
- **`TROUBLESHOOTING-GUIDE.md`** - Troubleshooting guide
- **`WINDOWS-SETUP.md`** - Windows-specific setup guide
- **And 20+ other specialized guides**

## 📄 License

MIT License - see LICENSE file for details
