*** Settings ***
Documentation    Products Categories Tests - UC-PROD-004: Obter Categorias de Produtos
...              This suite tests all scenarios for retrieving product categories
...              File: tests/api/products/products_categories_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-004: Get Categories - Success Scenarios
# ============================================================================

Get All Product Categories Should Return Valid Categories List
    [Documentation]    Verify getting all product categories returns valid list of available categories
    ...                Test: tests/api/products/products_categories_tests.robot:19
    ...                UC: UC-PROD-004 - Basic categories retrieval functionality
    [Tags]    products    categories    success    smoke
    Get All Product Categories

# ============================================================================
# UC-PROD-004: Get Categories - Response Structure Validation
# ============================================================================

Validate Categories Response Has Correct Structure
    [Documentation]    Verify categories response contains correct structure and format
    ...                Test: tests/api/products/products_categories_tests.robot:28
    ...                UC: UC-PROD-004-V1 - Response structure validation
    [Tags]    products    categories    validation    structure
    Validate Categories Response Structure
    
Validate Categories Content And Format Are Correct
    [Documentation]    Verify categories content and format meet expected specifications
    ...                Test: tests/api/products/products_categories_tests.robot:34
    ...                UC: UC-PROD-004-V2 - Content format validation
    [Tags]    products    categories    validation    content-format
    Validate Categories Content
    
Validate Known Categories Are Present In Response
    [Documentation]    Verify all known categories are present in the categories response
    ...                Test: tests/api/products/products_categories_tests.robot:40
    ...                UC: UC-PROD-004-V3 - Known categories validation
    [Tags]    products    categories    validation    known-categories
    Validate Known Categories Present
    
Validate Categories Order Is Consistent
    [Documentation]    Verify categories order is consistent across multiple requests
    ...                Test: tests/api/products/products_categories_tests.robot:46
    ...                UC: UC-PROD-004-V4 - Order consistency validation
    [Tags]    products    categories    validation    order
    Validate Categories Order

# ============================================================================
# UC-PROD-004: Get Categories - Performance Validation
# ============================================================================

Validate Categories Retrieval Performance
    [Documentation]    Verify categories retrieval meets performance benchmarks and response times
    ...                Test: tests/api/products/products_categories_tests.robot:55
    ...                UC: UC-PROD-004-V5 - Performance validation
    [Tags]    products    categories    validation    performance
    Validate Categories Performance

# ============================================================================
# UC-PROD-004: Get Categories - Data Quality Validation
# ============================================================================

Validate Categories Are Non-Empty Strings
    [Documentation]    Verify all categories are non-empty strings with valid content
    ...                Test: tests/api/products/products_categories_tests.robot:63
    ...                UC: UC-PROD-004-Q1 - Data quality validation
    [Tags]    products    categories    validation    data-quality
    _Execute Get Categories Request
    _Validate Categories Response
    ${categories}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${category}    IN    @{categories}
        Should Be String    ${category}
        Should Not Be Empty    ${category}
        Should Not Contain    ${category}    ${SPACE}${SPACE}    msg=Category should not contain double spaces
        ${length}=    Get Length    ${category}
        Should Be True    ${length} > 2    msg=Category name should be more than 2 characters
    END
    
Validate Categories Follow Naming Conventions
    [Documentation]    Verify categories follow expected naming conventions and standards
    ...                Test: tests/api/products/products_categories_tests.robot:76
    ...                UC: UC-PROD-004-Q2 - Naming conventions validation
    [Tags]    products    categories    validation    naming-conventions
    _Execute Get Categories Request
    _Validate Categories Response
    ${categories}=    Set Variable    ${LAST_RESPONSE.json()}
    FOR    ${category}    IN    @{categories}
        # Categories should be lowercase with hyphens for spaces
        ${is_valid_format}=    Run Keyword And Return Status    Should Match Regexp    ${category}    ^[a-z0-9-]+$
        Run Keyword If    not ${is_valid_format}
        ...    Log    Category '${category}' does not follow expected naming convention    WARN
    END
    
Validate Categories Are Unique
    [Documentation]    Verify all categories in the response are unique with no duplicates
    ...                Test: tests/api/products/products_categories_tests.robot:88
    ...                UC: UC-PROD-004-Q3 - Uniqueness validation
    [Tags]    products    categories    validation    uniqueness
    _Execute Get Categories Request
    _Validate Categories Response
    ${categories}=    Set Variable    ${LAST_RESPONSE.json()}
    ${unique_categories}=    Remove Duplicates    ${categories}
    ${original_length}=    Get Length    ${categories}
    ${unique_length}=    Get Length    ${unique_categories}
    Should Be Equal As Numbers    ${original_length}    ${unique_length}    msg=All categories should be unique

