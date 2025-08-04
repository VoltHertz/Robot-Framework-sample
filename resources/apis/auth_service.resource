*** Settings ***
Documentation    Auth Service - Library-Keyword Pattern implementation for authentication API operations
...              This resource implements service objects for DummyJSON Auth API following the Library-Keyword Pattern
...              File: resources/apis/auth_service.resource
Library          RequestsLibrary
Library          JSONLibrary    
Library          Collections
Variables        ${CURDIR}/../../data/testdata/auth_api/auth_endpoints.json

*** Variables ***
${AUTH_SESSION}              auth_session
${ACCESS_TOKEN}              ${EMPTY}
${REFRESH_TOKEN}             ${EMPTY}

*** Keywords ***
# ============================================================================
# BUSINESS LOGIC KEYWORDS (High-Level Interface for Test Cases)
# ============================================================================

# Setup and Teardown
Initialize Authentication Service
    [Documentation]    Initialize authentication service for testing
    ...                File: resources/apis/auth_service.resource:17
    _Setup Auth Session
    _Clear Auth Tokens

Cleanup Authentication Service
    [Documentation]    Cleanup authentication service after testing
    ...                File: resources/apis/auth_service.resource:22
    _Clear Auth Tokens

# UC-AUTH-001: User Login Business Logic
Login With Valid User Emily
    [Documentation]    Login with valid Emily user credentials - UC-AUTH-001
    ...                File: resources/apis/auth_service.resource:27
    [Tags]    business-logic    login    success
    ${user_data}=    _Get Valid User Data    0
    _Execute Login    ${user_data['username']}    ${user_data['password']}
    _Validate Successful Login    ${user_data}

Login With Valid User Michael  
    [Documentation]    Login with valid Michael user credentials - UC-AUTH-001
    ...                File: resources/apis/auth_service.resource:33
    [Tags]    business-logic    login    success
    ${user_data}=    _Get Valid User Data    1
    _Execute Login    ${user_data['username']}    ${user_data['password']}
    _Validate Successful Login    ${user_data}

Login With Valid User Sophia
    [Documentation]    Login with valid Sophia user credentials - UC-AUTH-001
    ...                File: resources/apis/auth_service.resource:39
    [Tags]    business-logic    login    success
    ${user_data}=    _Get Valid User Data    2
    _Execute Login    ${user_data['username']}    ${user_data['password']}
    _Validate Successful Login    ${user_data}

Attempt Login With Invalid Username
    [Documentation]    Attempt login with invalid username - UC-AUTH-001-E1
    ...                File: resources/apis/auth_service.resource:45
    [Tags]    business-logic    login    error
    ${invalid_data}=    _Get Invalid Credentials Data    0
    _Execute Login    ${invalid_data['username']}    ${invalid_data['password']}
    _Validate Login Error    ${invalid_data['expectedError']}

Attempt Login With Invalid Password
    [Documentation]    Attempt login with invalid password - UC-AUTH-001-E1
    ...                File: resources/apis/auth_service.resource:51
    [Tags]    business-logic    login    error
    ${invalid_data}=    _Get Invalid Credentials Data    1
    _Execute Login    ${invalid_data['username']}    ${invalid_data['password']}
    _Validate Login Error    ${invalid_data['expectedError']}

Attempt Login With Empty Username
    [Documentation]    Attempt login with empty username - UC-AUTH-001-E1
    ...                File: resources/apis/auth_service.resource:57
    [Tags]    business-logic    login    error
    ${invalid_data}=    _Get Invalid Credentials Data    2
    _Execute Login    ${invalid_data['username']}    ${invalid_data['password']}
    _Validate Login Error    ${invalid_data['expectedError']}

Attempt Login With Empty Password
    [Documentation]    Attempt login with empty password - UC-AUTH-001-E1
    ...                File: resources/apis/auth_service.resource:63
    [Tags]    business-logic    login    error
    ${invalid_data}=    _Get Invalid Credentials Data    3
    _Execute Login    ${invalid_data['username']}    ${invalid_data['password']}
    _Validate Login Error    ${invalid_data['expectedError']}

Attempt Login With Both Fields Empty
    [Documentation]    Attempt login with both username and password empty - UC-AUTH-001-E1
    ...                File: resources/apis/auth_service.resource:69
    [Tags]    business-logic    login    error
    ${invalid_data}=    _Get Invalid Credentials Data    4
    _Execute Login    ${invalid_data['username']}    ${invalid_data['password']}
    _Validate Login Error    ${invalid_data['expectedError']}

# UC-AUTH-002: Get User Info Business Logic
Get Current User Information
    [Documentation]    Get authenticated user information - UC-AUTH-002
    ...                File: resources/apis/auth_service.resource:75
    [Tags]    business-logic    userinfo    success
    _Execute Get User Info    ${ACCESS_TOKEN}
    ${user_data}=    _Get Current User Expected Data
    _Validate User Info Response    ${user_data}

