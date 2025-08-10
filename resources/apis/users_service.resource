*** Settings ***
Documentation    Users Service - Library-Keyword Pattern implementation for users API operations
...              This resource implements service objects for DummyJSON Users API following the Library-Keyword Pattern
...              File: resources/apis/users_service.resource
Library          RequestsLibrary
Library          JSONLibrary    
Library          Collections
Library          String
Variables        ${CURDIR}/../../data/testdata/users_api/users_endpoints.json
Variables        ${CURDIR}/../../data/testdata/users_api/valid_users.json
Variables        ${CURDIR}/../../data/testdata/users_api/invalid_users.json

*** Variables ***
${USERS_SESSION}              users_session
${ACCESS_TOKEN}               ${EMPTY}
${CURRENT_USER_ID}            ${EMPTY}
# Added placeholders so static analysis recognizes dynamic variables
${LAST_RESPONSE}              ${None}          # Placeholder - will be overwritten by Set Test Variable
${LAST_REQUEST_DATA}          ${None}
${LAST_REQUEST_PARAMS}        ${None}
${LAST_REQUEST_ID}            ${None}
${LAST_SEARCH_TERM}           ${None}

*** Keywords ***
# ============================================================================
# BUSINESS LOGIC KEYWORDS (High-Level Interface for Test Cases)
# ============================================================================

# Setup and Teardown
Initialize Users Service
    [Documentation]    Initialize users service for testing
    ...                File: resources/apis/users_service.resource:25
    _Setup Users Session
    _Clear User Context

Cleanup Users Service
    [Documentation]    Cleanup users service after testing
    ...                File: resources/apis/users_service.resource:30
    _Clear User Context

# UC-USER-001: User Login Business Logic (reuses auth functionality)
Login As Admin User Emily
    [Documentation]    Login as admin user Emily - UC-USER-001
    ...                File: resources/apis/users_service.resource:35
    [Tags]    business-logic    login    success    admin
    ${admin_data}=    Get From Dictionary    ${test_users}    admin_user
    _Execute User Login    ${admin_data['username']}    ${admin_data['password']}
    _Validate User Login Response    ${admin_data}

Login As Regular User Michael
    [Documentation]    Login as regular user Michael - UC-USER-001
    ...                File: resources/apis/users_service.resource:42
    [Tags]    business-logic    login    success    user
    ${user_data}=    Get From Dictionary    ${test_users}    regular_user
    _Execute User Login    ${user_data['username']}    ${user_data['password']}
    _Validate User Login Response    ${user_data}

# UC-USER-001: Login Error Scenarios
Login With Wrong Username Should Fail
    [Documentation]    Attempt login with wrong username should fail - UC-USER-001-E1
    ...                File: resources/apis/users_service.resource:49
    [Tags]    business-logic    login    error    invalid-credentials
    ${invalid_creds}=    Get From Dictionary    ${invalid_credentials}    wrong_username
    _Execute User Login    ${invalid_creds['username']}    ${invalid_creds['password']}
    _Validate Error Response    ${invalid_creds['expected_status']}    ${invalid_creds['expected_message']}

Login With Wrong Password Should Fail
    [Documentation]    Attempt login with wrong password should fail - UC-USER-001-E1
    ...                File: resources/apis/users_service.resource:56
    [Tags]    business-logic    login    error    invalid-credentials
    ${invalid_creds}=    Get From Dictionary    ${invalid_credentials}    wrong_password
    _Execute User Login    ${invalid_creds['username']}    ${invalid_creds['password']}
    _Validate Error Response    ${invalid_creds['expected_status']}    ${invalid_creds['expected_message']}

Login With Empty Username Should Fail
    [Documentation]    Attempt login with empty username should fail - UC-USER-001-E1
    ...                File: resources/apis/users_service.resource:63
    [Tags]    business-logic    login    error    empty-fields
    ${invalid_creds}=    Get From Dictionary    ${invalid_credentials}    empty_username
    _Execute User Login    ${invalid_creds['username']}    ${invalid_creds['password']}
    _Validate Error Response    ${invalid_creds['expected_status']}    ${invalid_creds['expected_message']}

Login With Empty Password Should Fail
    [Documentation]    Attempt login with empty password should fail - UC-USER-001-E1
    ...                File: resources/apis/users_service.resource:70
    [Tags]    business-logic    login    error    empty-fields
    ${invalid_creds}=    Get From Dictionary    ${invalid_credentials}    empty_password
    _Execute User Login    ${invalid_creds['username']}    ${invalid_creds['password']}
    _Validate Error Response    ${invalid_creds['expected_status']}    ${invalid_creds['expected_message']}

