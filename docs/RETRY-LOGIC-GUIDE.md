# 🔄 Retry Logic and Timeout Configuration Guide

## Overview

This guide explains the retry logic and timeout improvements implemented in the VaxCare API test suite. The system automatically handles transient network failures while maintaining fast failure for business logic errors.

## Table of Contents

- [Features](#features)
- [Configuration](#configuration)
- [How It Works](#how-it-works)
- [Exception Handling](#exception-handling)
- [Timing and Delays](#timing-and-delays)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## Features

### ✅ **Automatic Retry Logic**
- **Smart Retry**: Only retries on transient network failures
- **Exponential Backoff**: Increasing delays between retry attempts
- **Configurable**: All settings adjustable via JSON configuration
- **Comprehensive Logging**: Detailed logs for debugging and monitoring

### ⏱️ **Enhanced Timeout Settings**
- **Increased Timeout**: Extended from 30s to 60s for better reliability
- **Environment-Specific**: Different timeouts per environment
- **Configurable**: Easy to adjust without code changes

### 🎯 **Intelligent Exception Handling**
- **Network Errors**: Automatically retries on connection issues
- **Business Logic**: Fails fast on 4xx/5xx HTTP responses
- **Timeout Handling**: Retries on request timeouts
- **Socket Issues**: Handles connection problems gracefully

## Configuration

### Environment Configuration Files

The retry logic is configured in the following files:

- `appsettings.json` - Base configuration
- `appsettings.Development.json` - Development environment
- `appsettings.QA.json` - QA environment

### Configuration Structure

```json
{
  "ApiConfiguration": {
    "BaseUrl": "https://vhapistg.vaxcare.com",
    "Timeout": 60000,
    "InsecureHttps": true,
    "RetryConfiguration": {
      "MaxRetryAttempts": 3,
      "RetryDelayMs": 2000,
      "ExponentialBackoff": true,
      "MaxRetryDelayMs": 10000
    }
  }
}
```

### Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `MaxRetryAttempts` | int | 3 | Maximum number of retry attempts |
| `RetryDelayMs` | int | 2000 | Base delay between retries (milliseconds) |
| `ExponentialBackoff` | bool | true | Enable exponential backoff |
| `MaxRetryDelayMs` | int | 10000 | Maximum delay cap (milliseconds) |
| `Timeout` | int | 60000 | HTTP request timeout (milliseconds) |

## How It Works

### 1. Request Flow

```
HTTP Request → Retry Service → Execute Operation → Success/Failure
     ↓              ↓              ↓
  Check if      Apply Retry     Log Results
  Retryable     Logic if        and Timing
  Exception     Applicable
```

### 2. Retry Decision Process

```
Exception Occurs
       ↓
Is it a retryable error?
       ↓
   YES → Retry (up to MaxRetryAttempts)
   NO  → Fail immediately
```

### 3. Retry Flow Example

```
Attempt 1: Execute operation
❌ Fails: "nodename nor servname provided"
🔍 Check: HttpRequestException with network message → RETRY
⏱️  Wait: 0ms (immediate)

Attempt 2: Execute operation  
❌ Fails: "nodename nor servname provided"
🔍 Check: HttpRequestException with network message → RETRY
⏱️  Wait: 2000ms (2 seconds)

Attempt 3: Execute operation
❌ Fails: "nodename nor servname provided"
🔍 Check: HttpRequestException with network message → RETRY
⏱️  Wait: 4000ms (4 seconds)

Attempt 4: Execute operation
❌ Fails: "nodename nor servname provided"
🔍 Check: Max attempts (3) reached → FAIL
💥 Result: All retry attempts exhausted
```

## Exception Handling

### ✅ **Retryable Exceptions**

The system will automatically retry for these exceptions:

#### HttpRequestException
- **Network Issues**: "nodename nor servname provided"
- **DNS Problems**: "Name or service not known"
- **Host Unreachable**: "No such host"
- **Timeout Messages**: Contains "timeout"
- **Connection Issues**: Contains "connection" or "network"

#### TaskCanceledException
- **Request Timeouts**: When inner exception is TimeoutException
- **Timeout Messages**: Contains "timeout" in message

#### SocketException
- **Connection Problems**: All socket-related connection issues

### ❌ **Non-Retryable Exceptions**

The system will **NOT** retry for these exceptions:

- **4xx HTTP Responses**: 400, 401, 403, 404, etc.
- **5xx HTTP Responses**: 500, 502, 503, etc.
- **Authentication Errors**: 401 Unauthorized
- **Authorization Errors**: 403 Forbidden
- **Validation Errors**: 400 Bad Request
- **Business Logic Errors**: Any non-network related failures

## Timing and Delays

### Exponential Backoff Calculation

```
Formula: delay = baseDelay * (2 ^ (attempt - 1))
Base delay: 2000ms
Max delay cap: 10000ms

Attempt 1: 2000ms * 2^0 = 2000ms → 2000ms
Attempt 2: 2000ms * 2^1 = 4000ms → 4000ms  
Attempt 3: 2000ms * 2^2 = 8000ms → 8000ms
Attempt 4: 2000ms * 2^3 = 16000ms → 10000ms (capped)
```

### Timing Example

For a failing request with 3 retry attempts:

| Attempt | Delay | Cumulative Time |
|---------|-------|-----------------|
| 1 | 0ms | 0ms |
| 2 | 2000ms | 2000ms |
| 3 | 4000ms | 6000ms |
| 4 | 8000ms | 14000ms |
| **Total** | **14000ms** | **~14 seconds** |

### Linear Backoff (Alternative)

If `ExponentialBackoff` is set to `false`:

| Attempt | Delay | Cumulative Time |
|---------|-------|-----------------|
| 1 | 0ms | 0ms |
| 2 | 2000ms | 2000ms |
| 3 | 2000ms | 4000ms |
| 4 | 2000ms | 6000ms |
| **Total** | **6000ms** | **6 seconds** |

## Usage Examples

### 1. Basic HTTP Request with Retry

```csharp
// This automatically uses retry logic
var response = await _httpClientService.GetAsync("/api/inventory/product/v2");
```

### 2. POST Request with Retry

```csharp
var content = new StringContent(jsonData, Encoding.UTF8, "application/json");
var response = await _httpClientService.PostAsync("/api/patients/appointment/create", content);
```

### 3. PUT Request with Retry

```csharp
var content = new StringContent(jsonData, Encoding.UTF8, "application/json");
var response = await _httpClientService.PutAsync("/api/patients/appointment/123/checkout", content);
```

### 4. Custom Retry Logic

```csharp
// Custom retry logic for specific scenarios
var result = await _retryService.ExecuteWithRetryAsync(
    async () => await SomeOperation(),
    "Custom Operation",
    ex => ex is CustomException customEx && customEx.IsRetryable
);
```

## Troubleshooting

### Common Issues

#### 1. **Retry Logic Not Working**

**Symptoms**: Requests fail immediately without retries

**Solutions**:
- Check if `RetryConfiguration` is properly configured in `appsettings.json`
- Verify the exception is in the retryable exceptions list
- Check logs for retry service initialization

#### 2. **Too Many Retries**

**Symptoms**: Tests take too long due to excessive retries

**Solutions**:
- Reduce `MaxRetryAttempts` in configuration
- Check if the exception should be retryable
- Review the retry delay settings

#### 3. **Retry Logic Not Triggered**

**Symptoms**: Network errors don't trigger retries

**Solutions**:
- Verify the exception message contains retryable keywords
- Check if the exception type is supported
- Review the `ShouldRetryException` logic

### Debugging

#### Enable Detailed Logging

```json
{
  "Logging": {
    "LogLevel": {
      "VaxCareApiTests.Services.RetryService": "Debug"
    }
  }
}
```

#### Log Output Example

```
[INFO] Executing GET /api/inventory/product/v2 - Attempt 1/4
[WARN] GET /api/inventory/product/v2 failed on attempt 1. Retrying in 2000ms. Error: nodename nor servname provided
[INFO] Executing GET /api/inventory/product/v2 - Attempt 2/4
[WARN] GET /api/inventory/product/v2 failed on attempt 2. Retrying in 4000ms. Error: nodename nor servname provided
[INFO] Executing GET /api/inventory/product/v2 - Attempt 3/4
[ERROR] GET /api/inventory/product/v2 failed after 3 attempts. Giving up.
```

## Best Practices

### 1. **Configuration Management**

- **Environment-Specific**: Use different retry settings per environment
- **Conservative Defaults**: Start with lower retry counts in production
- **Monitor Performance**: Track retry success rates and adjust accordingly

### 2. **Exception Handling**

- **Be Specific**: Only retry truly transient failures
- **Log Appropriately**: Use appropriate log levels for retry attempts
- **Monitor Patterns**: Watch for recurring retry patterns that might indicate issues

### 3. **Performance Considerations**

- **Timeout Settings**: Balance timeout vs. retry delay settings
- **Exponential Backoff**: Use exponential backoff to prevent server overload
- **Max Delay Cap**: Set reasonable maximum delay caps

### 4. **Testing**

- **Test Retry Logic**: Include tests that verify retry behavior
- **Test Failure Scenarios**: Ensure non-retryable errors fail fast
- **Performance Testing**: Verify retry logic doesn't significantly impact test performance

## Configuration Examples

### Development Environment

```json
{
  "ApiConfiguration": {
    "Timeout": 30000,
    "RetryConfiguration": {
      "MaxRetryAttempts": 2,
      "RetryDelayMs": 1000,
      "ExponentialBackoff": true,
      "MaxRetryDelayMs": 5000
    }
  }
}
```

### QA Environment

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

### Production Environment

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

## Monitoring and Metrics

### Key Metrics to Monitor

1. **Retry Success Rate**: Percentage of retries that eventually succeed
2. **Average Retry Count**: How many retries are typically needed
3. **Total Request Time**: Impact of retries on overall request time
4. **Exception Patterns**: Types of exceptions that trigger retries

### Log Analysis

```bash
# Count retry attempts
grep "failed on attempt" test.log | wc -l

# Find successful retries
grep "succeeded on attempt" test.log

# Analyze retry patterns
grep "Retrying in" test.log | sort | uniq -c
```

## Conclusion

The retry logic and timeout improvements provide a robust foundation for handling transient network failures while maintaining fast failure for business logic errors. By following the configuration guidelines and best practices outlined in this guide, you can ensure optimal performance and reliability for your API test suite.

For additional support or questions, refer to the main [README.md](README.md) or contact the development team.
