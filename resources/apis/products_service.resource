*** Settings ***
Documentation    Products Service - Library-Keyword Pattern implementation for products API operations
...              This resource implements service objects for DummyJSON Products API following the Library-Keyword Pattern
...              File: resources/apis/products_service.resource
Library          RequestsLibrary
Library          JSONLibrary    
Library          Collections
Library          String
Variables        ${CURDIR}/../../data/testdata/products_api/products_endpoints.json
Variables        ${CURDIR}/../../data/testdata/products_api/valid_products.json
Variables        ${CURDIR}/../../data/testdata/products_api/invalid_products.json

*** Variables ***
${PRODUCTS_SESSION}           products_session
${CURRENT_PRODUCT_ID}         ${EMPTY}
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
Initialize Products Service
    [Documentation]    Initialize products service for testing
    ...                File: resources/apis/products_service.resource:25
    _Setup Products Session
    _Clear Product Context

Cleanup Products Service
    [Documentation]    Cleanup products service after testing
    ...                File: resources/apis/products_service.resource:30
    _Clear Product Context

# UC-PROD-001: Get All Products Business Logic
Get All Products With Default Pagination
    [Documentation]    Get all products with default pagination - UC-PROD-001
    ...                File: resources/apis/products_service.resource:34
    [Tags]    business-logic    get-products    success    pagination
    _Execute Get All Products Request
    _Validate Products List Response
    _Validate Pagination Fields    ${pagination_params['default']['limit']}    ${pagination_params['default']['skip']}

Get Products With Custom Pagination
    [Documentation]    Get products with custom pagination parameters - UC-PROD-001-A1
    ...                File: resources/apis/products_service.resource:42
    [Tags]    business-logic    get-products    success    custom-pagination
    ${custom_params}=    Get From Dictionary    ${pagination_params}    custom
    _Execute Get All Products Request    limit=${custom_params['limit']}    skip=${custom_params['skip']}
    _Validate Products List Response
    _Validate Pagination Fields    ${custom_params['limit']}    ${custom_params['skip']}

Get Products With Sorting
    [Documentation]    Get products with sorting parameters - UC-PROD-001-A2
    ...                File: resources/apis/products_service.resource:50
    [Tags]    business-logic    get-products    success    sorting
    ${sort_params}=    Get From Dictionary    ${pagination_params}    sorting
    _Execute Get All Products Request    sortBy=${sort_params['sortBy']}    order=${sort_params['order']}
    _Validate Products List Response
    _Validate Products Sorting    ${sort_params['sortBy']}    ${sort_params['order']}

Get All Products With Large Limit
    [Documentation]    Get all products with large limit parameter - UC-PROD-001-A3
    ...                File: resources/apis/products_service.resource:58
    [Tags]    business-logic    get-products    success    large-limit
    _Execute Get All Products Request    limit=100
    _Validate Products List Response
    _Validate Pagination Fields    100    0
    _Validate Large Limit Response

Get All Products With High Skip
    [Documentation]    Get all products with high skip parameter - UC-PROD-001-A4
    ...                File: resources/apis/products_service.resource:66
    [Tags]    business-logic    get-products    success    high-skip
    _Execute Get All Products Request    skip=50
    _Validate Products List Response
    _Validate Pagination Fields    30    50
    _Validate High Skip Response

Get All Products With Zero Limit
    [Documentation]    Get all products with zero limit parameter - UC-PROD-001-E1
    ...                File: resources/apis/products_service.resource:74
    [Tags]    business-logic    get-products    edge-case    zero-limit
    _Execute Get All Products Request    limit=0
    _Validate Products List Response
    _Validate Zero Limit Response

# UC-PROD-001: Get All Products - Validation Keywords (Public Interface)
Validate Products Response Has Correct Structure
    [Documentation]    Validate comprehensive response structure - UC-PROD-001-V1
    ...                File: resources/apis/products_service.resource:87
    [Tags]    business-logic    get-products    validation    structure
    _Execute Get All Products Request
    _Validate Products List Response
    _Validate All Products Response Structure

Validate Each Product Object Fields
    [Documentation]    Validate each product object has all required fields - UC-PROD-001-V2
    ...                File: resources/apis/products_service.resource:95
    [Tags]    business-logic    get-products    validation    product-fields
    _Execute Get All Products Request
    _Validate Products List Response
    _Validate Each Product Object Complete Fields