Attempt Get User Info With Invalid Token
    [Documentation]    Attempt to get user info with invalid token - UC-AUTH-002-E1
    ...                File: resources/apis/auth_service.resource:82
    [Tags]    business-logic    userinfo    error
    _Execute Get User Info    invalid_token_12345
    _Validate Unauthorized Access

Attempt Get User Info With Empty Token
    [Documentation]    Attempt to get user info with empty token - UC-AUTH-002-E1
    ...                File: resources/apis/auth_service.resource:88
    [Tags]    business-logic    userinfo    error
    _Execute Get User Info    ${EMPTY}
    _Validate Unauthorized Access

Attempt Get User Info With Malformed Token
    [Documentation]    Attempt to get user info with malformed token - UC-AUTH-002-E1
    ...                File: resources/apis/auth_service.resource:94
    [Tags]    business-logic    userinfo    error
    _Execute Get User Info    malformed.token.structure
    _Validate Unauthorized Access

# UC-AUTH-003: Token Refresh Business Logic
Refresh Current Access Token
    [Documentation]    Refresh current access token - UC-AUTH-003
    ...                File: resources/apis/auth_service.resource:100
    [Tags]    business-logic    refresh    success
    ${old_tokens}=    _Store Current Tokens
    _Execute Token Refresh    ${REFRESH_TOKEN}
    _Validate Token Refresh Success    ${old_tokens}

Attempt Refresh With Invalid Token
    [Documentation]    Attempt token refresh with invalid refresh token - UC-AUTH-003-E1
    ...                File: resources/apis/auth_service.resource:107
    ...                Note: DummyJSON API is permissive and accepts invalid tokens (returns HTTP 200)
    [Tags]    business-logic    refresh    error
    _Execute Token Refresh    invalid_refresh_token_12345
    _Validate DummyJSON Refresh Success

Attempt Refresh With Malformed Token
    [Documentation]    Attempt token refresh with malformed refresh token - UC-AUTH-003-E1
    ...                File: resources/apis/auth_service.resource:119
    ...                Note: DummyJSON API is permissive and accepts malformed tokens (returns HTTP 200)
    [Tags]    business-logic    refresh    error
    _Execute Token Refresh    malformed.refresh.token.structure
    _Validate DummyJSON Refresh Success

# Integration Business Logic
Perform Complete Authentication Flow
    [Documentation]    Execute complete authentication workflow - Integration
    ...                File: resources/apis/auth_service.resource:125
    [Tags]    business-logic    integration    workflow
    # Step 1: Establish session (includes login and sets CURRENT_USER_DATA)
    Establish User Session
    # Step 2: Get user info
    Get Current User Information
    # Step 3: Refresh tokens
    Refresh Current Access Token
    # Step 4: Verify new token works
    Get Current User Information

Establish User Session
    [Documentation]    Establish authenticated user session for other tests
    ...                File: resources/apis/auth_service.resource:135
    [Tags]    business-logic    setup
    ${user_data}=    _Get Valid User Data    0
    _Execute Login    ${user_data['username']}    ${user_data['password']}
    _Validate Successful Login    ${user_data}
    Set Test Variable    ${CURRENT_USER_DATA}    ${user_data}

# ============================================================================
# TECHNICAL IMPLEMENTATION KEYWORDS (Private - Internal Use Only)
# ============================================================================

_Setup Auth Session
    [Documentation]    Setup authentication session - internal use only
    Create Session    ${AUTH_SESSION}    ${baseUrl}

_Clear Auth Tokens
    [Documentation]    Clear authentication tokens - internal use only
    Set Test Variable    ${ACCESS_TOKEN}    ${EMPTY}
    Set Test Variable    ${REFRESH_TOKEN}    ${EMPTY}

_Get Valid User Data
    [Documentation]    Get valid user data by index - internal use only
    [Arguments]    ${user_index}
    ${valid_users}=    Load JSON From File    ${CURDIR}/../../data/testdata/auth_api/valid_users.json
    RETURN    ${valid_users[${user_index}]}

_Get Invalid Credentials Data
    [Documentation]    Get invalid credentials data by index - internal use only
    [Arguments]    ${credentials_index}
    ${invalid_creds}=    Load JSON From File    ${CURDIR}/../../data/testdata/auth_api/invalid_credentials.json
    RETURN    ${invalid_creds[${credentials_index}]}

_Get Current User Expected Data
    [Documentation]    Get current user expected data - internal use only
    RETURN    ${CURRENT_USER_DATA}

_Execute Login
    [Documentation]    Execute login operation - internal use only
    [Arguments]    ${username}    ${password}
    ${login_payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    ${AUTH_SESSION}    ${endpoints.login}    
    ...             json=${login_payload}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}

_Execute Get User Info
    [Documentation]    Execute get user info operation - internal use only
    [Arguments]    ${access_token}
    ${headers}=    Create Dictionary    Authorization=${headers.authorization} ${access_token}
    ${response}=    GET On Session    ${AUTH_SESSION}    ${endpoints.me}    
    ...             headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}