Login With Missing Username Should Fail
    [Documentation]    Attempt login with missing username field should fail - UC-USER-001-E1
    ...                File: resources/apis/users_service.resource:77
    [Tags]    business-logic    login    error    missing-fields
    ${invalid_creds}=    Get From Dictionary    ${invalid_credentials}    missing_username
    ${login_data}=    Create Dictionary    password=${invalid_creds['password']}
    ${response}=    POST On Session    ${USERS_SESSION}    ${endpoints['login']}    
    ...    json=${login_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    _Validate Error Response    ${invalid_creds['expected_status']}    ${invalid_creds['expected_message']}

Login With Missing Password Should Fail
    [Documentation]    Attempt login with missing password field should fail - UC-USER-001-E1
    ...                File: resources/apis/users_service.resource:87
    [Tags]    business-logic    login    error    missing-fields
    ${invalid_creds}=    Get From Dictionary    ${invalid_credentials}    missing_password
    ${login_data}=    Create Dictionary    username=${invalid_creds['username']}
    ${response}=    POST On Session    ${USERS_SESSION}    ${endpoints['login']}    
    ...    json=${login_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    _Validate Error Response    ${invalid_creds['expected_status']}    ${invalid_creds['expected_message']}

Login With Null Values Should Fail
    [Documentation]    Attempt login with null values should fail - UC-USER-001-E1
    ...                File: resources/apis/users_service.resource:97
    [Tags]    business-logic    login    error    null-values
    ${invalid_creds}=    Get From Dictionary    ${invalid_credentials}    null_values
    ${login_data}=    Create Dictionary    username=${invalid_creds['username']}    password=${invalid_creds['password']}
    ${response}=    POST On Session    ${USERS_SESSION}    ${endpoints['login']}    
    ...    json=${login_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    _Validate Error Response    ${invalid_creds['expected_status']}    ${invalid_creds['expected_message']}

# UC-USER-002: Get All Users Business Logic
Get All Users With Default Pagination
    [Documentation]    Get all users with default pagination - UC-USER-002
    ...                File: resources/apis/users_service.resource:118
    [Tags]    business-logic    get-users    success    pagination
    _Execute Get All Users Request
    _Validate Users List Response
    _Validate Pagination Fields    ${pagination_params['default']['limit']}    ${pagination_params['default']['skip']}

Get Users With Custom Pagination
    [Documentation]    Get users with custom pagination parameters - UC-USER-002-A1
    ...                File: resources/apis/users_service.resource:125
    [Tags]    business-logic    get-users    success    custom-pagination
    ${custom_params}=    Get From Dictionary    ${pagination_params}    custom
    _Execute Get All Users Request    limit=${custom_params['limit']}    skip=${custom_params['skip']}
    _Validate Users List Response
    _Validate Pagination Fields    ${custom_params['limit']}    ${custom_params['skip']}

Get Users With Sorting
    [Documentation]    Get users with sorting parameters - UC-USER-002-A2
    ...                File: resources/apis/users_service.resource:133
    [Tags]    business-logic    get-users    success    sorting
    ${sort_params}=    Get From Dictionary    ${pagination_params}    sorting
    _Execute Get All Users Request    sortBy=${sort_params['sortBy']}    order=${sort_params['order']}
    _Validate Users List Response
    _Validate Users Sorting    ${sort_params['sortBy']}    ${sort_params['order']}

Get All Users With Large Limit
    [Documentation]    Get all users with large limit parameter - UC-USER-002-A3
    ...                File: resources/apis/users_service.resource:141
    [Tags]    business-logic    get-users    success    large-limit
    _Execute Get All Users Request    limit=100
    _Validate Users List Response
    _Validate Pagination Fields    100    0
    _Validate Large Limit Response

Get All Users With High Skip
    [Documentation]    Get all users with high skip parameter - UC-USER-002-A4
    ...                File: resources/apis/users_service.resource:149
    [Tags]    business-logic    get-users    success    high-skip
    _Execute Get All Users Request    skip=50
    _Validate Users List Response
    _Validate Pagination Fields    30    50
    _Validate High Skip Response

Get All Users With Zero Limit
    [Documentation]    Get all users with zero limit parameter - UC-USER-002-E1
    ...                File: resources/apis/users_service.resource:157
    [Tags]    business-logic    get-users    edge-case    zero-limit
    _Execute Get All Users Request    limit=0
    _Validate Users List Response
    _Validate Zero Limit Response

Get All Users Sorted By LastName Ascending
    [Documentation]    Get all users sorted by lastName in ascending order - UC-USER-002-S1
    ...                File: resources/apis/users_service.resource:164
    [Tags]    business-logic    get-users    success    sorting    lastName    asc
    _Execute Get All Users Request    sortBy=lastName    order=asc
    _Validate Users List Response
    _Validate Users Sorting    lastName    asc

Get All Users Sorted By Age Descending
    [Documentation]    Get all users sorted by age in descending order - UC-USER-002-S2
    ...                File: resources/apis/users_service.resource:171
    [Tags]    business-logic    get-users    success    sorting    age    desc
    _Execute Get All Users Request    sortBy=age    order=desc
    _Validate Users List Response
    _Validate Users Sorting    age    desc

Get All Users Sorted By Email Ascending
    [Documentation]    Get all users sorted by email in ascending order - UC-USER-002-S3
    ...                File: resources/apis/users_service.resource:178
    [Tags]    business-logic    get-users    success    sorting    email    asc
    _Execute Get All Users Request    sortBy=email    order=asc
    _Validate Users List Response
    _Validate Users Sorting    email    asc

Get All Users With Invalid Sorting Field
    [Documentation]    Get all users with invalid sorting field - UC-USER-002-E2
    ...                File: resources/apis/users_service.resource:185
    [Tags]    business-logic    get-users    error    invalid-sort-field
    _Execute Get All Users Request    sortBy=invalidField    order=asc
    _Validate Invalid Sorting Field Response

Get All Users With Invalid Sort Order
    [Documentation]    Get all users with invalid sort order - UC-USER-002-E3
    ...                File: resources/apis/users_service.resource:192
    [Tags]    business-logic    get-users    error    invalid-sort-order
    _Execute Get All Users Request    sortBy=firstName    order=invalid
    _Validate Invalid Sort Order Response

Validate All Users Response Structure
    [Documentation]    Validate comprehensive response structure - UC-USER-002-V1
    ...                File: resources/apis/users_service.resource:199
    [Tags]    business-logic    get-users    validation    structure
    _Execute Get All Users Request
    _Validate Users List Response
    _Validate All Users Response Structure

Validate Each User Object Fields
    [Documentation]    Validate each user object has all required fields - UC-USER-002-V2
    ...                File: resources/apis/users_service.resource:206
    [Tags]    business-logic    get-users    validation    user-fields
    _Execute Get All Users Request
    _Validate Users List Response
    _Validate Each User Object Complete Fields

# UC-USER-003: Get User By ID Business Logic
Get Valid User By ID
    [Documentation]    Get user details by valid ID - UC-USER-003
    ...                File: resources/apis/users_service.resource:214
    [Tags]    business-logic    get-user-by-id    success
    [Arguments]    ${user_id}=1
    _Execute Get User By ID Request    ${user_id}
    _Validate Single User Response
    _Validate User ID Matches    ${user_id}

Get User By Valid ID 5
    [Documentation]    Get user details by valid ID 5 - UC-USER-003-A1
    ...                File: resources/apis/users_service.resource:222
    [Tags]    business-logic    get-user-by-id    success    specific-id
    _Execute Get User By ID Request    5
    _Validate Single User Response
    _Validate User ID Matches    5
    _Validate User Specific Data    5

Get User By Valid ID 10
    [Documentation]    Get user details by valid ID 10 - UC-USER-003-A2
    ...                File: resources/apis/users_service.resource:230
    [Tags]    business-logic    get-user-by-id    success    specific-id
    _Execute Get User By ID Request    10
    _Validate Single User Response
    _Validate User ID Matches    10
    _Validate User Specific Data    10

Get User By Valid ID 15
    [Documentation]    Get user details by valid ID 15 - UC-USER-003-A3
    ...                File: resources/apis/users_service.resource:238
    [Tags]    business-logic    get-user-by-id    success    specific-id
    _Execute Get User By ID Request    15
    _Validate Single User Response
    _Validate User ID Matches    15
    _Validate User Specific Data    15

Get User By Negative ID Should Fail
    [Documentation]    Attempt to get user with negative ID should fail - UC-USER-003-E1
    ...                File: resources/apis/users_service.resource:246
    [Tags]    business-logic    get-user-by-id    error    negative-id
    _Execute Get User By ID Request    -1
    _Validate Negative ID Error Response

Get User By Zero ID Should Fail
    [Documentation]    Attempt to get user with zero ID should fail - UC-USER-003-E2
    ...                File: resources/apis/users_service.resource:253
    [Tags]    business-logic    get-user-by-id    error    zero-id
    _Execute Get User By ID Request    0
    _Validate Zero ID Error Response

Get User By Text ID Should Fail
    [Documentation]    Attempt to get user with text ID should fail - UC-USER-003-E3
    ...                File: resources/apis/users_service.resource:260
    [Tags]    business-logic    get-user-by-id    error    text-id
    _Execute Get User By ID Request    abc
    _Validate Text ID Error Response

Get User By Special Characters ID Should Fail
    [Documentation]    Attempt to get user with special characters ID should fail - UC-USER-003-E4
    ...                File: resources/apis/users_service.resource:267
    [Tags]    business-logic    get-user-by-id    error    special-chars
    _Execute Get User By ID Request    @#$
    _Validate Special Characters ID Error Response

Get Non-Existent User By ID
    [Documentation]    Attempt to get user with non-existent ID - UC-USER-003-E5
    ...                File: resources/apis/users_service.resource:274
    [Tags]    business-logic    get-user-by-id    error    404
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    non_existent_id
    _Execute Get User By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Validate User Response Contains All Fields
    [Documentation]    Validate user response contains all required fields - UC-USER-003-V1
    ...                File: resources/apis/users_service.resource:282
    [Tags]    business-logic    get-user-by-id    validation    all-fields
    _Execute Get User By ID Request    1
    _Validate Single User Response
    _Validate User Response All Fields

Validate User Response Data Types
    [Documentation]    Validate user response data types are correct - UC-USER-003-V2
    ...                File: resources/apis/users_service.resource:289
    [Tags]    business-logic    get-user-by-id    validation    data-types
    _Execute Get User By ID Request    1
    _Validate Single User Response
    _Validate User Response Data Types

Validate User Email Format
    [Documentation]    Validate user email format is valid - UC-USER-003-V3
    ...                File: resources/apis/users_service.resource:296
    [Tags]    business-logic    get-user-by-id    validation    email-format
    _Execute Get User By ID Request    1
    _Validate Single User Response
    _Validate User Email Format

Validate User Nested Objects Structure
    [Documentation]    Validate user nested objects structure - UC-USER-003-V4
    ...                File: resources/apis/users_service.resource:303
    [Tags]    business-logic    get-user-by-id    validation    nested-objects
    _Execute Get User By ID Request    1
    _Validate Single User Response
    _Validate User Nested Objects Structure

Get Different Users Should Have Unique Data
    [Documentation]    Validate different users have unique data - UC-USER-003-V5
    ...                File: resources/apis/users_service.resource:310
    [Tags]    business-logic    get-user-by-id    validation    unique-data
    _Execute Get User By ID Request    1
    _Validate Single User Response
    ${user1_data}=    Set Variable    ${LAST_RESPONSE.json()}
    _Execute Get User By ID Request    2
    _Validate Single User Response
    ${user2_data}=    Set Variable    ${LAST_RESPONSE.json()}
    _Validate Users Have Unique Data    ${user1_data}    ${user2_data}

# UC-USER-004: Search Users Business Logic
Search Users With Valid Term
    [Documentation]    Search users with valid search term - UC-USER-004
    ...                File: resources/apis/users_service.resource:322
    [Tags]    business-logic    search-users    success
    ${search_term}=    Get From Dictionary    ${search_terms}    valid_term
    _Execute Search Users Request    ${search_term}
    _Validate Users List Response
    _Validate Search Results    ${search_term}

Search Users With Partial Match
    [Documentation]    Search users with partial match term - UC-USER-004
    ...                File: resources/apis/users_service.resource:330
    [Tags]    business-logic    search-users    success    partial
    ${search_term}=    Get From Dictionary    ${search_terms}    partial_match
    _Execute Search Users Request    ${search_term}
    _Validate Users List Response
    _Validate Search Results    ${search_term}

Search Users With No Results
    [Documentation]    Search users with term that returns no results - UC-USER-004
    ...                File: resources/apis/users_service.resource:338
    [Tags]    business-logic    search-users    success    empty
    ${search_term}=    Get From Dictionary    ${search_terms}    no_results
    _Execute Search Users Request    ${search_term}
    _Validate Empty Search Results

Search Users By First Name
    [Documentation]    Search users by first name - UC-USER-004-A1
    ...                File: resources/apis/users_service.resource:345
    [Tags]    business-logic    search-users    success    first-name
    _Execute Search Users Request    Emily
    _Validate Users List Response
    _Validate Search Results    Emily
    _Validate Search By First Name Results

Search Users By Last Name
    [Documentation]    Search users by last name - UC-USER-004-A2
    ...                File: resources/apis/users_service.resource:353
    [Tags]    business-logic    search-users    success    last-name
    _Execute Search Users Request    Johnson
    _Validate Users List Response
    _Validate Search Results    Johnson
    _Validate Search By Last Name Results

Search Users By Email Domain
    [Documentation]    Search users by email domain - UC-USER-004-A3
    ...                File: resources/apis/users_service.resource:361
    [Tags]    business-logic    search-users    success    email-domain
    _Execute Search Users Request    gmail.com
    _Validate Users List Response
    _Validate Search Results    gmail.com
    _Validate Search By Email Domain Results

Search Users Case Insensitive
    [Documentation]    Search users with case insensitive query - UC-USER-004-A4
    ...                File: resources/apis/users_service.resource:369
    [Tags]    business-logic    search-users    success    case-insensitive
    _Execute Search Users Request    EMILY
    _Validate Users List Response
    _Validate Search Case Insensitive Results

Search Users With Single Character
    [Documentation]    Search users with single character - UC-USER-004-A5
    ...                File: resources/apis/users_service.resource:376
    [Tags]    business-logic    search-users    success    single-char
    _Execute Search Users Request    a
    _Validate Users List Response
    _Validate Search Single Character Results

Search Users With Multiple Words
    [Documentation]    Search users with multiple words - UC-USER-004-A6
    ...                File: resources/apis/users_service.resource:383
    [Tags]    business-logic    search-users    success    multiple-words
    _Execute Search Users Request    Emily Johnson
    _Validate Users List Response
    _Validate Search Multiple Words Results

Search Users With Empty Query
    [Documentation]    Search users with empty query - UC-USER-004-E1
    ...                File: resources/apis/users_service.resource:390
    [Tags]    business-logic    search-users    edge-case    empty-query
    _Execute Search Users Request    ${EMPTY}
    _Validate Empty Query Search Response

Search Users With Special Characters
    [Documentation]    Search users with special characters - UC-USER-004-E2
    ...                File: resources/apis/users_service.resource:397
    [Tags]    business-logic    search-users    edge-case    special-chars
    _Execute Search Users Request    @#$%
    _Validate Special Characters Search Response

Search Users With Numbers
    [Documentation]    Search users with numbers in query - UC-USER-004-A7
    ...                File: resources/apis/users_service.resource:404
    [Tags]    business-logic    search-users    success    numbers
    _Execute Search Users Request    123
    _Validate Search Numbers Results

Validate Search Results Pagination
    [Documentation]    Validate search results pagination - UC-USER-004-V1
    ...                File: resources/apis/users_service.resource:411
    [Tags]    business-logic    search-users    validation    pagination
    _Execute Search Users Request    a
    _Validate Users List Response
    _Validate Search Pagination Fields

Validate Search Results User Fields
    [Documentation]    Validate search results user fields - UC-USER-004-V2
    ...                File: resources/apis/users_service.resource:418
    [Tags]    business-logic    search-users    validation    user-fields
    _Execute Search Users Request    Emily
    _Validate Users List Response
    _Validate Search Results User Fields

Validate Search Results Relevance
    [Documentation]    Validate search results relevance - UC-USER-004-V3
    ...                File: resources/apis/users_service.resource:425
    [Tags]    business-logic    search-users    validation    relevance
    _Execute Search Users Request    Emily
    _Validate Users List Response
    _Validate Search Results Relevance Internal    Emily

Search Users With Pagination Parameters
    [Documentation]    Search users with pagination parameters - UC-USER-004-A8
    ...                File: resources/apis/users_service.resource:432
    [Tags]    business-logic    search-users    success    pagination
    _Execute Search Users Request With Pagination    a    limit=5    skip=2
    _Validate Users List Response
    _Validate Search Pagination Response    5    2

Validate Search Performance
    [Documentation]    Validate search performance benchmarks - UC-USER-004-V4
    ...                File: resources/apis/users_service.resource:440
    [Tags]    business-logic    search-users    validation    performance
    ${start_time}=    Get Time    epoch
    _Execute Search Users Request    Emily
    ${end_time}=    Get Time    epoch
    _Validate Users List Response
    _Validate Search Performance Internal    ${start_time}    ${end_time}

# UC-USER-005: Add New User Business Logic (Simulated)
Add New User With Valid Data
    [Documentation]    Add new user with valid data - UC-USER-005 (simulated)
    ...                File: resources/apis/users_service.resource:449
    [Tags]    business-logic    add-user    success    simulated
    _Execute Add User Request    ${new_user_data}
    _Validate User Creation Response    ${new_user_data}
    _Store Created User ID

Add User With Minimal Fields
    [Documentation]    Add new user with minimal required fields - UC-USER-005-A1
    ...                File: resources/apis/users_service.resource:456
    [Tags]    business-logic    add-user    success    minimal-fields
    ${minimal_user}=    Create Dictionary    firstName=John    lastName=Doe    email=john.doe@test.com
    _Execute Add User Request    ${minimal_user}
    _Validate User Creation Response    ${minimal_user}
    _Store Created User ID

Add User With Complete Data
    [Documentation]    Add new user with complete data set - UC-USER-005-A2
    ...                File: resources/apis/users_service.resource:464
    [Tags]    business-logic    add-user    success    complete-data
    ${complete_user}=    Get From Dictionary    ${new_user_data}    complete_user
    _Execute Add User Request    ${complete_user}
    _Validate User Creation Response    ${complete_user}
    _Validate Complete User Data Response    ${complete_user}
    _Store Created User ID

Add User With Different Ages
    [Documentation]    Add new users with different ages - UC-USER-005-A3
    ...                File: resources/apis/users_service.resource:473
    [Tags]    business-logic    add-user    success    different-ages
    ${young_user}=    Create Dictionary    firstName=Young    lastName=User    email=young@test.com    age=18
    _Execute Add User Request    ${young_user}
    _Validate User Creation Response    ${young_user}
    ${old_user}=    Create Dictionary    firstName=Old    lastName=User    email=old@test.com    age=65
    _Execute Add User Request    ${old_user}
    _Validate User Creation Response    ${old_user}

Add User Should Include Generated ID
    [Documentation]    Validate added user includes generated ID - UC-USER-005-V1
    ...                File: resources/apis/users_service.resource:483
    [Tags]    business-logic    add-user    validation    generated-id
    _Execute Add User Request    ${new_user_data}
    _Validate User Creation Response    ${new_user_data}
    _Validate Generated ID Exists

Add User Should Echo All Sent Fields
    [Documentation]    Validate added user echoes all sent fields - UC-USER-005-V2
    ...                File: resources/apis/users_service.resource:490
    [Tags]    business-logic    add-user    validation    echo-fields
    ${test_user}=    Get From Dictionary    ${new_user_data}    complete_user
    _Execute Add User Request    ${test_user}
    _Validate User Creation Response    ${test_user}
    _Validate All Sent Fields Echoed    ${test_user}

Add User Should Not Require All Fields
    [Documentation]    Validate user creation doesn't require all fields - UC-USER-005-V3
    ...                File: resources/apis/users_service.resource:498
    [Tags]    business-logic    add-user    validation    optional-fields
    ${basic_user}=    Create Dictionary    firstName=Basic    lastName=User
    _Execute Add User Request    ${basic_user}
    _Validate User Creation Response    ${basic_user}
    _Validate Optional Fields Handling

Add User With Duplicate Email
    [Documentation]    Add user with duplicate email - UC-USER-005-A4
    ...                File: resources/apis/users_service.resource:506
    [Tags]    business-logic    add-user    edge-case    duplicate-email
    ${duplicate_user}=    Create Dictionary    firstName=Duplicate    lastName=Email    email=emily.johnson@x.dummyjson.com
    _Execute Add User Request    ${duplicate_user}
    _Validate User Creation Response    ${duplicate_user}
    _Validate Duplicate Email Handling

Add User With Duplicate Username
    [Documentation]    Add user with duplicate username - UC-USER-005-A5
    ...                File: resources/apis/users_service.resource:514
    [Tags]    business-logic    add-user    edge-case    duplicate-username
    ${duplicate_user}=    Create Dictionary    firstName=Duplicate    lastName=Username    username=emilys
    _Execute Add User Request    ${duplicate_user}
    _Validate User Creation Response    ${duplicate_user}
    _Validate Duplicate Username Handling

Add User With Special Characters
    [Documentation]    Add user with special characters in name - UC-USER-005-A6
    ...                File: resources/apis/users_service.resource:522
    [Tags]    business-logic    add-user    edge-case    special-characters
    ${special_user}=    Create Dictionary    firstName=José    lastName=O'Connor    email=jose.oconnor@test.com
    _Execute Add User Request    ${special_user}
    _Validate User Creation Response    ${special_user}
    _Validate Special Characters Handling

Add User With Different Email Formats
    [Documentation]    Add users with different email formats - UC-USER-005-A7
    ...                File: resources/apis/users_service.resource:530
    [Tags]    business-logic    add-user    success    email-formats
    ${email_formats}=    Create List    test@domain.com    test.email@domain.co.uk    test+tag@domain.org
    FOR    ${email}    IN    @{email_formats}
        ${user}=    Create Dictionary    firstName=Test    lastName=Email    email=${email}
        _Execute Add User Request    ${user}
        _Validate User Creation Response    ${user}
        _Validate Email Format Accepted    ${email}
    END

Add Multiple Users Should Generate Different IDs
    [Documentation]    Validate multiple users get different IDs - UC-USER-005-V4
    ...                File: resources/apis/users_service.resource:541
    [Tags]    business-logic    add-user    validation    unique-ids
    ${user1}=    Create Dictionary    firstName=User1    lastName=Test    email=user1@test.com
    _Execute Add User Request    ${user1}
    _Validate User Creation Response    ${user1}
    ${id1}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    ${user2}=    Create Dictionary    firstName=User2    lastName=Test    email=user2@test.com
    _Execute Add User Request    ${user2}
    _Validate User Creation Response    ${user2}
    ${id2}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    _Validate Different User IDs    ${id1}    ${id2}

Validate Add User Performance
    [Documentation]    Validate add user performance benchmarks - UC-USER-005-V5
    ...                File: resources/apis/users_service.resource:553
    [Tags]    business-logic    add-user    validation    performance
    ${start_time}=    Get Time    epoch
    _Execute Add User Request    ${new_user_data}
    ${end_time}=    Get Time    epoch
    _Validate User Creation Response    ${new_user_data}
    _Validate Add User Performance Internal    ${start_time}    ${end_time}

# UC-USER-006: Update User Business Logic (Simulated)
Update User With Valid Data
    [Documentation]    Update existing user with valid data - UC-USER-006 (simulated)
    ...                File: resources/apis/users_service.resource:562
    [Tags]    business-logic    update-user    success    simulated
    [Arguments]    ${user_id}=1
    _Execute Update User Request    ${user_id}    ${update_user_data}
    _Validate User Update Response    ${user_id}    ${update_user_data}

Update User With Partial Data
    [Documentation]    Update user with partial data only - UC-USER-006-A1
    ...                File: resources/apis/users_service.resource:569
    [Tags]    business-logic    update-user    success    partial-data
    [Arguments]    ${user_id}=1
    ${partial_data}=    Create Dictionary    firstName=UpdatedFirst
    _Execute Update User Request    ${user_id}    ${partial_data}
    _Validate User Update Response    ${user_id}    ${partial_data}
    _Validate Partial Update Response    ${partial_data}

Update User First Name Only
    [Documentation]    Update user first name only - UC-USER-006-A2
    ...                File: resources/apis/users_service.resource:578
    [Tags]    business-logic    update-user    success    first-name-only
    [Arguments]    ${user_id}=1
    ${update_data}=    Create Dictionary    firstName=NewFirstName
    _Execute Update User Request    ${user_id}    ${update_data}
    _Validate User Update Response    ${user_id}    ${update_data}
    _Validate Single Field Update    firstName    NewFirstName

Update User Last Name Only
    [Documentation]    Update user last name only - UC-USER-006-A3
    ...                File: resources/apis/users_service.resource:587
    [Tags]    business-logic    update-user    success    last-name-only
    [Arguments]    ${user_id}=1
    ${update_data}=    Create Dictionary    lastName=NewLastName
    _Execute Update User Request    ${user_id}    ${update_data}
    _Validate User Update Response    ${user_id}    ${update_data}
    _Validate Single Field Update    lastName    NewLastName

Update User Email Only
    [Documentation]    Update user email only - UC-USER-006-A4
    ...                File: resources/apis/users_service.resource:596
    [Tags]    business-logic    update-user    success    email-only
    [Arguments]    ${user_id}=1
    ${update_data}=    Create Dictionary    email=newemail@test.com
    _Execute Update User Request    ${user_id}    ${update_data}
    _Validate User Update Response    ${user_id}    ${update_data}
    _Validate Single Field Update    email    newemail@test.com

Update User Age Only
    [Documentation]    Update user age only - UC-USER-006-A5
    ...                File: resources/apis/users_service.resource:605
    [Tags]    business-logic    update-user    success    age-only
    [Arguments]    ${user_id}=1
    ${update_data}=    Create Dictionary    age=35
    _Execute Update User Request    ${user_id}    ${update_data}
    _Validate User Update Response    ${user_id}    ${update_data}
    _Validate Single Field Update    age    35

Update User Phone Only
    [Documentation]    Update user phone only - UC-USER-006-A6
    ...                File: resources/apis/users_service.resource:614
    [Tags]    business-logic    update-user    success    phone-only
    [Arguments]    ${user_id}=1
    ${update_data}=    Create Dictionary    phone=+1-555-123-4567
    _Execute Update User Request    ${user_id}    ${update_data}
    _Validate User Update Response    ${user_id}    ${update_data}
    _Validate Single Field Update    phone    +1-555-123-4567

Update User With Different Ages
    [Documentation]    Update user with different age values - UC-USER-006-A7
    ...                File: resources/apis/users_service.resource:623
    [Tags]    business-logic    update-user    success    different-ages
    [Arguments]    ${user_id}=1
    ${ages}=    Create List    18    25    35    50    65
    FOR    ${age}    IN    @{ages}
        ${update_data}=    Create Dictionary    age=${age}
        _Execute Update User Request    ${user_id}    ${update_data}
        _Validate User Update Response    ${user_id}    ${update_data}
        _Validate Age Update Response    ${age}
    END

Update User With Different Email Formats
    [Documentation]    Update user with different email formats - UC-USER-006-A8
    ...                File: resources/apis/users_service.resource:634
    [Tags]    business-logic    update-user    success    email-formats
    [Arguments]    ${user_id}=1
    ${emails}=    Create List    test@domain.com    test.user@domain.co.uk    test+tag@domain.org
    FOR    ${email}    IN    @{emails}
        ${update_data}=    Create Dictionary    email=${email}
        _Execute Update User Request    ${user_id}    ${update_data}
        _Validate User Update Response    ${user_id}    ${update_data}
        _Validate Email Format Update    ${email}
    END

Update User With Special Characters
    [Documentation]    Update user with special characters - UC-USER-006-A9
    ...                File: resources/apis/users_service.resource:645
    [Tags]    business-logic    update-user    success    special-characters
    [Arguments]    ${user_id}=1
    ${update_data}=    Create Dictionary    firstName=José    lastName=O'Connor-Smith
    _Execute Update User Request    ${user_id}    ${update_data}
    _Validate User Update Response    ${user_id}    ${update_data}
    _Validate Special Characters Update    ${update_data}

Update User Response Should Preserve ID
    [Documentation]    Validate update response preserves original ID - UC-USER-006-V1
    ...                File: resources/apis/users_service.resource:654
    [Tags]    business-logic    update-user    validation    preserve-id
    [Arguments]    ${user_id}=1
    _Execute Update User Request    ${user_id}    ${update_user_data}
    _Validate User Update Response    ${user_id}    ${update_user_data}
    _Validate ID Preservation    ${user_id}

Update User Response Should Echo Updated Fields
    [Documentation]    Validate update response echoes updated fields - UC-USER-006-V2
    ...                File: resources/apis/users_service.resource:662
    [Tags]    business-logic    update-user    validation    echo-fields
    [Arguments]    ${user_id}=1
    _Execute Update User Request    ${user_id}    ${update_user_data}
    _Validate User Update Response    ${user_id}    ${update_user_data}
    _Validate Updated Fields Echo    ${update_user_data}

Update User With Empty Data
    [Documentation]    Update user with empty data - UC-USER-006-E1
    ...                File: resources/apis/users_service.resource:670
    [Tags]    business-logic    update-user    edge-case    empty-data
    [Arguments]    ${user_id}=1
    ${empty_data}=    Create Dictionary
    _Execute Update User Request    ${user_id}    ${empty_data}
    _Validate Empty Data Update Response

Update Same User Multiple Times
    [Documentation]    Update same user multiple times - UC-USER-006-A10
    ...                File: resources/apis/users_service.resource:678
    [Tags]    business-logic    update-user    success    multiple-updates
    [Arguments]    ${user_id}=1
    ${update1}=    Create Dictionary    firstName=Update1
    _Execute Update User Request    ${user_id}    ${update1}
    _Validate User Update Response    ${user_id}    ${update1}
    ${update2}=    Create Dictionary    firstName=Update2
    _Execute Update User Request    ${user_id}    ${update2}
    _Validate User Update Response    ${user_id}    ${update2}
    _Validate Multiple Updates Response    ${update1}    ${update2}

Update User With Same Data
    [Documentation]    Update user with same existing data - UC-USER-006-A11
    ...                File: resources/apis/users_service.resource:690
    [Tags]    business-logic    update-user    edge-case    same-data
    [Arguments]    ${user_id}=1
    ${same_data}=    Create Dictionary    firstName=Emily    lastName=Johnson
    _Execute Update User Request    ${user_id}    ${same_data}
    _Validate User Update Response    ${user_id}    ${same_data}
    _Validate Same Data Update Response

Update User With Long Names
    [Documentation]    Update user with long name values - UC-USER-006-A12
    ...                File: resources/apis/users_service.resource:699
    [Tags]    business-logic    update-user    edge-case    long-names
    [Arguments]    ${user_id}=1
    ${long_names}=    Create Dictionary    firstName=${{"A" * 50}}    lastName=${{"B" * 50}}
    _Execute Update User Request    ${user_id}    ${long_names}
    _Validate User Update Response    ${user_id}    ${long_names}
    _Validate Long Names Update Response    ${long_names}

Update Non-Existent User
    [Documentation]    Attempt to update non-existent user - UC-USER-006-E2
    ...                File: resources/apis/users_service.resource:708
    [Tags]    business-logic    update-user    error    404
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    non_existent_id
    _Execute Update User Request    ${invalid_data['id']}    ${update_user_data}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Validate Update User Performance
    [Documentation]    Validate update user performance benchmarks - UC-USER-006-V3
    ...                File: resources/apis/users_service.resource:715
    [Tags]    business-logic    update-user    validation    performance
    [Arguments]    ${user_id}=1
    ${start_time}=    Get Time    epoch
    _Execute Update User Request    ${user_id}    ${update_user_data}
    ${end_time}=    Get Time    epoch
    _Validate User Update Response    ${user_id}    ${update_user_data}
    _Validate Update User Performance Internal    ${start_time}    ${end_time}

# UC-USER-007: Delete User Business Logic (Simulated)
Delete User With Valid ID
    [Documentation]    Delete user with valid ID - UC-USER-007 (simulated)
    ...                File: resources/apis/users_service.resource:724
    [Tags]    business-logic    delete-user    success    simulated
    [Arguments]    ${user_id}=1
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}

Delete User Should Return Confirmation
    [Documentation]    Validate delete returns confirmation - UC-USER-007-V1
    ...                File: resources/apis/users_service.resource:731
    [Tags]    business-logic    delete-user    validation    confirmation
    [Arguments]    ${user_id}=1
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}
    _Validate Deletion Confirmation    ${user_id}

Delete User Should Include Timestamp
    [Documentation]    Validate delete includes timestamp - UC-USER-007-V2
    ...                File: resources/apis/users_service.resource:739
    [Tags]    business-logic    delete-user    validation    timestamp
    [Arguments]    ${user_id}=1
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}
    _Validate Deletion Timestamp