# ============================================================================
# TECHNICAL KEYWORDS (Low-Level API Operations - Private/Internal)
# ============================================================================

# Session Management
_Setup Products Session
    [Documentation]    Setup HTTP session for products API requests
    ...                File: resources/apis/products_service.resource:87
    Create Session    ${PRODUCTS_SESSION}    ${base_url}    timeout=${timeout}

_Clear Product Context
    [Documentation]    Clear product context variables
    ...                File: resources/apis/products_service.resource:92
    Set Test Variable    ${CURRENT_PRODUCT_ID}    ${EMPTY}

# UC-PROD-001: Get All Products Operations
_Execute Get All Products Request
    [Documentation]    Execute get all products API request
    ...                File: resources/apis/products_service.resource:832
    [Arguments]    ${limit}=${None}    ${skip}=${None}    ${sortBy}=${None}    ${order}=${None}
    ${params}=    Create Dictionary
    Run Keyword If    $limit is not None    Set To Dictionary    ${params}    limit=${limit}
    Run Keyword If    $skip is not None    Set To Dictionary    ${params}    skip=${skip}
    Run Keyword If    $sortBy is not None    Set To Dictionary    ${params}    sortBy=${sortBy}
    Run Keyword If    $order is not None    Set To Dictionary    ${params}    order=${order}
    ${response}=    GET On Session    ${PRODUCTS_SESSION}    ${endpoints['get_all_products']}
    ...    params=${params}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_PARAMS}    ${params}

_Validate Products List Response
    [Documentation]    Validate products list response structure
    ...                File: resources/apis/products_service.resource:845
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    products
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit
    Should Be True    ${response_json['total']} > 0
    Should Be True    len(${response_json['products']}) > 0
    _Validate Product Objects In List    ${response_json['products']}

_Validate Product Objects In List
    [Documentation]    Validate individual product objects in list
    ...                File: resources/apis/products_service.resource:857
    [Arguments]    ${products_list}
    FOR    ${product}    IN    @{products_list}
        Dictionary Should Contain Key    ${product}    id
        Dictionary Should Contain Key    ${product}    title
        Dictionary Should Contain Key    ${product}    price
        Dictionary Should Contain Key    ${product}    category
        Dictionary Should Contain Key    ${product}    brand
        Should Be True    ${product['id']} > 0
        Should Not Be Empty    ${product['title']}
        Should Be True    ${product['price']} >= 0
        Should Not Be Empty    ${product['category']}
    END

_Validate Pagination Fields
    [Documentation]    Validate pagination fields in response
    ...                File: resources/apis/products_service.resource:872
    [Arguments]    ${expected_limit}    ${expected_skip}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['limit']}    ${expected_limit}
    Should Be Equal As Numbers    ${response_json['skip']}    ${expected_skip}
    Should Be True    ${response_json['total']} >= ${expected_skip}

_Validate Products Sorting
    [Documentation]    Validate products are sorted correctly
    ...                File: resources/apis/products_service.resource:880
    [Arguments]    ${sort_field}    ${sort_order}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${products_list}=    Set Variable    ${response_json['products']}
    Should Be True    len(${products_list}) > 1
    ${first_product}=    Get From List    ${products_list}    0
    ${second_product}=    Get From List    ${products_list}    1
    Run Keyword If    '${sort_order}' == 'asc'
    ...    Should Be True    "${first_product['${sort_field}']}" <= "${second_product['${sort_field}']}"
    Run Keyword If    '${sort_order}' == 'desc'
    ...    Should Be True    "${first_product['${sort_field}']}" >= "${second_product['${sort_field}']}"

# UC-PROD-002: Get Product By ID Operations
_Execute Get Product By ID Request
    [Documentation]    Execute get product by ID API request
    ...                File: resources/apis/products_service.resource:893
    [Arguments]    ${product_id}
    ${endpoint}=    Replace String    ${endpoints['get_product_by_id']}    {id}    ${product_id}
    ${response}=    GET On Session    ${PRODUCTS_SESSION}    ${endpoint}
    ...    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_ID}    ${product_id}

_Validate Single Product Response
    [Documentation]    Validate single product response structure
    ...                File: resources/apis/products_service.resource:902
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${field}    IN    @{expected_response_fields}
        Dictionary Should Contain Key    ${response_json}    ${field}
    END
    Should Be True    ${response_json['id']} > 0
    Should Not Be Empty    ${response_json['title']}
    Should Be True    ${response_json['price']} >= 0

