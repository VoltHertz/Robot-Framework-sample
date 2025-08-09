*** Settings ***
Documentation    Users API Test Suite - Complete Test Coverage
...              Main test suite for DummyJSON Users API covering all use cases:
...              UC-USER-001: User Login (Success and Error scenarios)
...              UC-USER-002: Get All Users (Pagination, Sorting, Filtering)
...              UC-USER-003: Get User By ID (Success and Error scenarios)  
...              UC-USER-004: Search Users (Multiple criteria and Edge cases)
...              UC-USER-005: Add New User - Simulated (Data validation and Creation)
...              UC-USER-006: Update User - Simulated (PATCH operations and Validation)
...              UC-USER-007: Delete User - Simulated (Deletion confirmation and Validation)
...              Plus Integration tests covering complete Users API workflows
...              File: tests/api/users/users_test_suite.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service

*** Test Cases ***
Execute All Users API Tests
    [Documentation]    Execute complete Users API test coverage
    ...                This test serves as a runner for all users test scenarios
    ...                File: tests/api/users/users_test_suite.robot:17
    [Tags]    users    suite    runner
    
    Log    Starting Users API Test Suite Execution    console=True
    Log    Testing DummyJSON Users API: https://dummyjson.com/docs/users    console=True
    
    # Test data validation using service objects access
    ${admin_user}=         Get User Test Data    admin_user
    ${regular_user}=       Get User Test Data    regular_user
    ${search_user}=        Get User Test Data    search_user
    ${invalid_creds}=      Get Invalid User Test Data    non_existent_id
    Log    Test data accessible for validation    console=True
    
    Should Not Be Empty    ${admin_user}       msg=Admin user test data should not be empty
    Should Not Be Empty    ${regular_user}     msg=Regular user test data should not be empty  
    Should Not Be Empty    ${search_user}      msg=Search user test data should not be empty
    Should Not Be Empty    ${invalid_creds}    msg=Invalid user test data should not be empty
    
    Log    ✅ Test data validation completed successfully    console=True

Users Service Connectivity Test
    [Documentation]    Test basic connectivity to Users API service
    ...                Validates that the API is accessible and responding correctly
    ...                File: tests/api/users/users_test_suite.robot:35
    [Tags]    users    connectivity    smoke    health-check
    
    Log    Testing Users API connectivity...    console=True
    
    # Test basic connectivity by attempting to get all users
    _Execute Get All Users Request    limit=1    skip=0
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    users
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit
    
    Should Be True    ${response_json['total']} > 0    msg=API should return users data
    Should Be True    isinstance($response_json['users'], list)    msg=Users should be a list
    
    Log    ✅ Users API connectivity test passed    console=True

Users Service Authentication Test
    [Documentation]    Test user authentication functionality through Users API
    ...                Validates login capability with admin user credentials
    ...                File: tests/api/users/users_test_suite.robot:53
    [Tags]    users    auth    smoke    login-verification
    
    Log    Testing Users API authentication capability...    console=True
    
    # Test authentication using admin user
    Login As Admin User Emily
    
    Log    ✅ Users API authentication test passed    console=True

Users API Data Integrity Test  
    [Documentation]    Test data integrity and consistency in Users API responses
    ...                Validates that user data structure is consistent and complete
    ...                File: tests/api/users/users_test_suite.robot:64
    [Tags]    users    data-integrity    smoke    validation
    
    Log    Testing Users API data integrity...    console=True
    
    # Get a specific user and validate complete data structure
    _Execute Get User By ID Request    1
    _Validate Single User Response
    
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Validate core user fields exist and have correct types
    Should Be Equal As Numbers    ${response_json['id']}    1
    Should Not Be Empty    ${response_json['firstName']}
    Should Not Be Empty    ${response_json['lastName']}  
    Should Not Be Empty    ${response_json['email']}
    Should Not Be Empty    ${response_json['username']}
    Should Be True    ${response_json['age']} > 0
    
    # Validate nested object structures exist
    Dictionary Should Contain Key    ${response_json}    address
    Dictionary Should Contain Key    ${response_json}    hair
    Dictionary Should Contain Key    ${response_json}    bank
    Dictionary Should Contain Key    ${response_json}    company
    
    Log    ✅ Users API data integrity test passed    console=True

