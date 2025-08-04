*** Settings ***
Documentation    Authentication Login Tests - UC-AUTH-001
...              Business logic focused test suite for user login functionality
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/auth/auth_login_tests.robot
Resource         ../../../resources/apis/auth_service.resource
Suite Setup      Initialize Authentication Service
Suite Teardown   Cleanup Authentication Service
Test Teardown    Cleanup Authentication Service

*** Test Cases ***
# UC-AUTH-001: Successful Login Business Tests
User Emily Can Login Successfully
    [Documentation]    Emily should be able to login with her valid credentials
    ...                UC-AUTH-001 - File: tests/api/auth/auth_login_tests.robot:12
    [Tags]    auth    login    success    smoke
    Login With Valid User Emily

User Michael Can Login Successfully
    [Documentation]    Michael should be able to login with his valid credentials
    ...                UC-AUTH-001 - File: tests/api/auth/auth_login_tests.robot:17
    [Tags]    auth    login    success    regression
    Login With Valid User Michael

User Sophia Can Login Successfully
    [Documentation]    Sophia should be able to login with her valid credentials
    ...                UC-AUTH-001 - File: tests/api/auth/auth_login_tests.robot:22
    [Tags]    auth    login    success    regression
    Login With Valid User Sophia

# UC-AUTH-001-E1: Invalid Credentials Business Error Tests
System Should Reject Invalid Username
    [Documentation]    System should reject login attempts with invalid username
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:28
    [Tags]    auth    login    error    negative    security
    Attempt Login With Invalid Username

System Should Reject Invalid Password
    [Documentation]    System should reject login attempts with invalid password
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:33
    [Tags]    auth    login    error    negative    security
    Attempt Login With Invalid Password

System Should Reject Empty Username
    [Documentation]    System should reject login attempts with empty username
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:38
    [Tags]    auth    login    error    negative    boundary    security
    Attempt Login With Empty Username

System Should Reject Empty Password
    [Documentation]    System should reject login attempts with empty password
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:43
    [Tags]    auth    login    error    negative    boundary    security
    Attempt Login With Empty Password

System Should Reject Completely Empty Credentials
    [Documentation]    System should reject login attempts with both username and password empty
    ...                UC-AUTH-001-E1 - File: tests/api/auth/auth_login_tests.robot:48
    [Tags]    auth    login    error    negative    boundary    security
    Attempt Login With Both Fields Empty