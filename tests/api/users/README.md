# Users API Test Suite - DummyJSON API

## Overview
Complete test implementation for DummyJSON Users API following Design Patterns principles and covering all use cases defined in `Documentation/Use_Cases/Users_Use_Cases.md`.

## Test Coverage

### Use Cases Implemented:
- **UC-USER-001**: User Login (Success and Error scenarios) - 8 test cases
- **UC-USER-002**: Get All Users (Pagination, Sorting, Filtering) - 13 test cases  
- **UC-USER-003**: Get User By ID (Success and Error scenarios) - 15 test cases
- **UC-USER-004**: Search Users (Multiple criteria and Edge cases) - 18 test cases
- **UC-USER-005**: Add New User - Simulated (Data validation and Creation) - 16 test cases
- **UC-USER-006**: Update User - Simulated (PATCH operations and Validation) - 18 test cases
- **UC-USER-007**: Delete User - Simulated (Deletion confirmation and Validation) - 19 test cases

**Total: 107+ comprehensive test cases covering all scenarios**

### Design Patterns Applied:
- **Library-Keyword Pattern**: Implemented in `resources/apis/users_service.resource`
- **Data Organization**: Structured test data in `data/testdata/users_api/`
- **DRY Principle**: Reusable keywords and validation methods
- **Facade Pattern**: High-level business keywords for complex operations

## Test Files Structure

```
tests/api/users/
├── users_login_tests.robot          # UC-USER-001 - Login functionality
├── users_get_all_tests.robot        # UC-USER-002 - Get all users with pagination
├── users_get_by_id_tests.robot      # UC-USER-003 - Get individual users
├── users_search_tests.robot         # UC-USER-004 - Search functionality
├── users_add_tests.robot            # UC-USER-005 - Add new users (simulated)
├── users_update_tests.robot         # UC-USER-006 - Update users (simulated)
├── users_delete_tests.robot         # UC-USER-007 - Delete users (simulated)
├── users_test_suite.robot           # Main suite runner with connectivity tests
└── README.md                        # This file
```

## Execution Methods

### 1. Recommended Method - Execution Scripts

#### Interactive Mode:
```bash
# Python Script (Cross-platform)
python run_users_tests.py

# Windows Batch
run_users_tests.bat

# PowerShell
.\run_users_tests.ps1
```

#### Direct Execution with Parameters:
```bash
# All tests
python run_users_tests.py 1

# Specific test suites
python run_users_tests.py 2    # Login tests only
python run_users_tests.py 3    # Get all users tests
python run_users_tests.py 4    # Get by ID tests
python run_users_tests.py 5    # Search tests
python run_users_tests.py 6    # Add user tests
python run_users_tests.py 7    # Update user tests
python run_users_tests.py 8    # Delete user tests

# By test categories
python run_users_tests.py 9    # Smoke tests only
python run_users_tests.py 10   # Error tests only
python run_users_tests.py 11   # Success tests only
python run_users_tests.py 12   # Simulated tests only
python run_users_tests.py 13   # CRUD operations only
```

#### Available Execution Modes:
1. **All Users Tests** - Complete test suite execution
2. **Login Tests Only** - UC-USER-001 scenarios
3. **Get All Users Tests Only** - UC-USER-002 scenarios  
4. **Get User By ID Tests Only** - UC-USER-003 scenarios
5. **Search Users Tests Only** - UC-USER-004 scenarios
6. **Add User Tests Only** - UC-USER-005 scenarios
7. **Update User Tests Only** - UC-USER-006 scenarios
8. **Delete User Tests Only** - UC-USER-007 scenarios
9. **Smoke Tests Only** - Essential functionality verification
10. **Error Tests Only** - Error handling and validation
11. **Success Tests Only** - Positive scenario validation
12. **Simulated Tests Only** - Mock operations (Add/Update/Delete)
13. **CRUD Operations Only** - Create, Read, Update, Delete tests
14. **Single Login Test** - Quick connectivity verification

### 2. Direct Robot Framework Execution