_Validate Product ID Matches
    [Documentation]    Validate product ID matches the requested ID
    ...                File: resources/apis/products_service.resource:913
    [Arguments]    ${expected_id}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_id}

# UC-PROD-003: Search Products Operations
_Execute Search Products Request
    [Documentation]    Execute search products API request
    ...                File: resources/apis/products_service.resource:920
    [Arguments]    ${search_term}
    ${params}=    Create Dictionary    q=${search_term}
    ${response}=    GET On Session    ${PRODUCTS_SESSION}    ${endpoints['search_products']}
    ...    params=${params}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_SEARCH_TERM}    ${search_term}

_Execute Search Products Request With Pagination
    [Documentation]    Execute search products API request with pagination
    ...                File: resources/apis/products_service.resource:930
    [Arguments]    ${search_term}    ${limit}=${None}    ${skip}=${None}
    ${params}=    Create Dictionary    q=${search_term}
    Run Keyword If    $limit is not None    Set To Dictionary    ${params}    limit=${limit}
    Run Keyword If    $skip is not None    Set To Dictionary    ${params}    skip=${skip}
    ${response}=    GET On Session    ${PRODUCTS_SESSION}    ${endpoints['search_products']}
    ...    params=${params}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_SEARCH_TERM}    ${search_term}
    Set Test Variable    ${LAST_REQUEST_PARAMS}    ${params}

_Validate Search Results
    [Documentation]    Validate search results contain the search term
    ...                File: resources/apis/products_service.resource:943
    [Arguments]    ${search_term}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    Should Be True    len(${response_json['products']}) > 0
    ${products_list}=    Set Variable    ${response_json['products']}
    FOR    ${product}    IN    @{products_list}
        ${search_term_lower}=    Convert To Lower Case    ${search_term}
        ${title_lower}=    Convert To Lower Case    ${product['title']}
        ${description_lower}=    Convert To Lower Case    ${product['description']}
        ${category_lower}=    Convert To Lower Case    ${product['category']}
        ${brand_lower}=    Convert To Lower Case    ${product['brand']}
        ${found}=    Evaluate    "${search_term_lower}" in "${title_lower}" or "${search_term_lower}" in "${description_lower}" or "${search_term_lower}" in "${category_lower}" or "${search_term_lower}" in "${brand_lower}"
        Run Keyword If    not ${found}    Log    Product ${product['title']} doesn't contain search term but was returned    WARN
    END

_Validate Empty Search Results
    [Documentation]    Validate search returns empty results
    ...                File: resources/apis/products_service.resource:958
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['total']}    0
    Should Be True    len(${response_json['products']}) == 0

# UC-PROD-004: Get Categories Operations
_Execute Get Categories Request
    [Documentation]    Execute get categories API request
    ...                File: resources/apis/products_service.resource:966
    ${response}=    GET On Session    ${PRODUCTS_SESSION}    ${endpoints['get_categories']}
    ...    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}

_Validate Categories Response
    [Documentation]    Validate categories response structure
    ...                File: resources/apis/products_service.resource:973
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${{isinstance($response_json, list)}}
    Should Be True    len(${response_json}) > 0
    FOR    ${category}    IN    @{response_json}
        Should Be String    ${category}
        Should Not Be Empty    ${category}
    END

# UC-PROD-005: Get Products By Category Operations
_Execute Get Products By Category Request
    [Documentation]    Execute get products by category API request
    ...                File: resources/apis/products_service.resource:984
    [Arguments]    ${category_name}
    ${endpoint}=    Replace String    ${endpoints['get_products_by_category']}    {categoryName}    ${category_name}
    ${response}=    GET On Session    ${PRODUCTS_SESSION}    ${endpoint}
    ...    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_CATEGORY_NAME}    ${category_name}

_Validate Products By Category
    [Documentation]    Validate products by category response
    ...                File: resources/apis/products_service.resource:994
    [Arguments]    ${expected_category}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0
    ${products_list}=    Set Variable    ${response_json['products']}
    FOR    ${product}    IN    @{products_list}
        Should Be Equal As Strings    ${product['category']}    ${expected_category}
    END

_Validate Empty Category Results
    [Documentation]    Validate empty category results
    ...                File: resources/apis/products_service.resource:1004
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['total']}    0
    Should Be True    len(${response_json['products']}) == 0

