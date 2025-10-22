using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using VaxCareApiTests.Models;

namespace VaxCareApiTests.Services;

public class HttpClientService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<HttpClientService> _logger;
    private readonly ApiConfiguration _apiConfig;
    private readonly HeadersConfiguration _headersConfig;

    public HttpClientService(HttpClient httpClient, IConfiguration configuration, ILogger<HttpClientService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        
        _apiConfig = configuration.GetSection("ApiConfiguration").Get<ApiConfiguration>() ?? new ApiConfiguration();
        _headersConfig = configuration.GetSection("Headers").Get<HeadersConfiguration>() ?? new HeadersConfiguration();
        
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
            ServicePointManager.ServerCertificateValidationCallback = 
                (sender, certificate, chain, sslPolicyErrors) => true;
        }
        
        // Add default headers
        AddDefaultHeaders();
    }

    private void AddDefaultHeaders()
    {
        _httpClient.DefaultRequestHeaders.Clear();
        
        _httpClient.DefaultRequestHeaders.Add("IsCalledByJob", _headersConfig.IsCalledByJob);
        _httpClient.DefaultRequestHeaders.Add("X-VaxHub-Identifier", _headersConfig.XVaxHubIdentifier);
        _httpClient.DefaultRequestHeaders.Add("traceparent", _headersConfig.Traceparent);
        _httpClient.DefaultRequestHeaders.Add("MobileData", _headersConfig.MobileData);
        _httpClient.DefaultRequestHeaders.Add("UserSessionId", _headersConfig.UserSessionId);
        _httpClient.DefaultRequestHeaders.Add("MessageSource", _headersConfig.MessageSource);
        _httpClient.DefaultRequestHeaders.Add("Host", _headersConfig.Host);
        _httpClient.DefaultRequestHeaders.Add("Connection", _headersConfig.Connection);
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
}
