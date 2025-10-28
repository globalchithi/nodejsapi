# 📋 VaxCare API Test Suite - Complete Test Catalog

This document provides a comprehensive catalog of all test classes and test methods in the VaxCare API test suite, organized by functionality and what each test verifies.

## 📊 Test Suite Overview

- **Total Test Classes:** 12
- **Total Test Methods:** 38+
- **Test Categories:** Inventory, Patients, Setup, Retry Logic
- **Test Types:** Integration Tests, Unit Tests, Validation Tests

---

## 🏥 **PATIENTS API TESTS**

### **PatientsAppointmentCheckoutTests**
**Endpoint:** `PUT /api/patients/appointment/{appointmentId}/checkout`  
**Purpose:** Tests appointment checkout functionality for various patient types and scenarios

| Test Method | What It Verifies |
|-------------|------------------|
| `CheckoutAppointment_Success_SingleVaccine` | ✅ Successful checkout of single vaccine appointment with insurance payment |
| `CheckoutAppointment_Success_MultipleVaccines` | ✅ Successful checkout of multiple vaccines in one appointment |
| `CheckoutAppointment_Success_SelfPayPatient` | ✅ Successful checkout for self-pay patients with credit card information |
| `CheckoutAppointment_Success_VFCPatient` | ✅ Successful checkout for VFC (Vaccines for Children) patients |
| `CheckoutAppointment_Success_DifferentDoseSeries` | ✅ Successful checkout with different dose series (1st and 2nd doses) |
| `CheckoutAppointment_Success_EmptyVaccineList` | ✅ Checkout behavior with empty vaccine list |
| `CheckoutAppointment_ShouldValidateRequiredFields` | ✅ Field validation for required checkout data |
| `CheckoutAppointment_ShouldHandleInvalidAppointmentId` | ✅ Error handling for invalid appointment IDs |
| `CheckoutAppointment_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |

**Key Features Tested:**
- Multiple payment modes (Insurance, SelfPay, VFC/NoPay)
- Single and multiple vaccine administration
- Different dose series handling
- Credit card processing for self-pay
- Field validation and error handling
- Network connectivity requirements for PUT operations

---

### **PatientsAppointmentCreateTests**
**Endpoint:** `POST /api/patients/appointment`  
**Purpose:** Tests appointment creation functionality

| Test Method | What It Verifies |
|-------------|------------------|
| `CreateAppointment_ShouldReturnAppointmentId` | ✅ Successful appointment creation returns valid appointment ID |
| `CreateAppointment_ShouldHandleUniquePatientNames` | ✅ System handles unique patient names without conflicts |
| `CreateAppointment_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |

**Key Features Tested:**
- New patient creation with insurance information
- Appointment ID generation and validation
- Unique patient name handling
- JSON response parsing and validation
- Network connectivity requirements for POST operations

---

### **PatientsAppointmentSyncTests**
**Endpoint:** `GET /api/patients/appointment/sync`  
**Purpose:** Tests appointment synchronization functionality

| Test Method | What It Verifies |
|-------------|------------------|
| `GetPatientsAppointmentSync_ShouldReturnAppointmentData` | ✅ API returns valid appointment synchronization data |
| `GetPatientsAppointmentSync_ShouldValidateQueryParameters` | ✅ Query parameter validation (clinicId, date, version) |
| `GetPatientsAppointmentSync_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetPatientsAppointmentSync_ShouldValidateDateFormats` | ✅ Date format validation (YYYY-MM-DD) |
| `GetPatientsAppointmentSync_ShouldValidateVersionFormats` | ✅ Version format validation (X.Y) |
| `GetPatientsAppointmentSync_ShouldValidateClinicIdFormats` | ✅ Clinic ID format validation (numeric) |
| `GetPatientsAppointmentSync_ShouldDemonstrateResponseLogging` | ✅ Response logging demonstration |

**Key Features Tested:**
- Query parameter validation (clinicId=89534, date=2025-10-22, version=2.0)
- Date format validation (YYYY-MM-DD)
- Version format validation (X.Y pattern)
- Clinic ID numeric validation
- Response logging capabilities

---

### **PatientsClinicTests**
**Endpoint:** `GET /api/patients/clinic`  
**Purpose:** Tests clinic data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetPatientsClinic_ShouldReturnClinicData` | ✅ API returns valid clinic data |
| `GetPatientsClinic_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetPatientsClinic_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- Clinic data retrieval
- JSON response validation
- HTTP header validation

---