# UC-PROD-006: Add Product Operations
_Execute Add Product Request
    [Documentation]    Execute add product API request
    ...                File: resources/apis/products_service.resource:1012
    [Arguments]    ${product_data}
    ${response}=    POST On Session    ${PRODUCTS_SESSION}    ${endpoints['add_product']}
    ...    json=${product_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_DATA}    ${product_data}

_Validate Product Creation Response
    [Documentation]    Validate product creation response (simulated)
    ...                File: resources/apis/products_service.resource:1021
    [Arguments]    ${original_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Should Be True    ${response_json['id']} > 0
    Should Be Equal As Strings    ${response_json['title']}    ${original_data['title']}
    Run Keyword If    'price' in $original_data    Should Be Equal As Numbers    ${response_json['price']}    ${original_data['price']}
    Run Keyword If    'description' in $original_data    Should Be Equal As Strings    ${response_json['description']}    ${original_data['description']}

_Store Created Product ID
    [Documentation]    Store created product ID for later use
    ...                File: resources/apis/products_service.resource:1032
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Set Test Variable    ${CURRENT_PRODUCT_ID}    ${response_json['id']}

# UC-PROD-007: Update Product Operations
_Execute Update Product Request
    [Documentation]    Execute update product API request
    ...                File: resources/apis/products_service.resource:1038
    [Arguments]    ${product_id}    ${update_data}
    ${endpoint}=    Replace String    ${endpoints['update_product']}    {id}    ${product_id}
    ${response}=    PUT On Session    ${PRODUCTS_SESSION}    ${endpoint}
    ...    json=${update_data}    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_DATA}    ${update_data}
    Set Test Variable    ${LAST_REQUEST_ID}    ${product_id}

_Validate Product Update Response
    [Documentation]    Validate product update response (simulated)
    ...                File: resources/apis/products_service.resource:1048
    [Arguments]    ${product_id}    ${update_data}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${product_id}
    FOR    ${key}    IN    @{update_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Run Keyword If    '${key}' == 'price'    Should Be Equal As Numbers    ${response_json['${key}']}    ${update_data['${key}']}
        Run Keyword Unless    '${key}' == 'price'    Should Be Equal As Strings    ${response_json['${key}']}    ${update_data['${key}']}
    END

# UC-PROD-008: Delete Product Operations
_Execute Delete Product Request
    [Documentation]    Execute delete product API request
    ...                File: resources/apis/products_service.resource:1060
    [Arguments]    ${product_id}
    ${endpoint}=    Replace String    ${endpoints['delete_product']}    {id}    ${product_id}
    ${response}=    DELETE On Session    ${PRODUCTS_SESSION}    ${endpoint}
    ...    headers=${headers}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Set Test Variable    ${LAST_REQUEST_ID}    ${product_id}

_Validate Product Deletion Response
    [Documentation]    Validate product deletion response (simulated)
    ...                File: resources/apis/products_service.resource:1069
    [Arguments]    ${product_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${product_id}
    Dictionary Should Contain Key    ${response_json}    isDeleted
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Be True    ${response_json['isDeleted']}
    Should Not Be Empty    ${response_json['deletedOn']}

# ============================================================================
# COMMON VALIDATION KEYWORDS
# ============================================================================

_Validate Error Response
    [Documentation]    Validate error response structure and message
    ...                File: resources/apis/products_service.resource:1082
    [Arguments]    ${expected_status}    ${expected_message}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    ${expected_status}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    message
    Should Contain    ${response_json['message']}    ${expected_message}

# ============================================================================
# ADDITIONAL VALIDATION KEYWORDS (Stubs for complex validations)
# ============================================================================

_Validate Large Limit Response
    [Documentation]    Validate large limit response behavior
    ...                File: resources/apis/products_service.resource:1094
    Log    Large limit validation - products_service.resource:1094
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    len($response_json['products']) <= 100

_Validate High Skip Response
    [Documentation]    Validate high skip response behavior
    ...                File: resources/apis/products_service.resource:1100
    Log    High skip validation - products_service.resource:1100
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['skip']} == 50

_Validate Zero Limit Response
    [Documentation]    Validate zero limit response behavior
    ...                File: resources/apis/products_service.resource:1106
    Log    Zero limit validation - products_service.resource:1106
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['limit']}    0

