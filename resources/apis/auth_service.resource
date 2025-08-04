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
# Setup and Configuration Keywords
Initialize Auth Service
    [Documentation]    Initialize the auth service session for API requests
    ...                File: resources/apis/auth_service.resource:17
    Create Session    ${AUTH_SESSION}    ${baseUrl}
    Set Test Variable    ${ACCESS_TOKEN}    ${EMPTY}
    Set Test Variable    ${REFRESH_TOKEN}    ${EMPTY}

Load Auth Test Data
    [Documentation]    Load authentication test data from JSON files
    ...                File: resources/apis/auth_service.resource:24
    [Arguments]    ${data_file}
    ${test_data}=    Load JSON From File    ${CURDIR}/../../data/testdata/auth_api/${data_file}
    RETURN    ${test_data}

# Authentication Operation Keywords (Library-Keyword Pattern)
Perform User Login
    [Documentation]    Perform user login operation - UC-AUTH-001
    ...                File: resources/apis/auth_service.resource:31
    [Arguments]    ${username}    ${password}
    ${login_payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    ${AUTH_SESSION}    ${endpoints.login}    
    ...             json=${login_payload}    expected_status=any
    RETURN    ${response}

Get Authenticated User Info
    [Documentation]    Get authenticated user information - UC-AUTH-002
    ...                File: resources/apis/auth_service.resource:39
    [Arguments]    ${access_token}
    ${headers}=    Create Dictionary    Authorization=${headers.authorization} ${access_token}
    ${response}=    GET On Session    ${AUTH_SESSION}    ${endpoints.me}    
    ...             headers=${headers}    expected_status=any
    RETURN    ${response}

Refresh Access Token
    [Documentation]    Refresh access token using refresh token - UC-AUTH-003
    ...                File: resources/apis/auth_service.resource:47
    [Arguments]    ${refresh_token}
    ${refresh_payload}=    Create Dictionary    refreshToken=${refresh_token}
    ${response}=    POST On Session    ${AUTH_SESSION}    ${endpoints.refresh}    
    ...             json=${refresh_payload}    expected_status=any
    RETURN    ${response}

# Response Validation Keywords
Validate Successful Login Response
    [Documentation]    Validate successful login response structure and content
    ...                File: resources/apis/auth_service.resource:56
    [Arguments]    ${response}    ${expected_user_data}
    Should Be Equal As Numbers    ${response.status_code}    ${expectedStatusCodes.success}
    ${response_json}=    Set Variable    ${response.json()}
    
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

Validate Invalid Credentials Response
    [Documentation]    Validate invalid credentials error response
    ...                File: resources/apis/auth_service.resource:76
    [Arguments]    ${response}    ${expected_error}
    Should Be Equal As Numbers    ${response.status_code}    ${expectedStatusCodes.badRequest}
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['message']}    ${expected_error}

Validate User Info Response
    [Documentation]    Validate authenticated user info response
    ...                File: resources/apis/auth_service.resource:83
    [Arguments]    ${response}    ${expected_user_data}
    Should Be Equal As Numbers    ${response.status_code}    ${expectedStatusCodes.success}
    ${response_json}=    Set Variable    ${response.json()}
    
    # Validate user information
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_user_data['expectedId']}
    Should Be Equal    ${response_json['firstName']}    ${expected_user_data['expectedFirstName']}
    Should Be Equal    ${response_json['lastName']}    ${expected_user_data['expectedLastName']}
    Should Be Equal    ${response_json['email']}    ${expected_user_data['expectedEmail']}
    Should Be Equal    ${response_json['gender']}    ${expected_user_data['expectedGender']}

Validate Unauthorized Response
    [Documentation]    Validate unauthorized access response
    ...                File: resources/apis/auth_service.resource:95
    [Arguments]    ${response}
    Should Be True    ${response.status_code} in [${expectedStatusCodes.unauthorized}, ${expectedStatusCodes.forbidden}]

Validate Token Refresh Response
    [Documentation]    Validate successful token refresh response
    ...                File: resources/apis/auth_service.resource:100
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    ${expectedStatusCodes.success}
    ${response_json}=    Set Variable    ${response.json()}
    
    # Validate new tokens presence
    Dictionary Should Contain Key    ${response_json}    accessToken
    Dictionary Should Contain Key    ${response_json}    refreshToken
    Should Not Be Empty    ${response_json['accessToken']}
    Should Not Be Empty    ${response_json['refreshToken']}
    
    # Update stored tokens
    Set Test Variable    ${ACCESS_TOKEN}    ${response_json['accessToken']}
    Set Test Variable    ${REFRESH_TOKEN}    ${response_json['refreshToken']}

# Utility Keywords
Extract Token From Response
    [Documentation]    Extract access token from login response
    ...                File: resources/apis/auth_service.resource:115
    [Arguments]    ${response}
    ${response_json}=    Set Variable    ${response.json()}
    RETURN    ${response_json['accessToken']}

Extract Refresh Token From Response
    [Documentation]    Extract refresh token from login response
    ...                File: resources/apis/auth_service.resource:121
    [Arguments]    ${response}
    ${response_json}=    Set Variable    ${response.json()}
    RETURN    ${response_json['refreshToken']}

Clear Auth Tokens
    [Documentation]    Clear stored authentication tokens
    ...                File: resources/apis/auth_service.resource:127
    Set Test Variable    ${ACCESS_TOKEN}    ${EMPTY}
    Set Test Variable    ${REFRESH_TOKEN}    ${EMPTY}