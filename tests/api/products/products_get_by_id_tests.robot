*** Settings ***
Documentation    Products Get By ID Tests - UC-PROD-002: Consultar Produto por ID
...              This suite tests all scenarios for retrieving product details by specific ID
...              File: tests/api/products/products_get_by_id_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-002: Get Product By ID - Success Scenarios
# ============================================================================

Get Product By Valid ID 1 Should Return Correct Product Details
    [Documentation]    Verify getting product by ID 1 returns correct product information
    ...                Test: tests/api/products/products_get_by_id_tests.robot:19
    ...                UC: UC-PROD-002-A1 - Get product by specific valid ID
    [Tags]    products    get-by-id    success    smoke    id-1
    Get Product By Valid ID 1
    
Get Product By Valid ID 5 Should Return Correct Product Details
    [Documentation]    Verify getting product by ID 5 returns correct product information
    ...                Test: tests/api/products/products_get_by_id_tests.robot:25
    ...                UC: UC-PROD-002-A2 - Get product by specific valid ID
    [Tags]    products    get-by-id    success    id-5
    Get Product By Valid ID 5
    
Get Product By Valid ID 10 Should Return Correct Product Details
    [Documentation]    Verify getting product by ID 10 returns correct product information
    ...                Test: tests/api/products/products_get_by_id_tests.robot:31
    ...                UC: UC-PROD-002-A3 - Get product by specific valid ID
    [Tags]    products    get-by-id    success    id-10
    Get Product By Valid ID 10
    
Get Product By Valid ID 15 Should Return Correct Product Details
    [Documentation]    Verify getting product by ID 15 returns correct product information
    ...                Test: tests/api/products/products_get_by_id_tests.robot:37
    ...                UC: UC-PROD-002-A4 - Get product by specific valid ID
    [Tags]    products    get-by-id    success    id-15
    Get Product By Valid ID 15
    
Get Product By Valid ID 30 Should Return Correct Product Details
    [Documentation]    Verify getting product by ID 30 returns correct product information
    ...                Test: tests/api/products/products_get_by_id_tests.robot:43
    ...                UC: UC-PROD-002-A5 - Get product by specific valid ID
    [Tags]    products    get-by-id    success    id-30
    Get Product By Valid ID 30

# ============================================================================
# UC-PROD-002: Get Product By ID - Error Scenarios
# ============================================================================

Get Product By Non-Existent ID Should Return 404 Error
    [Documentation]    Verify getting product by non-existent ID returns 404 Not Found error
    ...                Test: tests/api/products/products_get_by_id_tests.robot:52
    ...                UC: UC-PROD-002-E1 - Product not found error handling
    [Tags]    products    get-by-id    error    404    not-found
    Get Non-Existent Product By ID
    
Get Product By Negative ID Should Return 400 Error
    [Documentation]    Verify getting product by negative ID returns 400 Bad Request error
    ...                Test: tests/api/products/products_get_by_id_tests.robot:58
    ...                UC: UC-PROD-002-E2 - Invalid negative ID error handling
    [Tags]    products    get-by-id    error    400    negative-id
    Get Product By Negative ID Should Fail
    
Get Product By Zero ID Should Return 400 Error
    [Documentation]    Verify getting product by zero ID returns 400 Bad Request error
    ...                Test: tests/api/products/products_get_by_id_tests.robot:64
    ...                UC: UC-PROD-002-E3 - Invalid zero ID error handling
    [Tags]    products    get-by-id    error    400    zero-id
    Get Product By Zero ID Should Fail
    
Get Product By Text ID Should Return 400 Error
    [Documentation]    Verify getting product by text ID returns 400 Bad Request error
    ...                Test: tests/api/products/products_get_by_id_tests.robot:70
    ...                UC: UC-PROD-002-E4 - Invalid text ID error handling
    [Tags]    products    get-by-id    error    400    text-id
    Get Product By Text ID Should Fail
    
Get Product By Special Characters ID Should Return 400 Error
    [Documentation]    Verify getting product by special characters ID returns 400 Bad Request error
    ...                Test: tests/api/products/products_get_by_id_tests.robot:76
    ...                UC: UC-PROD-002-E5 - Invalid special characters ID error handling
    [Tags]    products    get-by-id    error    400    special-chars
    Get Product By Special Characters ID Should Fail

# ============================================================================
# UC-PROD-002: Get Product By ID - Response Validation
# ============================================================================

Validate Product Response Contains All Required Fields
    [Documentation]    Verify product response contains all required fields for complete product data
    ...                Test: tests/api/products/products_get_by_id_tests.robot:85
    ...                UC: UC-PROD-002-V1 - Complete field validation
    [Tags]    products    get-by-id    validation    all-fields
    Validate Product Response Contains All Fields
    
Validate Product Response Data Types Are Correct
    [Documentation]    Verify product response data types match expected format specifications
    ...                Test: tests/api/products/products_get_by_id_tests.robot:91
    ...                UC: UC-PROD-002-V2 - Data type validation
    [Tags]    products    get-by-id    validation    data-types
    Validate Product Response Data Types
    
