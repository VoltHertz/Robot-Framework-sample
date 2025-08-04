# Authentication Test Suite - DummyJSON API

## Overview
Complete test implementation for DummyJSON Authentication API following Design Patterns principles and covering all use cases defined in `Documentation/Use_Cases/Auth_Use_Cases.md`.

## Test Coverage

### Use Cases Implemented:
- **UC-AUTH-001**: User Login (Success and Error scenarios)
- **UC-AUTH-002**: Get Authenticated User Info (Success and Error scenarios)
- **UC-AUTH-003**: Token Refresh (Success and Error scenarios)
- **Integration Tests**: Complete authentication workflows

### Design Patterns Applied:
- **Library-Keyword Pattern**: Implemented in `resources/apis/auth_service.resource`
- **Data Organization**: Structured test data in `data/testdata/auth_api/`
- **DRY Principle**: Reusable keywords and validation methods

## Test Files Structure

```
tests/api/auth/
├── auth_login_tests.robot           # UC-AUTH-001 - Login functionality
├── auth_user_info_tests.robot       # UC-AUTH-002 - User info retrieval
├── auth_refresh_token_tests.robot   # UC-AUTH-003 - Token refresh
├── auth_integration_tests.robot     # End-to-end workflows
├── auth_test_suite.robot            # Main suite runner
└── README.md                        # This file
```

## Prerequisites

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

## Execution Commands

### Using Execution Scripts (Recommended)

The project includes execution scripts that automatically organize results in dynamic date-time folders:

#### Python Script (Cross-platform)
```bash
# Interactive mode - select execution option
python run_auth_tests.py

# Direct mode execution
python run_auth_tests.py 1    # All Auth Tests
python run_auth_tests.py 2    # Login Tests Only
python run_auth_tests.py 3    # User Info Tests Only
python run_auth_tests.py 4    # Token Refresh Tests Only
python run_auth_tests.py 5    # Integration Tests Only
python run_auth_tests.py 6    # Smoke Tests Only
python run_auth_tests.py 7    # Error Tests Only
python run_auth_tests.py 8    # Success Tests Only
python run_auth_tests.py 9    # Connectivity Test Only
python run_auth_tests.py 10   # Single Login Test
```

#### Windows Batch Script
```cmd
# Interactive mode
run_auth_tests.bat

# Direct mode
run_auth_tests.bat 1
```

#### PowerShell Script
```powershell
# Interactive mode
.\run_auth_tests.ps1

# Direct mode
.\run_auth_tests.ps1 1

# Help
.\run_auth_tests.ps1 -Help
```

### Direct Robot Framework Commands

If you prefer to run tests directly without the execution scripts:

```bash
# Create results directory with timestamp
mkdir results/api/auth_api/$(date +%Y%m%d_%H%M%S)

# Run all tests
python -m robot --outputdir results/api/auth_api/[timestamp] tests/api/auth/

# Run specific test suites
python -m robot --outputdir results/api/auth_api/[timestamp] tests/api/auth/auth_login_tests.robot

# Run by tags
python -m robot --outputdir results/api/auth_api/[timestamp] --include smoke tests/api/auth/

# Run specific test
python -m robot --outputdir results/api/auth_api/[timestamp] --test "Successful Login With Valid Credentials - Emily" tests/api/auth/auth_login_tests.robot
```

### Parallel Execution
```bash
# Run tests in parallel using pabot with custom output directory  
pabot --processes 4 --outputdir results/api/auth_api/$(date +%Y%m%d_%H%M%S) tests/api/auth/
```

## Test Data

Test data is organized in `data/testdata/auth_api/`:
- `valid_users.json` - Valid user credentials for successful tests
- `invalid_credentials.json` - Invalid credentials for error scenario tests
- `auth_endpoints.json` - API endpoint configuration

## Reports

### Results Organization

All test results are automatically organized in the following structure:
```
results/
└── api/
    └── auth_api/
        └── [YYYYMMDD_HHMMSS]/    # Dynamic timestamp folder
            ├── log.html          # Detailed execution log
            ├── report.html       # Test results summary  
            └── output.xml        # Raw test results
```

Example result paths:
- `results/api/auth_api/20250804_145651/`
- `results/api/auth_api/20250804_150245/`

### Generated Reports

After execution, check the generated reports in the timestamped folder:
- `log.html` - Detailed execution log with step-by-step test execution
- `report.html` - Test results summary with statistics and charts
- `output.xml` - Raw test results in XML format for CI/CD integration

## Design Pattern Implementation

### Library-Keyword Pattern (Service Objects)
The `auth_service.resource` file implements the Library-Keyword pattern providing:
- API operation keywords (`Perform User Login`, `Get Authenticated User Info`, etc.)
- Response validation keywords (`Validate Successful Login Response`, etc.)
- Utility keywords for token management

### Data Organization
- Structured JSON test data files
- Centralized endpoint configuration
- Separation of valid and invalid test scenarios

### Reusability
- Keywords are designed for maximum reusability
- Common setup/teardown procedures
- Consistent validation patterns

## API Endpoints Tested

Base URL: `https://dummyjson.com`

- `POST /auth/login` - User authentication
- `GET /auth/me` - Get authenticated user info
- `POST /auth/refresh` - Refresh access token

## Success Criteria

All tests should pass, demonstrating:
1. ✅ Successful authentication with valid credentials
2. ✅ Proper error handling for invalid credentials
3. ✅ Correct user info retrieval with valid tokens
4. ✅ Proper token refresh functionality
5. ✅ Complete integration workflows
6. ✅ Robust error handling for all scenarios

## Implementation Status

- [x] Test data organization
- [x] Service object implementation (Library-Keyword Pattern)
- [x] Complete test coverage for all use cases
- [x] Error scenario testing
- [x] Integration testing
- [x] Validation and execution testing

This implementation serves as a reference for applying Design Patterns in Robot Framework test automation for API testing scenarios.