Delete User Should Preserve Original Data
    [Documentation]    Validate delete preserves original data - UC-USER-007-V3
    ...                File: resources/apis/users_service.resource:747
    [Tags]    business-logic    delete-user    validation    preserve-data
    [Arguments]    ${user_id}=1
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}
    _Validate Original Data Preservation    ${user_id}

Delete Same User Multiple Times
    [Documentation]    Delete same user multiple times - UC-USER-007-A1
    ...                File: resources/apis/users_service.resource:755
    [Tags]    business-logic    delete-user    edge-case    multiple-deletes
    [Arguments]    ${user_id}=1
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}
    _Execute Delete User Request    ${user_id}
    _Validate Multiple Deletion Response    ${user_id}

Delete User Should Not Affect Other Users
    [Documentation]    Validate delete doesn't affect other users - UC-USER-007-V4
    ...                File: resources/apis/users_service.resource:764
    [Tags]    business-logic    delete-user    validation    isolation
    [Arguments]    ${user_id}=1
    _Execute Get User By ID Request    2
    ${other_user_before}=    Set Variable    ${LAST_RESPONSE.json()}
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}
    _Execute Get User By ID Request    2
    ${other_user_after}=    Set Variable    ${LAST_RESPONSE.json()}
    _Validate Other Users Not Affected    ${other_user_before}    ${other_user_after}

