# 🔄 Retry Logic Quick Reference

## Configuration

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

## Retry Flow

```
Request → Exception → Retryable? → YES → Wait → Retry
                           ↓
                         NO → Fail
```

## Exception Types

### ✅ **RETRIED**
- `HttpRequestException` (network issues)
- `TaskCanceledException` (timeouts)
- `SocketException` (connection problems)

### ❌ **NOT RETRIED**
- 4xx/5xx HTTP responses
- Authentication errors (401)
- Authorization errors (403)
- Validation errors (400)

## Timing

| Attempt | Exponential Delay | Linear Delay |
|---------|------------------|--------------|
| 1 | 0ms | 0ms |
| 2 | 2000ms | 2000ms |
| 3 | 4000ms | 2000ms |
| 4 | 8000ms | 2000ms |

## Usage

```csharp
// Automatic retry
var response = await _httpClientService.GetAsync("/api/endpoint");

// Custom retry
var result = await _retryService.ExecuteWithRetryAsync(
    async () => await operation(),
    "Operation Name"
);
```

## Debugging

```bash
# Enable debug logging
"LogLevel": { "VaxCareApiTests.Services.RetryService": "Debug" }

# Check retry attempts
grep "failed on attempt" test.log
```

## Best Practices

- ✅ Use exponential backoff
- ✅ Set reasonable max delays
- ✅ Monitor retry success rates
- ❌ Don't retry business logic errors
- ❌ Don't set too many retry attempts
