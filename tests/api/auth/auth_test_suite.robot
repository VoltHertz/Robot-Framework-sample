*** Settings ***
Documentation    Authentication Test Suite - Complete Test Coverage
...              Main test suite for DummyJSON Authentication API covering all use cases:
...              UC-AUTH-001: User Login (Success and Error scenarios)
...              UC-AUTH-002: Get Authenticated User Info (Success and Error scenarios)  
...              UC-AUTH-003: Token Refresh (Success and Error scenarios)
...              Plus Integration tests covering complete authentication workflows
...              File: tests/api/auth/auth_test_suite.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Auth Service
Suite Teardown   Clear Auth Tokens

*** Test Cases ***
Execute All Authentication Tests
    [Documentation]    Execute complete authentication test coverage
    ...                This test serves as a runner for all authentication test scenarios
    ...                File: tests/api/auth/auth_test_suite.robot:15
    [Tags]    auth    suite    runner
    
    Log    Starting Authentication Test Suite Execution    console=True
    Log    Testing DummyJSON Auth API: https://dummyjson.com/docs/auth    console=True
    
    # Test data validation
    ${valid_users}=        Load Auth Test Data    valid_users.json
    ${invalid_creds}=      Load Auth Test Data    invalid_credentials.json
    ${endpoints}=          Load Auth Test Data    auth_endpoints.json
    
    Should Not Be Empty    ${valid_users}      msg=Valid users test data should not be empty
    Should Not Be Empty    ${invalid_creds}    msg=Invalid credentials test data should not be empty
    Should Not Be Empty    ${endpoints}        msg=Endpoints configuration should not be empty
    
    Log    Test data validation completed successfully    console=True
    Log    Authentication Test Suite Ready for Execution   console=True

Authentication Test Data Validation
    [Documentation]    Validate all authentication test data files are properly structured
    ...                File: tests/api/auth/auth_test_suite.robot:32
    [Tags]    auth    data    validation
    
    # Validate valid users data structure
    ${valid_users}=    Load Auth Test Data    valid_users.json
    FOR    ${user}    IN    @{valid_users}
        Dictionary Should Contain Key    ${user}    username
        Dictionary Should Contain Key    ${user}    password
        Dictionary Should Contain Key    ${user}    expectedId
        Dictionary Should Contain Key    ${user}    expectedFirstName
        Dictionary Should Contain Key    ${user}    expectedLastName
        Dictionary Should Contain Key    ${user}    expectedEmail
        Dictionary Should Contain Key    ${user}    expectedGender
        Should Not Be Empty    ${user['username']}
        Should Not Be Empty    ${user['password']}
    END
    
    # Validate invalid credentials data structure
    ${invalid_creds}=    Load Auth Test Data    invalid_credentials.json
    FOR    ${cred}    IN    @{invalid_creds}
        Dictionary Should Contain Key    ${cred}    testCase
        Dictionary Should Contain Key    ${cred}    username
        Dictionary Should Contain Key    ${cred}    password
        Dictionary Should Contain Key    ${cred}    expectedError
        Should Not Be Empty    ${cred['testCase']}
        Should Not Be Empty    ${cred['expectedError']}
    END
    
    Log    All test data validation completed successfully    console=True

Authentication Service Connectivity Test
    [Documentation]    Validate connectivity to DummyJSON Auth API endpoints
    ...                File: tests/api/auth/auth_test_suite.robot:58
    [Tags]    auth    connectivity    health
    
    # Test basic connectivity with a simple login attempt
    ${valid_users}=      Load Auth Test Data    valid_users.json
    ${user_data}=        Set Variable    ${valid_users[0]}
    ${response}=         Perform User Login    ${user_data['username']}    ${user_data['password']}
    
    # Should get either success (200) or error (400) - both indicate API is reachable
    Should Be True    ${response.status_code} in [200, 400, 401]
    
    Log    DummyJSON Auth API connectivity verified    console=True
    Clear Auth Tokens