Validate Product Images Array Structure
    [Documentation]    Verify product images array has correct structure and contains valid image URLs
    ...                Test: tests/api/products/products_get_by_id_tests.robot:97
    ...                UC: UC-PROD-002-V3 - Images array validation
    [Tags]    products    get-by-id    validation    images
    Validate Product Images Array
    
Validate Different Products Have Unique Data
    [Documentation]    Verify different product IDs return unique product data and information
    ...                Test: tests/api/products/products_get_by_id_tests.robot:103
    ...                UC: UC-PROD-002-V4 - Unique data validation
    [Tags]    products    get-by-id    validation    unique-data
    Get Different Products Should Have Unique Data

# ============================================================================
# UC-PROD-002: Get Product By ID - Performance Validation
# ============================================================================

Get Product By ID Should Meet Performance Requirements
    [Documentation]    Verify getting product by ID meets performance benchmarks
    ...                Test: tests/api/products/products_get_by_id_tests.robot:112
    ...                UC: UC-PROD-002-P1 - Performance validation
    [Tags]    products    get-by-id    validation    performance
    ${start_time}=    Get Time    epoch
    Get Valid Product By ID    1
    ${end_time}=    Get Time    epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${duration} < 3.0    msg=Product retrieval took ${duration}s, should be under 3s

# ============================================================================
# UC-PROD-002: Get Product By ID - Edge Cases and Boundary Testing
# ============================================================================

Get Product By Minimum Valid ID Should Work
    [Documentation]    Verify getting product by minimum valid ID (1) works correctly
    ...                Test: tests/api/products/products_get_by_id_tests.robot:123
    ...                UC: UC-PROD-002-B1 - Minimum boundary validation
    [Tags]    products    get-by-id    boundary    min-id
    Get Valid Product By ID    1
    
Get Product By Large Valid ID Should Work
    [Documentation]    Verify getting product by large valid ID works correctly
    ...                Test: tests/api/products/products_get_by_id_tests.robot:129
    ...                UC: UC-PROD-002-B2 - Maximum boundary validation
    [Tags]    products    get-by-id    boundary    max-id
    Get Valid Product By ID    30

# ============================================================================
# UC-PROD-002: Get Product By ID - Data Consistency
# ============================================================================

Get Same Product Multiple Times Should Return Identical Data
    [Documentation]    Verify getting the same product multiple times returns identical data
    ...                Test: tests/api/products/products_get_by_id_tests.robot:138
    ...                UC: UC-PROD-002-D1 - Data consistency validation
    [Tags]    products    get-by-id    validation    consistency
    Get Valid Product By ID    1
    ${first_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Sleep    1s    # Small delay between calls
    Get Valid Product By ID    1  
    ${second_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal    ${first_response}    ${second_response}

# ============================================================================
# UC-PROD-002: Get Product By ID - Integration Tests
# ============================================================================

Get Product By ID Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of get product by ID
    ...                Test: tests/api/products/products_get_by_id_tests.robot:151
    ...                UC: UC-PROD-002-I1 - Complete integration validation
    [Tags]    products    get-by-id    integration    comprehensive
    # Test multiple valid IDs
    Get Product By Valid ID 1
    ${product1_title}=    Set Variable    ${LAST_RESPONSE.json()['title']}
    
    Get Product By Valid ID 5
    ${product5_title}=    Set Variable    ${LAST_RESPONSE.json()['title']}
    
    Get Product By Valid ID 30
    ${product30_title}=    Set Variable    ${LAST_RESPONSE.json()['title']}
    
    # Ensure all products have different titles
    Should Not Be Equal    ${product1_title}    ${product5_title}
    Should Not Be Equal    ${product1_title}    ${product30_title}
    Should Not Be Equal    ${product5_title}    ${product30_title}
    
    # Test error scenarios
    Get Non-Existent Product By ID
    Get Product By Negative ID Should Fail
    
    # Validate response structure
    Validate Product Response Contains All Fields
    Validate Product Response Data Types
    
    # Log completion for reporting
    Log    Integration test completed successfully for product IDs: 1, 5, 30    INFO

# ============================================================================
# UC-PROD-002: Get Product By ID - Security Tests
# ============================================================================

Get Product By ID Should Handle SQL Injection Attempts
    [Documentation]    Verify product by ID endpoint handles SQL injection attempts safely
    ...                Test: tests/api/products/products_get_by_id_tests.robot:179
    ...                UC: UC-PROD-002-S1 - SQL injection security validation
    [Tags]    products    get-by-id    security    sql-injection
    # Test SQL injection in ID parameter
    _Execute Get Product By ID Request    1'; DROP TABLE products; --
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    400
    
Get Product By ID Should Handle XSS Attempts
    [Documentation]    Verify product by ID endpoint handles XSS attempts safely
    ...                Test: tests/api/products/products_get_by_id_tests.robot:187
    ...                UC: UC-PROD-002-S2 - XSS security validation
    [Tags]    products    get-by-id    security    xss
    # Test XSS in ID parameter  
    _Execute Get Product By ID Request    <script>alert('xss')</script>
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    400