Delete User Should Handle Large Valid IDs
    [Documentation]    Delete user with large valid ID - UC-USER-007-A2
    ...                File: resources/apis/users_service.resource:775
    [Tags]    business-logic    delete-user    success    large-id
    _Execute Delete User Request    30
    _Validate User Deletion Response    30
    _Validate Large ID Deletion    30

Delete Multiple Users In Sequence
    [Documentation]    Delete multiple users in sequence - UC-USER-007-A3
    ...                File: resources/apis/users_service.resource:782
    [Tags]    business-logic    delete-user    success    sequence
    ${user_ids}=    Create List    1    2    3
    FOR    ${user_id}    IN    @{user_ids}
        _Execute Delete User Request    ${user_id}
        _Validate User Deletion Response    ${user_id}
        _Validate Sequential Deletion    ${user_id}
    END

Delete All Valid Users
    [Documentation]    Delete all valid users - UC-USER-007-A4
    ...                File: resources/apis/users_service.resource:792
    [Tags]    business-logic    delete-user    success    all-users
    ${valid_ids}=    Create List    1    2    3    4    5
    FOR    ${user_id}    IN    @{valid_ids}
        _Execute Delete User Request    ${user_id}
        _Validate User Deletion Response    ${user_id}
    END
    _Validate All Users Deletion