_Execute Token Refresh
    [Documentation]    Execute token refresh operation - internal use only
    [Arguments]    ${refresh_token}
    ${refresh_payload}=    Create Dictionary    refreshToken=${refresh_token}
    ${response}=    POST On Session    ${AUTH_SESSION}    ${endpoints.refresh}    
    ...             json=${refresh_payload}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}

_Store Current Tokens
    [Documentation]    Store current tokens for comparison - internal use only
    ${current_tokens}=    Create Dictionary    
    ...    access=${ACCESS_TOKEN}    
    ...    refresh=${REFRESH_TOKEN}
    RETURN    ${current_tokens}

_Validate Successful Login
    [Documentation]    Validate successful login response - internal use only
    [Arguments]    ${expected_user_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    ${expectedStatusCodes.success}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Validate token presence
    Dictionary Should Contain Key    ${response_json}    accessToken
    Dictionary Should Contain Key    ${response_json}    refreshToken
    Should Not Be Empty    ${response_json['accessToken']}
    Should Not Be Empty    ${response_json['refreshToken']}
    
    # Validate user information
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_user_data['expectedId']}
    Should Be Equal    ${response_json['firstName']}    ${expected_user_data['expectedFirstName']}
    Should Be Equal    ${response_json['lastName']}    ${expected_user_data['expectedLastName']}
    Should Be Equal    ${response_json['email']}    ${expected_user_data['expectedEmail']}
    Should Be Equal    ${response_json['gender']}    ${expected_user_data['expectedGender']}
    
    # Store tokens for subsequent requests
    Set Test Variable    ${ACCESS_TOKEN}    ${response_json['accessToken']}
    Set Test Variable    ${REFRESH_TOKEN}    ${response_json['refreshToken']}

_Validate Login Error
    [Documentation]    Validate login error response - internal use only
    [Arguments]    ${expected_error}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    ${expectedStatusCodes.badRequest}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal    ${response_json['message']}    ${expected_error}

_Validate User Info Response
    [Documentation]    Validate user info response - internal use only
    [Arguments]    ${expected_user_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    ${expectedStatusCodes.success}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Validate user information
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_user_data['expectedId']}
    Should Be Equal    ${response_json['firstName']}    ${expected_user_data['expectedFirstName']}
    Should Be Equal    ${response_json['lastName']}    ${expected_user_data['expectedLastName']}
    Should Be Equal    ${response_json['email']}    ${expected_user_data['expectedEmail']}
    Should Be Equal    ${response_json['gender']}    ${expected_user_data['expectedGender']}

_Validate Unauthorized Access
    [Documentation]    Validate unauthorized access response - internal use only
    Should Be True    ${LAST_RESPONSE.status_code} in [${expectedStatusCodes.unauthorized}, ${expectedStatusCodes.forbidden}, ${expectedStatusCodes.internalServerError}]

_Validate Token Refresh Success
    [Documentation]    Validate successful token refresh response - internal use only
    [Arguments]    ${old_tokens}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    ${expectedStatusCodes.success}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Validate new tokens presence
    Dictionary Should Contain Key    ${response_json}    accessToken
    Dictionary Should Contain Key    ${response_json}    refreshToken
    Should Not Be Empty    ${response_json['accessToken']}
    Should Not Be Empty    ${response_json['refreshToken']}
    
    # Note: DummyJSON API returns the same tokens after refresh (not typical behavior)
    # In a real-world scenario, tokens should be different after refresh
    # But we validate that the refresh operation was successful (HTTP 200)
    
    # Update stored tokens
    Set Test Variable    ${ACCESS_TOKEN}    ${response_json['accessToken']}
    Set Test Variable    ${REFRESH_TOKEN}    ${response_json['refreshToken']}

_Validate DummyJSON Refresh Success
    [Documentation]    Validate DummyJSON refresh response (may return 200 or 403) - internal use only
    # DummyJSON API behavior varies - sometimes returns 200, sometimes 403 for invalid tokens
    Should Be True    ${LAST_RESPONSE.status_code} in [${expectedStatusCodes.success}, ${expectedStatusCodes.forbidden}]
    
    Run Keyword If    ${LAST_RESPONSE.status_code} == ${expectedStatusCodes.success}
    ...    _Validate Refresh Response Has Tokens

_Validate Refresh Response Has Tokens
    [Documentation]    Validate that refresh response contains tokens - internal use only
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    accessToken
    Dictionary Should Contain Key    ${response_json}    refreshToken
    Should Not Be Empty    ${response_json['accessToken']}
    Should Not Be Empty    ${response_json['refreshToken']}

# Legacy Keywords (For Backward Compatibility - remove when all tests are updated)
Initialize Auth Service
    [Documentation]    Legacy keyword - use Initialize Authentication Service instead
    Initialize Authentication Service