namespace VaxCareApiTests.Models;

public class ApiConfiguration
{
    public string BaseUrl { get; set; } = string.Empty;
    public int Timeout { get; set; } = 30000;
    public bool InsecureHttps { get; set; } = true;
}

public class TestConfiguration
{
    public string Environment { get; set; } = "Development";
    public string LogLevel { get; set; } = "Information";
}

public class HeadersConfiguration
{
    public string IsCalledByJob { get; set; } = string.Empty;
    public string XVaxHubIdentifier { get; set; } = string.Empty;
    public string Traceparent { get; set; } = string.Empty;
    public string MobileData { get; set; } = string.Empty;
    public string UserSessionId { get; set; } = string.Empty;
    public string MessageSource { get; set; } = string.Empty;
    public string Host { get; set; } = string.Empty;
    public string Connection { get; set; } = string.Empty;
    public string UserAgent { get; set; } = string.Empty;
}

public class AppSettings
{
    public ApiConfiguration ApiConfiguration { get; set; } = new();
    public TestConfiguration TestConfiguration { get; set; } = new();
    public HeadersConfiguration Headers { get; set; } = new();
}
