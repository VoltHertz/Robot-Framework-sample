*** Settings ***
Documentation    Users Login Tests - UC-USER-001
...              Business logic focused test suite for user login functionality via Users API
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/users/users_login_tests.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service
Test Teardown    Cleanup Users Service

*** Test Cases ***
# UC-USER-001: Successful Login Business Tests
Admin User Emily Can Login Successfully
    [Documentation]    Admin user Emily should be able to login with her valid credentials
    ...                UC-USER-001 - File: tests/api/users/users_login_tests.robot:12
    [Tags]    users    login    success    smoke    admin
    Login As Admin User Emily

Regular User Michael Can Login Successfully
    [Documentation]    Regular user Michael should be able to login with his valid credentials
    ...                UC-USER-001 - File: tests/api/users/users_login_tests.robot:18
    [Tags]    users    login    success    regression    user
    Login As Regular User Michael

# UC-USER-001: Invalid Credentials Error Tests
Login With Invalid Username Should Fail
    [Documentation]    Login attempt with invalid username should return 400 error
    ...                UC-USER-001-E1 - File: tests/api/users/users_login_tests.robot:24
    [Tags]    users    login    error    400    invalid-credentials
    Login With Wrong Username Should Fail

Login With Invalid Password Should Fail
    [Documentation]    Login attempt with invalid password should return 400 error
    ...                UC-USER-001-E1 - File: tests/api/users/users_login_tests.robot:29
    [Tags]    users    login    error    400    invalid-credentials
    Login With Wrong Password Should Fail

Login With Empty Username Should Fail
    [Documentation]    Login attempt with empty username should return 400 error
    ...                UC-USER-001-E1 - File: tests/api/users/users_login_tests.robot:34
    [Tags]    users    login    error    400    empty-fields
    Login With Empty Username Should Fail

Login With Empty Password Should Fail
    [Documentation]    Login attempt with empty password should return 400 error
    ...                UC-USER-001-E1 - File: tests/api/users/users_login_tests.robot:39
    [Tags]    users    login    error    400    empty-fields
    Login With Empty Password Should Fail

Login With Missing Username Should Fail
    [Documentation]    Login attempt with missing username field should return 400 error
    ...                UC-USER-001-E1 - File: tests/api/users/users_login_tests.robot:44
    [Tags]    users    login    error    400    missing-fields
    Login With Missing Username Should Fail

Login With Missing Password Should Fail
    [Documentation]    Login attempt with missing password field should return 400 error
    ...                UC-USER-001-E1 - File: tests/api/users/users_login_tests.robot:49
    [Tags]    users    login    error    400    missing-fields
    Login With Missing Password Should Fail

Login With Null Values Should Fail
    [Documentation]    Login attempt with null username and password should return 400 error
    ...                UC-USER-001-E1 - File: tests/api/users/users_login_tests.robot:54
    [Tags]    users    login    error    400    null-values
    Login With Null Values Should Fail