*** Settings ***
Documentation    Users Update Tests - UC-USER-006
...              Business logic focused test suite for updating users functionality (simulated)
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/users/users_update_tests.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service
Test Teardown    Cleanup Users Service

*** Test Cases ***
# UC-USER-006: Update User Success Tests (Simulated)
Update User With Valid Data Should Succeed
    [Documentation]    Should successfully update user with valid data (simulated operation)
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:12
    [Tags]    users    update-user    success    smoke    simulated
    Update User With Valid Data    1

Update User With Partial Data Should Succeed
    [Documentation]    Should update user with only some fields provided
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:18
    [Tags]    users    update-user    success    partial-update    simulated
    ${partial_data}=    Create Dictionary
    ...    firstName=Updated Name
    ...    age=35
    _Execute Update User Request    2    ${partial_data}
    _Validate User Update Response    2    ${partial_data}

Update User First Name Only Should Succeed
    [Documentation]    Should update only user's first name
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:27
    [Tags]    users    update-user    success    first-name-only    simulated
    ${name_update}=    Create Dictionary    firstName=NewFirstName
    _Execute Update User Request    3    ${name_update}
    _Validate User Update Response    3    ${name_update}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    NewFirstName
    Should Be Equal As Numbers    ${response_json['id']}    3

Update User Last Name Only Should Succeed
    [Documentation]    Should update only user's last name
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:37
    [Tags]    users    update-user    success    last-name-only    simulated
    ${name_update}=    Create Dictionary    lastName=NewLastName
    _Execute Update User Request    4    ${name_update}
    _Validate User Update Response    4    ${name_update}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['lastName']}    NewLastName

Update User Email Only Should Succeed
    [Documentation]    Should update only user's email address
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:47
    [Tags]    users    update-user    success    email-only    simulated
    ${email_update}=    Create Dictionary    email=newemail@example.com
    _Execute Update User Request    5    ${email_update}
    _Validate User Update Response    5    ${email_update}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['email']}    newemail@example.com

Update User Age Only Should Succeed
    [Documentation]    Should update only user's age
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:57
    [Tags]    users    update-user    success    age-only    simulated
    ${age_update}=    Create Dictionary    age=45
    _Execute Update User Request    6    ${age_update}
    _Validate User Update Response    6    ${age_update}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['age']}    45

Update User Phone Only Should Succeed
    [Documentation]    Should update only user's phone number
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:67
    [Tags]    users    update-user    success    phone-only    simulated
    ${phone_update}=    Create Dictionary    phone=+1-555-123-4567
    _Execute Update User Request    7    ${phone_update}
    _Validate User Update Response    7    ${phone_update}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['phone']}    +1-555-123-4567

# UC-USER-006: Update User With Different Data Types
Update User With Different Age Values Should Succeed
    [Documentation]    Should handle different valid age values during update
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:78
    [Tags]    users    update-user    success    age-values    simulated
    ${young_age}=    Create Dictionary    age=21
    _Execute Update User Request    8    ${young_age}
    _Validate User Update Response    8    ${young_age}
    
    ${senior_age}=    Create Dictionary    age=65
    _Execute Update User Request    9    ${senior_age}
    _Validate User Update Response    9    ${senior_age}
    
    ${middle_age}=    Create Dictionary    age=40
    _Execute Update User Request    10    ${middle_age}
    _Validate User Update Response    10    ${middle_age}

Update User With Different Email Formats Should Succeed
    [Documentation]    Should handle various valid email formats during update
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:92
    [Tags]    users    update-user    success    email-formats    simulated
    ${email_formats}=    Create List
    ...    updated@domain.com
    ...    user.updated@example.org
    ...    updated+test@example.net
    ...    user123@example-domain.co.uk
    ${user_id}=    Set Variable    11
    FOR    ${email}    IN    @{email_formats}
        ${email_update}=    Create Dictionary    email=${email}
        _Execute Update User Request    ${user_id}    ${email_update}
        _Validate User Update Response    ${user_id}    ${email_update}
        ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
        Should Be Equal As Strings    ${response_json['email']}    ${email}
        ${user_id}=    Evaluate    ${user_id} + 1
    END

Update User With Special Characters In Names Should Succeed
    [Documentation]    Should handle special characters in name updates
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:108
    [Tags]    users    update-user    success    special-chars    simulated
    ${special_names}=    Create Dictionary
    ...    firstName=José María
    ...    lastName=O'Connor-Smith
    _Execute Update User Request    15    ${special_names}
    _Validate User Update Response    15    ${special_names}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    José María
    Should Be Equal As Strings    ${response_json['lastName']}    O'Connor-Smith

# UC-USER-006: Update User Error Tests - UC-USER-006-E1
Update Non-Existent User Should Return 404
    [Documentation]    Should return 404 error when attempting to update non-existent user
    ...                UC-USER-006-E1 - File: tests/api/users/users_update_tests.robot:121
    [Tags]    users    update-user    error    404    non-existent
    Update Non-Existent User