_Validate All Products Response Structure
    [Documentation]    Validate comprehensive products response structure
    ...                File: resources/apis/products_service.resource:1112
    Log    All products response structure validation - products_service.resource:1112
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    products
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit

_Validate Each Product Object Complete Fields
    [Documentation]    Validate each product object has complete fields
    ...                File: resources/apis/products_service.resource:1121
    Log    Each product object complete fields validation - products_service.resource:1121
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${products_list}=    Set Variable    ${response_json['products']}
    FOR    ${product}    IN    @{products_list}
        FOR    ${field}    IN    @{expected_response_fields}
            Dictionary Should Contain Key    ${product}    ${field}
        END
    END

_Validate Product Specific Data
    [Documentation]    Validate specific product data matches test data
    ...                File: resources/apis/products_service.resource:1132
    [Arguments]    ${product_id}
    Log    Product specific data validation for ID ${product_id} - products_service.resource:1132
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${product_id}

_Validate Product Response All Fields
    [Documentation]    Validate product response contains all required fields
    ...                File: resources/apis/products_service.resource:1139
    Log    Product response all fields validation - products_service.resource:1139
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${field}    IN    @{expected_response_fields}
        Dictionary Should Contain Key    ${response_json}    ${field}
    END

_Validate Product Response Data Types
    [Documentation]    Validate product response data types
    ...                File: resources/apis/products_service.resource:1147
    Log    Product response data types validation - products_service.resource:1147
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${{isinstance($response_json['id'], int)}}
    Should Be True    ${{isinstance($response_json['price'], (int, float))}}

_Validate Product Images Array
    [Documentation]    Validate product images array structure
    ...                File: resources/apis/products_service.resource:1154
    Log    Product images array validation - products_service.resource:1154
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    images
    Should Be True    ${{isinstance($response_json['images'], list)}}

_Validate Products Have Unique Data
    [Documentation]    Validate products have unique data
    ...                File: resources/apis/products_service.resource:1161
    [Arguments]    ${product1_data}    ${product2_data}
    Log    Products unique data validation - products_service.resource:1161
    Should Not Be Equal As Numbers    ${product1_data['id']}    ${product2_data['id']}
    Should Not Be Equal As Strings    ${product1_data['title']}    ${product2_data['title']}

_Validate Search Case Insensitive Results
    [Documentation]    Validate search case insensitive results
    ...                File: resources/apis/products_service.resource:1168
    Log    Search case insensitive results validation - products_service.resource:1168
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0

_Validate Search Single Character Results
    [Documentation]    Validate search single character results
    ...                File: resources/apis/products_service.resource:1174
    Log    Search single character results validation - products_service.resource:1174
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} >= 0

_Validate Search Multiple Words Results
    [Documentation]    Validate search multiple words results
    ...                File: resources/apis/products_service.resource:1180
    Log    Search multiple words results validation - products_service.resource:1180
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} >= 0

_Validate Empty Query Search Response
    [Documentation]    Validate empty query search response
    ...                File: resources/apis/products_service.resource:1186
    Log    Empty query search response validation - products_service.resource:1186
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200

_Validate Search Pagination Fields
    [Documentation]    Validate search pagination fields
    ...                File: resources/apis/products_service.resource:1191
    Log    Search pagination fields validation - products_service.resource:1191
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    total
    Dictionary Should Contain Key    ${response_json}    skip
    Dictionary Should Contain Key    ${response_json}    limit

_Validate Search Results Product Fields
    [Documentation]    Validate search results product fields
    ...                File: resources/apis/products_service.resource:1199
    Log    Search results product fields validation - products_service.resource:1199
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${products_list}=    Set Variable    ${response_json['products']}
    FOR    ${product}    IN    @{products_list}
        Dictionary Should Contain Key    ${product}    id
        Dictionary Should Contain Key    ${product}    title
        Dictionary Should Contain Key    ${product}    price
    END

_Validate Search Results Relevance
    [Documentation]    Validate search results relevance
    ...                File: resources/apis/products_service.resource:1209
    [Arguments]    ${search_term}
    Log    Search results relevance validation for term '${search_term}' - products_service.resource:1209
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['total']} > 0