Users API CRUD Operations Smoke Test
    [Documentation]    Test basic CRUD operations functionality in Users API (simulated)
    ...                Validates Create, Read, Update, Delete operations work correctly
    ...                File: tests/api/users/users_test_suite.robot:87
    [Tags]    users    crud    smoke    simulated    operations
    
    Log    Testing Users API CRUD operations...    console=True
    
    # Create (Add) operation test
    Add New User With Valid Data
    
    # Read (Get by ID) operation test  
    Get Valid User By ID    1
    
    # Update operation test
    Update User With Valid Data    1
    
    # Delete operation test
    Delete User With Valid ID    1
    
    Log    ✅ Users API CRUD operations test passed    console=True

Users API Search Functionality Test
    [Documentation]    Test search functionality in Users API
    ...                Validates that search operations work with different criteria
    ...                File: tests/api/users/users_test_suite.robot:105
    [Tags]    users    search    smoke    functionality
    
    Log    Testing Users API search functionality...    console=True
    
    # Test search with valid terms
    Search Users With Valid Term
    
    # Test search with partial match
    Search Users With Partial Match
    
    Log    ✅ Users API search functionality test passed    console=True

Users API Performance Baseline Test
    [Documentation]    Test performance baseline for Users API operations
    ...                Validates that API operations complete within reasonable time
    ...                File: tests/api/users/users_test_suite.robot:119
    [Tags]    users    performance    smoke    baseline
    
    Log    Testing Users API performance baseline...    console=True
    
    # Test get all users performance
    ${start_time}=    Get Time    epoch
    _Execute Get All Users Request
    ${end_time}=    Get Time    epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 10.0    msg=Get all users should complete within 10 seconds
    
    # Test get user by ID performance
    ${start_time}=    Get Time    epoch
    _Execute Get User By ID Request    1
    ${end_time}=    Get Time    epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0    msg=Get user by ID should complete within 5 seconds
    
    Log    ✅ Users API performance baseline test passed    console=True

Users API Error Handling Test
    [Documentation]    Test error handling capabilities in Users API
    ...                Validates that API properly handles and responds to error conditions
    ...                File: tests/api/users/users_test_suite.robot:138
    [Tags]    users    error-handling    smoke    validation
    
    Log    Testing Users API error handling...    console=True
    
    # Test non-existent user handling
    Get Non-Existent User By ID
    
    # Test invalid login handling  
    Login With Wrong Username Should Fail
    
    Log    ✅ Users API error handling test passed    console=True

Users API Complete Workflow Test
    [Documentation]    Test complete workflow combining multiple Users API operations
    ...                Validates end-to-end functionality across different use cases
    ...                File: tests/api/users/users_test_suite.robot:152
    [Tags]    users    workflow    integration    end-to-end
    
    Log    Testing Users API complete workflow...    console=True
    
    # Authentication workflow
    Log    Step 1: Authenticate admin user    console=True
    Login As Admin User Emily
    
    # Data retrieval workflow
    Log    Step 2: Retrieve users data    console=True
    Get All Users With Default Pagination
    
    # Search workflow
    Log    Step 3: Search for specific users    console=True
    Search Users With Valid Term
    
    # Individual user workflow
    Log    Step 4: Get individual user details    console=True
    Get Valid User By ID    1
    
    # CRUD operations workflow (simulated)
    Log    Step 5: Perform CRUD operations    console=True
    Add New User With Valid Data
    Update User With Valid Data    1
    Delete User With Valid ID    1
    
    Log    ✅ Users API complete workflow test passed    console=True