# Node.js API Testing Project

A comprehensive API testing suite for the VaxCare inventory API, converted from curl commands to Node.js using Jest and Axios. This project provides robust testing capabilities with detailed validation, error handling, and debugging features.

## 🚀 Features

- ✅ **Complete curl-to-Node.js conversion** - Faithful reproduction of original curl command
- ✅ **Comprehensive test coverage** - Multiple test scenarios and edge cases
- ✅ **Advanced error handling** - Network errors, timeouts, and API errors
- ✅ **Header validation** - Ensures all required headers are present and correct
- ✅ **Response structure validation** - Validates API response format and content
- ✅ **JWT token decoding** - Automatic authentication token validation
- ✅ **Debug logging** - Comprehensive logging for troubleshooting
- ✅ **Environment configuration** - Support for different environments
- ✅ **Test utilities** - Helper functions for test creation and management

## 📁 Project Structure

```
nodejsapi/
├── package.json              # Dependencies and npm scripts
├── jest.config.js           # Jest test configuration
├── tests/
│   ├── inventory.test.js    # Main API test suite
│   └── setup.js             # Test setup and global utilities
├── env.example              # Environment configuration template
└── README.md                # This documentation
```

## 🛠️ Setup & Installation

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn package manager

### Installation Steps

1. **Clone and navigate to the project:**
   ```bash
   cd /Users/asadzaman/Documents/GitHub/nodejsapi
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment configuration:**
   ```bash
   cp env.example .env
   ```

4. **Verify installation:**
   ```bash
   npm test
   ```

## 🧪 Running Tests

### Basic Test Commands

```bash
# Run all tests once
npm test

# Run tests in watch mode (re-runs on file changes)
npm run test:watch

# Run tests with coverage report
npm run test:coverage

# Run specific test file
npx jest tests/inventory.test.js

# Run tests with verbose output
npx jest --verbose
```

### Test Output Examples

**Successful Test Run:**
```
 PASS  tests/inventory.test.js
  VaxCare Inventory API Tests
    ✓ GET /api/inventory/product/v2 - should return inventory products (1247ms)
    ✓ GET /api/inventory/product/v2 - should handle authentication headers (23ms)
    ✓ GET /api/inventory/product/v2 - should validate required headers (8ms)
    ✓ GET /api/inventory/product/v2 - should handle network errors gracefully (156ms)