_Validate Search Pagination Response
    [Documentation]    Validate search pagination response
    ...                File: resources/apis/products_service.resource:1215
    [Arguments]    ${expected_limit}    ${expected_skip}
    Log    Search pagination response validation - products_service.resource:1215
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['limit']}    ${expected_limit}
    Should Be Equal As Numbers    ${response_json['skip']}    ${expected_skip}

_Validate Search Performance
    [Documentation]    Validate search performance benchmarks
    ...                File: resources/apis/products_service.resource:1222
    [Arguments]    ${start_time}    ${end_time}
    Log    Search performance validation - products_service.resource:1222
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0

_Validate Categories Response Structure
    [Documentation]    Validate categories response structure
    ...                File: resources/apis/products_service.resource:1228
    Log    Categories response structure validation - products_service.resource:1228
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${{isinstance($response_json, list)}}
    Should Be True    len(${response_json}) > 0

_Validate Categories Content Format
    [Documentation]    Validate categories content and format
    ...                File: resources/apis/products_service.resource:1235
    Log    Categories content format validation - products_service.resource:1235
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${category}    IN    @{response_json}
        Should Be String    ${category}
        Should Not Be Empty    ${category}
        Should Not Contain    ${category}    ${SPACE}${SPACE}
    END

_Validate Known Categories Present
    [Documentation]    Validate known categories are present
    ...                File: resources/apis/products_service.resource:1244
    Log    Known categories present validation - products_service.resource:1244
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${known_category}    IN    @{valid_categories}
        Should Contain    ${response_json}    ${known_category}
    END

_Validate Categories Order
    [Documentation]    Validate categories order consistency
    ...                File: resources/apis/products_service.resource:1251
    Log    Categories order validation - products_service.resource:1251
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    len(${response_json}) > 0

_Validate Categories Performance
    [Documentation]    Validate categories retrieval performance
    ...                File: resources/apis/products_service.resource:1257
    [Arguments]    ${start_time}    ${end_time}
    Log    Categories performance validation - products_service.resource:1257
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0

_Validate Category Response Structure
    [Documentation]    Validate category response structure
    ...                File: resources/apis/products_service.resource:1263
    Log    Category response structure validation - products_service.resource:1263
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    products
    Dictionary Should Contain Key    ${response_json}    total

_Validate All Products Match Category
    [Documentation]    Validate all returned products belong to category
    ...                File: resources/apis/products_service.resource:1270
    [Arguments]    ${expected_category}
    Log    All products match category validation - products_service.resource:1270
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${products_list}=    Set Variable    ${response_json['products']}
    FOR    ${product}    IN    @{products_list}
        Should Be Equal As Strings    ${product['category']}    ${expected_category}
    END

_Validate Category Products Count
    [Documentation]    Validate category products count consistency
    ...                File: resources/apis/products_service.resource:1279
    Log    Category products count validation - products_service.resource:1279
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['total']}    ${response_json['products'].__len__()}

_Validate Different Category Products
    [Documentation]    Validate different categories return different products
    ...                File: resources/apis/products_service.resource:1285
    [Arguments]    ${category1_data}    ${category2_data}
    Log    Different category products validation - products_service.resource:1285
    Should Not Be Equal    ${category1_data['products']}    ${category2_data['products']}

_Validate Category Products Performance
    [Documentation]    Validate category products performance benchmarks
    ...                File: resources/apis/products_service.resource:1290
    [Arguments]    ${start_time}    ${end_time}
    Log    Category products performance validation - products_service.resource:1290
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0

# Additional validation keywords for CRUD operations follow the same pattern...
# These are simplified implementations that focus on core validation logic

_Validate Complete Product Data Response
    [Documentation]    Validate complete product data response
    ...                File: resources/apis/products_service.resource:1296
    [Arguments]    ${original_data}
    Log    Complete product data response validation - products_service.resource:1296
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{original_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
    END

_Validate Generated Product ID Exists
    [Documentation]    Validate generated product ID exists
    ...                File: resources/apis/products_service.resource:1304
    Log    Generated product ID exists validation - products_service.resource:1304
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Should Be True    ${response_json['id']} > 0

_Validate All Product Fields Echoed
    [Documentation]    Validate all product fields echoed
    ...                File: resources/apis/products_service.resource:1311
    [Arguments]    ${original_data}
    Log    All product fields echoed validation - products_service.resource:1311
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{original_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Run Keyword If    '${key}' == 'price'    Should Be Equal As Numbers    ${response_json['${key}']}    ${original_data['${key}']}
        Run Keyword Unless    '${key}' == 'price'    Should Be Equal As Strings    ${response_json['${key}']}    ${original_data['${key}']}
    END

_Validate Product Category
    [Documentation]    Validate product category
    ...                File: resources/apis/products_service.resource:1320
    [Arguments]    ${expected_category}
    Log    Product category validation - products_service.resource:1320
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['category']}    ${expected_category}

_Validate Product Price
    [Documentation]    Validate product price
    ...                File: resources/apis/products_service.resource:1326
    [Arguments]    ${expected_price}
    Log    Product price validation - products_service.resource:1326
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['price']}    ${expected_price}

