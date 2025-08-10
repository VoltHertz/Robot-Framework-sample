*** Settings ***
Documentation    Products Get All Tests - UC-PROD-001: Consultar Lista de Produtos
...              This suite tests all scenarios for retrieving products list with pagination and validation
...              File: tests/api/products/products_get_all_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-001: Get All Products - Success Scenarios
# ============================================================================

Get All Products With Default Settings Should Return Valid List
    [Documentation]    Verify getting all products with default pagination returns valid product list
    ...                Test: tests/api/products/products_get_all_tests.robot:19
    ...                UC: UC-PROD-001 - Basic product listing functionality
    [Tags]    products    get-all    success    smoke    default-pagination
    Get All Products With Default Pagination
    
Get Products With Custom Pagination Should Handle Parameters Correctly
    [Documentation]    Verify getting products with custom pagination parameters works properly
    ...                Test: tests/api/products/products_get_all_tests.robot:25
    ...                UC: UC-PROD-001-A1 - Custom pagination functionality
    [Tags]    products    get-all    success    custom-pagination
    Get Products With Custom Pagination
    
Get Products With Sorting Should Order Results Correctly
    [Documentation]    Verify getting products with sorting parameters orders results as expected
    ...                Test: tests/api/products/products_get_all_tests.robot:31
    ...                UC: UC-PROD-001-A2 - Sorting functionality
    [Tags]    products    get-all    success    sorting
    Get Products With Sorting
    
Get Products With Large Limit Should Handle Boundary Values
    [Documentation]    Verify getting products with large limit parameter handles boundary conditions
    ...                Test: tests/api/products/products_get_all_tests.robot:37
    ...                UC: UC-PROD-001-A3 - Large limit boundary testing
    [Tags]    products    get-all    success    large-limit    boundary
    Get All Products With Large Limit
    
Get Products With High Skip Should Handle Offset Correctly
    [Documentation]    Verify getting products with high skip parameter handles pagination offset
    ...                Test: tests/api/products/products_get_all_tests.robot:43
    ...                UC: UC-PROD-001-A4 - High skip offset testing
    [Tags]    products    get-all    success    high-skip    pagination
    Get All Products With High Skip

# ============================================================================
# UC-PROD-001: Get All Products - Edge Cases
# ============================================================================

Get Products With Zero Limit Should Handle Edge Case
    [Documentation]    Verify getting products with zero limit parameter handles edge case properly
    ...                Test: tests/api/products/products_get_all_tests.robot:52
    ...                UC: UC-PROD-001-E1 - Zero limit edge case
    [Tags]    products    get-all    edge-case    zero-limit
    Get All Products With Zero Limit

# ============================================================================
# UC-PROD-001: Get All Products - Validation Scenarios
# ============================================================================

Validate Products Response Has Correct Structure
    [Documentation]    Verify products response contains all required fields and proper structure
    ...                Test: tests/api/products/products_get_all_tests.robot:60
    ...                UC: UC-PROD-001-V1 - Response structure validation
    [Tags]    products    get-all    validation    structure
    Validate All Products Response Structure
    
Validate Each Product Object Contains Required Fields
    [Documentation]    Verify each product object in the list contains all required fields
    ...                Test: tests/api/products/products_get_all_tests.robot:66
    ...                UC: UC-PROD-001-V2 - Product object validation
    [Tags]    products    get-all    validation    product-fields
    Validate Each Product Object Fields

# ============================================================================
# UC-PROD-001: Get All Products - Performance Validation
# ============================================================================

Get All Products Should Meet Performance Requirements
    [Documentation]    Verify getting all products meets performance benchmarks
    ...                Test: tests/api/products/products_get_all_tests.robot:75
    ...                UC: UC-PROD-001-P1 - Performance validation
    [Tags]    products    get-all    validation    performance
    ${start_time}=    Get Time    epoch
    Get All Products With Default Pagination
    ${end_time}=    Get Time    epoch
    _Validate Search Performance    ${start_time}    ${end_time}

# ============================================================================
# UC-PROD-001: Get All Products - Data Integrity
# ============================================================================

Get All Products Should Return Consistent Data
    [Documentation]    Verify getting all products returns consistent data across multiple calls
    ...                Test: tests/api/products/products_get_all_tests.robot:86
    ...                UC: UC-PROD-001-D1 - Data consistency validation
    [Tags]    products    get-all    validation    consistency
    Get All Products With Default Pagination
    ${first_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Sleep    1s    # Small delay between calls
    Get All Products With Default Pagination  
    ${second_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${first_response['total']}    ${second_response['total']}
    Length Should Be    ${first_response['products']}    ${second_response['products'].__len__()}

# ============================================================================
# UC-PROD-001: Get All Products - Comprehensive Integration
# ============================================================================

Get All Products Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of get all products
    ...                Test: tests/api/products/products_get_all_tests.robot:99
    ...                UC: UC-PROD-001-I1 - Complete integration validation
    [Tags]    products    get-all    integration    comprehensive
    # Test default pagination
    Get All Products With Default Pagination
    ${total_products}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # Test custom pagination
    Get Products With Custom Pagination
    
    # Test large limit with boundary values
    Get All Products With Large Limit
    
    # Validate structure consistency across all calls
    Validate All Products Response Structure
    Validate Each Product Object Fields
    
    # Log completion for reporting
    Log    Integration test completed successfully for ${total_products} total products    INFO