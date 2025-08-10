*** Settings ***
Documentation    Users Get All Tests - UC-USER-002
...              Business logic focused test suite for getting all users functionality
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/users/users_get_all_tests.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service
Test Teardown    Cleanup Users Service

*** Test Cases ***
# UC-USER-002: Get All Users Business Tests
Get All Users With Default Pagination Should Succeed
    [Documentation]    Should retrieve all users with default pagination settings
    ...                UC-USER-002 - File: tests/api/users/users_get_all_tests.robot:12
    [Tags]    users    get-all    success    smoke    pagination
    Get All Users With Default Pagination

Get All Users With Custom Pagination Should Succeed
    [Documentation]    Should retrieve users with custom limit and skip parameters
    ...                UC-USER-002-A1 - File: tests/api/users/users_get_all_tests.robot:18
    [Tags]    users    get-all    success    regression    custom-pagination
    Get Users With Custom Pagination

Get All Users With Ascending Sort Should Succeed
    [Documentation]    Should retrieve users sorted by firstName in ascending order
    ...                UC-USER-002-A2 - File: tests/api/users/users_get_all_tests.robot:24
    [Tags]    users    get-all    success    regression    sorting    asc
    Get Users With Sorting

# UC-USER-002: Extended Pagination Tests
Get Users With Large Limit Should Succeed
    [Documentation]    Should handle requests with large limit parameter
    ...                UC-USER-002-A1 - File: tests/api/users/users_get_all_tests.robot:31
    [Tags]    users    get-all    success    edge-case    large-limit
    Get All Users With Large Limit

Get Users With High Skip Should Succeed
    [Documentation]    Should handle requests with high skip parameter
    ...                UC-USER-002-A1 - File: tests/api/users/users_get_all_tests.robot:40
    [Tags]    users    get-all    success    edge-case    high-skip
    _Execute Get All Users Request    limit=10    skip=50
    _Validate Users List Response
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['skip']}    50
    Should Be Equal As Numbers    ${response_json['limit']}    10

Get Users With Zero Limit Should Use Default
    [Documentation]    Should use default pagination when limit is 0
    ...                UC-USER-002-A1 - File: tests/api/users/users_get_all_tests.robot:49
    [Tags]    users    get-all    success    edge-case    zero-limit
    _Execute Get All Users Request    limit=0    skip=0
    _Validate Users List Response
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['limit']} > 0
    Should Be True    len(${response_json['users']}) > 0

# UC-USER-002: Sorting Tests
Get Users Sorted By LastName Ascending Should Succeed
    [Documentation]    Should retrieve users sorted by lastName in ascending order
    ...                UC-USER-002-A2 - File: tests/api/users/users_get_all_tests.robot:59
    [Tags]    users    get-all    success    regression    sorting    lastname    asc
    _Execute Get All Users Request    sortBy=lastName    order=asc
    _Validate Users List Response
    _Validate Users Sorting    lastName    asc

Get Users Sorted By Age Descending Should Succeed
    [Documentation]    Should retrieve users sorted by age in descending order
    ...                UC-USER-002-A2 - File: tests/api/users/users_get_all_tests.robot:67
    [Tags]    users    get-all    success    regression    sorting    age    desc
    _Execute Get All Users Request    sortBy=age    order=desc
    _Validate Users List Response
    _Validate Users Sorting    age    desc

Get Users Sorted By Email Ascending Should Succeed
    [Documentation]    Should retrieve users sorted by email in ascending order
    ...                UC-USER-002-A2 - File: tests/api/users/users_get_all_tests.robot:75
    [Tags]    users    get-all    success    regression    sorting    email    asc
    _Execute Get All Users Request    sortBy=email    order=asc
    _Validate Users List Response
    _Validate Users Sorting    email    asc

# UC-USER-002: Invalid Parameters Tests
Get Users With Invalid Sorting Field Should Handle Gracefully
    [Documentation]    Should handle invalid sortBy field gracefully
    ...                UC-USER-002 - File: tests/api/users/users_get_all_tests.robot:84
    [Tags]    users    get-all    edge-case    invalid-sort
    ${invalid_sort}=    Get From Dictionary    ${invalid_sorting}    invalid_sortby
    _Execute Get All Users Request    sortBy=${invalid_sort['sortBy']}    order=${invalid_sort['order']}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    _Validate Users List Response

Get Users With Invalid Sort Order Should Handle Gracefully
    [Documentation]    Should handle invalid sort order gracefully
    ...                UC-USER-002 - File: tests/api/users/users_get_all_tests.robot:93
    [Tags]    users    get-all    edge-case    invalid-order
    ${invalid_sort}=    Get From Dictionary    ${invalid_sorting}    invalid_order
    _Execute Get All Users Request    sortBy=${invalid_sort['sortBy']}    order=${invalid_sort['order']}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    _Validate Users List Response

# UC-USER-002: Response Structure Validation Tests
Users List Response Should Contain Required Fields
    [Documentation]    Users list response should contain all required pagination fields
    ...                UC-USER-002 - File: tests/api/users/users_get_all_tests.robot:102
    [Tags]    users    get-all    success    response-validation
    _Execute Get All Users Request
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    users
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit
    Should Be True    isinstance($response_json['users'], list)
    Should Be True    isinstance($response_json['total'], int)
    Should Be True    isinstance($response_json['skip'], int)
    Should Be True    isinstance($response_json['limit'], int)

Each User Object Should Contain Required Fields
    [Documentation]    Each user object should contain all required user fields
    ...                UC-USER-002 - File: tests/api/users/users_get_all_tests.robot:116
    [Tags]    users    get-all    success    response-validation    user-fields
    _Execute Get All Users Request    limit=5
    _Validate Users List Response
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${user}    IN    @{response_json['users']}
        FOR    ${field}    IN    id    firstName    lastName    email    username    age    gender    phone
            Dictionary Should Contain Key    ${user}    ${field}
        END
        Should Be True    ${user['id']} > 0
        Should Not Be Empty    ${user['firstName']}
        Should Not Be Empty    ${user['lastName']}
        Should Not Be Empty    ${user['email']}
        Should Not Be Empty    ${user['username']}
        Should Be True    ${user['age']} > 0
    END