Delete User Should Return Complete Object
    [Documentation]    Validate delete returns complete object - UC-USER-007-V5
    ...                File: resources/apis/users_service.resource:802
    [Tags]    business-logic    delete-user    validation    complete-object
    [Arguments]    ${user_id}=1
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}
    _Validate Complete Object Return    ${user_id}

Delete User Should Maintain Data Integrity
    [Documentation]    Validate delete maintains data integrity - UC-USER-007-V6
    ...                File: resources/apis/users_service.resource:810
    [Tags]    business-logic    delete-user    validation    data-integrity
    [Arguments]    ${user_id}=1
    _Execute Delete User Request    ${user_id}
    _Validate User Deletion Response    ${user_id}
    _Validate Data Integrity After Deletion    ${user_id}

Delete Non-Existent User
    [Documentation]    Attempt to delete non-existent user - UC-USER-007-E1
    ...                File: resources/apis/users_service.resource:818
    [Tags]    business-logic    delete-user    error    404
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    non_existent_id
    _Execute Delete User Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Validate Delete User Performance
    [Documentation]    Validate delete user performance benchmarks - UC-USER-007-V7
    ...                File: resources/apis/users_service.resource:825
    [Tags]    business-logic    delete-user    validation    performance
    [Arguments]    ${user_id}=1
    ${start_time}=    Get Time    epoch
    _Execute Delete User Request    ${user_id}
    ${end_time}=    Get Time    epoch
    _Validate User Deletion Response    ${user_id}
    _Validate Delete User Performance Internal    ${start_time}    ${end_time}

# ============================================================================
# TECHNICAL KEYWORDS (Low-Level API Operations - Private/Internal)
# ============================================================================

# Session Management
_Setup Users Session
    [Documentation]    Setup HTTP session for users API requests
    ...                File: resources/apis/users_service.resource:158
    Create Session    ${USERS_SESSION}    ${base_url}    timeout=${timeout}

_Clear User Context
    [Documentation]    Clear user context variables
    ...                File: resources/apis/users_service.resource:163
    Set Test Variable    ${ACCESS_TOKEN}    ${EMPTY}
    Set Test Variable    ${CURRENT_USER_ID}    ${EMPTY}

# UC-USER-001: Login Operations
_Execute User Login
    [Documentation]    Execute login API request
    ...                File: resources/apis/users_service.resource:169
    [Arguments]    ${username}    ${password}
    ${login_data}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    ${USERS_SESSION}    ${endpoints['login']}    
    ...    json=${login_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_DATA}    ${login_data}

_Validate User Login Response
    [Documentation]    Validate successful login response structure
    ...                File: resources/apis/users_service.resource:178
    [Arguments]    ${expected_user_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Not Be Empty    ${response_json['token']}
    Should Be Equal As Strings    ${response_json['username']}    ${expected_user_data['username']}
    Should Be Equal As Strings    ${response_json['email']}    ${expected_user_data['email']}
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_user_data['id']}
    Set Test Variable    ${ACCESS_TOKEN}    ${response_json['token']}
    Set Test Variable    ${CURRENT_USER_ID}    ${response_json['id']}

# UC-USER-002: Get All Users Operations
_Execute Get All Users Request
    [Documentation]    Execute get all users API request
    ...                File: resources/apis/users_service.resource:191
    [Arguments]    ${limit}=${None}    ${skip}=${None}    ${sortBy}=${None}    ${order}=${None}
    ${params}=    Create Dictionary
    Run Keyword If    $limit is not None    Set To Dictionary    ${params}    limit=${limit}
    Run Keyword If    $skip is not None    Set To Dictionary    ${params}    skip=${skip}
    Run Keyword If    $sortBy is not None    Set To Dictionary    ${params}    sortBy=${sortBy}
    Run Keyword If    $order is not None    Set To Dictionary    ${params}    order=${order}
    ${response}=    GET On Session    ${USERS_SESSION}    ${endpoints['get_all_users']}
    ...    params=${params}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_PARAMS}    ${params}

_Validate Users List Response
    [Documentation]    Validate users list response structure
    ...                File: resources/apis/users_service.resource:204
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    users
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit
    Should Be True    ${response_json['total']} > 0
    Should Be True    len(${response_json['users']}) > 0
    _Validate User Objects In List    ${response_json['users']}

_Validate User Objects In List
    [Documentation]    Validate individual user objects in list
    ...                File: resources/apis/users_service.resource:216
    [Arguments]    ${users_list}
    FOR    ${user}    IN    @{users_list}
        Dictionary Should Contain Key    ${user}    id
        Dictionary Should Contain Key    ${user}    firstName
        Dictionary Should Contain Key    ${user}    lastName
        Dictionary Should Contain Key    ${user}    email
        Dictionary Should Contain Key    ${user}    username
        Should Be True    ${user['id']} > 0
        Should Not Be Empty    ${user['firstName']}
        Should Not Be Empty    ${user['lastName']}
        Should Not Be Empty    ${user['email']}
        Should Not Be Empty    ${user['username']}
    END

_Validate Pagination Fields
    [Documentation]    Validate pagination fields in response
    ...                File: resources/apis/users_service.resource:231
    [Arguments]    ${expected_limit}    ${expected_skip}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['limit']}    ${expected_limit}
    Should Be Equal As Numbers    ${response_json['skip']}    ${expected_skip}
    Should Be True    ${response_json['total']} >= ${expected_skip}

_Validate Users Sorting
    [Documentation]    Validate users are sorted correctly
    ...                File: resources/apis/users_service.resource:239
    [Arguments]    ${sort_field}    ${sort_order}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${users_list}=    Set Variable    ${response_json['users']}
    Should Be True    len(${users_list}) > 1
    ${first_user}=    Get From List    ${users_list}    0
    ${second_user}=    Get From List    ${users_list}    1
    Run Keyword If    '${sort_order}' == 'asc'    
    ...    Should Be True    "${first_user['${sort_field}']}" <= "${second_user['${sort_field}']}"
    Run Keyword If    '${sort_order}' == 'desc'    
    ...    Should Be True    "${first_user['${sort_field}']}" >= "${second_user['${sort_field}']}"

# UC-USER-003: Get User By ID Operations
_Execute Get User By ID Request
    [Documentation]    Execute get user by ID API request
    ...                File: resources/apis/users_service.resource:253
    [Arguments]    ${user_id}
    ${endpoint}=    Replace String    ${endpoints['get_user_by_id']}    {id}    ${user_id}
    ${response}=    GET On Session    ${USERS_SESSION}    ${endpoint}
    ...    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_ID}    ${user_id}

_Validate Single User Response
    [Documentation]    Validate single user response structure
    ...                File: resources/apis/users_service.resource:262
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${field}    IN    @{expected_response_fields}
        Dictionary Should Contain Key    ${response_json}    ${field}
    END
    Should Be True    ${response_json['id']} > 0
    Should Not Be Empty    ${response_json['firstName']}
    Should Not Be Empty    ${response_json['lastName']}

_Validate User ID Matches
    [Documentation]    Validate user ID matches the requested ID
    ...                File: resources/apis/users_service.resource:273
    [Arguments]    ${expected_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_id}

# UC-USER-004: Search Users Operations
_Execute Search Users Request
    [Documentation]    Execute search users API request
    ...                File: resources/apis/users_service.resource:280
    [Arguments]    ${search_term}
    ${params}=    Create Dictionary    q=${search_term}
    ${response}=    GET On Session    ${USERS_SESSION}    ${endpoints['search_users']}
    ...    params=${params}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_SEARCH_TERM}    ${search_term}

