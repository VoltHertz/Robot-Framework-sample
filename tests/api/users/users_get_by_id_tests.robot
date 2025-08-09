*** Settings ***
Documentation    Users Get By ID Tests - UC-USER-003
...              Business logic focused test suite for getting user by ID functionality
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/users/users_get_by_id_tests.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service
Test Teardown    Cleanup Users Service

*** Test Cases ***
# UC-USER-003: Get User By ID Success Tests
Get User By Valid ID 1 Should Succeed
    [Documentation]    Should retrieve user details for ID 1 successfully
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:12
    [Tags]    users    get-by-id    success    smoke    id-1
    Get Valid User By ID    1

Get User By Valid ID 2 Should Succeed
    [Documentation]    Should retrieve user details for ID 2 successfully
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:18
    [Tags]    users    get-by-id    success    regression    id-2
    Get Valid User By ID    2

Get User By Valid ID 5 Should Succeed
    [Documentation]    Should retrieve user details for ID 5 successfully
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:24
    [Tags]    users    get-by-id    success    regression    id-5
    Get Valid User By ID    5

Get User By Valid ID 10 Should Succeed
    [Documentation]    Should retrieve user details for ID 10 successfully
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:30
    [Tags]    users    get-by-id    success    regression    id-10
    Get Valid User By ID    10

Get User By Valid ID 15 Should Succeed
    [Documentation]    Should retrieve user details for ID 15 successfully
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:36
    [Tags]    users    get-by-id    success    edge-case    id-15
    Get Valid User By ID    15

# UC-USER-003: Get User By ID Error Tests - UC-USER-003-E1
Get User By Non-Existent ID Should Return 404
    [Documentation]    Should return 404 error for non-existent user ID
    ...                UC-USER-003-E1 - File: tests/api/users/users_get_by_id_tests.robot:43
    [Tags]    users    get-by-id    error    404    non-existent
    Get Non-Existent User By ID

Get User By Negative ID Should Return 404
    [Documentation]    Should return 404 error for negative user ID
    ...                UC-USER-003-E1 - File: tests/api/users/users_get_by_id_tests.robot:49
    [Tags]    users    get-by-id    error    404    negative-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    negative_id
    _Execute Get User By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Get User By Zero ID Should Return 404
    [Documentation]    Should return 404 error for user ID 0
    ...                UC-USER-003-E1 - File: tests/api/users/users_get_by_id_tests.robot:57
    [Tags]    users    get-by-id    error    404    zero-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    zero_id
    _Execute Get User By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Get User By Text ID Should Return 404
    [Documentation]    Should return 404 error for text-based user ID
    ...                UC-USER-003-E1 - File: tests/api/users/users_get_by_id_tests.robot:65
    [Tags]    users    get-by-id    error    404    text-id
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    text_id
    _Execute Get User By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Get User By Special Characters ID Should Return 404
    [Documentation]    Should return 404 error for special characters user ID
    ...                UC-USER-003-E1 - File: tests/api/users/users_get_by_id_tests.robot:73
    [Tags]    users    get-by-id    error    404    special-chars
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    special_chars_id
    _Execute Get User By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

# UC-USER-003: Response Structure Validation Tests
User By ID Response Should Contain All Required Fields
    [Documentation]    User by ID response should contain all required user fields
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:82
    [Tags]    users    get-by-id    success    response-validation    complete-fields
    _Execute Get User By ID Request    1
    _Validate Single User Response
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${field}    IN    @{expected_response_fields}
        Dictionary Should Contain Key    ${response_json}    ${field}
    END

User By ID Response Should Have Correct Data Types
    [Documentation]    User by ID response should have correct data types for all fields
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:92
    [Tags]    users    get-by-id    success    response-validation    data-types
    _Execute Get User By ID Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    isinstance($response_json['id'], int)
    Should Be True    isinstance($response_json['firstName'], str)
    Should Be True    isinstance($response_json['lastName'], str)
    Should Be True    isinstance($response_json['email'], str)
    Should Be True    isinstance($response_json['username'], str)
    Should Be True    isinstance($response_json['age'], int)
    Should Be True    isinstance($response_json['gender'], str)
    Should Be True    isinstance($response_json['phone'], str)
    Should Be True    isinstance($response_json['height'], (int, float))
    Should Be True    isinstance($response_json['weight'], (int, float))

User By ID Response Should Have Valid Email Format
    [Documentation]    User by ID response should contain valid email format
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:107
    [Tags]    users    get-by-id    success    response-validation    email-format
    _Execute Get User By ID Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Contain    ${response_json['email']}    @
    Should Match Regexp    ${response_json['email']}    ^[\\w\\.-]+@[\\w\\.-]+\\.[a-zA-Z]{2,}$

User By ID Response Should Have Nested Objects Structure
    [Documentation]    User by ID response should contain properly structured nested objects
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:116
    [Tags]    users    get-by-id    success    response-validation    nested-objects
    _Execute Get User By ID Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    address
    Dictionary Should Contain Key    ${response_json}    hair
    Dictionary Should Contain Key    ${response_json}    bank
    Dictionary Should Contain Key    ${response_json}    company
    Dictionary Should Contain Key    ${response_json}    crypto
    Dictionary Should Contain Key    ${response_json['address']}    coordinates
    Should Be True    isinstance($response_json['address'], dict)
    Should Be True    isinstance($response_json['hair'], dict)
    Should Be True    isinstance($response_json['bank'], dict)
    Should Be True    isinstance($response_json['company'], dict)
    Should Be True    isinstance($response_json['crypto'], dict)

# UC-USER-003: Edge Case Tests
Get User By Maximum Valid ID Should Succeed
    [Documentation]    Should handle request for maximum valid user ID
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:133
    [Tags]    users    get-by-id    success    edge-case    max-id
    ${max_id}=    Get From List    ${valid_user_ids}    -1
    _Execute Get User By ID Request    ${max_id}
    _Validate Single User Response
    _Validate User ID Matches    ${max_id}

Get User By Different Valid IDs Should All Have Unique Data
    [Documentation]    Different valid user IDs should return different user data
    ...                UC-USER-003 - File: tests/api/users/users_get_by_id_tests.robot:142
    [Tags]    users    get-by-id    success    regression    unique-data
    ${user_1_response}=    _Execute Get User By ID And Return Response    1
    ${user_2_response}=    _Execute Get User By ID And Return Response    2
    Should Not Be Equal    ${user_1_response['firstName']}    ${user_2_response['firstName']}
    Should Not Be Equal    ${user_1_response['email']}    ${user_2_response['email']}
    Should Not Be Equal    ${user_1_response['username']}    ${user_2_response['username']}

*** Keywords ***
_Execute Get User By ID And Return Response
    [Documentation]    Helper keyword to execute get user by ID and return response JSON
    [Arguments]    ${user_id}
    _Execute Get User By ID Request    ${user_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    [Return]    ${response_json}