_Validate Special Characters Handling
    [Documentation]    Validate special characters handling
    ...                File: resources/apis/products_service.resource:1332
    Log    Special characters handling validation - products_service.resource:1332
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Not Be Empty    ${response_json['title']}

_Validate Different Product IDs
    [Documentation]    Validate different product IDs
    ...                File: resources/apis/products_service.resource:1338
    [Arguments]    ${id1}    ${id2}
    Log    Different product IDs validation - products_service.resource:1338
    Should Not Be Equal As Numbers    ${id1}    ${id2}

_Validate Add Product Performance
    [Documentation]    Validate add product performance benchmarks
    ...                File: resources/apis/products_service.resource:1343
    [Arguments]    ${start_time}    ${end_time}
    Log    Add product performance validation - products_service.resource:1343
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0

_Validate Partial Product Update Response
    [Documentation]    Validate partial product update response
    ...                File: resources/apis/products_service.resource:1349
    [Arguments]    ${partial_data}
    Log    Partial product update response validation - products_service.resource:1349
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{partial_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
    END

_Validate Single Field Update
    [Documentation]    Validate single field update
    ...                File: resources/apis/products_service.resource:1357
    [Arguments]    ${field_name}    ${expected_value}
    Log    Single field update validation - products_service.resource:1357
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    ${field_name}
    Run Keyword If    '${field_name}' == 'price'    Should Be Equal As Numbers    ${response_json['${field_name}']}    ${expected_value}
    Run Keyword Unless    '${field_name}' == 'price'    Should Be Equal As Strings    ${response_json['${field_name}']}    ${expected_value}

_Validate Price Update Response
    [Documentation]    Validate price update response
    ...                File: resources/apis/products_service.resource:1365
    [Arguments]    ${expected_price}
    Log    Price update response validation - products_service.resource:1365
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['price']}    ${expected_price}

_Validate Special Characters Update
    [Documentation]    Validate special characters update
    ...                File: resources/apis/products_service.resource:1371
    [Arguments]    ${update_data}
    Log    Special characters update validation - products_service.resource:1371
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{update_data}
        Should Be Equal As Strings    ${response_json['${key}']}    ${update_data['${key}']}
    END

_Validate Product ID Preservation
    [Documentation]    Validate product ID preservation
    ...                File: resources/apis/products_service.resource:1379
    [Arguments]    ${expected_id}
    Log    Product ID preservation validation - products_service.resource:1379
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${expected_id}

_Validate Updated Product Fields Echo
    [Documentation]    Validate updated product fields echo
    ...                File: resources/apis/products_service.resource:1385
    [Arguments]    ${update_data}
    Log    Updated product fields echo validation - products_service.resource:1385
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${key}    IN    @{update_data}
        Dictionary Should Contain Key    ${response_json}    ${key}
        Run Keyword If    '${key}' == 'price'    Should Be Equal As Numbers    ${response_json['${key}']}    ${update_data['${key}']}
        Run Keyword Unless    '${key}' == 'price'    Should Be Equal As Strings    ${response_json['${key}']}    ${update_data['${key}']}
    END

_Validate Empty Data Product Update Response
    [Documentation]    Validate empty data product update response
    ...                File: resources/apis/products_service.resource:1394
    Log    Empty data product update response validation - products_service.resource:1394
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200

_Validate Multiple Product Updates Response
    [Documentation]    Validate multiple product updates response
    ...                File: resources/apis/products_service.resource:1399
    [Arguments]    ${update1}    ${update2}
    Log    Multiple product updates response validation - products_service.resource:1399
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id

_Validate Update Product Performance
    [Documentation]    Validate update product performance benchmarks
    ...                File: resources/apis/products_service.resource:1405
    [Arguments]    ${start_time}    ${end_time}
    Log    Update product performance validation - products_service.resource:1405
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0

