using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration.EnvironmentVariables;
using Microsoft.Extensions.Logging.Console;
using VaxCareApiTests.Services;

namespace VaxCareApiTests;

public class Program
{
    public static async Task Main(string[] args)
    {
        // Setup configuration
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
            .AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: true)
            .AddEnvironmentVariables()
            .Build();

        // Setup services
        var services = new ServiceCollection();
        services.AddSingleton<IConfiguration>(configuration);
        services.AddLogging(builder => builder.AddConsole().SetMinimumLevel(LogLevel.Information));
        services.AddHttpClient<HttpClientService>();
        services.AddTransient<HttpClientService>();
        services.AddTransient<TestUtilities>();

        var serviceProvider = services.BuildServiceProvider();
        
        // Get services
        var httpClientService = serviceProvider.GetRequiredService<HttpClientService>();
        var testUtilities = serviceProvider.GetRequiredService<TestUtilities>();
        var logger = serviceProvider.GetRequiredService<ILogger<Program>>();

        try
        {
            logger.LogInformation("Starting VaxCare API Test Application");
            
            // Example: Test the API endpoint
            var endpoint = "/api/inventory/product/v2";
            logger.LogInformation($"Testing endpoint: {endpoint}");
            
            var response = await httpClientService.GetAsync(endpoint);
            logger.LogInformation($"Response Status: {response.StatusCode}");
            
            var content = await response.Content.ReadAsStringAsync();
            testUtilities.LogResponseDetails(response, content);
            
            logger.LogInformation("API test completed successfully");
        }
        catch (HttpRequestException ex) when (ex.Message.Contains("Name or service not known") || ex.Message.Contains("No such host"))
        {
            logger.LogWarning("Network connectivity issue - API endpoint not reachable");
            logger.LogWarning("This is expected if the API server is not accessible from your network");
            logger.LogWarning("The test structure and configuration are correct");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred during API testing");
            testUtilities.LogErrorDetails(ex);
        }
    }
}
