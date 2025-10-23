using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Xunit;

namespace VaxCareApiTests.Services
{
    public abstract class BaseTestClass : IDisposable
    {
        protected readonly ILogger Logger;
        protected readonly TestResultCollector ResultCollector;
        protected readonly TestReportService ReportService;
        protected readonly Stopwatch TestStopwatch;
        protected readonly string TestName;
        protected readonly string ClassName;

        protected BaseTestClass()
        {
            // Get test name from the calling method
            var stackTrace = new StackTrace();
            var callingMethod = stackTrace.GetFrame(1).GetMethod();
            TestName = callingMethod.Name;
            ClassName = GetType().Name;

            // Setup logging
            var loggerFactory = LoggerFactory.Create(builder => builder.AddConsole());
            Logger = loggerFactory.CreateLogger(GetType());

            // Setup test reporting
            ReportService = new TestReportService(loggerFactory.CreateLogger<TestReportService>());
            ResultCollector = new TestResultCollector(ReportService, loggerFactory.CreateLogger<TestResultCollector>());
            
            TestStopwatch = Stopwatch.StartNew();
            
            // Start test tracking
            ResultCollector.StartTest(TestName, ClassName);
        }

        protected virtual void OnTestCompleted(TestStatus status, string? errorMessage = null, string? stackTrace = null)
        {
            TestStopwatch.Stop();
            ResultCollector.EndTest(TestName, status, errorMessage, stackTrace);
        }

        protected virtual async Task OnTestCompletedAsync(TestStatus status, string? errorMessage = null, string? stackTrace = null)
        {
            TestStopwatch.Stop();
            ResultCollector.EndTest(TestName, status, errorMessage, stackTrace);
            
            // Generate reports after each test (optional - can be moved to end of test suite)
            await ResultCollector.GenerateReportsAsync();
        }

        public virtual void Dispose()
        {
            TestStopwatch?.Stop();
            ResultCollector?.Dispose();
        }
    }

    // Custom Fact attribute that integrates with our reporting system
    public class ReportingFactAttribute : FactAttribute
    {
        public ReportingFactAttribute()
        {
            DisplayName = "Custom Test with Reporting";
        }
    }

    // Custom Theory attribute that integrates with our reporting system
    public class ReportingTheoryAttribute : TheoryAttribute
    {
        public ReportingTheoryAttribute()
        {
            DisplayName = "Custom Theory Test with Reporting";
        }
    }
}
