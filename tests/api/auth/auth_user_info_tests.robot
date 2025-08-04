*** Settings ***
Documentation    Authentication User Info Tests - UC-AUTH-002
...              Complete test coverage for authenticated user information retrieval including success and error scenarios
...              File: tests/api/auth/auth_user_info_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Auth Service
Suite Teardown   Clear Auth Tokens
Test Setup       Setup Authenticated User
Test Teardown    Clear Auth Tokens

*** Keywords ***
Setup Authenticated User
    [Documentation]    Setup an authenticated user for testing user info endpoints
    ...                File: tests/api/auth/auth_user_info_tests.robot:12
    ${valid_users}=    Load Auth Test Data    valid_users.json
    ${user_data}=      Set Variable    ${valid_users[0]}
    ${response}=       Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${response}    ${user_data}
    Set Test Variable    ${CURRENT_USER_DATA}    ${user_data}

*** Test Cases ***
# UC-AUTH-002: Successful User Info Retrieval Tests
Get Authenticated User Info With Valid Token
    [Documentation]    Test successful retrieval of authenticated user information with valid access token
    ...                UC-AUTH-002 - File: tests/api/auth/auth_user_info_tests.robot:21
    [Tags]    auth    userinfo    success    smoke
    ${response}=    Get Authenticated User Info    ${ACCESS_TOKEN}
    Validate User Info Response    ${response}    ${CURRENT_USER_DATA}

Get User Info After Fresh Login
    [Documentation]    Test user info retrieval immediately after fresh login
    ...                UC-AUTH-002 - File: tests/api/auth/auth_user_info_tests.robot:27
    [Tags]    auth    userinfo    success    regression
    Clear Auth Tokens
    ${valid_users}=    Load Auth Test Data    valid_users.json
    ${user_data}=      Set Variable    ${valid_users[1]}
    ${login_response}= Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${login_response}    ${user_data}
    ${token}=          Extract Token From Response    ${login_response}
    ${response}=       Get Authenticated User Info    ${token}
    Validate User Info Response    ${response}    ${user_data}

# UC-AUTH-002-E1: Invalid Token Error Tests
Get User Info With Invalid Token
    [Documentation]    Test user info retrieval failure with invalid access token
    ...                UC-AUTH-002-E1 - File: tests/api/auth/auth_user_info_tests.robot:39
    [Tags]    auth    userinfo    error    negative
    ${invalid_token}=    Set Variable    invalid_token_12345
    ${response}=         Get Authenticated User Info    ${invalid_token}
    Validate Unauthorized Response    ${response}

Get User Info With Empty Token
    [Documentation]    Test user info retrieval failure with empty access token
    ...                UC-AUTH-002-E1 - File: tests/api/auth/auth_user_info_tests.robot:46
    [Tags]    auth    userinfo    error    negative    boundary
    ${response}=    Get Authenticated User Info    ${EMPTY}
    Validate Unauthorized Response    ${response}

Get User Info With Malformed Token
    [Documentation]    Test user info retrieval failure with malformed access token
    ...                UC-AUTH-002-E1 - File: tests/api/auth/auth_user_info_tests.robot:52
    [Tags]    auth    userinfo    error    negative
    ${malformed_token}=    Set Variable    malformed.token.structure
    ${response}=           Get Authenticated User Info    ${malformed_token}
    Validate Unauthorized Response    ${response}

Get User Info With Expired Token Simulation
    [Documentation]    Test user info retrieval with potentially expired token (simulated by using different format)
    ...                UC-AUTH-002-E1 - File: tests/api/auth/auth_user_info_tests.robot:59
    [Tags]    auth    userinfo    error    negative    expired
    ${expired_token}=    Set Variable    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.expired.token
    ${response}=         Get Authenticated User Info    ${expired_token}
    Validate Unauthorized Response    ${response}