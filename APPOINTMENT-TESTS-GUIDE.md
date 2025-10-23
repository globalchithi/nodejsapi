# 📅 Appointment Tests Guide - POST /api/patients/appointment

## 🎉 **New Appointment Tests Created!**

I've created comprehensive tests for the POST /api/patients/appointment endpoint with unique last names and appointment ID validation.

## 🚀 **What's Been Added:**

### **1. Appointment Test Class**
**File:** `Tests/PatientsAppointmentCreateTests.cs`

**Features:**
- ✅ **Unique last names** - Uses timestamp-based unique names
- ✅ **Appointment ID validation** - Verifies response contains appointment ID
- ✅ **Required headers validation** - Checks for proper headers
- ✅ **Endpoint structure validation** - Validates URL structure
- ✅ **Response format validation** - Ensures proper JSON response
- ✅ **Unique patient handling** - Tests unique patient name handling

### **2. Test Categories Updated**
**File:** `run-all-tests.py` (Updated)

**New Features:**
- ✅ **Appointment category** - `--category appointment`
- ✅ **Test filtering** - Run only appointment tests
- ✅ **Teams integration** - Send appointment test results to Teams

## 🧪 **Test Methods Created:**

### **1. CreateAppointment_ShouldReturnAppointmentId**
- **Purpose:** Tests appointment creation with unique last name
- **Validates:** Response contains appointment ID
- **Unique Name:** `Patient{DateTime.Now:yyyyMMddHHmmss}`

### **2. CreateAppointment_ShouldValidateRequiredHeaders**
- **Purpose:** Validates required HTTP headers
- **Validates:** Content-Type, response headers
- **Checks:** JSON content type

### **3. CreateAppointment_ShouldValidateEndpointStructure**
- **Purpose:** Validates endpoint URL structure
- **Validates:** HTTPS scheme, correct path
- **Checks:** URL format and structure

### **4. CreateAppointment_ShouldHandleUniquePatientNames**
- **Purpose:** Tests unique patient name handling
- **Validates:** No duplicate errors
- **Unique Name:** `Patient{DateTime.Now:yyyyMMddHHmmss}{Random(1000-9999)}`

### **5. CreateAppointment_ShouldValidateResponseFormat**
- **Purpose:** Validates response JSON format
- **Validates:** JSON structure, expected fields
- **Checks:** Valid JSON object

## 🎯 **Usage Examples:**

### **Run Appointment Tests:**
```bash
# Run all appointment tests
python3 run-all-tests.py --category appointment

# Run appointment tests with Teams notification
python3 run-all-tests.py --category appointment --teams

# Run appointment tests with custom environment
python3 run-all-tests.py --category appointment --teams --environment "Production"
```

### **Run Specific Appointment Tests:**
```bash
# Run only appointment ID validation test
python3 run-all-tests.py --filter "FullyQualifiedName~PatientsAppointmentCreateTests.CreateAppointment_ShouldReturnAppointmentId"

# Run only header validation test
python3 run-all-tests.py --filter "FullyQualifiedName~PatientsAppointmentCreateTests.CreateAppointment_ShouldValidateRequiredHeaders"
```

### **List All Test Categories:**
```bash
# List all available test categories
python3 run-all-tests.py --list-categories
```

## 📊 **Test Data Structure:**

### **Appointment Request Payload:**
```json
{
  "newPatient": {
    "firstName": "Test",
    "lastName": "Patient{unique_timestamp}",
    "dob": "1990-07-07 00:00:00.000",
    "gender": 0,
    "phoneNumber": "5555555555",
    "paymentInformation": {
      "primaryInsuranceId": 12,
      "paymentMode": "InsurancePay",
      "primaryMemberId": "",
      "primaryGroupId": "",
      "relationshipToInsured": "Self",
      "insuranceName": "Cigna",
      "mbi": "",
      "stock": "Private"
    },
    "SSN": ""
  },
  "clinicId": 10808,
  "date": "2025-10-16T20:00:00Z",
  "providerId": 100001877,
  "initialPaymentMode": "InsurancePay",
  "visitType": "Well"
}
```

### **Unique Last Name Generation:**
- **Format:** `Patient{DateTime.Now:yyyyMMddHHmmss}`
- **Example:** `Patient20251023143045`
- **Additional Random:** `Patient20251023143045{Random(1000-9999)}`

