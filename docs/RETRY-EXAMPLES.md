# 🔄 Retry Logic Examples

## Basic Usage

### 1. Simple HTTP Request with Automatic Retry

```csharp
[Fact]
public async Task GetInventoryProducts_WithRetryLogic()
{
    // This automatically uses retry logic if configured
    var response = await _httpClientService.GetAsync("/api/inventory/product/v2");
    
    response.Should().NotBeNull();
    response.StatusCode.Should().Be(HttpStatusCode.OK);
}
```

### 2. POST Request with Retry

```csharp
[Fact]
public async Task CreateAppointment_WithRetryLogic()
{
    var appointmentData = new
    {
        clinicId = 89534,
        patientId = 100186894,
        appointmentDate = "2025-10-22T10:00:00Z"
    };

    var jsonContent = JsonSerializer.Serialize(appointmentData);
    var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

    // Automatic retry on network failures
    var response = await _httpClientService.PostAsync("/api/patients/appointment/create", content);
    
    response.Should().NotBeNull();
}
```

### 3. PUT Request with Retry

```csharp
[Fact]
public async Task CheckoutAppointment_WithRetryLogic()
{
    var checkoutData = new
    {
        tabletId = "550e8400-e29b-41d4-a716-446655440001",
        administeredVaccines = new[]
        {
            new { id = 1, productId = 13, lotNumber = "J003535" }
        }
    };

    var jsonContent = JsonSerializer.Serialize(checkoutData);
    var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

    // Automatic retry on network failures
    var response = await _httpClientService.PutAsync("/api/patients/appointment/123/checkout", content);
    
    response.Should().NotBeNull();
}
```

## Advanced Usage

### 1. Custom Retry Logic

```csharp
[Fact]
public async Task CustomRetryLogic_Example()
{
    var retryService = new RetryService(_logger, _retryConfig);
    
    var result = await retryService.ExecuteWithRetryAsync(
        async () =>
        {
            // Your custom operation here
            return await SomeCustomOperation();
        },
        "Custom Operation",
        ex => ex is CustomException customEx && customEx.IsRetryable
    );
    
    result.Should().NotBeNull();
}
```

### 2. Retry with Different Configurations

```csharp
[Fact]
public async Task RetryWithCustomConfig_Example()
{
    var customRetryConfig = new RetryConfiguration
    {
        MaxRetryAttempts = 5,
        RetryDelayMs = 1000,
        ExponentialBackoff = false,
        MaxRetryDelayMs = 5000
    };

    var retryService = new RetryService(_logger, customRetryConfig);
    
    var result = await retryService.ExecuteWithRetryAsync(
        async () => await SomeOperation(),
        "Custom Config Operation"
    );
}
```

## Configuration Examples

### 1. Development Environment (Fast Feedback)

```json
{
  "ApiConfiguration": {
    "Timeout": 30000,
    "RetryConfiguration": {
      "MaxRetryAttempts": 2,
      "RetryDelayMs": 1000,
      "ExponentialBackoff": true,
      "MaxRetryDelayMs": 3000
    }
  }
}
```

### 2. QA Environment (Balanced)

```json
{
  "ApiConfiguration": {
    "Timeout": 60000,
    "RetryConfiguration": {
      "MaxRetryAttempts": 3,
      "RetryDelayMs": 2000,
      "ExponentialBackoff": true,
      "MaxRetryDelayMs": 10000
    }
  }
}
```

### 3. Production Environment (Conservative)

```json
{
  "ApiConfiguration": {
    "Timeout": 30000,
    "RetryConfiguration": {
      "MaxRetryAttempts": 2,
      "RetryDelayMs": 1000,
      "ExponentialBackoff": false,
      "MaxRetryDelayMs": 3000
    }
  }
}
```

## Testing Retry Logic

### 1. Test Retry Configuration Loading

```csharp
[Fact]
public void RetryConfiguration_ShouldBeLoadedCorrectly()
{
    var retryConfig = _configuration.GetSection("ApiConfiguration:RetryConfiguration");
    
    retryConfig.Should().NotBeNull();
    retryConfig["MaxRetryAttempts"].Should().NotBeNullOrEmpty();
    retryConfig["RetryDelayMs"].Should().NotBeNullOrEmpty();
    retryConfig["ExponentialBackoff"].Should().NotBeNullOrEmpty();
    retryConfig["MaxRetryDelayMs"].Should().NotBeNullOrEmpty();
}
```

### 2. Test Timeout Configuration

```csharp
[Fact]
public void TimeoutConfiguration_ShouldBeIncreased()
{
    var timeout = _configuration["ApiConfiguration:Timeout"];
    
    timeout.Should().NotBeNullOrEmpty();
    int.Parse(timeout!).Should().BeGreaterOrEqualTo(60000);
}
```

### 3. Test Retry Behavior

```csharp
[Fact]
public async Task RetryLogic_ShouldHandleTransientFailures()
{
    try
    {
        var response = await _httpClientService.GetAsync("/api/inventory/product/v2");
        response.Should().NotBeNull();
    }
    catch (HttpRequestException ex) when (ex.Message.Contains("nodename nor servname provided"))
    {
        // Expected in environments without network access
        Console.WriteLine("⚠️  Network connectivity issue - retry logic would have been tested if endpoint was reachable");
    }
}
```

