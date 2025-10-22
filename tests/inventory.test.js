const axios = require('axios');

describe('VaxCare Inventory API Tests', () => {
  const baseURL = 'https://vhapistg.vaxcare.com';
  const endpoint = '/api/inventory/product/v2';
  
  // Headers from the curl command
  const headers = {
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

  test('GET /api/inventory/product/v2 - should return inventory products', async () => {
    try {
      const response = await axios.get(`${baseURL}${endpoint}`, {
        headers,
        // Equivalent to --insecure flag in curl
        httpsAgent: new (require('https').Agent)({
          rejectUnauthorized: false
        }),
        timeout: 30000 // 30 second timeout
      });

      // Basic response validation
      expect(response.status).toBe(200);
      expect(response.headers['content-type']).toMatch(/application\/json/);
      
      // Log response for debugging
      console.log('Response Status:', response.status);
      console.log('Response Headers:', response.headers);
      console.log('Response Data:', JSON.stringify(response.data, null, 2));

      // Validate response structure (adjust based on actual API response)
      expect(response.data).toBeDefined();
      
      // If the API returns an array of products
      if (Array.isArray(response.data)) {
        expect(response.data.length).toBeGreaterThanOrEqual(0);
      }
      
      // If the API returns an object with products
      if (response.data && typeof response.data === 'object') {
        expect(response.data).toHaveProperty('data');
      }

    } catch (error) {
      // Log error details for debugging
      console.error('API Error:', error.message);
      if (error.response) {
        console.error('Response Status:', error.response.status);
        console.error('Response Data:', error.response.data);
        console.error('Response Headers:', error.response.headers);
      }
      
      // Re-throw to fail the test
      throw error;
    }
  });

  test('GET /api/inventory/product/v2 - should handle authentication headers', async () => {
    // Test that the X-VaxHub-Identifier header is properly formatted
    const identifierHeader = headers['X-VaxHub-Identifier'];
    expect(identifierHeader).toBeDefined();
    expect(identifierHeader.length).toBeGreaterThan(0);
    
    // Decode and validate the base64 identifier
    try {
      const decoded = Buffer.from(identifierHeader, 'base64').toString('utf-8');
      const identifier = JSON.parse(decoded);
      
      expect(identifier).toHaveProperty('clinicId');
      expect(identifier).toHaveProperty('partnerId');
      expect(identifier).toHaveProperty('version');
      expect(identifier.clinicId).toBe(89534);
      expect(identifier.partnerId).toBe(178764);
      
      console.log('Decoded Identifier:', JSON.stringify(identifier, null, 2));
    } catch (error) {
      console.error('Failed to decode X-VaxHub-Identifier:', error.message);
      throw error;
    }
  });

  test('GET /api/inventory/product/v2 - should validate required headers', async () => {
    // Test that all required headers are present
    const requiredHeaders = [
      'IsCalledByJob',
      'X-VaxHub-Identifier',
      'UserSessionId',
      'MessageSource',
      'User-Agent'
    ];

    requiredHeaders.forEach(header => {
      expect(headers[header]).toBeDefined();
      expect(headers[header]).not.toBe('');
    });

    // Validate specific header values
    expect(headers['IsCalledByJob']).toBe('true');
    expect(headers['UserSessionId']).toBe('NO USER LOGGED IN');
    expect(headers['MessageSource']).toBe('VaxMobile');
    expect(headers['User-Agent']).toBe('okhttp/4.12.0');
  });

  test('GET /api/inventory/product/v2 - should handle network errors gracefully', async () => {
    // Test with invalid endpoint to ensure proper error handling
    const invalidEndpoint = '/api/invalid/endpoint';
    
    try {
      await axios.get(`${baseURL}${invalidEndpoint}`, {
        headers,
        httpsAgent: new (require('https').Agent)({
          rejectUnauthorized: false
        }),
        timeout: 5000
      });
      
      // If we get here, the endpoint exists (unexpected)
      fail('Expected request to fail with invalid endpoint');
    } catch (error) {
      // Expected to fail with 404 or similar
      expect(error.response).toBeDefined();
      expect([404, 400, 500]).toContain(error.response.status);
    }
  });
});