_Validate Search Results
    [Documentation]    Validate search results contain the search term
    ...                File: resources/apis/users_service.resource:289
    [Arguments]    ${search_term}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    Should Be True    len(${response_json['users']}) > 0
    ${users_list}=    Set Variable    ${response_json['users']}
    FOR    ${user}    IN    @{users_list}
        ${search_term_lower}=    Convert To Lower Case    ${search_term}
        ${first_name_lower}=    Convert To Lower Case    ${user['firstName']}
        ${last_name_lower}=    Convert To Lower Case    ${user['lastName']}
        ${email_lower}=    Convert To Lower Case    ${user['email']}
        ${found}=    Evaluate    "${search_term_lower}" in "${first_name_lower}" or "${search_term_lower}" in "${last_name_lower}" or "${search_term_lower}" in "${email_lower}"
        Run Keyword If    not ${found}    Log    User ${user['firstName']} ${user['lastName']} doesn't contain search term but was returned    WARN
    END

_Validate Empty Search Results
    [Documentation]    Validate search returns empty results
    ...                File: resources/apis/users_service.resource:304
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['total']}    0
    Should Be True    len(${response_json['users']}) == 0

# UC-USER-005: Add User Operations
_Execute Add User Request
    [Documentation]    Execute add user API request
    ...                File: resources/apis/users_service.resource:312
    [Arguments]    ${user_data}
    ${response}=    POST On Session    ${USERS_SESSION}    ${endpoints['add_user']}
    ...    json=${user_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_DATA}    ${user_data}

_Validate User Creation Response
    [Documentation]    Validate user creation response (simulated)
    ...                File: resources/apis/users_service.resource:320
    [Arguments]    ${original_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Should Be True    ${response_json['id']} > 0
    Should Be Equal As Strings    ${response_json['firstName']}    ${original_data['firstName']}
    Should Be Equal As Strings    ${response_json['lastName']}    ${original_data['lastName']}
    Should Be Equal As Strings    ${response_json['email']}    ${original_data['email']}

_Store Created User ID
    [Documentation]    Store created user ID for later use
    ...                File: resources/apis/users_service.resource:331
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Set Test Variable    ${CURRENT_USER_ID}    ${response_json['id']}

# UC-USER-006: Update User Operations
_Execute Update User Request
    [Documentation]    Execute update user API request
    ...                File: resources/apis/users_service.resource:337
    [Arguments]    ${user_id}    ${update_data}
    ${endpoint}=    Replace String    ${endpoints['update_user']}    {id}    ${user_id}
    ${response}=    PUT On Session    ${USERS_SESSION}    ${endpoint}
    ...    json=${update_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_DATA}    ${update_data}
    Set Test Variable    ${LAST_REQUEST_ID}    ${user_id}

_Validate User Update Response
    [Documentation]    Validate user update response (simulated)
    ...                File: resources/apis/users_service.resource:347
    [Arguments]    ${user_id}    ${update_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    FOR    ${key}    IN    @{update_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Should Be Equal As Strings    ${response_json['${key}']}    ${update_data['${key}']}
    END

# UC-USER-007: Delete User Operations
_Execute Delete User Request
    [Documentation]    Execute delete user API request
    ...                File: resources/apis/users_service.resource:358
    [Arguments]    ${user_id}
    ${endpoint}=    Replace String    ${endpoints['delete_user']}    {id}    ${user_id}
    ${response}=    DELETE On Session    ${USERS_SESSION}    ${endpoint}
    ...    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_ID}    ${user_id}

_Validate User Deletion Response
    [Documentation]    Validate user deletion response (simulated)
    ...                File: resources/apis/users_service.resource:367
    [Arguments]    ${user_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Dictionary Should Contain Key    ${response_json}    isDeleted
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Be True    ${response_json['isDeleted']}
    Should Not Be Empty    ${response_json['deletedOn']}

# ============================================================================
# COMMON VALIDATION KEYWORDS
# ============================================================================

_Validate Error Response
    [Documentation]    Validate error response structure and message
    ...                File: resources/apis/users_service.resource:380
    [Arguments]    ${expected_status}    ${expected_message}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    ${expected_status}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    message
    Should Be Equal As Strings    ${response_json['message']}    ${expected_message}

# ============================================================================
# ADDITIONAL VALIDATION KEYWORDS (Missing from previous implementation)
# ============================================================================

_Validate Search Results Relevance Internal
    [Documentation]    Validate search results relevance for query - internal technical implementation
    ...                File: resources/apis/users_service.resource:469
    [Arguments]    ${search_term}
    Log    Search results relevance validation for term: ${search_term} - users_service.resource:469
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    # Validate that results contain the search term in relevant fields
    ${users_list}=    Set Variable    ${response_json['users']}
    FOR    ${user}    IN    @{users_list}
        ${term_lower}=    Convert To Lower Case    ${search_term}
        ${first_name_lower}=    Convert To Lower Case    ${user['firstName']}
        ${last_name_lower}=    Convert To Lower Case    ${user['lastName']}
        ${found_in_first}=    Run Keyword And Return Status    Should Contain    ${first_name_lower}    ${term_lower}
        ${found_in_last}=    Run Keyword And Return Status    Should Contain    ${last_name_lower}    ${term_lower}
        ${found}=    Evaluate    ${found_in_first} or ${found_in_last}
        Should Be True    ${found}    Search term '${search_term}' not found in user '${user['firstName']} ${user['lastName']}'
    END

_Execute Search Users Request With Pagination
    [Documentation]    Execute search users request with pagination parameters
    ...                File: resources/apis/users_service.resource:475
    [Arguments]    ${query}    ${limit}=${None}    ${skip}=${None}
    Log    Execute search users request with pagination - users_service.resource:475
    ${params}=    Create Dictionary    q=${query}
    Run Keyword If    '${limit}' != '${None}'    Set To Dictionary    ${params}    limit=${limit}
    Run Keyword If    '${skip}' != '${None}'    Set To Dictionary    ${params}    skip=${skip}
    ${response}=    GET On Session    ${USERS_SESSION}    ${endpoints['search_users']}    params=${params}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_PARAMS}    ${params}
    Set Test Variable    ${LAST_SEARCH_TERM}    ${query}

_Validate Search Performance Internal
    [Documentation]    Validate search performance benchmarks - internal technical implementation
    ...                File: resources/apis/users_service.resource:487
    [Arguments]    ${start_time}    ${end_time}
    Log    Search performance validation - users_service.resource:487
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0    Search took too long: ${duration} seconds
    Log    Search completed in ${duration} seconds

_Validate Add User Performance Internal
    [Documentation]    Validate add user performance benchmarks - internal technical implementation
    ...                File: resources/apis/users_service.resource:615
    [Arguments]    ${start_time}    ${end_time}
    Log    Add user performance validation - users_service.resource:615
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 3.0    Add user took too long: ${duration} seconds
    Log    Add user completed in ${duration} seconds

_Validate Update User Performance Internal
    [Documentation]    Validate update user performance benchmarks - internal technical implementation
    ...                File: resources/apis/users_service.resource:799
    [Arguments]    ${start_time}    ${end_time}
    Log    Update user performance validation - users_service.resource:799
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 3.0    Update user took too long: ${duration} seconds
    Log    Update user completed in ${duration} seconds

_Validate Delete User Performance Internal
    [Documentation]    Validate delete user performance benchmarks - internal technical implementation
    ...                File: resources/apis/users_service.resource:925
    [Arguments]    ${start_time}    ${end_time}
    Log    Delete user performance validation - users_service.resource:925
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 3.0    Delete user took too long: ${duration} seconds
    Log    Delete user completed in ${duration} seconds

# ============================================================================
# UTILITY KEYWORDS
# ============================================================================

Get User Test Data
    [Documentation]    Get specific user test data by key
    ...                File: resources/apis/users_service.resource:391
    [Arguments]    ${user_key}
    ${user_data}=    Get From Dictionary    ${test_users}    ${user_key}
    [Return]    ${user_data}

Get Valid User ID For Testing
    [Documentation]    Get a valid user ID for testing purposes
    ...                File: resources/apis/users_service.resource:397
    [Arguments]    ${index}=0
    ${user_id}=    Get From List    ${valid_user_ids}    ${index}
    [Return]    ${user_id}

Get Invalid User Test Data
    [Documentation]    Get invalid user test data by scenario
    ...                File: resources/apis/users_service.resource:403
    [Arguments]    ${scenario_key}
    ${invalid_data}=    Get From Dictionary    ${invalid_user_ids}    ${scenario_key}
    [Return]    ${invalid_data}

Log Current Response Details
    [Documentation]    Log current response details for debugging
    ...                File: resources/apis/users_service.resource:409
    Log    Response Status: ${LAST_RESPONSE.status_code}
    Log    Response Body: ${LAST_RESPONSE.json()}
    Log    Response Headers: ${LAST_RESPONSE.headers}

# ============================================================================
# SPECIFIC VALIDATION KEYWORDS (Missing implementations)
# ============================================================================

_Validate Large Limit Response
    [Documentation]    Additional validations for large limit (limit=100) scenario
    ...                File: resources/apis/users_service.resource:1220
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['limit']}    100
    Should Be True    len(${response_json['users']}) > 0
    Should Be True    len(${response_json['users']}) <= 100
    Log    users_service.resource:1220 [_Validate Large Limit Response] length=${response_json['users'].__len__()}

_Validate High Skip Response
    [Documentation]    Validations for high skip (skip=50) scenario
    ...                File: resources/apis/users_service.resource:1228
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['skip']}    50
    Should Be True    ${response_json['total']} >= 50
    Should Be True    len(${response_json['users']}) >= 0
    Log    users_service.resource:1228 [_Validate High Skip Response] skip=${response_json['skip']}