```bash
# All users tests
python -m robot --outputdir results/api/users_api/manual tests/api/users/

# Specific test files
python -m robot --outputdir results/api/users_api/manual tests/api/users/users_login_tests.robot

# By tags
python -m robot --outputdir results/api/users_api/manual --include smoke tests/api/users/
python -m robot --outputdir results/api/users_api/manual --include error tests/api/users/
python -m robot --outputdir results/api/users_api/manual --include simulated tests/api/users/

# Suite runner only
python -m robot --outputdir results/api/users_api/manual tests/api/users/users_test_suite.robot
```

## Results Organization

### Dynamic Results Folders:
- **Location**: `results/api/users_api/[YYYYMMDD_HHMMSS]/`
- **Automatic**: Each execution creates unique timestamped folder
- **Never Overwrites**: Previous execution results are preserved

### Generated Reports:
- **log.html** - Detailed execution log with step-by-step results
- **report.html** - Summary report with statistics and test results  
- **output.xml** - Raw XML data for further processing/CI integration

## Test Scenarios Coverage

### Success Scenarios:
- ✅ User authentication with valid credentials
- ✅ Retrieve all users with different pagination settings
- ✅ Get individual users by valid IDs
- ✅ Search users with various criteria
- ✅ Add new users with valid data (simulated)
- ✅ Update existing users (simulated)
- ✅ Delete users (simulated)

### Error Scenarios:
- ✅ Invalid login credentials
- ✅ Non-existent user IDs
- ✅ Invalid search parameters
- ✅ Edge case data validation
- ✅ Empty and null value handling

### Edge Cases:
- ✅ Special characters in names
- ✅ Large data sets
- ✅ Performance validation
- ✅ Concurrent operations simulation
- ✅ Data integrity verification

## Prerequisites

### Dependencies (from root requirements.txt):
- Robot Framework 7.0+
- RequestsLibrary 0.9.7+
- JSONLibrary 0.5.0+
- Collections (built-in)
- Python 3.8+

### API Access:
- **Base URL**: https://dummyjson.com
- **Documentation**: https://dummyjson.com/docs/users
- **No Authentication Required** for read operations
- **Simulated Operations** for write operations (Add/Update/Delete)

## Validation and Health Checks

### Connectivity Test:
```bash
python run_users_tests.py 14  # Single login test
```

### Data Integrity Test:
```bash
python -m robot --outputdir results/api/users_api/manual --test "Users API Data Integrity Test" tests/api/users/users_test_suite.robot
```

### Performance Baseline:
```bash
python -m robot --outputdir results/api/users_api/manual --test "Users API Performance Baseline Test" tests/api/users/users_test_suite.robot
```

## Troubleshooting

### Common Issues:
1. **Connection Errors**: Check internet connectivity and API availability
2. **Import Errors**: Ensure all dependencies are installed (`pip install -r requirements.txt`)
3. **Path Issues**: Run scripts from project root directory
4. **Permission Errors**: Ensure write permissions for results directory

### Debug Mode:
```bash
# Enable verbose logging
python -m robot --outputdir results/api/users_api/debug --loglevel DEBUG tests/api/users/

# Single test debug
python -m robot --outputdir results/api/users_api/debug --test "Admin User Emily Can Login Successfully" tests/api/users/users_login_tests.robot
```

### Test Data Verification:
```bash
# Verify test data accessibility
python -m robot --outputdir results/api/users_api/verify --test "Execute All Users API Tests" tests/api/users/users_test_suite.robot
```

## Integration with CI/CD

The test suite is designed for CI/CD integration:

- **Exit Codes**: Scripts return appropriate exit codes for CI/CD decisions
- **XML Output**: Generates standard Robot Framework XML for parsing
- **Parallel Execution Ready**: Tests are independent and can run in parallel
- **Environment Agnostic**: Works across different platforms and environments

Example CI/CD usage:
```yaml
# Example GitHub Actions step
- name: Run Users API Tests
  run: python run_users_tests.py 9  # Smoke tests
  
- name: Upload Test Results
  uses: actions/upload-artifact@v3
  with:
    name: users-api-test-results
    path: results/api/users_api/
```

This test suite provides comprehensive coverage of the DummyJSON Users API following industry best practices and design patterns.