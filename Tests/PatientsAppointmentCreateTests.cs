using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using System.Text.Json;
using System.Collections.Generic;
using System.Linq;

namespace VaxCareApiTests.Tests
{
    public class PatientsAppointmentCreateTests
    {
        private readonly HttpClient _httpClient;
        private readonly string _baseUrl;

        public PatientsAppointmentCreateTests()
        {
            _httpClient = new HttpClient();
            _baseUrl = Environment.GetEnvironmentVariable("API_BASE_URL") ?? "https://api.vaxcare.com";
        }

        [Fact]
        public async Task CreateAppointment_ShouldReturnAppointmentId()
        {
            // Arrange
            var uniqueLastName = $"Patient{DateTime.Now:yyyyMMddHHmmss}";
            var appointmentData = new
            {
                newPatient = new
                {
                    firstName = "Test",
                    lastName = uniqueLastName,
                    dob = "1990-07-07 00:00:00.000",
                    gender = 0,
                    phoneNumber = "5555555555",
                    paymentInformation = new
                    {
                        primaryInsuranceId = 12,
                        paymentMode = "InsurancePay",
                        primaryMemberId = "",
                        primaryGroupId = "",
                        relationshipToInsured = "Self",
                        insuranceName = "Cigna",
                        mbi = "",
                        stock = "Private"
                    },
                    SSN = ""
                },
                clinicId = 10808,
                date = "2025-10-16T20:00:00Z",
                providerId = 100001877,
                initialPaymentMode = "InsurancePay",
                visitType = "Well"
            };

            var json = JsonSerializer.Serialize(appointmentData, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            var content = new StringContent(json, Encoding.UTF8, "application/json");

            // Act
            var response = await _httpClient.PostAsync($"{_baseUrl}/api/patients/appointment", content);

            // Assert
            Assert.True(response.IsSuccessStatusCode, 
                $"Expected successful response but got {response.StatusCode}: {await response.Content.ReadAsStringAsync()}");

            var responseContent = await response.Content.ReadAsStringAsync();
            Assert.False(string.IsNullOrEmpty(responseContent), "Response content should not be empty");

            // Verify response contains appointment ID
            var responseJson = JsonSerializer.Deserialize<JsonElement>(responseContent);
            
            // Check for common appointment ID field names
            var hasAppointmentId = responseJson.TryGetProperty("appointmentId", out _) ||
                                 responseJson.TryGetProperty("appointment_id", out _) ||
                                 responseJson.TryGetProperty("id", out _) ||
                                 responseJson.TryGetProperty("appointment", out var appointmentElement) && 
                                 (appointmentElement.TryGetProperty("id", out _) || 
                                  appointmentElement.TryGetProperty("appointmentId", out _));

            Assert.True(hasAppointmentId, 
                $"Response should contain an appointment ID. Response: {responseContent}");

            // Log the response for debugging
            Console.WriteLine($"Appointment created successfully for patient: {uniqueLastName}");
            Console.WriteLine($"Response: {responseContent}");
        }

        [Fact]
        public async Task CreateAppointment_ShouldValidateRequiredHeaders()
        {
            // Arrange
            var uniqueLastName = $"Patient{DateTime.Now:yyyyMMddHHmmss}";
            var appointmentData = new
            {
                newPatient = new
                {
                    firstName = "Test",
                    lastName = uniqueLastName,
                    dob = "1990-07-07 00:00:00.000",
                    gender = 0,
                    phoneNumber = "5555555555",
                    paymentInformation = new
                    {
                        primaryInsuranceId = 12,
                        paymentMode = "InsurancePay",
                        primaryMemberId = "",
                        primaryGroupId = "",
                        relationshipToInsured = "Self",
                        insuranceName = "Cigna",
                        mbi = "",
                        stock = "Private"
                    },
                    SSN = ""
                },
                clinicId = 10808,
                date = "2025-10-16T20:00:00Z",
                providerId = 100001877,
                initialPaymentMode = "InsurancePay",
                visitType = "Well"
            };

            var json = JsonSerializer.Serialize(appointmentData, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            var content = new StringContent(json, Encoding.UTF8, "application/json");

            // Act
            var response = await _httpClient.PostAsync($"{_baseUrl}/api/patients/appointment", content);

            // Assert
            Assert.True(response.IsSuccessStatusCode, 
                $"Expected successful response but got {response.StatusCode}: {await response.Content.ReadAsStringAsync()}");

            // Verify required headers are present
            Assert.True(response.Headers.Contains("Content-Type"), "Response should contain Content-Type header");
            
            var contentType = response.Content.Headers.ContentType?.ToString();
            Assert.True(contentType?.Contains("application/json") == true, 
                $"Expected JSON content type, but got: {contentType}");

            Console.WriteLine($"Required headers validated successfully");
        }

        [Fact]
        public async Task CreateAppointment_ShouldValidateEndpointStructure()
        {
            // Arrange
            var endpoint = "/api/patients/appointment";
            var fullUrl = $"{_baseUrl}{endpoint}";

            // Act & Assert
            Assert.True(Uri.TryCreate(fullUrl, UriKind.Absolute, out var uri), 
                $"Invalid endpoint URL: {fullUrl}");
            
            Assert.Equal("https", uri.Scheme);
            Assert.True(uri.AbsolutePath.EndsWith("/api/patients/appointment"), 
                $"Endpoint should end with /api/patients/appointment, but got: {uri.AbsolutePath}");

            Console.WriteLine($"Endpoint structure validated: {fullUrl}");
        }

        [Fact]
        public async Task CreateAppointment_ShouldHandleUniquePatientNames()
        {
            // Arrange
            var uniqueLastName = $"Patient{DateTime.Now:yyyyMMddHHmmss}{new Random().Next(1000, 9999)}";
            var appointmentData = new
            {
                newPatient = new
                {
                    firstName = "Test",
                    lastName = uniqueLastName,
                    dob = "1990-07-07 00:00:00.000",
                    gender = 0,
                    phoneNumber = "5555555555",
                    paymentInformation = new
                    {
                        primaryInsuranceId = 12,
                        paymentMode = "InsurancePay",
                        primaryMemberId = "",
                        primaryGroupId = "",
                        relationshipToInsured = "Self",
                        insuranceName = "Cigna",
                        mbi = "",
                        stock = "Private"
                    },
                    SSN = ""
                },
                clinicId = 10808,
                date = "2025-10-16T20:00:00Z",
                providerId = 100001877,
                initialPaymentMode = "InsurancePay",
                visitType = "Well"
            };

            var json = JsonSerializer.Serialize(appointmentData, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            var content = new StringContent(json, Encoding.UTF8, "application/json");

            // Act
            var response = await _httpClient.PostAsync($"{_baseUrl}/api/patients/appointment", content);

            // Assert
            Assert.True(response.IsSuccessStatusCode, 
                $"Expected successful response but got {response.StatusCode}: {await response.Content.ReadAsStringAsync()}");

            var responseContent = await response.Content.ReadAsStringAsync();
            Assert.False(string.IsNullOrEmpty(responseContent), "Response content should not be empty");

            // Verify the unique last name is handled correctly
            Assert.DoesNotContain("duplicate", responseContent.ToLower());
            Assert.DoesNotContain("already exists", responseContent.ToLower());

            Console.WriteLine($"Unique patient name handled successfully: {uniqueLastName}");
            Console.WriteLine($"Response: {responseContent}");
        }

        [Fact]
        public async Task CreateAppointment_ShouldValidateResponseFormat()
        {
            // Arrange
            var uniqueLastName = $"Patient{DateTime.Now:yyyyMMddHHmmss}";
            var appointmentData = new
            {
                newPatient = new
                {
                    firstName = "Test",
                    lastName = uniqueLastName,
                    dob = "1990-07-07 00:00:00.000",
                    gender = 0,
                    phoneNumber = "5555555555",
                    paymentInformation = new
                    {
                        primaryInsuranceId = 12,
                        paymentMode = "InsurancePay",
                        primaryMemberId = "",
                        primaryGroupId = "",
                        relationshipToInsured = "Self",
                        insuranceName = "Cigna",
                        mbi = "",
                        stock = "Private"
                    },
                    SSN = ""
                },
                clinicId = 10808,
                date = "2025-10-16T20:00:00Z",
                providerId = 100001877,
                initialPaymentMode = "InsurancePay",
                visitType = "Well"
            };

            var json = JsonSerializer.Serialize(appointmentData, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            var content = new StringContent(json, Encoding.UTF8, "application/json");

            // Act
            var response = await _httpClient.PostAsync($"{_baseUrl}/api/patients/appointment", content);

            // Assert
            Assert.True(response.IsSuccessStatusCode, 
                $"Expected successful response but got {response.StatusCode}: {await response.Content.ReadAsStringAsync()}");

            var responseContent = await response.Content.ReadAsStringAsync();
            
            // Verify response is valid JSON
            var responseJson = JsonSerializer.Deserialize<JsonElement>(responseContent);
            Assert.True(responseJson.ValueKind == JsonValueKind.Object, 
                "Response should be a valid JSON object");

            // Verify response contains expected fields
            var hasExpectedFields = responseJson.TryGetProperty("appointmentId", out _) ||
                                  responseJson.TryGetProperty("appointment_id", out _) ||
                                  responseJson.TryGetProperty("id", out _) ||
                                  responseJson.TryGetProperty("appointment", out _) ||
                                  responseJson.TryGetProperty("patient", out _) ||
                                  responseJson.TryGetProperty("success", out _);

            Assert.True(hasExpectedFields, 
                $"Response should contain expected fields. Response: {responseContent}");

            Console.WriteLine($"Response format validated successfully");
            Console.WriteLine($"Response: {responseContent}");
        }

        public void Dispose()
        {
            _httpClient?.Dispose();
        }
    }
}