## 🔍 **Validation Checks:**

### **Appointment ID Validation:**
- ✅ **appointmentId** - Primary appointment ID field
- ✅ **appointment_id** - Alternative appointment ID field
- ✅ **id** - Generic ID field
- ✅ **appointment.id** - Nested appointment ID
- ✅ **appointment.appointmentId** - Nested appointment ID

### **Response Format Validation:**
- ✅ **Valid JSON** - Response is valid JSON
- ✅ **Object structure** - Response is JSON object
- ✅ **Expected fields** - Contains appointment/patient fields
- ✅ **No errors** - No error messages in response

### **Header Validation:**
- ✅ **Content-Type** - application/json
- ✅ **Response headers** - Proper HTTP headers
- ✅ **Status code** - 200 OK or success status

## 🎉 **Benefits:**

### **For Testing:**
- ✅ **Unique patients** - No duplicate patient conflicts
- ✅ **Appointment validation** - Ensures appointment creation works
- ✅ **Response validation** - Verifies proper response format
- ✅ **Header validation** - Checks required headers
- ✅ **Endpoint validation** - Validates URL structure

### **For Development:**
- ✅ **Automated testing** - No manual test data creation
- ✅ **Unique data** - Each test run uses unique data
- ✅ **Comprehensive coverage** - Tests all aspects of appointment creation
- ✅ **Easy debugging** - Clear test names and descriptions

### **For Teams:**
- ✅ **Test results** - Beautiful Teams notifications
- ✅ **HTML reports** - Detailed test reports
- ✅ **Download links** - Easy access to test results
- ✅ **Real-time updates** - Immediate test result notifications

## 🚀 **Quick Start:**

### **Test Appointment Creation:**
```bash
# Run all appointment tests
python3 run-all-tests.py --category appointment

# Run with Teams notification
python3 run-all-tests.py --category appointment --teams

# Run with custom environment
python3 run-all-tests.py --category appointment --teams --environment "Staging"
```

### **Test Specific Functionality:**
```bash
# Test appointment ID validation
python3 run-all-tests.py --filter "CreateAppointment_ShouldReturnAppointmentId"

# Test header validation
python3 run-all-tests.py --filter "CreateAppointment_ShouldValidateRequiredHeaders"

# Test unique patient handling
python3 run-all-tests.py --filter "CreateAppointment_ShouldHandleUniquePatientNames"
```

## 🔧 **Configuration:**

### **Environment Variables:**
```bash
# Set API base URL
export API_BASE_URL="https://api.vaxcare.com"

# Set test environment
export TEST_ENVIRONMENT="Development"
```

### **Test Data Customization:**
- **Clinic ID:** 10808 (configurable)
- **Provider ID:** 100001877 (configurable)
- **Insurance ID:** 12 (configurable)
- **Visit Type:** "Well" (configurable)

## 🎯 **Success Indicators:**

### **When Tests Pass:**
- ✅ "Appointment created successfully for patient: Patient{timestamp}"
- ✅ "Response contains appointment ID"
- ✅ "Required headers validated successfully"
- ✅ "Endpoint structure validated"
- ✅ "Unique patient name handled successfully"
- ✅ "Response format validated successfully"

### **Test Output Example:**
```
✅ CreateAppointment_ShouldReturnAppointmentId
✅ CreateAppointment_ShouldValidateRequiredHeaders
✅ CreateAppointment_ShouldValidateEndpointStructure
✅ CreateAppointment_ShouldHandleUniquePatientNames
✅ CreateAppointment_ShouldValidateResponseFormat
```

## 🎉 **Summary:**

### **What's Created:**
- 🎉 **Complete appointment tests** - All aspects of appointment creation
- 📅 **Unique patient names** - No duplicate conflicts
- 🆔 **Appointment ID validation** - Ensures proper response
- 📊 **Comprehensive coverage** - Headers, format, structure, uniqueness
- 🚀 **Teams integration** - Beautiful test result notifications

### **Result:**
Your appointment creation endpoint is now fully tested with unique patient names and appointment ID validation! 🚀

The tests ensure that appointments are created successfully with unique patient data and proper response validation! 📅
