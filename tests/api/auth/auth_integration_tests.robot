*** Settings ***
Documentation    Authentication Integration Tests - Complete Authentication Flow
...              End-to-end tests covering complete authentication workflows combining UC-AUTH-001, UC-AUTH-002, UC-AUTH-003
...              File: tests/api/auth/auth_integration_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Auth Service
Suite Teardown   Clear Auth Tokens
Test Teardown    Clear Auth Tokens

*** Test Cases ***
Complete Authentication Flow - Login To User Info To Refresh
    [Documentation]    Test complete authentication flow: Login -> Get User Info -> Refresh Token -> Use New Token
    ...                Integration of UC-AUTH-001, UC-AUTH-002, UC-AUTH-003
    ...                File: tests/api/auth/auth_integration_tests.robot:11
    [Tags]    auth    integration    workflow    smoke
    
    # Step 1: Login with valid credentials (UC-AUTH-001)
    ${valid_users}=      Load Auth Test Data    valid_users.json
    ${user_data}=        Set Variable    ${valid_users[0]}
    ${login_response}=   Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${login_response}    ${user_data}
    
    # Step 2: Get user info with access token (UC-AUTH-002)
    ${user_info_response}=    Get Authenticated User Info    ${ACCESS_TOKEN}
    Validate User Info Response    ${user_info_response}    ${user_data}
    
    # Step 3: Refresh tokens (UC-AUTH-003)
    ${old_access_token}=      Set Variable    ${ACCESS_TOKEN}
    ${refresh_response}=      Refresh Access Token    ${REFRESH_TOKEN}
    Validate Token Refresh Response    ${refresh_response}
    
    # Step 4: Verify new access token works
    ${final_user_info}=       Get Authenticated User Info    ${ACCESS_TOKEN}
    Validate User Info Response    ${final_user_info}    ${user_data}
    
    # Verify old token is different from new token
    Should Not Be Equal    ${old_access_token}    ${ACCESS_TOKEN}

Multi-User Authentication Workflow
    [Documentation]    Test authentication workflow with multiple different users
    ...                File: tests/api/auth/auth_integration_tests.robot:31
    [Tags]    auth    integration    multi-user    regression
    
    ${valid_users}=    Load Auth Test Data    valid_users.json
    
    FOR    ${user_data}    IN    @{valid_users}
        # Login with current user
        ${login_response}=       Perform User Login    ${user_data['username']}    ${user_data['password']}
        Validate Successful Login Response    ${login_response}    ${user_data}
        
        # Verify user info
        ${user_info_response}=   Get Authenticated User Info    ${ACCESS_TOKEN}
        Validate User Info Response    ${user_info_response}    ${user_data}
        
        # Clear tokens for next user
        Clear Auth Tokens
    END

Session Invalidation After Invalid Refresh
    [Documentation]    Test session behavior after invalid refresh token usage
    ...                File: tests/api/auth/auth_integration_tests.robot:47
    [Tags]    auth    integration    security    negative
    
    # Step 1: Establish valid session
    ${valid_users}=      Load Auth Test Data    valid_users.json
    ${user_data}=        Set Variable    ${valid_users[0]}
    ${login_response}=   Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${login_response}    ${user_data}
    
    # Step 2: Verify access token works
    ${user_info_response}=    Get Authenticated User Info    ${ACCESS_TOKEN}
    Validate User Info Response    ${user_info_response}    ${user_data}
    
    # Step 3: Try invalid refresh token
    ${invalid_response}=      Refresh Access Token    invalid_refresh_token
    Validate Unauthorized Response    ${invalid_response}
    
    # Step 4: Verify original access token still works (should work as refresh failure doesn't invalidate current session)
    ${final_user_info}=       Get Authenticated User Info    ${ACCESS_TOKEN}
    Validate User Info Response    ${final_user_info}    ${user_data}

Token Security Validation Flow
    [Documentation]    Test token security aspects and validation
    ...                File: tests/api/auth/auth_integration_tests.robot:65
    [Tags]    auth    integration    security    validation
    
    # Step 1: Login and get tokens
    ${valid_users}=      Load Auth Test Data    valid_users.json
    ${user_data}=        Set Variable    ${valid_users[0]}
    ${login_response}=   Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${login_response}    ${user_data}
    
    ${original_access_token}=     Set Variable    ${ACCESS_TOKEN}
    ${original_refresh_token}=    Set Variable    ${REFRESH_TOKEN}
    
    # Step 2: Verify tokens are not empty and have expected format
    Should Not Be Empty    ${original_access_token}
    Should Not Be Empty    ${original_refresh_token}
    Should Contain         ${original_access_token}    eyJ
    Should Contain         ${original_refresh_token}   eyJ
    
    # Step 3: Refresh tokens
    ${refresh_response}=      Refresh Access Token    ${original_refresh_token}
    Validate Token Refresh Response    ${refresh_response}
    
    # Step 4: Verify new tokens are different and valid
    Should Not Be Equal    ${ACCESS_TOKEN}     ${original_access_token}
    Should Not Be Empty    ${ACCESS_TOKEN}
    Should Contain         ${ACCESS_TOKEN}     eyJ
    
    # Step 5: Verify new access token works
    ${user_info_response}=    Get Authenticated User Info    ${ACCESS_TOKEN}
    Validate User Info Response    ${user_info_response}    ${user_data}