*** Settings ***
Documentation    Authentication User Info Tests - UC-AUTH-002
...              Business logic focused test suite for authenticated user information retrieval
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/auth/auth_user_info_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Authentication Service
Suite Teardown   Cleanup Authentication Service
Test Setup       Establish User Session
Test Teardown    Cleanup Authentication Service

*** Test Cases ***
# UC-AUTH-002: Successful User Info Business Tests
Authenticated User Can Access Their Information
    [Documentation]    Authenticated user should be able to retrieve their own information
    ...                UC-AUTH-002 - File: tests/api/auth/auth_user_info_tests.robot:12
    [Tags]    auth    userinfo    success    smoke
    Get Current User Information

User Can Get Fresh Information After New Login
    [Documentation]    User should be able to get their information immediately after login
    ...                UC-AUTH-002 - File: tests/api/auth/auth_user_info_tests.robot:17
    [Tags]    auth    userinfo    success    regression
    # Clean session and establish new one with Emily (consistent with setup)
    Cleanup Authentication Service
    Initialize Authentication Service
    Login With Valid User Emily
    Get Current User Information

# UC-AUTH-002-E1: Invalid Token Business Error Tests
System Should Reject Invalid Access Token
    [Documentation]    System should reject access attempts with invalid token
    ...                UC-AUTH-002-E1 - File: tests/api/auth/auth_user_info_tests.robot:26
    [Tags]    auth    userinfo    error    negative    security
    Attempt Get User Info With Invalid Token

System Should Reject Empty Access Token
    [Documentation]    System should reject access attempts with empty token
    ...                UC-AUTH-002-E1 - File: tests/api/auth/auth_user_info_tests.robot:31
    [Tags]    auth    userinfo    error    negative    boundary    security
    Attempt Get User Info With Empty Token

System Should Reject Malformed Access Token
    [Documentation]    System should reject access attempts with malformed token
    ...                UC-AUTH-002-E1 - File: tests/api/auth/auth_user_info_tests.robot:36
    [Tags]    auth    userinfo    error    negative    security
    Attempt Get User Info With Malformed Token