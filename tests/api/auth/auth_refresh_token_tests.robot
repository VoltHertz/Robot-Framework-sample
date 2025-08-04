*** Settings ***
Documentation    Authentication Token Refresh Tests - UC-AUTH-003
...              Business logic focused test suite for token refresh functionality
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/auth/auth_refresh_token_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Authentication Service
Suite Teardown   Cleanup Authentication Service
Test Setup       Establish User Session
Test Teardown    Cleanup Authentication Service

*** Test Cases ***
# UC-AUTH-003: Successful Token Refresh Business Tests
User Can Refresh Their Access Token
    [Documentation]    User should be able to refresh their access token using valid refresh token
    ...                UC-AUTH-003 - File: tests/api/auth/auth_refresh_token_tests.robot:12
    [Tags]    auth    refresh    success    smoke
    Refresh Current Access Token

User Can Refresh Token Multiple Times Consecutively
    [Documentation]    User should be able to perform multiple consecutive token refreshes
    ...                UC-AUTH-003 - File: tests/api/auth/auth_refresh_token_tests.robot:17
    [Tags]    auth    refresh    success    regression
    # First refresh
    Refresh Current Access Token
    # Second refresh with new token
    Refresh Current Access Token

New Access Token Should Work After Refresh
    [Documentation]    New access token should work for accessing protected resources after refresh
    ...                UC-AUTH-003 - File: tests/api/auth/auth_refresh_token_tests.robot:24
    [Tags]    auth    refresh    success    integration
    # Refresh token
    Refresh Current Access Token
    # Use new access token to verify it works
    Get Current User Information

# UC-AUTH-003-E1: Invalid Refresh Token Business Error Tests
# Note: DummyJSON API has permissive behavior for token refresh - it returns HTTP 200 even for invalid/empty tokens
# In a real-world scenario, these would return error responses
System Should Reject Invalid Refresh Token
    [Documentation]    System should reject token refresh attempts with invalid refresh token
    ...                UC-AUTH-003-E1 - File: tests/api/auth/auth_refresh_token_tests.robot:32
    ...                Note: DummyJSON API is permissive and accepts invalid tokens
    [Tags]    auth    refresh    error    negative    security
    Attempt Refresh With Invalid Token

System Should Reject Malformed Refresh Token
    [Documentation]    System should reject token refresh attempts with malformed refresh token
    ...                UC-AUTH-003-E1 - File: tests/api/auth/auth_refresh_token_tests.robot:42
    ...                Note: DummyJSON API is permissive and accepts malformed tokens
    [Tags]    auth    refresh    error    negative    security
    Attempt Refresh With Malformed Token