Update User With Negative ID Should Return 404
    [Documentation]    Should return 404 error for negative user ID
    ...                UC-USER-006-E1 - File: tests/api/users/users_update_tests.robot:127
    [Tags]    users    update-user    error    404    negative-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    negative_id
    ${update_data}=    Create Dictionary    firstName=Test    lastName=Update
    _Execute Update User Request    ${invalid_data['id']}    ${update_data}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Update User With Zero ID Should Return 404
    [Documentation]    Should return 404 error for user ID 0
    ...                UC-USER-006-E1 - File: tests/api/users/users_update_tests.robot:136
    [Tags]    users    update-user    error    404    zero-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    zero_id
    ${update_data}=    Create Dictionary    firstName=Test    lastName=Update
    _Execute Update User Request    ${invalid_data['id']}    ${update_data}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Update User With Text ID Should Return 404
    [Documentation]    Should return 404 error for text-based user ID
    ...                UC-USER-006-E1 - File: tests/api/users/users_update_tests.robot:145
    [Tags]    users    update-user    error    404    text-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    text_id
    ${update_data}=    Create Dictionary    firstName=Test    lastName=Update
    _Execute Update User Request    ${invalid_data['id']}    ${update_data}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Update User With Special Characters ID Should Return 404
    [Documentation]    Should return 404 error for special characters user ID
    ...                UC-USER-006-E1 - File: tests/api/users/users_update_tests.robot:154
    [Tags]    users    update-user    error    404    special-chars
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    special_chars_id
    ${update_data}=    Create Dictionary    firstName=Test    lastName=Update
    _Execute Update User Request    ${invalid_data['id']}    ${update_data}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

# UC-USER-006: Update Response Validation Tests
Update User Response Should Preserve User ID
    [Documentation]    Update response should preserve the original user ID
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:164
    [Tags]    users    update-user    success    response-validation    preserve-id
    ${original_id}=    Set Variable    20
    ${update_data}=    Create Dictionary
    ...    firstName=Preserved
    ...    lastName=ID
    ...    age=30
    _Execute Update User Request    ${original_id}    ${update_data}
    _Validate User Update Response    ${original_id}    ${update_data}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${original_id}

Update User Response Should Echo Updated Fields Only
    [Documentation]    Update response should reflect only the fields that were updated
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:177
    [Tags]    users    update-user    success    response-validation    echo-fields
    ${update_fields}=    Create Dictionary
    ...    firstName=EchoTest
    ...    email=echo@test.com
    _Execute Update User Request    1    ${update_fields}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    EchoTest
    Should Be Equal As Strings    ${response_json['email']}    echo@test.com

Update User With Empty Data Should Handle Gracefully
    [Documentation]    Should handle update requests with empty data gracefully
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:189
    [Tags]    users    update-user    edge-case    empty-data    simulated
    ${empty_data}=    Create Dictionary
    _Execute Update User Request    1    ${empty_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    1

# UC-USER-006: Update User Multiple Operations Tests
Update Same User Multiple Times Should Succeed
    [Documentation]    Should allow multiple updates to the same user in simulation
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:199
    [Tags]    users    update-user    success    multiple-updates    simulated
    ${target_id}=    Set Variable    1
    
    ${first_update}=    Create Dictionary    firstName=FirstUpdate
    _Execute Update User Request    ${target_id}    ${first_update}
    _Validate User Update Response    ${target_id}    ${first_update}
    
    ${second_update}=    Create Dictionary    lastName=SecondUpdate
    _Execute Update User Request    ${target_id}    ${second_update}
    _Validate User Update Response    ${target_id}    ${second_update}
    
    ${third_update}=    Create Dictionary    age=50
    _Execute Update User Request    ${target_id}    ${third_update}
    _Validate User Update Response    ${target_id}    ${third_update}

Update User Performance Should Be Reasonable
    [Documentation]    Update operation should complete within reasonable time
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:215
    [Tags]    users    update-user    success    performance
    ${performance_update}=    Create Dictionary
    ...    firstName=Performance
    ...    lastName=Test
    ...    age=33
    ${start_time}=    Get Time    epoch
    _Execute Update User Request    1    ${performance_update}
    ${end_time}=    Get Time    epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200

# UC-USER-006: Update User Edge Cases
Update User With Same Data Should Succeed
    [Documentation]    Should handle updating user with same existing data
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:230
    [Tags]    users    update-user    success    edge-case    same-data
    ${existing_data}=    Create Dictionary
    ...    firstName=Emily
    ...    lastName=Johnson
    ...    email=emily.johnson@x.dummyjson.com
    _Execute Update User Request    1    ${existing_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    Emily
    Should Be Equal As Strings    ${response_json['lastName']}    Johnson

Update User With Very Long Names Should Succeed
    [Documentation]    Should handle very long name values
    ...                UC-USER-006 - File: tests/api/users/users_update_tests.robot:243
    [Tags]    users    update-user    success    edge-case    long-names
    ${long_names}=    Create Dictionary
    ...    firstName=${'VeryLongFirstName' * 5}
    ...    lastName=${'VeryLongLastName' * 5}
    _Execute Update User Request    1    ${long_names}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    ${long_names['firstName']}
    Should Be Equal As Strings    ${response_json['lastName']}    ${long_names['lastName']}