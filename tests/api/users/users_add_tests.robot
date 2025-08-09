*** Settings ***
Documentation    Users Add Tests - UC-USER-005
...              Business logic focused test suite for adding new users functionality (simulated)
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/users/users_add_tests.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service
Test Teardown    Cleanup Users Service

*** Test Cases ***
# UC-USER-005: Add New User Success Tests (Simulated)
Add New User With Valid Data Should Succeed
    [Documentation]    Should successfully add a new user with valid data (simulated operation)
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:12
    [Tags]    users    add-user    success    smoke    simulated
    Add New User With Valid Data

Add New User With Minimal Required Fields Should Succeed
    [Documentation]    Should add user with only minimal required fields
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:18
    [Tags]    users    add-user    success    minimal-fields    simulated
    ${minimal_user}=    Create Dictionary
    ...    firstName=Test
    ...    lastName=User  
    ...    age=25
    ...    email=test.user@example.com
    _Execute Add User Request    ${minimal_user}
    _Validate User Creation Response    ${minimal_user}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['id']} > 0
    Should Be Equal As Strings    ${response_json['firstName']}    Test
    Should Be Equal As Strings    ${response_json['lastName']}    User

Add New User With Complete Data Should Succeed
    [Documentation]    Should add user with complete user data
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:32
    [Tags]    users    add-user    success    complete-data    simulated
    ${complete_user}=    Create Dictionary
    ...    firstName=Complete
    ...    lastName=TestUser
    ...    age=30
    ...    email=complete.test@example.com
    ...    phone=+1234567890
    ...    username=completeuser
    ...    password=securepass123
    ...    birthDate=1993-06-15
    ...    gender=male
    _Execute Add User Request    ${complete_user}
    _Validate User Creation Response    ${complete_user}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['id']} > 0

Add New User With Different Age Values Should Succeed
    [Documentation]    Should handle different valid age values
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:48
    [Tags]    users    add-user    success    age-values    simulated
    ${young_user}=    Create Dictionary
    ...    firstName=Young
    ...    lastName=User
    ...    age=18
    ...    email=young@example.com
    _Execute Add User Request    ${young_user}
    _Validate User Creation Response    ${young_user}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['age']}    18

Add New User With Senior Age Should Succeed
    [Documentation]    Should handle senior age users
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:62
    [Tags]    users    add-user    success    senior-age    simulated
    ${senior_user}=    Create Dictionary
    ...    firstName=Senior
    ...    lastName=User
    ...    age=70
    ...    email=senior@example.com
    _Execute Add User Request    ${senior_user}
    _Validate User Creation Response    ${senior_user}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['age']}    70

# UC-USER-005: Add User Data Validation Tests
Add User Response Should Include Generated ID
    [Documentation]    Response should include generated ID for new user
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:76
    [Tags]    users    add-user    success    response-validation    generated-id
    ${test_user}=    Create Dictionary
    ...    firstName=IDTest
    ...    lastName=User
    ...    age=28
    ...    email=idtest@example.com
    _Execute Add User Request    ${test_user}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Should Be True    ${response_json['id']} > 0
    Should Be True    isinstance($response_json['id'], int)

Add User Response Should Echo All Sent Fields
    [Documentation]    Response should echo back all fields that were sent
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:91
    [Tags]    users    add-user    success    response-validation    echo-fields
    ${test_user}=    Create Dictionary
    ...    firstName=Echo
    ...    lastName=Test
    ...    age=35
    ...    email=echo.test@example.com
    ...    phone=+9876543210
    ...    username=echotest
    _Execute Add User Request    ${test_user}
    _Validate User Creation Response    ${test_user}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{test_user}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Should Be Equal As Strings    ${response_json['${key}']}    ${test_user['${key}']}
    END