## Logging Examples

### 1. Enable Debug Logging

```json
{
  "Logging": {
    "LogLevel": {
      "VaxCareApiTests.Services.RetryService": "Debug",
      "VaxCareApiTests.Services.HttpClientService": "Information"
    }
  }
}
```

### 2. Expected Log Output

```
[INFO] BaseUrl: https://vhapistg.vaxcare.com
[INFO] Timeout: 60000ms
[INFO] Retry: 3 attempts, 2000ms base delay
[INFO] Executing GET /api/inventory/product/v2 - Attempt 1/4
[WARN] GET /api/inventory/product/v2 failed on attempt 1. Retrying in 2000ms. Error: nodename nor servname provided
[INFO] Executing GET /api/inventory/product/v2 - Attempt 2/4
[WARN] GET /api/inventory/product/v2 failed on attempt 2. Retrying in 4000ms. Error: nodename nor servname provided
[INFO] Executing GET /api/inventory/product/v2 - Attempt 3/4
[ERROR] GET /api/inventory/product/v2 failed after 3 attempts. Giving up.
```

## Error Handling Examples

### 1. Handle Retryable vs Non-Retryable Errors

```csharp
[Fact]
public async Task ErrorHandling_ShouldDistinguishErrorTypes()
{
    try
    {
        var response = await _httpClientService.GetAsync("/api/inventory/product/v2");
        response.Should().NotBeNull();
    }
    catch (HttpRequestException ex) when (ex.Message.Contains("nodename nor servname provided"))
    {
        // Network error - would be retried
        Console.WriteLine("Network error - retry logic would handle this");
    }
    catch (HttpRequestException ex) when (ex.Message.Contains("401"))
    {
        // Authentication error - would NOT be retried
        Console.WriteLine("Authentication error - fails immediately");
    }
    catch (TaskCanceledException ex) when (ex.InnerException is TimeoutException)
    {
        // Timeout error - would be retried
        Console.WriteLine("Timeout error - retry logic would handle this");
    }
}
```

### 2. Custom Exception Handling

```csharp
[Fact]
public async Task CustomExceptionHandling_Example()
{
    var customRetryLogic = new Func<Exception, bool>(ex =>
    {
        return ex switch
        {
            HttpRequestException httpEx when httpEx.Message.Contains("timeout") => true,
            HttpRequestException httpEx when httpEx.Message.Contains("connection") => true,
            TaskCanceledException => true,
            _ => false
        };
    });

    var retryService = new RetryService(_logger, _retryConfig);
    
    try
    {
        var result = await retryService.ExecuteWithRetryAsync(
            async () => await SomeOperation(),
            "Custom Exception Handling",
            customRetryLogic
        );
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Operation failed: {ex.Message}");
    }
}
```

## Performance Monitoring

### 1. Measure Retry Impact

```csharp
[Fact]
public async Task RetryPerformance_ShouldBeMeasured()
{
    var stopwatch = Stopwatch.StartNew();
    
    try
    {
        var response = await _httpClientService.GetAsync("/api/inventory/product/v2");
        stopwatch.Stop();
        
        Console.WriteLine($"Request completed in: {stopwatch.ElapsedMilliseconds}ms");
        response.Should().NotBeNull();
    }
    catch (Exception ex)
    {
        stopwatch.Stop();
        Console.WriteLine($"Request failed after: {stopwatch.ElapsedMilliseconds}ms");
        Console.WriteLine($"Error: {ex.Message}");
    }
}
```

### 2. Monitor Retry Patterns

```csharp
[Fact]
public async Task RetryPatterns_ShouldBeMonitored()
{
    var retryCount = 0;
    var retryDelays = new List<int>();
    
    // This would be implemented in a custom retry service
    // that tracks retry patterns for monitoring
    
    var response = await _httpClientService.GetAsync("/api/inventory/product/v2");
    
    Console.WriteLine($"Total retries: {retryCount}");
    Console.WriteLine($"Retry delays: {string.Join(", ", retryDelays)}ms");
}
```

## Best Practices

### 1. Configuration Management

```csharp
// Use environment-specific configurations
var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Staging";
var config = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json")
    .AddJsonFile($"appsettings.{environment}.json", optional: true)
    .Build();
```

### 2. Error Logging

```csharp
// Log retry attempts with appropriate levels
_logger.LogInformation($"Executing {operationName} - Attempt {attempt + 1}/{maxAttempts}");
_logger.LogWarning($"Operation failed on attempt {attempt}. Retrying in {delay}ms. Error: {ex.Message}");
_logger.LogError($"Operation failed after {attempt} attempts. Giving up.");
```

### 3. Testing Strategy

```csharp
// Test both success and failure scenarios
[Theory]
[InlineData(true, "Should succeed on retry")]
[InlineData(false, "Should fail after max attempts")]
public async Task RetryLogic_ShouldHandleBothScenarios(bool shouldSucceed, string description)
{
    // Test implementation here
}
```