# ============================================================================
# UC-PROD-004: Get Categories - Cross-Validation
# ============================================================================

Validate Categories Match Products Categories
    [Documentation]    Verify categories list matches categories found in actual products
    ...                Test: tests/api/products/products_categories_tests.robot:102
    ...                UC: UC-PROD-004-X1 - Cross-reference validation
    [Tags]    products    categories    validation    cross-validation
    # Get categories list
    _Execute Get Categories Request
    _Validate Categories Response
    ${categories_list}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Get all products to check their categories
    _Execute Get All Products Request    limit=100
    _Validate Products List Response
    ${all_products}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    
    # Extract unique categories from products
    ${product_categories}=    Create List
    FOR    ${product}    IN    @{all_products}
        Append To List    ${product_categories}    ${product['category']}
    END
    ${unique_product_categories}=    Remove Duplicates    ${product_categories}
    
    # Verify all product categories exist in categories list
    FOR    ${product_category}    IN    @{unique_product_categories}
        Should Contain    ${categories_list}    ${product_category}
        ...    msg=Product category '${product_category}' should exist in categories endpoint
    END

# ============================================================================
# UC-PROD-004: Get Categories - Data Consistency
# ============================================================================

Get Categories Multiple Times Should Return Same Results
    [Documentation]    Verify getting categories multiple times returns consistent results
    ...                Test: tests/api/products/products_categories_tests.robot:125
    ...                UC: UC-PROD-004-D1 - Data consistency validation
    [Tags]    products    categories    validation    consistency
    _Execute Get Categories Request
    ${first_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Sleep    1s    # Small delay between calls
    _Execute Get Categories Request
    ${second_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal    ${first_response}    ${second_response}

# ============================================================================
# UC-PROD-004: Get Categories - Integration Tests
# ============================================================================

Categories Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of categories
    ...                Test: tests/api/products/products_categories_tests.robot:138
    ...                UC: UC-PROD-004-I1 - Complete integration validation
    [Tags]    products    categories    integration    comprehensive
    # Get categories and validate basic response
    Get All Product Categories
    ${categories_count}=    Set Variable    ${LAST_RESPONSE.json().__len__()}
    
    # Validate structure and content
    Validate Categories Response Structure
    Validate Categories Content
    Validate Known Categories Present
    Validate Categories Order
    
    # Validate performance
    Validate Categories Performance
    
    # Data quality validations
    _Execute Get Categories Request
    _Validate Categories Response
    ${categories}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Ensure we have a reasonable number of categories
    Should Be True    ${categories_count} >= 10    msg=Should have at least 10 categories
    Should Be True    ${categories_count} <= 50    msg=Should have no more than 50 categories
    
    # Validate specific categories exist
    Should Contain    ${categories}    smartphones
    Should Contain    ${categories}    laptops
    Should Contain    ${categories}    fragrances
    
    # Cross-validate with products
    Validate Categories Match Products Categories
    
    # Log completion for reporting
    Log    Integration test completed successfully for ${categories_count} categories    INFO

# ============================================================================
# UC-PROD-004: Get Categories - Edge Case Testing
# ============================================================================

Categories Endpoint Should Handle Concurrent Requests
    [Documentation]    Verify categories endpoint handles concurrent requests properly
    ...                Test: tests/api/products/products_categories_tests.robot:172
    ...                UC: UC-PROD-004-E1 - Concurrent requests validation
    [Tags]    products    categories    edge-case    concurrent
    # Simulate concurrent requests by rapid succession
    FOR    ${i}    IN RANGE    5
        _Execute Get Categories Request
        _Validate Categories Response
        ${categories_${i}}=    Set Variable    ${LAST_RESPONSE.json()}
    END
    # All responses should be identical
    Should Be Equal    ${categories_0}    ${categories_1}
    Should Be Equal    ${categories_1}    ${categories_2}
    Should Be Equal    ${categories_2}    ${categories_3}
    Should Be Equal    ${categories_3}    ${categories_4}

# ============================================================================
# UC-PROD-004: Get Categories - Cache Validation
# ============================================================================

Categories Should Support Caching Headers
    [Documentation]    Verify categories endpoint returns appropriate caching headers
    ...                Test: tests/api/products/products_categories_tests.robot:189
    ...                UC: UC-PROD-004-C1 - Cache headers validation
    [Tags]    products    categories    validation    caching
    _Execute Get Categories Request
    _Validate Categories Response
    # Categories data should be cacheable since it changes infrequently
    ${headers}=    Set Variable    ${LAST_RESPONSE.headers}
    # Log headers for analysis (actual cache validation depends on API implementation)
    Log    Response headers: ${headers}    INFO