Add User Should Not Require All Fields
    [Documentation]    Should allow adding user without all optional fields
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:107
    [Tags]    users    add-user    success    optional-fields
    ${basic_user}=    Create Dictionary
    ...    firstName=Basic
    ...    lastName=User
    _Execute Add User Request    ${basic_user}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Should Be Equal As Strings    ${response_json['firstName']}    Basic
    Should Be Equal As Strings    ${response_json['lastName']}    User

# UC-USER-005: Add User Edge Case Tests
Add User With Same Email Should Still Succeed In Simulation
    [Documentation]    Should handle duplicate email in simulation mode
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:122
    [Tags]    users    add-user    success    edge-case    duplicate-email    simulated
    ${duplicate_email_user}=    Create Dictionary
    ...    firstName=Duplicate
    ...    lastName=Email
    ...    age=29
    ...    email=emily.johnson@x.dummyjson.com
    _Execute Add User Request    ${duplicate_email_user}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['email']}    emily.johnson@x.dummyjson.com

Add User With Same Username Should Still Succeed In Simulation
    [Documentation]    Should handle duplicate username in simulation mode
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:135
    [Tags]    users    add-user    success    edge-case    duplicate-username    simulated
    ${duplicate_username_user}=    Create Dictionary
    ...    firstName=Duplicate
    ...    lastName=Username
    ...    age=31
    ...    email=duplicate@example.com
    ...    username=emilys
    _Execute Add User Request    ${duplicate_username_user}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['username']}    emilys

Add User With Special Characters In Name Should Succeed
    [Documentation]    Should handle special characters in user names
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:148
    [Tags]    users    add-user    success    edge-case    special-chars
    ${special_char_user}=    Create Dictionary
    ...    firstName=José
    ...    lastName=O'Connor-Smith
    ...    age=33
    ...    email=jose.oconnor@example.com
    _Execute Add User Request    ${special_char_user}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    José
    Should Be Equal As Strings    ${response_json['lastName']}    O'Connor-Smith

Add User With Different Email Formats Should Succeed
    [Documentation]    Should handle various valid email formats
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:161
    [Tags]    users    add-user    success    email-formats
    ${email_formats}=    Create List
    ...    user@example.com
    ...    user.name@example.com  
    ...    user+tag@example.com
    ...    user123@example-site.com
    ...    user@example.co.uk
    FOR    ${email}    IN    @{email_formats}
        ${email_user}=    Create Dictionary
        ...    firstName=Email
        ...    lastName=Test
        ...    age=26
        ...    email=${email}
        _Execute Add User Request    ${email_user}
        Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
        ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
        Should Be Equal As Strings    ${response_json['email']}    ${email}
    END

# UC-USER-005: Data Persistence Simulation Tests
Add User Multiple Times Should Generate Different IDs
    [Documentation]    Multiple user additions should generate different IDs in simulation
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:181
    [Tags]    users    add-user    success    multiple-additions    id-generation
    ${user1}=    Create Dictionary
    ...    firstName=User1
    ...    lastName=Test
    ...    age=25
    ...    email=user1@example.com
    ${user2}=    Create Dictionary
    ...    firstName=User2
    ...    lastName=Test
    ...    age=26
    ...    email=user2@example.com
    
    _Execute Add User Request    ${user1}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response1}=    Set Variable    ${LAST_RESPONSE.json()}
    
    _Execute Add User Request    ${user2}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response2}=    Set Variable    ${LAST_RESPONSE.json()}
    
    Should Not Be Equal As Numbers    ${response1['id']}    ${response2['id']}
    Should Be True    ${response1['id']} > 0
    Should Be True    ${response2['id']} > 0

Add User Response Time Should Be Reasonable
    [Documentation]    User addition should complete within reasonable time
    ...                UC-USER-005 - File: tests/api/users/users_add_tests.robot:204
    [Tags]    users    add-user    success    performance
    ${performance_user}=    Create Dictionary
    ...    firstName=Performance
    ...    lastName=Test
    ...    age=28
    ...    email=performance@example.com
    ${start_time}=    Get Time    epoch
    _Execute Add User Request    ${performance_user}
    ${end_time}=    Get Time    epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200