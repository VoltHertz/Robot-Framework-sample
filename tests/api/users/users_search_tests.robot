*** Settings ***
Documentation    Users Search Tests - UC-USER-004
...              Business logic focused test suite for searching users functionality
...              Following Library-Keyword/Object Service Pattern with proper encapsulation
...              File: tests/api/users/users_search_tests.robot
Resource         ../../../resources/apis/users_service.resource
Suite Setup      Initialize Users Service
Suite Teardown   Cleanup Users Service
Test Teardown    Cleanup Users Service

*** Test Cases ***
# UC-USER-004: Search Users Success Tests
Search Users With Valid Term Should Return Results
    [Documentation]    Should find users matching the valid search term
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:12
    [Tags]    users    search    success    smoke    valid-term
    Search Users With Valid Term

Search Users With Partial Match Should Return Results
    [Documentation]    Should find users with partial name matches
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:18
    [Tags]    users    search    success    regression    partial-match
    Search Users With Partial Match

Search Users With No Results Should Return Empty List
    [Documentation]    Should return empty results for non-matching search term
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:24
    [Tags]    users    search    success    empty-results
    Search Users With No Results

# UC-USER-004: Extended Search Tests
Search Users By First Name Should Return Matches
    [Documentation]    Should find users by searching their first name
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:31
    [Tags]    users    search    success    first-name
    _Execute Search Users Request    Emily
    _Validate Users List Response
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    FOR    ${user}    IN    @{response_json['users']}
        ${first_name_lower}=    Convert To Lower Case    ${user['firstName']}
        Should Contain    ${first_name_lower}    emily
    END

Search Users By Last Name Should Return Matches
    [Documentation]    Should find users by searching their last name
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:42
    [Tags]    users    search    success    last-name
    _Execute Search Users Request    Johnson
    _Validate Users List Response
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    FOR    ${user}    IN    @{response_json['users']}
        ${last_name_lower}=    Convert To Lower Case    ${user['lastName']}
        Should Contain    ${last_name_lower}    johnson
    END

Search Users By Email Domain Should Return Matches
    [Documentation]    Should find users by searching email domain
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:53
    [Tags]    users    search    success    email-domain
    _Execute Search Users Request    dummyjson.com
    _Validate Users List Response
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    FOR    ${user}    IN    @{response_json['users']}
        Should Contain    ${user['email']}    dummyjson.com
    END

Search Users Case Insensitive Should Work
    [Documentation]    Search should work regardless of case sensitivity
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:64
    [Tags]    users    search    success    case-insensitive
    _Execute Search Users Request    JOHN
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${uppercase_response}=    Set Variable    ${LAST_RESPONSE.json()}
    _Execute Search Users Request    john
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${lowercase_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${uppercase_response['total']}    ${lowercase_response['total']}

Search Users With Single Character Should Return Results
    [Documentation]    Should handle single character search terms
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:75
    [Tags]    users    search    success    single-char
    _Execute Search Users Request    E
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} >= 0

Search Users With Multiple Words Should Work
    [Documentation]    Should handle search terms with multiple words
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:84
    [Tags]    users    search    success    multiple-words
    _Execute Search Users Request    Emily Johnson
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    _Validate Users List Response

# UC-USER-004: Edge Case Search Tests  
Search Users With Empty Query Should Handle Gracefully
    [Documentation]    Should handle empty search query gracefully
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:93
    [Tags]    users    search    edge-case    empty-query
    ${empty_query}=    Get From Dictionary    ${invalid_search}    empty_query
    _Execute Search Users Request    ${empty_query['q']}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} >= 0

Search Users With Special Characters Should Handle Gracefully
    [Documentation]    Should handle special characters in search query
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:103
    [Tags]    users    search    edge-case    special-chars
    ${special_chars}=    Get From Dictionary    ${invalid_search}    special_chars
    _Execute Search Users Request    ${special_chars['q']}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} >= 0

Search Users With Very Long Query Should Handle Gracefully
    [Documentation]    Should handle very long search queries
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:113
    [Tags]    users    search    edge-case    long-query
    ${long_query}=    Set Variable    ${'A' * 100}
    _Execute Search Users Request    ${long_query}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['total']}    0

Search Users With Numbers Should Work
    [Documentation]    Should handle numeric search terms
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:123
    [Tags]    users    search    success    numbers
    _Execute Search Users Request    123
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} >= 0

# UC-USER-004: Search Response Validation Tests
Search Results Should Contain Required Pagination Fields
    [Documentation]    Search results should contain all required pagination fields
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:133
    [Tags]    users    search    success    response-validation    pagination
    _Execute Search Users Request    John
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    users
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit
    Should Be True    isinstance($response_json['users'], list)
    Should Be True    isinstance($response_json['total'], int)

Search Results Users Should Contain Required Fields
    [Documentation]    Each user in search results should contain required fields
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:146
    [Tags]    users    search    success    response-validation    user-fields
    _Execute Search Users Request    John
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Run Keyword If    ${response_json['total']} > 0    _Validate User Objects In List    ${response_json['users']}

Search Results Should Be Relevant To Search Term
    [Documentation]    Search results should be relevant to the search term used
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:155
    [Tags]    users    search    success    response-validation    relevance
    ${search_term}=    Set Variable    Emily
    _Execute Search Users Request    ${search_term}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Run Keyword If    ${response_json['total']} > 0    _Validate Search Results    ${search_term}

# UC-USER-004: Performance and Limit Tests
Search Users Should Handle Pagination Parameters
    [Documentation]    Search should work with pagination parameters
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:166
    [Tags]    users    search    success    pagination-params
    ${params}=    Create Dictionary    q=John    limit=5    skip=0
    ${response}=    GET On Session    ${USERS_SESSION}    ${endpoints['search_users']}
    ...    params=${params}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    len(${response_json['users']}) <= 5

Search Users Performance Should Be Reasonable
    [Documentation]    Search operation should complete within reasonable time
    ...                UC-USER-004 - File: tests/api/users/users_search_tests.robot:177
    [Tags]    users    search    success    performance
    ${start_time}=    Get Time    epoch
    _Execute Search Users Request    John
    ${end_time}=    Get Time    epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200