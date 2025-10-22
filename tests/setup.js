// Test setup file
require('dotenv').config();

// Global test configuration
global.console = {
  ...console,
  // Uncomment to suppress console.log during tests
  // log: jest.fn(),
  // debug: jest.fn(),
  // info: jest.fn(),
  // warn: jest.fn(),
  // error: jest.fn(),
};

// Increase timeout for API tests
jest.setTimeout(30000);

// Global test utilities
global.testUtils = {
  // Helper function to create test headers
  createTestHeaders: (overrides = {}) => {
    const defaultHeaders = {
      'IsCalledByJob': 'true',
      'X-VaxHub-Identifier': 'eyJhbmRyb2lkU2RrIjoyOSwiYW5kcm9pZFZlcnNpb24iOiIxMCIsImFzc2V0VGFnIjotMSwiY2xpbmljSWQiOjg5NTM0LCJkZXZpY2VTZXJpYWxOdW1iZXIiOiJOT19QRVJNSVNTSU9OIiwicGFydG5lcklkIjoxNzg3NjQsInVzZXJJZCI6MCwidXNlck5hbWUiOiAiIiwidmVyc2lvbiI6MTQsInZlcnNpb25OYW1lIjoiMy4wLjAtMC1TVEciLCJtb2RlbFR5cGUiOiJNb2JpbGVIdWIifQ==',
      'traceparent': '00-3140053e06f8472dbe84f9feafcdb447-55674bbd17d441fe-01',
      'MobileData': 'false',
      'UserSessionId': 'NO USER LOGGED IN',
      'MessageSource': 'VaxMobile',
      'Host': 'vhapistg.vaxcare.com',
      'Connection': 'Keep-Alive',
      'User-Agent': 'okhttp/4.12.0'
    };
    
    return { ...defaultHeaders, ...overrides };
  },

  // Helper function to create axios config
  createAxiosConfig: (headers, timeout = 30000) => {
    return {
      headers,
      httpsAgent: new (require('https').Agent)({
        rejectUnauthorized: false
      }),
      timeout
    };
  }
};
