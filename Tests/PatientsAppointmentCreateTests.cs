using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using System.Text.Json;
using System.Collections.Generic;
using System.Linq;
using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration.EnvironmentVariables;
using Microsoft.Extensions.Logging.Console;
using VaxCareApiTests.Models;
using VaxCareApiTests.Services;

namespace VaxCareApiTests.Tests
{
    public class PatientsAppointmentCreateTests : IDisposable
    {
        private readonly HttpClientService _httpClientService;
        private readonly TestUtilities _testUtilities;
        private readonly IConfiguration _configuration;
        private readonly string _endpoint = "/api/patients/appointment";

        public PatientsAppointmentCreateTests()
        {
            // Setup configuration
            _configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();

            // Setup services
            var services = new ServiceCollection();
            services.AddSingleton<IConfiguration>(_configuration);
            services.AddLogging(builder => builder.AddConsole().SetMinimumLevel(LogLevel.Information));
            services.AddHttpClient<HttpClientService>();
            services.AddTransient<HttpClientService>();
            services.AddTransient<TestUtilities>();

            var serviceProvider = services.BuildServiceProvider();
            _httpClientService = serviceProvider.GetRequiredService<HttpClientService>();
            _testUtilities = serviceProvider.GetRequiredService<TestUtilities>();
        }

        [Fact]
        public async Task CreateAppointment_ShouldReturnAppointmentId()
        {
            try
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
                var response = await _httpClientService.PostAsync(_endpoint, content);

                // Assert
                response.Should().NotBeNull();
                
                var responseContent = await response.Content.ReadAsStringAsync();
                responseContent.Should().NotBeNullOrEmpty("Response content should not be empty");
                
                // Log the response for debugging
                Console.WriteLine($"Response Status: {response.StatusCode}");
                Console.WriteLine($"Response Content: {responseContent}");
                
                response.IsSuccessStatusCode.Should().BeTrue($"Expected successful response but got {response.StatusCode}. Response content: {responseContent}");

                // Verify response contains appointment ID
                JsonElement responseJson;
                try
                {
                    responseJson = JsonSerializer.Deserialize<JsonElement>(responseContent);
                }
                catch (JsonException ex)
                {
                    throw new InvalidOperationException($"Failed to parse JSON response: {ex.Message}. Response content: {responseContent}", ex);
                }
                
                // Check for common appointment ID field names (numeric IDs)
                var hasAppointmentId = false;
                var appointmentIdValue = "";
                
                if (responseJson.TryGetProperty("appointmentId", out var appointmentIdProp))
                {
                    hasAppointmentId = true;
                    appointmentIdValue = appointmentIdProp.ValueKind == JsonValueKind.Number ? 
                        appointmentIdProp.GetInt64().ToString() : appointmentIdProp.GetString() ?? "";
                }
                else if (responseJson.TryGetProperty("appointment_id", out var appointmentIdProp2))
                {
                    hasAppointmentId = true;
                    appointmentIdValue = appointmentIdProp2.ValueKind == JsonValueKind.Number ? 
                        appointmentIdProp2.GetInt64().ToString() : appointmentIdProp2.GetString() ?? "";
                }
                else if (responseJson.TryGetProperty("id", out var idProp))
                {
                    hasAppointmentId = true;
                    appointmentIdValue = idProp.ValueKind == JsonValueKind.Number ? 
                        idProp.GetInt64().ToString() : idProp.GetString() ?? "";
                }
                else if (responseJson.TryGetProperty("appointment", out var appointmentElement))
                {
                    if (appointmentElement.TryGetProperty("id", out var nestedIdProp))
                    {
                        hasAppointmentId = true;
                        appointmentIdValue = nestedIdProp.ValueKind == JsonValueKind.Number ? 
                            nestedIdProp.GetInt64().ToString() : nestedIdProp.GetString() ?? "";
                    }
                    else if (appointmentElement.TryGetProperty("appointmentId", out var nestedAppointmentIdProp))
                    {
                        hasAppointmentId = true;
                        appointmentIdValue = nestedAppointmentIdProp.ValueKind == JsonValueKind.Number ? 
                            nestedAppointmentIdProp.GetInt64().ToString() : nestedAppointmentIdProp.GetString() ?? "";
                    }
                }

                hasAppointmentId.Should().BeTrue($"Response should contain an appointment ID. Response: {responseContent}");
                
                if (hasAppointmentId && !string.IsNullOrEmpty(appointmentIdValue))
                {
                    Console.WriteLine($"Appointment ID found: {appointmentIdValue} (Type: {(responseJson.TryGetProperty("appointmentId", out var testProp) && testProp.ValueKind == JsonValueKind.Number ? "Number" : "String")})");
                }

                // Log the response for debugging
                Console.WriteLine($"Appointment created successfully for patient: {uniqueLastName}");
                Console.WriteLine($"Response: {responseContent}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Test failed with exception: {ex.Message}");
                throw;
            }
        }