Test Suites: 1 passed, 1 total
Tests:       4 passed, 4 total
Time:        1.45s
```

## 📋 Test Suite Details

### Main Test File: `tests/inventory.test.js`

The test suite includes four comprehensive test cases:

#### 1. **Basic API Test**
- **Purpose**: Tests the main GET endpoint with all headers from the curl command
- **Validates**: Response status (200), content-type, response structure
- **Features**: 30-second timeout, insecure HTTPS, comprehensive logging

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

### Test Configuration: `jest.config.js`

```javascript
module.exports = {
  testEnvironment: 'node',           // Node.js environment
  testMatch: ['**/tests/**/*.test.js'], // Test file pattern
  collectCoverageFrom: [             // Coverage collection
    '**/*.js',
    '!**/node_modules/**',
    '!**/coverage/**',
    '!jest.config.js'
  ],
  coverageDirectory: 'coverage',     // Coverage output directory
  coverageReporters: ['text', 'lcov', 'html'], // Coverage formats
  verbose: true,                     // Detailed output
  testTimeout: 30000,                // 30-second timeout for API tests
  setupFilesAfterEnv: ['<rootDir>/tests/setup.js'] // Global setup
};
```

### Test Setup: `tests/setup.js`

Global test utilities and configuration:

```javascript
// Test utilities available globally
global.testUtils = {
  createTestHeaders: (overrides = {}) => { /* ... */ },
  createAxiosConfig: (headers, timeout = 30000) => { /* ... */ }
};
```

## 🔧 Original Curl Command

The tests are based on this curl command:

```bash
curl --insecure "https://vhapistg.vaxcare.com/api/inventory/product/v2" \
-X GET \
-H "IsCalledByJob: true" \
-H "X-VaxHub-Identifier: eyJhbmRyb2lkU2RrIjoyOSwiYW5kcm9pZFZlcnNpb24iOiIxMCIsImFzc2V0VGFnIjotMSwiY2xpbmljSWQiOjg5NTM0LCJkZXZpY2VTZXJpYWxOdW1iZXIiOiJOT19QRVJNSVNTSU9OIiwicGFydG5lcklkIjoxNzg3NjQsInVzZXJJZCI6MCwidXNlck5hbWUiOiAiIiwidmVyc2lvbiI6MTQsInZlcnNpb25OYW1lIjoiMy4wLjAtMC1TVEciLCJtb2RlbFR5cGUiOiJNb2JpbGVIdWIifQ==" \
-H "traceparent: 00-3140053e06f8472dbe84f9feafcdb447-55674bbd17d441fe-01" \
-H "MobileData: false" \
-H "UserSessionId: NO USER LOGGED IN" \
-H "MessageSource: VaxMobile" \
-H "Host: vhapistg.vaxcare.com" \
-H "Connection: Keep-Alive" \
-H "User-Agent: okhttp/4.12.0"
```

## 🔍 Key Technical Features

### **Insecure HTTPS Support**
```javascript
httpsAgent: new (require('https').Agent)({
  rejectUnauthorized: false  // Equivalent to curl's --insecure flag
})
```

### **Complete Header Replication**
All headers from the curl command are faithfully reproduced:
- `IsCalledByJob: true`
- `X-VaxHub-Identifier: [JWT Token]`
- `traceparent: [Trace ID]`
- `MobileData: false`
- `UserSessionId: NO USER LOGGED IN`
- `MessageSource: VaxMobile`
- `Host: vhapistg.vaxcare.com`
- `Connection: Keep-Alive`
- `User-Agent: okhttp/4.12.0`

### **JWT Token Validation**
The X-VaxHub-Identifier header is automatically decoded and validated:
```javascript
const decoded = Buffer.from(identifierHeader, 'base64').toString('utf-8');
const identifier = JSON.parse(decoded);
// Validates: clinicId, partnerId, version, and other fields
```

### **Comprehensive Error Handling**
- Network timeout handling (30 seconds)
- HTTP error status code validation
- Response structure validation
- Detailed error logging with status codes and response data

## 📊 Coverage Reports

The test suite generates comprehensive coverage reports:

```bash
npm run test:coverage
```

**Coverage Output:**
- **Text**: Console output with coverage percentages
- **LCOV**: Machine-readable format for CI/CD integration
- **HTML**: Interactive web-based coverage report

**Coverage Metrics:**
- Statement coverage
- Branch coverage
- Function coverage
- Line coverage

## 🐛 Debugging & Troubleshooting

### **Comprehensive Logging**
The tests include detailed logging for debugging:

```javascript
console.log('Response Status:', response.status);
console.log('Response Headers:', response.headers);
console.log('Response Data:', JSON.stringify(response.data, null, 2));
console.log('Decoded Identifier:', JSON.stringify(identifier, null, 2));
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
   - Increase timeout in test configuration
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
```javascript
test('Custom test case', async () => {
  const customHeaders = testUtils.createTestHeaders({
    'Custom-Header': 'custom-value'
  });
  
  const response = await axios.get(endpoint, {
    ...testUtils.createAxiosConfig(customHeaders)
  });
  
  expect(response.status).toBe(200);
});
```

### **Environment Configuration**
Create a `.env` file with custom settings:
```bash
API_BASE_URL=https://your-api-endpoint.com
API_TIMEOUT=60000
X_VAXHUB_IDENTIFIER=your_custom_token
```

### **Test Utilities**
Use the global test utilities for consistent test creation:
```javascript
// Create custom headers
const headers = testUtils.createTestHeaders({
  'Custom-Header': 'value'
});

// Create axios configuration
const config = testUtils.createAxiosConfig(headers, 60000);
```

## 📦 Dependencies

### **Core Dependencies**
- **jest**: Test framework with comprehensive features
- **axios**: HTTP client with promise support
- **supertest**: HTTP assertion library
- **dotenv**: Environment variable management

### **Development Dependencies**
- **jest**: Testing framework
- **supertest**: HTTP testing utilities
- **axios**: HTTP client library

## 🚀 Advanced Usage

### **CI/CD Integration**
```yaml
# GitHub Actions example
- name: Run API Tests
  run: |
    npm install
    npm test
    npm run test:coverage
```

### **Docker Integration**
```dockerfile
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm", "test"]
```

### **Performance Testing**
```javascript
test('API Performance Test', async () => {
  const startTime = Date.now();
  
  const response = await axios.get(endpoint, config);
  
  const duration = Date.now() - startTime;
  expect(duration).toBeLessThan(5000); // 5 second max
  expect(response.status).toBe(200);
});
```

## 📈 Best Practices

1. **Always validate response structure** before asserting specific values
2. **Use descriptive test names** that explain the test purpose
3. **Include error scenarios** in your test suite
4. **Mock external dependencies** when possible for faster tests
5. **Use environment variables** for configuration management
6. **Implement proper cleanup** in test teardown
7. **Document test assumptions** and expected behavior

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add your tests
4. Run the test suite
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details