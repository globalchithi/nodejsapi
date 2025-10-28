# 🔄 Retry Logic Flow Diagram

## Visual Flow

```
┌─────────────────────────────────────────────────────────┐
│                    HTTP Request                         │
│  GET /api/inventory/product/v2                         │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                Retry Service Check                     │
│  Is retry service enabled?                             │
│  ┌─────────┐    ┌─────────┐                           │
│  │   YES   │    │   NO    │                           │
│  │    ↓    │    │    ↓    │                           │
│  │ Retry   │    │ Direct  │                           │
│  │ Logic   │    │ Execute │                           │
│  └─────────┘    └─────────┘                           │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                Attempt 1 (Immediate)                   │
│  ✅ Execute operation                                  │
│  ❌ Fails: "nodename nor servname provided"            │
│  🔍 Check: Is this a retryable error?                  │
│  ┌─────────┐    ┌─────────┐                           │
│  │   YES   │    │   NO    │                           │
│  │    ↓    │    │    ↓    │                           │
│  │ Retry   │    │  FAIL   │                           │
│  │ Logic   │    │  Fast   │                           │
│  └─────────┘    └─────────┘                           │
│  ⏱️  Wait: 0ms (immediate retry)                      │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                Attempt 2 (2 seconds)                   │
│  ✅ Execute operation                                  │
│  ❌ Fails: "nodename nor servname provided"            │
│  🔍 Check: Is this a retryable error?                  │
│  ┌─────────┐    ┌─────────┐                           │
│  │   YES   │    │   NO    │                           │
│  │    ↓    │    │    ↓    │                           │
│  │ Retry   │    │  FAIL   │                           │
│  │ Logic   │    │  Fast   │                           │
│  └─────────┘    └─────────┘                           │
│  ⏱️  Wait: 2000ms (2 seconds)                         │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                Attempt 3 (4 seconds)                   │
│  ✅ Execute operation                                  │
│  ❌ Fails: "nodename nor servname provided"            │
│  🔍 Check: Is this a retryable error?                  │
│  ┌─────────┐    ┌─────────┐                           │
│  │   YES   │    │   NO    │                           │
│  │    ↓    │    │    ↓    │                           │
│  │ Retry   │    │  FAIL   │                           │
│  │ Logic   │    │  Fast   │                           │
│  └─────────┘    └─────────┘                           │
│  ⏱️  Wait: 4000ms (4 seconds)                         │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                Attempt 4 (8 seconds)                   │
│  ✅ Execute operation                                  │
│  ❌ Fails: "nodename nor servname provided"            │
│  🔍 Check: Max attempts (3) reached                    │
│  💥 FAIL: All retry attempts exhausted                 │
└─────────────────────────────────────────────────────────┘
```

## Exception Decision Tree

```
                    Exception Occurs
                           │
                           ▼
            ┌─────────────────────────────┐
            │  Exception Type Check       │
            └─────────┬───────────────────┘
                      │
            ┌─────────▼──────────┐
            │  HttpRequestException?      │
            │  TaskCanceledException?     │
            │  SocketException?           │
            └─────────┬───────────────────┘
                      │
            ┌─────────▼──────────┐
            │  Message Contains: │
            │  - "timeout"       │
            │  - "connection"    │
            │  - "network"       │
            │  - "nodename"      │
            └─────────┬───────────────────┘
                      │
            ┌─────────▼──────────┐
            │  YES: RETRY        │  NO: FAIL immediately
            │  - Up to MaxRetry  │  - 4xx/5xx responses
            │  - Apply delays    │  - Business errors
            │  - Log attempts    │  - Auth errors
            └────────────────────┘
```

## Timing Diagram

```
Time →
0s    2s    4s    6s    8s    10s   12s   14s
│     │     │     │     │     │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────
│     │     │     │     │     │     │     │
│  A1 │  A2 │  A3 │  A4 │     │     │     │
│  ❌ │  ❌ │  ❌ │  ❌ │     │     │     │
│     │     │     │     │     │     │     │
│ 0ms │2s   │4s   │8s   │     │     │     │
│     │     │     │     │     │     │     │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────
      │     │     │     │     │     │     │
      └─────┴─────┴─────┴─────┴─────┴─────┴─────
            │     │     │     │     │     │
            └─────┴─────┴─────┴─────┴─────┴─────
                  │     │     │     │     │
                  └─────┴─────┴─────┴─────┴─────
                        │     │     │     │
                        └─────┴─────┴─────┴─────
                              │     │     │
                              └─────┴─────┴─────
                                    │     │
                                    └─────┴─────
                                          │
                                          └─────

A1 = Attempt 1 (0ms delay)
A2 = Attempt 2 (2000ms delay)  
A3 = Attempt 3 (4000ms delay)
A4 = Attempt 4 (8000ms delay)
```

## Configuration Impact

```
┌─────────────────────────────────────────────────────────┐
│                Configuration Settings                   │
└─────────┬───────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────┐
│  MaxRetryAttempts: 3                                   │
│  RetryDelayMs: 2000                                    │
│  ExponentialBackoff: true                              │
│  MaxRetryDelayMs: 10000                                │
└─────────┬───────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────┐
│                Retry Behavior                          │
│  • Up to 3 retry attempts                              │
│  • 2s, 4s, 8s delays (exponential)                     │
│  • Max delay capped at 10s                             │
│  • Total time: ~14 seconds max                         │
└─────────────────────────────────────────────────────────┘
```

## Success vs Failure Scenarios

### ✅ **Success Scenario**
```
Attempt 1: ❌ Network error → Retry
Attempt 2: ❌ Network error → Retry  
Attempt 3: ✅ Success! → Return result
Total time: ~6 seconds
```

### ❌ **Failure Scenario**
```
Attempt 1: ❌ Network error → Retry
Attempt 2: ❌ Network error → Retry
Attempt 3: ❌ Network error → Retry
Attempt 4: ❌ Network error → Max attempts reached
Result: 💥 FAIL after ~14 seconds
```

### 🚫 **Fast Fail Scenario**
```
Attempt 1: ❌ 401 Unauthorized → Not retryable
Result: 💥 FAIL immediately (business logic error)
```
