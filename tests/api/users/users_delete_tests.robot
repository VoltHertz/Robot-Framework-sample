*** Settings ***
Documentation    Users Delete Tests - UC-USER-007
...              Business logic focused test suite for deleting users functionality (simulated)
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/users/users_delete_tests.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service
Test Teardown    Cleanup Users Service

*** Test Cases ***
# UC-USER-007: Delete User Success Tests (Simulated)
Delete User With Valid ID Should Succeed
    [Documentation]    Should successfully delete user with valid ID (simulated operation)
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:12
    [Tags]    users    delete-user    success    smoke    simulated
    Delete User With Valid ID    1

Delete Different Valid Users Should Succeed
    [Documentation]    Should delete multiple different users with valid IDs
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:18
    [Tags]    users    delete-user    success    multiple-users    simulated
    Delete User With Valid ID    2
    Delete User With Valid ID    3
    Delete User With Valid ID    5
    Delete User With Valid ID    10

Delete User Should Return Deletion Confirmation
    [Documentation]    Delete response should confirm the deletion operation
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:26
    [Tags]    users    delete-user    success    confirmation    simulated
    _Execute Delete User Request    15
    _Validate User Deletion Response    15
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    15
    Dictionary Should Contain Key    ${response_json}    isDeleted
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Be True    ${response_json['isDeleted']}
    Should Not Be Empty    ${response_json['deletedOn']}

Delete User Should Include Timestamp
    [Documentation]    Delete response should include deletion timestamp
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:38
    [Tags]    users    delete-user    success    timestamp    simulated
    _Execute Delete User Request    20
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Not Be Empty    ${response_json['deletedOn']}
    Should Match Regexp    ${response_json['deletedOn']}    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}

Delete User Should Preserve Original User Data
    [Documentation]    Delete response should include original user data with deletion flags
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:48
    [Tags]    users    delete-user    success    preserve-data    simulated
    _Execute Delete User Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    1
    Dictionary Should Contain Key    ${response_json}    firstName
    Dictionary Should Contain Key    ${response_json}    lastName
    Dictionary Should Contain Key    ${response_json}    email
    Should Not Be Empty    ${response_json['firstName']}
    Should Not Be Empty    ${response_json['lastName']}
    Should Not Be Empty    ${response_json['email']}

# UC-USER-007: Delete User Error Tests - UC-USER-007-E1  
Delete Non-Existent User Should Return 404
    [Documentation]    Should return 404 error when attempting to delete non-existent user
    ...                UC-USER-007-E1 - File: tests/api/users/users_delete_tests.robot:63
    [Tags]    users    delete-user    error    404    non-existent
    Delete Non-Existent User

Delete User With Negative ID Should Return 404
    [Documentation]    Should return 404 error for negative user ID
    ...                UC-USER-007-E1 - File: tests/api/users/users_delete_tests.robot:69
    [Tags]    users    delete-user    error    404    negative-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    negative_id
    _Execute Delete User Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Delete User With Zero ID Should Return 404
    [Documentation]    Should return 404 error for user ID 0
    ...                UC-USER-007-E1 - File: tests/api/users/users_delete_tests.robot:77
    [Tags]    users    delete-user    error    404    zero-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    zero_id
    _Execute Delete User Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Delete User With Text ID Should Return 404
    [Documentation]    Should return 404 error for text-based user ID
    ...                UC-USER-007-E1 - File: tests/api/users/users_delete_tests.robot:85
    [Tags]    users    delete-user    error    404    text-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    text_id
    _Execute Delete User Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Delete User With Special Characters ID Should Return 404
    [Documentation]    Should return 404 error for special characters user ID
    ...                UC-USER-007-E1 - File: tests/api/users/users_delete_tests.robot:93
    [Tags]    users    delete-user    error    404    special-chars
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    special_chars_id
    _Execute Delete User Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Delete User With Extremely Large ID Should Return 404
    [Documentation]    Should return 404 error for extremely large user ID
    ...                UC-USER-007-E1 - File: tests/api/users/users_delete_tests.robot:101
    [Tags]    users    delete-user    error    404    large-id
    ${large_id}=    Set Variable    999999999
    _Execute Delete User Request    ${large_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    404
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    message
    Should Be Equal As Strings    ${response_json['message']}    User not found

# UC-USER-007: Delete Response Validation Tests
Delete User Response Should Have Correct Structure
    [Documentation]    Delete response should have all required fields and correct structure
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:112
    [Tags]    users    delete-user    success    response-validation    structure
    _Execute Delete User Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Dictionary Should Contain Key    ${response_json}    isDeleted
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Be True    isinstance($response_json['id'], int)
    Should Be True    isinstance($response_json['isDeleted'], bool)
    Should Be True    isinstance($response_json['deletedOn'], str)

Delete User Response Should Have Correct Boolean Values
    [Documentation]    Delete response should have correct boolean values for deletion flags
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:125
    [Tags]    users    delete-user    success    response-validation    boolean-values
    _Execute Delete User Request    2
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['isDeleted']}
    Should Be Equal As Strings    ${response_json['isDeleted']}    True

