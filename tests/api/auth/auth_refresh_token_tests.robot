*** Settings ***
Documentation    Authentication Token Refresh Tests - UC-AUTH-003
...              Complete test coverage for token refresh functionality including success and error scenarios
...              File: tests/api/auth/auth_refresh_token_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Auth Service
Suite Teardown   Clear Auth Tokens
Test Setup       Setup Authenticated User With Tokens
Test Teardown    Clear Auth Tokens

*** Keywords ***
Setup Authenticated User With Tokens
    [Documentation]    Setup an authenticated user with valid tokens for testing refresh functionality
    ...                File: tests/api/auth/auth_refresh_token_tests.robot:12
    ${valid_users}=    Load Auth Test Data    valid_users.json
    ${user_data}=      Set Variable    ${valid_users[0]}
    ${response}=       Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${response}    ${user_data}
    Set Test Variable    ${CURRENT_USER_DATA}    ${user_data}

*** Test Cases ***
# UC-AUTH-003: Successful Token Refresh Tests
Refresh Access Token With Valid Refresh Token
    [Documentation]    Test successful access token refresh using valid refresh token
    ...                UC-AUTH-003 - File: tests/api/auth/auth_refresh_token_tests.robot:22
    [Tags]    auth    refresh    success    smoke
    ${old_access_token}=    Set Variable    ${ACCESS_TOKEN}
    ${old_refresh_token}=   Set Variable    ${REFRESH_TOKEN}
    ${response}=            Refresh Access Token    ${old_refresh_token}
    Validate Token Refresh Response    ${response}
    # Verify tokens are different (new tokens generated)
    Should Not Be Equal    ${ACCESS_TOKEN}    ${old_access_token}
    Should Not Be Equal    ${REFRESH_TOKEN}   ${old_refresh_token}

Refresh Token Multiple Times
    [Documentation]    Test multiple consecutive token refreshes
    ...                UC-AUTH-003 - File: tests/api/auth/auth_refresh_token_tests.robot:32
    [Tags]    auth    refresh    success    regression
    # First refresh
    ${first_refresh_token}=    Set Variable    ${REFRESH_TOKEN}
    ${first_response}=         Refresh Access Token    ${first_refresh_token}
    Validate Token Refresh Response    ${first_response}
    
    # Second refresh with new token
    ${second_refresh_token}=   Set Variable    ${REFRESH_TOKEN}
    ${second_response}=        Refresh Access Token    ${second_refresh_token}
    Validate Token Refresh Response    ${second_response}
    
    # Verify all tokens are different
    Should Not Be Equal    ${first_refresh_token}    ${second_refresh_token}

Use New Access Token After Refresh
    [Documentation]    Test using new access token after successful refresh
    ...                UC-AUTH-003 - File: tests/api/auth/auth_refresh_token_tests.robot:46
    [Tags]    auth    refresh    success    integration
    # Refresh token
    ${response}=    Refresh Access Token    ${REFRESH_TOKEN}
    Validate Token Refresh Response    ${response}
    
    # Use new access token to get user info
    ${user_info_response}=    Get Authenticated User Info    ${ACCESS_TOKEN}
    Validate User Info Response    ${user_info_response}    ${CURRENT_USER_DATA}

# UC-AUTH-003-E1: Invalid Refresh Token Error Tests
Refresh With Invalid Refresh Token
    [Documentation]    Test token refresh failure with invalid refresh token
    ...                UC-AUTH-003-E1 - File: tests/api/auth/auth_refresh_token_tests.robot:57
    [Tags]    auth    refresh    error    negative
    ${invalid_refresh_token}=    Set Variable    invalid_refresh_token_12345
    ${response}=                 Refresh Access Token    ${invalid_refresh_token}
    Validate Unauthorized Response    ${response}

Refresh With Empty Refresh Token
    [Documentation]    Test token refresh failure with empty refresh token
    ...                UC-AUTH-003-E1 - File: tests/api/auth/auth_refresh_token_tests.robot:64
    [Tags]    auth    refresh    error    negative    boundary
    ${response}=    Refresh Access Token    ${EMPTY}
    Validate Unauthorized Response    ${response}

Refresh With Malformed Refresh Token
    [Documentation]    Test token refresh failure with malformed refresh token
    ...                UC-AUTH-003-E1 - File: tests/api/auth/auth_refresh_token_tests.robot:70
    [Tags]    auth    refresh    error    negative
    ${malformed_token}=    Set Variable    malformed.refresh.token.structure
    ${response}=           Refresh Access Token    ${malformed_token}
    Validate Unauthorized Response    ${response}

Refresh With Previously Used Token
    [Documentation]    Test token refresh failure with previously used refresh token (replay attack simulation)
    ...                UC-AUTH-003-E1 - File: tests/api/auth/auth_refresh_token_tests.robot:77
    [Tags]    auth    refresh    error    negative    security
    ${old_refresh_token}=    Set Variable    ${REFRESH_TOKEN}
    # First refresh - should succeed
    ${first_response}=       Refresh Access Token    ${old_refresh_token}
    Validate Token Refresh Response    ${first_response}
    
    # Try to use old refresh token again - should fail
    ${second_response}=      Refresh Access Token    ${old_refresh_token}
    Validate Unauthorized Response    ${second_response}