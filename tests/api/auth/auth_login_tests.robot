*** Settings ***
Documentation    Authentication Login Tests - UC-AUTH-001
...              Complete test coverage for user login functionality including success and error scenarios
...              File: tests/api/auth/auth_login_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Auth Service
Suite Teardown   Clear Auth Tokens
Test Teardown    Clear Auth Tokens

*** Test Cases ***
# UC-AUTH-001: Successful Login Tests
Successful Login With Valid Credentials - Emily
    [Documentation]    Test successful login with valid credentials for Emily user
    ...                UC-AUTH-001 - File: tests/api/auth/auth_login_tests.robot:13
    [Tags]    auth    login    success    smoke
    ${valid_users}=    Load Auth Test Data    valid_users.json
    ${user_data}=      Set Variable    ${valid_users[0]}
    ${response}=       Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${response}    ${user_data}

Successful Login With Valid Credentials - Michael
    [Documentation]    Test successful login with valid credentials for Michael user
    ...                UC-AUTH-001 - File: tests/api/auth/auth_login_tests.robot:21
    [Tags]    auth    login    success    regression
    ${valid_users}=    Load Auth Test Data    valid_users.json
    ${user_data}=      Set Variable    ${valid_users[1]}
    ${response}=       Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${response}    ${user_data}

Successful Login With Valid Credentials - Sophia
    [Documentation]    Test successful login with valid credentials for Sophia user
    ...                UC-AUTH-001 - File: tests/api/auth/auth_login_tests.robot:29
    [Tags]    auth    login    success    regression
    ${valid_users}=    Load Auth Test Data    valid_users.json
    ${user_data}=      Set Variable    ${valid_users[2]}
    ${response}=       Perform User Login    ${user_data['username']}    ${user_data['password']}
    Validate Successful Login Response    ${response}    ${user_data}

# UC-AUTH-001-E1: Invalid Credentials Error Tests
Login With Invalid Username
    [Documentation]    Test login failure with invalid username
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:37
    [Tags]    auth    login    error    negative
    ${invalid_creds}=    Load Auth Test Data    invalid_credentials.json
    ${test_data}=        Set Variable    ${invalid_creds[0]}
    ${response}=         Perform User Login    ${test_data['username']}    ${test_data['password']}
    Validate Invalid Credentials Response    ${response}    ${test_data['expectedError']}

Login With Invalid Password
    [Documentation]    Test login failure with invalid password
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:45
    [Tags]    auth    login    error    negative
    ${invalid_creds}=    Load Auth Test Data    invalid_credentials.json
    ${test_data}=        Set Variable    ${invalid_creds[1]}
    ${response}=         Perform User Login    ${test_data['username']}    ${test_data['password']}
    Validate Invalid Credentials Response    ${response}    ${test_data['expectedError']}

Login With Empty Username
    [Documentation]    Test login failure with empty username
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:53
    [Tags]    auth    login    error    negative    boundary
    ${invalid_creds}=    Load Auth Test Data    invalid_credentials.json
    ${test_data}=        Set Variable    ${invalid_creds[2]}
    ${response}=         Perform User Login    ${test_data['username']}    ${test_data['password']}
    Validate Invalid Credentials Response    ${response}    ${test_data['expectedError']}

Login With Empty Password
    [Documentation]    Test login failure with empty password
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:61
    [Tags]    auth    login    error    negative    boundary
    ${invalid_creds}=    Load Auth Test Data    invalid_credentials.json
    ${test_data}=        Set Variable    ${invalid_creds[3]}
    ${response}=         Perform User Login    ${test_data['username']}    ${test_data['password']}
    Validate Invalid Credentials Response    ${response}    ${test_data['expectedError']}

Login With Both Fields Empty
    [Documentation]    Test login failure with both username and password empty
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:69
    [Tags]    auth    login    error    negative    boundary
    ${invalid_creds}=    Load Auth Test Data    invalid_credentials.json
    ${test_data}=        Set Variable    ${invalid_creds[4]}
    ${response}=         Perform User Login    ${test_data['username']}    ${test_data['password']}
    Validate Invalid Credentials Response    ${response}    ${test_data['expectedError']}