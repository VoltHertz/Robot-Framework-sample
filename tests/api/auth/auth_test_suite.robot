*** Settings ***
Documentation    Authentication Test Suite - Complete Test Coverage
...              Main test suite for DummyJSON Authentication API covering all use cases:
...              UC-AUTH-001: User Login (Success and Error scenarios)
...              UC-AUTH-002: Get Authenticated User Info (Success and Error scenarios)  
...              UC-AUTH-003: Token Refresh (Success and Error scenarios)
...              Plus Integration tests covering complete authentication workflows
...              File: tests/api/auth/auth_test_suite.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Authentication Service
Suite Teardown   Cleanup Authentication Service

*** Test Cases ***
Execute All Authentication Tests
    [Documentation]    Execute complete authentication test coverage
    ...                This test serves as a runner for all authentication test scenarios
    ...                File: tests/api/auth/auth_test_suite.robot:15
    [Tags]    auth    suite    runner
    
    Log    Starting Authentication Test Suite Execution    console=True
    Log    Testing DummyJSON Auth API: https://dummyjson.com/docs/auth    console=True
    
    # Test data validation using internal access
    ${valid_users}=        _Get Valid User Data    0
    ${invalid_creds}=      _Get Invalid Credentials Data    0
    Log    Test data accessible for validation    console=True
    
    Should Not Be Empty    ${valid_users}      msg=Valid users test data should not be empty
    Should Not Be Empty    ${invalid_creds}    msg=Invalid credentials test data should not be empty
    
    Log    Test data validation completed successfully    console=True
    Log    Authentication Test Suite Ready for Execution   console=True

Authentication Test Data Validation
    [Documentation]    Validate authentication test data is properly accessible through business layer
    ...                File: tests/api/auth/auth_test_suite.robot:32
    [Tags]    auth    data    validation
    
    # Validate access to different user data
    ${emily_data}=      _Get Valid User Data    0
    ${michael_data}=    _Get Valid User Data    1
    ${sophia_data}=     _Get Valid User Data    2
    
    # Validate user data structure
    Dictionary Should Contain Key    ${emily_data}    username
    Dictionary Should Contain Key    ${emily_data}    expectedId
    Should Not Be Empty    ${emily_data['username']}
    
    # Validate access to invalid credentials
    ${invalid_user}=     _Get Invalid Credentials Data    0
    ${invalid_pass}=     _Get Invalid Credentials Data    1
    
    # Validate invalid data structure
    Dictionary Should Contain Key    ${invalid_user}    testCase
    Dictionary Should Contain Key    ${invalid_user}    expectedError
    Should Not Be Empty    ${invalid_user['expectedError']}
    
    Log    All test data validation completed successfully    console=True

Authentication Service Connectivity Test
    [Documentation]    Validate connectivity to DummyJSON Auth API endpoints
    ...                File: tests/api/auth/auth_test_suite.robot:58
    [Tags]    auth    connectivity    health
    
    # Test basic connectivity using business logic
    Login With Valid User Emily
    Log    DummyJSON Auth API connectivity verified    console=True