Delete User Response Should Have Valid Timestamp Format
    [Documentation]    Delete response should have valid ISO timestamp format
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:134
    [Tags]    users    delete-user    success    response-validation    timestamp-format
    _Execute Delete User Request    3
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Match Regexp    ${response_json['deletedOn']}    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z

# UC-USER-007: Delete User Edge Cases
Delete Same User Multiple Times Should Succeed In Simulation
    [Documentation]    Should handle multiple deletion attempts of same user in simulation
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:144
    [Tags]    users    delete-user    success    edge-case    multiple-deletes    simulated
    ${target_id}=    Set Variable    10
    
    _Execute Delete User Request    ${target_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${first_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${first_response['isDeleted']}
    
    _Execute Delete User Request    ${target_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${second_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${second_response['isDeleted']}

Delete User Should Not Affect Other Users In Simulation
    [Documentation]    Deleting one user should not affect other users in simulation
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:158
    [Tags]    users    delete-user    success    edge-case    isolation    simulated
    _Execute Delete User Request    5
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${deleted_user}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${deleted_user['isDeleted']}
    Should Be Equal As Numbers    ${deleted_user['id']}    5
    
    _Execute Delete User Request    6
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${other_user}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${other_user['isDeleted']}
    Should Be Equal As Numbers    ${other_user['id']}    6
    Should Not Be Equal As Numbers    ${deleted_user['id']}    ${other_user['id']}

Delete User Performance Should Be Reasonable
    [Documentation]    Delete operation should complete within reasonable time
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:173
    [Tags]    users    delete-user    success    performance
    ${start_time}=    Get Time    epoch
    _Execute Delete User Request    1
    ${end_time}=    Get Time    epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200

Delete User Should Handle Large Valid IDs
    [Documentation]    Should handle deletion of users with large but valid IDs
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:184
    [Tags]    users    delete-user    success    edge-case    large-valid-id
    ${large_valid_id}=    Get From List    ${valid_user_ids}    -1
    _Execute Delete User Request    ${large_valid_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${large_valid_id}
    Should Be True    ${response_json['isDeleted']}

# UC-USER-007: Delete User Batch Operations
Delete Multiple Users In Sequence Should Succeed
    [Documentation]    Should handle sequential deletion of multiple users
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:196
    [Tags]    users    delete-user    success    batch-operations    simulated
    ${user_ids}=    Create List    1    2    3    4    5
    FOR    ${user_id}    IN    @{user_ids}
        _Execute Delete User Request    ${user_id}
        Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
        ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
        Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
        Should Be True    ${response_json['isDeleted']}
        Should Not Be Empty    ${response_json['deletedOn']}
    END

Delete Users From Valid ID List Should All Succeed
    [Documentation]    Should successfully delete all users from valid ID list
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:209
    [Tags]    users    delete-user    success    all-valid-ids    simulated
    FOR    ${user_id}    IN    @{valid_user_ids}
        _Execute Delete User Request    ${user_id}
        Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
        _Validate User Deletion Response    ${user_id}
    END

# UC-USER-007: Delete User Response Content Validation
Delete User Should Return Complete User Object
    [Documentation]    Delete response should include complete user object data
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:219
    [Tags]    users    delete-user    success    response-validation    complete-object
    _Execute Delete User Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${field}    IN    id    firstName    lastName    email    username    age    gender
        Dictionary Should Contain Key    ${response_json}    ${field}
        Should Not Be Empty    ${response_json['${field}']}
    END
    Dictionary Should Contain Key    ${response_json}    isDeleted
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Be True    ${response_json['isDeleted']}
    Should Not Be Empty    ${response_json['deletedOn']}

Delete User Should Maintain Data Integrity
    [Documentation]    Delete response should maintain original user data integrity
    ...                UC-USER-007 - File: tests/api/users/users_delete_tests.robot:234
    [Tags]    users    delete-user    success    data-integrity    simulated
    _Execute Delete User Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    1
    Should Be True    ${response_json['age']} > 0
    Should Contain    ${response_json['email']}    @
    Should Not Be Equal As Strings    ${response_json['firstName']}    ${EMPTY}
    Should Not Be Equal As Strings    ${response_json['lastName']}    ${EMPTY}