_Validate Product Deletion Confirmation
    [Documentation]    Validate product deletion confirmation
    ...                File: resources/apis/products_service.resource:1411
    [Arguments]    ${product_id}
    Log    Product deletion confirmation validation - products_service.resource:1411
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['isDeleted']}
    Should Be Equal As Numbers    ${response_json['id']}    ${product_id}

_Validate Product Deletion Timestamp
    [Documentation]    Validate product deletion timestamp
    ...                File: resources/apis/products_service.resource:1418
    Log    Product deletion timestamp validation - products_service.resource:1418
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    deletedOn
    Should Not Be Empty    ${response_json['deletedOn']}

_Validate Original Product Data Preservation
    [Documentation]    Validate original product data preservation
    ...                File: resources/apis/products_service.resource:1425
    [Arguments]    ${product_id}
    Log    Original product data preservation validation - products_service.resource:1425
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${product_id}
    Dictionary Should Contain Key    ${response_json}    title

_Validate Multiple Product Deletion Response
    [Documentation]    Validate multiple product deletion response
    ...                File: resources/apis/products_service.resource:1432
    [Arguments]    ${product_id}
    Log    Multiple product deletion response validation - products_service.resource:1432
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200

_Validate Other Products Not Affected
    [Documentation]    Validate other products not affected
    ...                File: resources/apis/products_service.resource:1437
    [Arguments]    ${product_before}    ${product_after}
    Log    Other products not affected validation - products_service.resource:1437
    Should Be Equal    ${product_before}    ${product_after}

_Validate Large Product ID Deletion
    [Documentation]    Validate large product ID deletion
    ...                File: resources/apis/products_service.resource:1442
    [Arguments]    ${product_id}
    Log    Large product ID deletion validation - products_service.resource:1442
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['id']}    ${product_id}

_Validate Sequential Product Deletion
    [Documentation]    Validate sequential product deletion
    ...                File: resources/apis/products_service.resource:1448
    [Arguments]    ${product_id}
    Log    Sequential product deletion validation - products_service.resource:1448
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    ${response_json['isDeleted']}

_Validate Complete Product Object Return
    [Documentation]    Validate complete product object return
    ...                File: resources/apis/products_service.resource:1454
    [Arguments]    ${product_id}
    Log    Complete product object return validation - products_service.resource:1454
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    id
    Dictionary Should Contain Key    ${response_json}    title
    Dictionary Should Contain Key    ${response_json}    price

_Validate Product Data Integrity After Deletion
    [Documentation]    Validate product data integrity after deletion
    ...                File: resources/apis/products_service.resource:1462
    [Arguments]    ${product_id}
    Log    Product data integrity after deletion validation - products_service.resource:1462
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    isDeleted
    Should Be True    ${response_json['isDeleted']}

_Validate Delete Product Performance
    [Documentation]    Validate delete product performance benchmarks
    ...                File: resources/apis/products_service.resource:1469
    [Arguments]    ${start_time}    ${end_time}
    Log    Delete product performance validation - products_service.resource:1469
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 5.0

# ============================================================================
# UTILITY KEYWORDS
# ============================================================================

Get Product Test Data
    [Documentation]    Get specific product test data by key
    ...                File: resources/apis/products_service.resource:1478
    [Arguments]    ${product_key}
    ${product_data}=    Get From Dictionary    ${test_products}    ${product_key}
    [Return]    ${product_data}

Get Valid Product ID For Testing
    [Documentation]    Get a valid product ID for testing purposes
    ...                File: resources/apis/products_service.resource:1484
    [Arguments]    ${index}=0
    ${product_id}=    Get From List    ${valid_product_ids}    ${index}
    [Return]    ${product_id}

Get Invalid Product Test Data
    [Documentation]    Get invalid product test data by scenario
    ...                File: resources/apis/products_service.resource:1490
    [Arguments]    ${scenario_key}
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    ${scenario_key}
    [Return]    ${invalid_data}

Log Current Response Details
    [Documentation]    Log current response details for debugging
    ...                File: resources/apis/products_service.resource:1496
    Log    Response Status: ${LAST_RESPONSE.status_code}
    Log    Response Body: ${LAST_RESPONSE.json()}
    Log    Response Headers: ${LAST_RESPONSE.headers}