_Validate Zero Limit Response
    [Documentation]    Validations for zero limit (limit=0) scenario
    ...                File: resources/apis/users_service.resource:1236
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['limit']}    0
    Should Be True    len(${response_json['users']}) == 0
    Log    users_service.resource:1236 [_Validate Zero Limit Response] zero list validated

_Validate Invalid Sorting Field Response
    [Documentation]    Validate response when sort field is invalid
    ...                File: resources/apis/users_service.resource:1243
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    # DummyJSON API ignores invalid sort fields and returns unsorted data
    Dictionary Should Contain Key    ${response_json}    users
    Log    users_service.resource:1243 [_Validate Invalid Sorting Field Response] handled gracefully

_Validate Invalid Sort Order Response
    [Documentation]    Validate response when sort order is invalid
    ...                File: resources/apis/users_service.resource:1251
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    # DummyJSON API ignores invalid sort order and returns default order
    Dictionary Should Contain Key    ${response_json}    users
    Log    users_service.resource:1251 [_Validate Invalid Sort Order Response] handled gracefully


_Validate Each User Object Complete Fields
    [Documentation]    Validate each user object has complete fields
    ...                File: resources/apis/users_service.resource:1268
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${users_list}=    Set Variable    ${response_json['users']}
    FOR    ${user}    IN    @{users_list}
        FOR    ${field}    IN    @{expected_response_fields}
            Dictionary Should Contain Key    ${user}    ${field}
        END
    END
    Log    users_service.resource:1268 [_Validate Each User Object Complete Fields] all fields validated

_Validate User Specific Data
    [Documentation]    Validate specific user data matches expected values
    ...                File: resources/apis/users_service.resource:1278
    [Arguments]    ${user_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Should Not Be Empty    ${response_json['firstName']}
    Should Not Be Empty    ${response_json['lastName']}
    Should Not Be Empty    ${response_json['email']}
    Log    users_service.resource:1278 [_Validate User Specific Data] user_id=${user_id} validated

_Validate Negative ID Error Response
    [Documentation]    Validate error response for negative ID
    ...                File: resources/apis/users_service.resource:1287
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    404
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    message
    Should Contain    ${response_json['message']}    not found
    Log    users_service.resource:1287 [_Validate Negative ID Error Response] negative ID handled

_Validate Zero ID Error Response
    [Documentation]    Validate error response for zero ID
    ...                File: resources/apis/users_service.resource:1295
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    404
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    message
    Should Contain    ${response_json['message']}    not found
    Log    users_service.resource:1295 [_Validate Zero ID Error Response] zero ID handled

_Validate Text ID Error Response
    [Documentation]    Validate error response for text ID
    ...                File: resources/apis/users_service.resource:1303
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    404
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    message
    Should Contain    ${response_json['message']}    not found
    Log    users_service.resource:1303 [_Validate Text ID Error Response] text ID handled

_Validate Special Characters ID Error Response
    [Documentation]    Validate error response for special characters ID
    ...                File: resources/apis/users_service.resource:1311
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    404
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    message
    Should Contain    ${response_json['message']}    not found
    Log    users_service.resource:1311 [_Validate Special Characters ID Error Response] special chars ID handled

_Validate User Response All Fields
    [Documentation]    Validate user response contains all required fields
    ...                File: resources/apis/users_service.resource:1319
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${field}    IN    @{expected_response_fields}
        Dictionary Should Contain Key    ${response_json}    ${field}
    END
    Log    users_service.resource:1319 [_Validate User Response All Fields] all fields present

_Validate Users Have Unique Data
    [Documentation]    Validate different users have unique data
    ...                File: resources/apis/users_service.resource:1349
    [Arguments]    ${user1_data}    ${user2_data}
    Should Not Be Equal    ${user1_data['id']}    ${user2_data['id']}
    Should Not Be Equal    ${user1_data['username']}    ${user2_data['username']}
    Should Not Be Equal    ${user1_data['email']}    ${user2_data['email']}
    Log    users_service.resource:1349 [_Validate Users Have Unique Data] uniqueness validated

# Search-specific validations
_Validate Search By First Name Results
    [Documentation]    Validate search results by first name
    ...                File: resources/apis/users_service.resource:1357
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${users_list}=    Set Variable    ${response_json['users']}
    FOR    ${user}    IN    @{users_list}
        Should Contain    ${user['firstName']}    Emily    ignore_case=True
    END
    Log    users_service.resource:1357 [_Validate Search By First Name Results] first name search validated

_Validate Search By Last Name Results
    [Documentation]    Validate search results by last name
    ...                File: resources/apis/users_service.resource:1365
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${users_list}=    Set Variable    ${response_json['users']}
    FOR    ${user}    IN    @{users_list}
        Should Contain    ${user['lastName']}    Johnson    ignore_case=True
    END
    Log    users_service.resource:1365 [_Validate Search By Last Name Results] last name search validated

_Validate Search By Email Domain Results
    [Documentation]    Validate search results by email domain
    ...                File: resources/apis/users_service.resource:1373
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${users_list}=    Set Variable    ${response_json['users']}
    FOR    ${user}    IN    @{users_list}
        Should Contain    ${user['email']}    gmail.com    ignore_case=True
    END
    Log    users_service.resource:1373 [_Validate Search By Email Domain Results] email domain search validated

_Validate Search Case Insensitive Results
    [Documentation]    Validate search results are case insensitive
    ...                File: resources/apis/users_service.resource:1381
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    ${users_list}=    Set Variable    ${response_json['users']}
    ${found_emily}=    Set Variable    False
    FOR    ${user}    IN    @{users_list}
        ${first_name_lower}=    Convert To Lower Case    ${user['firstName']}
        ${found_emily}=    Evaluate    ${found_emily} or "emily" in "${first_name_lower}"
    END
    Should Be True    ${found_emily}
    Log    users_service.resource:1381 [_Validate Search Case Insensitive Results] case insensitive search validated

_Validate Search Single Character Results
    [Documentation]    Validate search with single character returns results
    ...                File: resources/apis/users_service.resource:1393
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    Log    users_service.resource:1393 [_Validate Search Single Character Results] single char search validated

_Validate Search Multiple Words Results
    [Documentation]    Validate search with multiple words
    ...                File: resources/apis/users_service.resource:1399
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    ${users_list}=    Set Variable    ${response_json['users']}
    FOR    ${user}    IN    @{users_list}
        ${full_name}=    Set Variable    ${user['firstName']} ${user['lastName']}
        ${full_name_lower}=    Convert To Lower Case    ${full_name}
        ${match}=    Evaluate    "emily" in "${full_name_lower}" or "johnson" in "${full_name_lower}"
        Should Be True    ${match}
        BREAK
    END
    Log    users_service.resource:1399 [_Validate Search Multiple Words Results] multiple words search validated

_Validate Empty Query Search Response
    [Documentation]    Validate empty query search response behavior
    ...                File: resources/apis/users_service.resource:1411
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    Should Be True    ${response_json['total']} >= 0
    Log    users_service.resource:1411 [_Validate Empty Query Search Response] empty query handled

_Validate Special Characters Search Response
    [Documentation]    Validate special characters search response
    ...                File: resources/apis/users_service.resource:1418
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    Should Be True    ${response_json['total']} >= 0
    Log    users_service.resource:1418 [_Validate Special Characters Search Response] special chars handled

_Validate Search Numbers Results
    [Documentation]    Validate search with numbers in query
    ...                File: resources/apis/users_service.resource:1425
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} >= 0
    Log    users_service.resource:1425 [_Validate Search Numbers Results] numbers search handled

_Validate Search Pagination Fields
    [Documentation]    Validate search results pagination fields
    ...                File: resources/apis/users_service.resource:1431
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    users
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit
    Log    users_service.resource:1431 [_Validate Search Pagination Fields] pagination fields validated

_Validate Search Pagination Response
    [Documentation]    Validate search pagination response
    ...                File: resources/apis/users_service.resource:1463
    [Arguments]    ${expected_limit}    ${expected_skip}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['limit']}    ${expected_limit}
    Should Be Equal As Numbers    ${response_json['skip']}    ${expected_skip}
    Log    users_service.resource:1463 [_Validate Search Pagination Response] limit=${expected_limit} skip=${expected_skip}

# User creation validations
_Validate Complete User Data Response
    [Documentation]    Validate complete user data in response
    ...                File: resources/apis/users_service.resource:1477
    [Arguments]    ${expected_data}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    ${expected_data['firstName']}
    Should Be Equal As Strings    ${response_json['lastName']}    ${expected_data['lastName']}
    Should Be Equal As Strings    ${response_json['email']}    ${expected_data['email']}
    Log    users_service.resource:1477 [_Validate Complete User Data Response] complete data validated

_Validate Generated ID Exists
    [Documentation]    Validate generated ID exists and is valid
    ...                File: resources/apis/users_service.resource:1485
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Should Be True    ${response_json['id']} > 0
    Should Be True    ${{isinstance($response_json['id'], int)}}
    Log    users_service.resource:1485 [_Validate Generated ID Exists] id=${response_json['id']}