### **PatientsInsuranceByStateTests**
**Endpoint:** `GET /api/patients/insurance/bystate/FL`  
**Purpose:** Tests insurance data retrieval by state

| Test Method | What It Verifies |
|-------------|------------------|
| `GetPatientsInsuranceByState_ShouldReturnInsuranceData` | ✅ API returns valid insurance data for Florida |
| `GetPatientsInsuranceByState_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetPatientsInsuranceByState_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- State-specific insurance data retrieval
- Query parameter validation (contractedOnly=false)
- HTTP header validation

---

### **PatientsStafferProvidersTests**
**Endpoint:** `GET /api/patients/staffer/providers`  
**Purpose:** Tests provider data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetPatientsStafferProviders_ShouldReturnProvidersData` | ✅ API returns valid provider data |
| `GetPatientsStafferProviders_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetPatientsStafferProviders_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- Provider data retrieval
- HTTP header validation

---

### **PatientsStafferShotAdministratorsTests**
**Endpoint:** `GET /api/patients/staffer/shotadministrators`  
**Purpose:** Tests shot administrator data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetPatientsStafferShotAdministrators_ShouldReturnShotAdministratorsData` | ✅ API returns valid shot administrator data |
| `GetPatientsStafferShotAdministrators_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetPatientsStafferShotAdministrators_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- Shot administrator data retrieval
- HTTP header validation

---

## 📦 **INVENTORY API TESTS**

### **InventoryApiTests**
**Endpoint:** `GET /api/inventory/product/v2`  
**Purpose:** Tests inventory product data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetInventoryProducts_ShouldReturnInventoryProducts` | ✅ API returns valid inventory product data |
| `GetInventoryProducts_ShouldHandleAuthenticationHeaders` | ✅ JWT token authentication header validation |
| `GetInventoryProducts_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |
| `GetInventoryProducts_ShouldValidateCurlCommandStructure` | ✅ Complete curl command structure validation |

**Key Features Tested:**
- Inventory product data retrieval
- JWT token validation and decoding
- VaxHub identifier validation
- Complete HTTP header validation
- Curl command structure validation

---

### **InventoryApiTestsWithReporting**
**Endpoint:** `GET /api/inventory/product/v2`  
**Purpose:** Tests inventory product data with enhanced reporting

| Test Method | What It Verifies |
|-------------|------------------|
| `GetInventoryProducts_ShouldReturnInventoryProducts` | ✅ API returns valid inventory product data with reporting |
| `GetInventoryProducts_ShouldHandleAuthenticationHeaders` | ✅ JWT token authentication with reporting |
| `GetInventoryProducts_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation with reporting |
| `GetInventoryProducts_ShouldValidateCurlCommandStructure` | ✅ Complete curl command structure validation with reporting |

**Key Features Tested:**
- Same as InventoryApiTests but with enhanced reporting capabilities
- Test status tracking (Passed, Failed, Skipped)
- Enhanced error reporting and logging

---

### **InventoryLotInventoryTests**
**Endpoint:** `GET /api/inventory/LotInventory/SimpleOnHand`  
**Purpose:** Tests lot inventory data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetInventoryLotInventory_ShouldReturnLotInventoryData` | ✅ API returns valid lot inventory data |
| `GetInventoryLotInventory_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetInventoryLotInventory_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- Lot inventory data retrieval
- HTTP header validation

---

### **InventoryLotNumbersTests**
**Endpoint:** `GET /api/inventory/lotnumbers`  
**Purpose:** Tests lot numbers data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetInventoryLotNumbers_ShouldReturnLotNumbersData` | ✅ API returns valid lot numbers data |
| `GetInventoryLotNumbers_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetInventoryLotNumbers_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- Lot numbers data retrieval with query parameters
- Query parameter validation (maximumExpirationAgeInDays=365)
- HTTP header validation

---

## ⚙️ **SETUP API TESTS**

### **SetupCheckDataTests**
**Endpoint:** `GET /api/setup/checkData`  
**Purpose:** Tests setup data validation

