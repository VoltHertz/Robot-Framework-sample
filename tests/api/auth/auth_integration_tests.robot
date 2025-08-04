*** Settings ***
Documentation    Authentication Integration Tests - Complete Authentication Flow
...              Business logic focused integration tests covering complete authentication workflows
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/auth/auth_integration_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Authentication Service
Suite Teardown   Cleanup Authentication Service
Test Teardown    Cleanup Authentication Service

*** Test Cases ***
Complete Authentication Workflow Should Work End-To-End
    [Documentation]    Complete authentication workflow should work seamlessly from login to refresh
    ...                Integration of UC-AUTH-001, UC-AUTH-002, UC-AUTH-003
    ...                File: tests/api/auth/auth_integration_tests.robot:12
    [Tags]    auth    integration    workflow    smoke
    Perform Complete Authentication Flow

Multiple Users Should Be Able To Authenticate Independently
    [Documentation]    Multiple different users should be able to authenticate independently
    ...                File: tests/api/auth/auth_integration_tests.robot:17
    [Tags]    auth    integration    multi-user    regression
    
    # Test Emily
    Cleanup Authentication Service
    Initialize Authentication Service
    Establish User Session  # This sets up Emily's session and CURRENT_USER_DATA
    Get Current User Information
    Cleanup Authentication Service
    
    # Test Michael (need to use direct approach since we can't change Establish User Session)
    Initialize Authentication Service
    Login With Valid User Michael
    ${michael_data}=    _Get Valid User Data    1    # Get Michael's data manually
    Set Test Variable    ${CURRENT_USER_DATA}    ${michael_data}
    Get Current User Information
    Cleanup Authentication Service
    
    # Test Sophia
    Initialize Authentication Service
    Login With Valid User Sophia
    ${sophia_data}=    _Get Valid User Data    2    # Get Sophia's data manually
    Set Test Variable    ${CURRENT_USER_DATA}    ${sophia_data}
    Get Current User Information

Session Should Remain Valid After Invalid Refresh Attempt
    [Documentation]    Current session should remain valid even after invalid refresh token attempt
    ...                File: tests/api/auth/auth_integration_tests.robot:31
    [Tags]    auth    integration    security    negative
    
    # Establish valid session
    Establish User Session
    Get Current User Information
    
    # Try invalid refresh (should fail but not invalidate current session)
    Attempt Refresh With Invalid Token
    
    # Original access token should still work
    Get Current User Information