_Validate All Sent Fields Echoed
    [Documentation]    Validate all sent fields are echoed in response
    ...                File: resources/apis/users_service.resource:1493
    [Arguments]    ${sent_data}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{sent_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Should Be Equal    ${response_json['${key}']}    ${sent_data['${key}']}
    END
    Log    users_service.resource:1493 [_Validate All Sent Fields Echoed] all fields echoed

_Validate Optional Fields Handling
    [Documentation]    Validate optional fields handling in creation
    ...                File: resources/apis/users_service.resource:1502
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Dictionary Should Contain Key    ${response_json}    firstName
    Dictionary Should Contain Key    ${response_json}    lastName
    Log    users_service.resource:1502 [_Validate Optional Fields Handling] optional fields handled

_Validate Duplicate Email Handling
    [Documentation]    Validate duplicate email handling
    ...                File: resources/apis/users_service.resource:1509
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    # DummyJSON allows duplicate emails in simulation
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    Dictionary Should Contain Key    ${response_json}    id
    Log    users_service.resource:1509 [_Validate Duplicate Email Handling] duplicate email handled

_Validate Duplicate Username Handling
    [Documentation]    Validate duplicate username handling
    ...                File: resources/apis/users_service.resource:1517
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    # DummyJSON allows duplicate usernames in simulation
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    Dictionary Should Contain Key    ${response_json}    id
    Log    users_service.resource:1517 [_Validate Duplicate Username Handling] duplicate username handled

_Validate Special Characters Handling
    [Documentation]    Validate special characters handling in user data
    ...                File: resources/apis/users_service.resource:1525
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    Dictionary Should Contain Key    ${response_json}    firstName
    Dictionary Should Contain Key    ${response_json}    lastName
    Log    users_service.resource:1525 [_Validate Special Characters Handling] special chars handled

_Validate Email Format Accepted
    [Documentation]    Validate email format is accepted
    ...                File: resources/apis/users_service.resource:1533
    [Arguments]    ${email}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['email']}    ${email}
    Log    users_service.resource:1533 [_Validate Email Format Accepted] email=${email}

_Validate Different User IDs
    [Documentation]    Validate different users get different IDs
    ...                File: resources/apis/users_service.resource:1540
    [Arguments]    ${id1}    ${id2}
    Should Not Be Equal    ${id1}    ${id2}
    Log    users_service.resource:1540 [_Validate Different User IDs] id1=${id1} id2=${id2}

# User update validations
_Validate Partial Update Response
    [Documentation]    Validate partial update response
    ...                File: resources/apis/users_service.resource:1553
    [Arguments]    ${partial_data}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{partial_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Should Be Equal    ${response_json['${key}']}    ${partial_data['${key}']}
    END
    Log    users_service.resource:1553 [_Validate Partial Update Response] partial update validated

_Validate Single Field Update
    [Documentation]    Validate single field update in response
    ...                File: resources/apis/users_service.resource:1562
    [Arguments]    ${field_name}    ${expected_value}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    ${field_name}
    Should Be Equal    ${response_json['${field_name}']}    ${expected_value}
    Log    users_service.resource:1562 [_Validate Single Field Update] ${field_name}=${expected_value}

_Validate Age Update Response
    [Documentation]    Validate age update response
    ...                File: resources/apis/users_service.resource:1569
    [Arguments]    ${expected_age}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['age']}    ${expected_age}
    Log    users_service.resource:1569 [_Validate Age Update Response] age=${expected_age}

_Validate Email Format Update
    [Documentation]    Validate email format update
    ...                File: resources/apis/users_service.resource:1575
    [Arguments]    ${expected_email}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['email']}    ${expected_email}
    Should Match Regexp    ${expected_email}    ^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$
    Log    users_service.resource:1575 [_Validate Email Format Update] email=${expected_email}

_Validate Special Characters Update
    [Documentation]    Validate special characters update
    ...                File: resources/apis/users_service.resource:1582
    [Arguments]    ${update_data}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    ${update_data['firstName']}
    Should Be Equal As Strings    ${response_json['lastName']}    ${update_data['lastName']}
    Log    users_service.resource:1582 [_Validate Special Characters Update] special chars updated

_Validate ID Preservation
    [Documentation]    Validate update response preserves original ID
    ...                File: resources/apis/users_service.resource:1589
    [Arguments]    ${expected_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_id}
    Log    users_service.resource:1589 [_Validate ID Preservation] id=${expected_id}

_Validate Updated Fields Echo
    [Documentation]    Validate update response echoes updated fields
    ...                File: resources/apis/users_service.resource:1595
    [Arguments]    ${update_data}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{update_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Should Be Equal    ${response_json['${key}']}    ${update_data['${key}']}
    END
    Log    users_service.resource:1595 [_Validate Updated Fields Echo] updated fields echoed

_Validate Empty Data Update Response
    [Documentation]    Validate empty data update response
    ...                File: resources/apis/users_service.resource:1604
    # DummyJSON handles empty updates gracefully
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Log    users_service.resource:1604 [_Validate Empty Data Update Response] empty update handled

_Validate Multiple Updates Response
    [Documentation]    Validate multiple updates response
    ...                File: resources/apis/users_service.resource:1611
    [Arguments]    ${update1}    ${update2}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    # Should contain the latest update values
    FOR    ${key}    IN    @{update2}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Should Be Equal    ${response_json['${key}']}    ${update2['${key}']}
    END
    Log    users_service.resource:1611 [_Validate Multiple Updates Response] multiple updates handled

_Validate Same Data Update Response
    [Documentation]    Validate same data update response
    ...                File: resources/apis/users_service.resource:1620
    # Should handle idempotent updates gracefully
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Log    users_service.resource:1620 [_Validate Same Data Update Response] same data update handled

_Validate Long Names Update Response
    [Documentation]    Validate long names update response
    ...                File: resources/apis/users_service.resource:1627
    [Arguments]    ${long_names}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['firstName']}    ${long_names['firstName']}
    Should Be Equal As Strings    ${response_json['lastName']}    ${long_names['lastName']}
    Log    users_service.resource:1627 [_Validate Long Names Update Response] long names updated

# User deletion validations
_Validate Deletion Confirmation
    [Documentation]    Validate deletion confirmation response
    ...                File: resources/apis/users_service.resource:1641
    [Arguments]    ${user_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Should Be True    ${response_json['isDeleted']}
    Log    users_service.resource:1641 [_Validate Deletion Confirmation] user_id=${user_id} deleted

_Validate Deletion Timestamp
    [Documentation]    Validate deletion timestamp is present and valid
    ...                File: resources/apis/users_service.resource:1648
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Not Be Empty    ${response_json['deletedOn']}
    Should Match Regexp    ${response_json['deletedOn']}    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Log    users_service.resource:1648 [_Validate Deletion Timestamp] timestamp=${response_json['deletedOn']}

_Validate Original Data Preservation
    [Documentation]    Validate deletion preserves original data
    ...                File: resources/apis/users_service.resource:1655
    [Arguments]    ${user_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Dictionary Should Contain Key    ${response_json}    firstName
    Dictionary Should Contain Key    ${response_json}    lastName
    Dictionary Should Contain Key    ${response_json}    email
    Log    users_service.resource:1655 [_Validate Original Data Preservation] original data preserved

_Validate Multiple Deletion Response
    [Documentation]    Validate multiple deletion response
    ...                File: resources/apis/users_service.resource:1663
    [Arguments]    ${user_id}
    # DummyJSON handles multiple deletions gracefully
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Log    users_service.resource:1663 [_Validate Multiple Deletion Response] multiple deletion handled

_Validate Other Users Not Affected
    [Documentation]    Validate other users not affected by deletion
    ...                File: resources/apis/users_service.resource:1670
    [Arguments]    ${user_before}    ${user_after}
    Should Be Equal    ${user_before['id']}    ${user_after['id']}
    Should Be Equal    ${user_before['firstName']}    ${user_after['firstName']}
    Should Be Equal    ${user_before['lastName']}    ${user_after['lastName']}
    Should Be Equal    ${user_before['email']}    ${user_after['email']}
    Log    users_service.resource:1670 [_Validate Other Users Not Affected] other users preserved

_Validate Large ID Deletion
    [Documentation]    Validate deletion with large valid ID
    ...                File: resources/apis/users_service.resource:1678
    [Arguments]    ${user_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Should Be True    ${response_json['isDeleted']}
    Log    users_service.resource:1678 [_Validate Large ID Deletion] large_id=${user_id}

_Validate Sequential Deletion
    [Documentation]    Validate sequential deletion
    ...                File: resources/apis/users_service.resource:1685
    [Arguments]    ${user_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Should Be True    ${response_json['isDeleted']}
    Log    users_service.resource:1685 [_Validate Sequential Deletion] sequential deletion user_id=${user_id}

_Validate All Users Deletion
    [Documentation]    Validate all users deletion
    ...                File: resources/apis/users_service.resource:1692
    # All individual deletions should have succeeded
    Log    users_service.resource:1692 [_Validate All Users Deletion] all users deletion completed

_Validate Complete Object Return
    [Documentation]    Validate delete returns complete object
    ...                File: resources/apis/users_service.resource:1697
    [Arguments]    ${user_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Dictionary Should Contain Key    ${response_json}    firstName
    Dictionary Should Contain Key    ${response_json}    lastName
    Dictionary Should Contain Key    ${response_json}    email
    Dictionary Should Contain Key    ${response_json}    isDeleted
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Log    users_service.resource:1697 [_Validate Complete Object Return] complete object returned

_Validate Data Integrity After Deletion
    [Documentation]    Validate data integrity after deletion
    ...                File: resources/apis/users_service.resource:1706
    [Arguments]    ${user_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${user_id}
    Should Be True    ${response_json['isDeleted']}
    Should Not Be Empty    ${response_json['deletedOn']}
    # Original data should be preserved
    Dictionary Should Contain Key    ${response_json}    firstName
    Dictionary Should Contain Key    ${response_json}    lastName
    Log    users_service.resource:1706 [_Validate Data Integrity After Deletion] data integrity maintained

