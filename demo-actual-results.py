#!/usr/bin/env python3
"""
Demo script to show how actual results and failure reasons are displayed
"""

import os
from datetime import datetime

def create_demo_html_report():
    """Create a demo HTML report showing actual results and failure reasons"""
    
    # Demo data with some failed tests to show actual results
    demo_data = {
        'total_tests': 6,
        'passed_tests': 4,
        'failed_tests': 2,
        'skipped_tests': 0,
        'success_rate': 66.7,
        'test_details': [
            {
                'name': 'GetInventoryProducts ShouldReturnInventoryProducts',
                'full_name': 'VaxCareApiTests.Tests.InventoryApiTests.GetInventoryProducts_ShouldReturnInventoryProducts',
                'class': 'InventoryApiTests',
                'result': 'Passed',
                'duration_ms': 125.5,
                'status_icon': '&#10004;',
                'description': 'Tests retrieval of inventory products data',
                'test_type': 'Integration Test',
                'endpoint': 'GET /api/inventory/product/v2',
                'expected_result': '200 OK with inventory products data',
                'actual_result': '',
                'failure_reason': ''
            },
            {
                'name': 'CreateAppointment ShouldHandleUniquePatientNames',
                'full_name': 'VaxCareApiTests.Tests.PatientsAppointmentCreateTests.CreateAppointment_ShouldHandleUniquePatientNames',
                'class': 'PatientsAppointmentCreateTests',
                'result': 'Failed',
                'duration_ms': 496.2,
                'status_icon': '&#10008;',
                'description': 'Tests appointment creation with unique patient names to avoid conflicts',
                'test_type': 'Integration Test',
                'endpoint': 'POST /api/patients/appointment',
                'expected_result': '200 OK with unique patient appointment created',
                'actual_result': 'Network connectivity issue',
                'failure_reason': 'API endpoint not reachable - DNS resolution failed'
            },
            {
                'name': 'CheckoutAppointment ShouldValidateRequiredFields',
                'full_name': 'VaxCareApiTests.Tests.PatientsAppointmentCheckoutTests.CheckoutAppointment_ShouldValidateRequiredFields',
                'class': 'PatientsAppointmentCheckoutTests',
                'result': 'Passed',
                'duration_ms': 101.5,
                'status_icon': '&#10004;',
                'description': 'Validates that all required fields are present for checkout requests',
                'test_type': 'Unit Test',
                'endpoint': 'PUT /api/patients/appointment/{appointmentId}/checkout',
                'expected_result': 'Required fields validation completed',
                'actual_result': '',
                'failure_reason': ''
            },
            {
                'name': 'GetPatientsClinic ShouldReturnClinicData',
                'full_name': 'VaxCareApiTests.Tests.PatientsClinicTests.GetPatientsClinic_ShouldReturnClinicData',
                'class': 'PatientsClinicTests',
                'result': 'Failed',
                'duration_ms': 253.9,
                'status_icon': '&#10008;',
                'description': 'Tests retrieval of patients clinic data',
                'test_type': 'Integration Test',
                'endpoint': 'GET /api/patients/clinic',
                'expected_result': '200 OK with clinic data',
                'actual_result': 'Request timeout',
                'failure_reason': 'API endpoint timeout - server not responding'
            },
            {
                'name': 'GetSetupCheckData ShouldValidateRequiredHeaders',
                'full_name': 'VaxCareApiTests.Tests.SetupCheckDataTests.GetSetupCheckData_ShouldValidateRequiredHeaders',
                'class': 'SetupCheckDataTests',
                'result': 'Passed',
                'duration_ms': 1631.3,
                'status_icon': '&#10004;',
                'description': 'Validates that all required headers are present for setup check data requests',
                'test_type': 'Unit Test',
                'endpoint': 'GET /api/setup/checkData?partnerId=178764&clinicId=89534',
                'expected_result': 'All required headers validated',
                'actual_result': '',
                'failure_reason': ''
            },
            {
                'name': 'GetInventoryLotNumbers ShouldReturnLotNumbersData',
                'full_name': 'VaxCareApiTests.Tests.InventoryLotNumbersTests.GetInventoryLotNumbers_ShouldReturnLotNumbersData',
                'class': 'InventoryLotNumbersTests',
                'result': 'Passed',
                'duration_ms': 254.0,
                'status_icon': '&#10004;',
                'description': 'Tests retrieval of inventory lot numbers data',
                'test_type': 'Integration Test',
                'endpoint': 'GET /api/inventory/lotnumbers?maximumExpirationAgeInDays=365',
                'expected_result': '200 OK with lot numbers data',
                'actual_result': '',
                'failure_reason': ''
            }
        ]
    }
    
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VaxCare API Test Report - Demo with Actual Results</title>
    <style>
        body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }}
        .container {{ max-width: 1400px; margin: 0 auto; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 8px 8px 0 0; }}
        .header h1 {{ margin: 0; font-size: 2.5em; }}
        .header p {{ margin: 10px 0 0 0; opacity: 0.9; }}
        .content {{ padding: 30px; }}
        .stats {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }}
        .stat-card {{ background: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; border-left: 4px solid #28a745; }}
        .stat-card h3 {{ margin: 0 0 10px 0; color: #333; }}
        .stat-card .stat-number {{ font-size: 2em; font-weight: bold; color: #28a745; }}
        .stat-card .stat-label {{ color: #666; }}
        .passed .stat-number {{ color: #28a745; }}
        .failed .stat-number {{ color: #dc3545; }}
        .skipped .stat-number {{ color: #ffc107; }}
        .total .stat-number {{ color: #007bff; }}
        .success-rate .stat-number {{ color: #6f42c1; }}
        .test-table {{ width: 100%; border-collapse: collapse; margin: 20px 0; }}
        .test-table th, .test-table td {{ padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }}
        .test-table th {{ background: #007bff; color: white; font-weight: bold; }}
        .test-table tbody tr:hover {{ background-color: #f5f5f5; }}
        .status-passed {{ color: #28a745; font-weight: bold; }}
        .status-failed {{ color: #dc3545; font-weight: bold; background-color: #f8d7da; padding: 5px; border-radius: 3px; }}
        .status-skipped {{ color: #ffc107; font-weight: bold; }}
        .failed-test-row {{ background-color: #f8d7da; }}
        .actual-result {{ color: #dc3545; font-weight: bold; margin-top: 5px; }}
        .failure-reason {{ color: #dc3545; font-style: italic; margin-top: 3px; font-size: 0.9em; }}
        .duration {{ font-family: monospace; background: #f8f9fa; padding: 2px 6px; border-radius: 3px; }}
        .footer {{ text-align: center; margin-top: 30px; color: #666; }}
        .warning {{ background: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 10px; border-radius: 4px; margin: 10px 0; }}
        .test-info {{ margin-top: 10px; padding: 10px; background: #e9ecef; border-radius: 4px; font-size: 0.9em; }}
        .failure-info {{ margin-top: 10px; padding: 10px; background: #f8d7da; border: 1px solid #dc3545; border-radius: 4px; font-size: 0.9em; }}
        .demo-notice {{ background: #d1ecf1; border: 1px solid #bee5eb; color: #0c5460; padding: 15px; border-radius: 4px; margin: 20px 0; }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔬 VaxCare API Test Report - Demo</h1>
            <p>Generated: {timestamp}</p>
        </div>
        
        <div class="demo-notice">
            <h3>📋 Demo Report - Actual Results Feature</h3>
            <p>This is a demonstration of the enhanced HTML report showing <strong>Actual Results</strong> and <strong>Concise Failure Reasons</strong> for failed tests.</p>
            <p><strong>Key Features:</strong></p>
            <ul>
                <li>✅ <strong>Actual Result:</strong> Shows what actually happened during test execution</li>
                <li>🔍 <strong>Failure Reason:</strong> Provides concise explanation of why the test failed</li>
                <li>📊 <strong>Expected vs Actual:</strong> Clear comparison between expected and actual results</li>
                <li>🎯 <strong>Network Issues:</strong> Specific handling for connectivity problems</li>
            </ul>
        </div>
        
        <div class="stats">
            <div class="stat-card passed">
                <div class="stat-number">{demo_data['passed_tests']}</div>
                <div class="stat-label">✅ Passed</div>
            </div>
            <div class="stat-card failed">
                <div class="stat-number">{demo_data['failed_tests']}</div>
                <div class="stat-label">❌ Failed</div>
            </div>
            <div class="stat-card skipped">
                <div class="stat-number">{demo_data['skipped_tests']}</div>
                <div class="stat-label">⏭️ Skipped</div>
            </div>
            <div class="stat-card total">
                <div class="stat-number">{demo_data['total_tests']}</div>
                <div class="stat-label">📊 Total</div>
            </div>
            <div class="stat-card success-rate">
                <div class="stat-number">{demo_data['success_rate']}%</div>
                <div class="stat-label">🎯 Success Rate</div>
            </div>
        </div>
        
        <h2>📋 Test Results with Actual Results</h2>
        <table class="test-table">
            <thead>
                <tr>
                    <th>Status</th>
                    <th>Test Name</th>
                    <th>Class</th>
                    <th>Duration</th>
                </tr>
            </thead>
            <tbody>"""
    
    # Add test details to table
    for test in demo_data['test_details']:
        status_class = f"status-{test['result'].lower()}" if test['result'] in ['Passed', 'Failed', 'Skipped'] else 'status-unknown'
        row_class = "failed-test-row" if test['result'] == 'Failed' else ""
        
        # Add test information
        test_info_html = f"""
                <div class="test-info">
                    <div><strong>📋 Description:</strong> {test['description']}</div>
                    <div><strong>🎯 Test Type:</strong> {test['test_type']}</div>
                    <div><strong>🔗 Endpoint:</strong> {test['endpoint']}</div>
                    <div><strong>📊 Expected Result:</strong> {test['expected_result']}</div>
                </div>"""
        
        # Add failure information for failed tests
        failure_info_html = ""
        if test['result'] == 'Failed' and (test.get('actual_result') or test.get('failure_reason')):
            failure_info_html = f"""
                <div class="failure-info">
                    <div class='actual-result'><strong>❌ Actual Result:</strong> {test['actual_result']}</div>
                    <div class='failure-reason'><strong>🔍 Failure Reason:</strong> {test['failure_reason']}</div>
                </div>"""
        
        html_content += f"""
                <tr class="{row_class}">
                    <td class="{status_class}">{test['status_icon']} {test['result']}</td>
                    <td>
                        <div><strong>{test['name']}</strong></div>
                        {test_info_html}
                        {failure_info_html}
                    </td>
                    <td>{test['class']}</td>
                    <td><span class="duration">{test['duration_ms']}ms</span></td>
                </tr>"""
    
    html_content += f"""
            </tbody>
        </table>
        
        <div class="footer">
            <p>Demo Report generated by VaxCare API Test Suite | {timestamp}</p>
            <p><strong>Note:</strong> This is a demonstration showing how actual results and failure reasons are displayed in the enhanced HTML report.</p>
        </div>
    </div>
</body>
</html>"""
    
    # Write HTML content to file
    output_path = '/Users/asadzaman/Documents/GitHub/nodejsapi/TestReports/Demo_ActualResults_Report.html'
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(html_content)
        print(f"✅ Demo HTML report generated: {output_path}")
        return output_path
    except Exception as e:
        print(f"❌ Error writing demo HTML file: {e}")
        return None

if __name__ == "__main__":
    create_demo_html_report()