| Test Method | What It Verifies |
|-------------|------------------|
| `GetSetupCheckData_ShouldReturnCheckData` | ✅ API returns valid setup check data |
| `GetSetupCheckData_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetSetupCheckData_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- Setup data validation
- Query parameter validation (partnerId=178764, clinicId=89534)
- HTTP header validation

---

### **SetupLocationDataTests**
**Endpoint:** `GET /api/setup/LocationData`  
**Purpose:** Tests location data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetSetupLocationData_ShouldReturnLocationData` | ✅ API returns valid location data |
| `GetSetupLocationData_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetSetupLocationData_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- Location data retrieval
- Query parameter validation (clinicId=89534)
- HTTP header validation

---

### **SetupUsersPartnerLevelTests**
**Endpoint:** `GET /api/setup/usersPartnerLevel`  
**Purpose:** Tests user partner level data retrieval

| Test Method | What It Verifies |
|-------------|------------------|
| `GetSetupUsersPartnerLevel_ShouldReturnUsersPartnerLevelData` | ✅ API returns valid user partner level data |
| `GetSetupUsersPartnerLevel_ShouldValidateEndpointStructure` | ✅ Endpoint URL structure validation |
| `GetSetupUsersPartnerLevel_ShouldValidateRequiredHeaders` | ✅ Required HTTP headers validation |

**Key Features Tested:**
- User partner level data retrieval
- Query parameter validation (partnerId=178764)
- HTTP header validation

---

## 🔄 **RETRY LOGIC TESTS**

### **RetryLogicTests**
**Purpose:** Tests retry mechanism and configuration

| Test Method | What It Verifies |
|-------------|------------------|
| `GetInventoryProducts_WithRetryLogic_ShouldHandleTransientFailures` | ✅ Retry logic handles transient failures for GET requests |
| `PostAppointment_WithRetryLogic_ShouldHandleTransientFailures` | ✅ Retry logic handles transient failures for POST requests |
| `RetryConfiguration_ShouldBeLoadedCorrectly` | ✅ Retry configuration is loaded from appsettings |
| `TimeoutConfiguration_ShouldBeIncreased` | ✅ Timeout configuration is properly set (60+ seconds) |

**Key Features Tested:**
- Retry mechanism for transient failures
- Configuration loading (MaxRetryAttempts, RetryDelayMs, ExponentialBackoff)
- Timeout configuration validation
- Both GET and POST request retry handling

---

## 🎯 **COMMON TEST PATTERNS**

### **HTTP Header Validation**
All API tests validate these required headers:
- `IsCalledByJob`
- `X-VaxHub-Identifier` (JWT token)
- `traceparent`
- `MobileData`
- `UserSessionId`
- `MessageSource`
- `User-Agent`

### **Endpoint Structure Validation**
All tests validate:
- Correct URL structure
- Query parameter formatting
- HTTPS scheme validation
- Path parameter validation

### **Response Validation**
All tests validate:
- Non-null response
- Success status codes (200 OK)
- JSON content type
- Valid JSON structure
- Non-empty response content

### **Error Handling**
All tests handle:
- Network connectivity issues
- Request timeouts
- JSON parsing errors
- Invalid operation exceptions

---

## 🚀 **How to Run Tests by Category**

### **Run All Checkout Tests**
```bash
python3 run-all-tests.py --filter "ClassName=PatientsAppointmentCheckoutTests"
```

### **Run All Inventory Tests**
```bash
python3 run-all-tests.py --filter "ClassName~Inventory"
```

### **Run All Patient Tests**
```bash
python3 run-all-tests.py --filter "ClassName~Patients"
```

### **Run All Setup Tests**
```bash
python3 run-all-tests.py --filter "ClassName~Setup"
```

### **Run Specific Test Method**
```bash
python3 run-all-tests.py --filter "FullyQualifiedName~CheckoutAppointment_Success_SingleVaccine"
```

---

## 📈 **Test Statistics**

- **Integration Tests:** 35+ (API endpoint testing)
- **Unit Tests:** 3+ (Configuration and validation)
- **Validation Tests:** 20+ (Data format and structure validation)
- **Error Handling Tests:** 12+ (Network and timeout handling)

---

## 🔧 **Test Configuration**

All tests use:
- **Environment:** Staging (configurable)
- **Base URL:** Environment-specific from appsettings
- **Timeout:** 60+ seconds
- **Retry Logic:** Configurable retry attempts
- **Headers:** VaxHub authentication headers

---

## 📝 **Notes**

1. **Network Connectivity:** Tests gracefully handle network unavailability
2. **PUT/POST Operations:** Require network connectivity and will fail if unavailable
3. **GET Operations:** Skip gracefully when network is unavailable
4. **Configuration:** All tests load environment-specific configuration
5. **Reporting:** Enhanced reporting available with `InventoryApiTestsWithReporting`

---

*This catalog is automatically generated and maintained as part of the VaxCare API test suite documentation.*
