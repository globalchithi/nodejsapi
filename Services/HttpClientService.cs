using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using VaxCareApiTests.Models;

namespace VaxCareApiTests.Services;

public class HttpClientService : IDisposable
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<HttpClientService> _logger;
    private readonly ApiConfiguration _apiConfig;
    private readonly HeadersConfiguration _headersConfig;

    public HttpClientService(HttpClient httpClient, IConfiguration configuration, ILogger<HttpClientService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        
        // Read configuration directly from IConfiguration
        _apiConfig = new ApiConfiguration
        {
            BaseUrl = configuration["ApiConfiguration:BaseUrl"] ?? "https://vhapistg.vaxcare.com",
            Timeout = int.Parse(configuration["ApiConfiguration:Timeout"] ?? "30000"),
            InsecureHttps = bool.Parse(configuration["ApiConfiguration:InsecureHttps"] ?? "true")
        };
        
        _headersConfig = new HeadersConfiguration
        {
            IsCalledByJob = configuration["Headers:IsCalledByJob"] ?? "",
            XVaxHubIdentifier = configuration["Headers:X-VaxHub-Identifier"] ?? "",
            Traceparent = configuration["Headers:traceparent"] ?? "",
            MobileData = configuration["Headers:MobileData"] ?? "",
            UserSessionId = configuration["Headers:UserSessionId"] ?? "",
            MessageSource = configuration["Headers:MessageSource"] ?? "",
            Host = configuration["Headers:Host"] ?? "",
            Connection = configuration["Headers:Connection"] ?? "",
            UserAgent = configuration["Headers:User-Agent"] ?? ""
        };
        
        // Debug: Log configuration values
        _logger.LogInformation($"BaseUrl: {_apiConfig.BaseUrl}");
        _logger.LogInformation($"IsCalledByJob: '{_headersConfig.IsCalledByJob}'");
        _logger.LogInformation($"XVaxHubIdentifier: '{_headersConfig.XVaxHubIdentifier}'");
        _logger.LogInformation($"UserAgent: '{_headersConfig.UserAgent}'");
        
        ConfigureHttpClient();
    }

    private void ConfigureHttpClient()
    {
        // Set base URL
        _httpClient.BaseAddress = new Uri(_apiConfig.BaseUrl);
        
        // Set timeout
        _httpClient.Timeout = TimeSpan.FromMilliseconds(_apiConfig.Timeout);
        
        // Configure insecure HTTPS if needed (equivalent to curl --insecure)
        if (_apiConfig.InsecureHttps)
        {
            // Note: In production, you should use proper certificate validation
            // This is only for testing purposes
            // For .NET 6.0, we'll handle this in the HttpClient configuration
        }
        
        // Add default headers
        AddDefaultHeaders();
    }

    private void AddDefaultHeaders()
    {
        _httpClient.DefaultRequestHeaders.Clear();
        
        // Only add headers with non-empty values
        if (!string.IsNullOrEmpty(_headersConfig.IsCalledByJob))
            _httpClient.DefaultRequestHeaders.Add("IsCalledByJob", _headersConfig.IsCalledByJob);
        
        if (!string.IsNullOrEmpty(_headersConfig.XVaxHubIdentifier))
            _httpClient.DefaultRequestHeaders.Add("X-VaxHub-Identifier", _headersConfig.XVaxHubIdentifier);
        
        if (!string.IsNullOrEmpty(_headersConfig.Traceparent))
            _httpClient.DefaultRequestHeaders.Add("traceparent", _headersConfig.Traceparent);
        
        if (!string.IsNullOrEmpty(_headersConfig.MobileData))
            _httpClient.DefaultRequestHeaders.Add("MobileData", _headersConfig.MobileData);
        
        if (!string.IsNullOrEmpty(_headersConfig.UserSessionId))
            _httpClient.DefaultRequestHeaders.Add("UserSessionId", _headersConfig.UserSessionId);
        
        if (!string.IsNullOrEmpty(_headersConfig.MessageSource))
            _httpClient.DefaultRequestHeaders.Add("MessageSource", _headersConfig.MessageSource);
        
        if (!string.IsNullOrEmpty(_headersConfig.Host))
            _httpClient.DefaultRequestHeaders.Add("Host", _headersConfig.Host);
        
        if (!string.IsNullOrEmpty(_headersConfig.Connection))
            _httpClient.DefaultRequestHeaders.Add("Connection", _headersConfig.Connection);
        
        if (!string.IsNullOrEmpty(_headersConfig.UserAgent))
            _httpClient.DefaultRequestHeaders.Add("User-Agent", _headersConfig.UserAgent);
    }

    public async Task<HttpResponseMessage> GetAsync(string endpoint)
    {
        try
        {
            _logger.LogInformation($"Making GET request to: {_httpClient.BaseAddress}{endpoint}");
            
            var response = await _httpClient.GetAsync(endpoint);
            
            _logger.LogInformation($"Response Status: {response.StatusCode}");
            _logger.LogInformation($"Response Headers: {string.Join(", ", response.Headers.Select(h => $"{h.Key}: {string.Join(", ", h.Value)}"))}");
            
            return response;
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "HTTP request failed");
            throw;
        }
        catch (TaskCanceledException ex)
        {
            _logger.LogError(ex, "Request timeout");
            throw;
        }
    }

    public Dictionary<string, string> GetHeaders()
    {
        return new Dictionary<string, string>
        {
            ["IsCalledByJob"] = _headersConfig.IsCalledByJob,
            ["X-VaxHub-Identifier"] = _headersConfig.XVaxHubIdentifier,
            ["traceparent"] = _headersConfig.Traceparent,
            ["MobileData"] = _headersConfig.MobileData,
            ["UserSessionId"] = _headersConfig.UserSessionId,
            ["MessageSource"] = _headersConfig.MessageSource,
            ["Host"] = _headersConfig.Host,
            ["Connection"] = _headersConfig.Connection,
            ["User-Agent"] = _headersConfig.UserAgent
        };
    }

    public void Dispose()
    {
        _httpClient?.Dispose();
    }
}
