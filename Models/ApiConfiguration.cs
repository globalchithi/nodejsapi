using System.Text.Json.Serialization;

namespace VaxCareApiTests.Models;

public class ApiConfiguration
{
    [JsonPropertyName("BaseUrl")]
    public string BaseUrl { get; set; } = string.Empty;
    
    [JsonPropertyName("Timeout")]
    public int Timeout { get; set; } = 30000;
    
    [JsonPropertyName("InsecureHttps")]
    public bool InsecureHttps { get; set; } = true;
}

public class TestConfiguration
{
    [JsonPropertyName("Environment")]
    public string Environment { get; set; } = "Development";
    
    [JsonPropertyName("LogLevel")]
    public string LogLevel { get; set; } = "Information";
}

public class HeadersConfiguration
{
    [JsonPropertyName("IsCalledByJob")]
    public string IsCalledByJob { get; set; } = string.Empty;
    
    [JsonPropertyName("X-VaxHub-Identifier")]
    public string XVaxHubIdentifier { get; set; } = string.Empty;
    
    [JsonPropertyName("traceparent")]
    public string Traceparent { get; set; } = string.Empty;
    
    [JsonPropertyName("MobileData")]
    public string MobileData { get; set; } = string.Empty;
    
    [JsonPropertyName("UserSessionId")]
    public string UserSessionId { get; set; } = string.Empty;
    
    [JsonPropertyName("MessageSource")]
    public string MessageSource { get; set; } = string.Empty;
    
    [JsonPropertyName("Host")]
    public string Host { get; set; } = string.Empty;
    
    [JsonPropertyName("Connection")]
    public string Connection { get; set; } = string.Empty;
    
    [JsonPropertyName("User-Agent")]
    public string UserAgent { get; set; } = string.Empty;
}

public class AppSettings
{
    public ApiConfiguration ApiConfiguration { get; set; } = new();
    public TestConfiguration TestConfiguration { get; set; } = new();
    public HeadersConfiguration Headers { get; set; } = new();
}