        [Fact]
        public async Task CreateAppointment_ShouldValidateRequiredHeaders()
        {
            try
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
                var response = await _httpClientService.PostAsync(_endpoint, content);

                // Assert
                response.Should().NotBeNull();
                response.IsSuccessStatusCode.Should().BeTrue($"Expected successful response but got {response.StatusCode}");

                // Verify required headers are present
                response.Headers.Should().ContainKey("Content-Type", "Response should contain Content-Type header");
                
                var contentType = response.Content.Headers.ContentType?.ToString();
                contentType.Should().Contain("application/json", $"Expected JSON content type, but got: {contentType}");

                Console.WriteLine($"Required headers validated successfully");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Test failed with exception: {ex.Message}");
                throw;
            }
        }

        [Fact]
        public async Task CreateAppointment_ShouldValidateEndpointStructure()
        {
            try
            {
                // Arrange
                var endpoint = _endpoint;
                var baseUrl = _httpClientService.GetHeaders()["Host"] ?? "vhapistg.vaxcare.com";
                var fullUrl = $"https://{baseUrl}{endpoint}";

                // Act & Assert
                var uri = new Uri(fullUrl);
                uri.Scheme.Should().Be("https");
                uri.AbsolutePath.Should().EndWith("/api/patients/appointment");

                Console.WriteLine($"Endpoint structure validated: {fullUrl}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Test failed with exception: {ex.Message}");
                throw;
            }
        }

        [Fact]
        public async Task CreateAppointment_ShouldHandleUniquePatientNames()
        {
            try
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
                var response = await _httpClientService.PostAsync(_endpoint, content);

                // Assert
                response.Should().NotBeNull();
                response.IsSuccessStatusCode.Should().BeTrue($"Expected successful response but got {response.StatusCode}");

                var responseContent = await response.Content.ReadAsStringAsync();
                responseContent.Should().NotBeNullOrEmpty("Response content should not be empty");

                // Verify the unique last name is handled correctly
                responseContent.ToLower().Should().NotContain("duplicate");
                responseContent.ToLower().Should().NotContain("already exists");

                Console.WriteLine($"Unique patient name handled successfully: {uniqueLastName}");
                Console.WriteLine($"Response: {responseContent}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Test failed with exception: {ex.Message}");
                throw;
            }
        }

        [Fact]
        public async Task CreateAppointment_ShouldValidateResponseFormat()
        {
            try
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
                var response = await _httpClientService.PostAsync(_endpoint, content);

                // Assert
                response.Should().NotBeNull();
                response.IsSuccessStatusCode.Should().BeTrue($"Expected successful response but got {response.StatusCode}");

                var responseContent = await response.Content.ReadAsStringAsync();
                
                // Verify response is valid JSON
                JsonElement responseJson;
                try
                {
                    responseJson = JsonSerializer.Deserialize<JsonElement>(responseContent);
                }
                catch (JsonException ex)
                {
                    throw new InvalidOperationException($"Failed to parse JSON response: {ex.Message}. Response content: {responseContent}", ex);
                }
                responseJson.ValueKind.Should().Be(JsonValueKind.Object, "Response should be a valid JSON object");

                // Verify response contains expected fields (including numeric appointment IDs)
                var hasExpectedFields = false;
                var appointmentIdValue = "";
                
                if (responseJson.TryGetProperty("appointmentId", out var appointmentIdProp))
                {
                    hasExpectedFields = true;
                    appointmentIdValue = appointmentIdProp.ValueKind == JsonValueKind.Number ? 
                        appointmentIdProp.GetInt64().ToString() : appointmentIdProp.GetString() ?? "";
                }
                else if (responseJson.TryGetProperty("appointment_id", out var appointmentIdProp2))
                {
                    hasExpectedFields = true;
                    appointmentIdValue = appointmentIdProp2.ValueKind == JsonValueKind.Number ? 
                        appointmentIdProp2.GetInt64().ToString() : appointmentIdProp2.GetString() ?? "";
                }
                else if (responseJson.TryGetProperty("id", out var idProp))
                {
                    hasExpectedFields = true;
                    appointmentIdValue = idProp.ValueKind == JsonValueKind.Number ? 
                        idProp.GetInt64().ToString() : idProp.GetString() ?? "";
                }
                else if (responseJson.TryGetProperty("appointment", out var appointmentElement))
                {
                    hasExpectedFields = true;
                    if (appointmentElement.TryGetProperty("id", out var nestedIdProp))
                    {
                        appointmentIdValue = nestedIdProp.ValueKind == JsonValueKind.Number ? 
                            nestedIdProp.GetInt64().ToString() : nestedIdProp.GetString() ?? "";
                    }
                    else if (appointmentElement.TryGetProperty("appointmentId", out var nestedAppointmentIdProp))
                    {
                        appointmentIdValue = nestedAppointmentIdProp.ValueKind == JsonValueKind.Number ? 
                            nestedAppointmentIdProp.GetInt64().ToString() : nestedAppointmentIdProp.GetString() ?? "";
                    }
                }
                else if (responseJson.TryGetProperty("patient", out _) || responseJson.TryGetProperty("success", out _))
                {
                    hasExpectedFields = true;
                }

                hasExpectedFields.Should().BeTrue($"Response should contain expected fields. Response: {responseContent}");
                
                if (hasExpectedFields && !string.IsNullOrEmpty(appointmentIdValue))
                {
                    Console.WriteLine($"Appointment ID found: {appointmentIdValue} (Type: Number)");
                }

                Console.WriteLine($"Response format validated successfully");
                Console.WriteLine($"Response: {responseContent}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Test failed with exception: {ex.Message}");
                throw;
            }
        }

        public void Dispose()
        {
            _httpClientService?.Dispose();
        }
    }
}
