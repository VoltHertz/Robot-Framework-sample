*** Settings ***
Documentation    Products By Category Tests - UC-PROD-005: Obter Produtos por Categoria
...              This suite tests all scenarios for retrieving products filtered by specific categories
...              File: tests/api/products/products_by_category_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-005: Get Products By Category - Success Scenarios
# ============================================================================

Get Products By Smartphones Category Should Return Smartphone Products
    [Documentation]    Verify getting products by smartphones category returns only smartphone products
    ...                Test: tests/api/products/products_by_category_tests.robot:19
    ...                UC: UC-PROD-005 - Smartphones category filtering
    [Tags]    products    by-category    success    smoke    smartphones
    Get Products By Valid Category Smartphones
    
Get Products By Laptops Category Should Return Laptop Products
    [Documentation]    Verify getting products by laptops category returns only laptop products
    ...                Test: tests/api/products/products_by_category_tests.robot:25
    ...                UC: UC-PROD-005-A1 - Laptops category filtering
    [Tags]    products    by-category    success    laptops
    Get Products By Valid Category Laptops
    
Get Products By Fragrances Category Should Return Fragrance Products
    [Documentation]    Verify getting products by fragrances category returns only fragrance products
    ...                Test: tests/api/products/products_by_category_tests.robot:31
    ...                UC: UC-PROD-005-A2 - Fragrances category filtering
    [Tags]    products    by-category    success    fragrances
    Get Products By Valid Category Fragrances
    
Get Products By Home Decoration Category Should Return Home Decor Products
    [Documentation]    Verify getting products by home-decoration category returns only home decoration products
    ...                Test: tests/api/products/products_by_category_tests.robot:37
    ...                UC: UC-PROD-005-A3 - Home decoration category filtering
    [Tags]    products    by-category    success    home-decoration
    Get Products By Valid Category Home Decoration

# ============================================================================
# UC-PROD-005: Get Products By Category - Empty Results Scenarios
# ============================================================================

Get Products By Non-Existent Category Should Return Empty Results
    [Documentation]    Verify getting products by non-existent category returns empty results gracefully
    ...                Test: tests/api/products/products_by_category_tests.robot:46
    ...                UC: UC-PROD-005-A1 - Non-existent category handling
    [Tags]    products    by-category    success    empty-results    non-existent
    Get Products By Non-Existent Category

# ============================================================================
# UC-PROD-005: Get Products By Category - Edge Cases
# ============================================================================

Get Products By Invalid Special Characters Category Should Handle Gracefully
    [Documentation]    Verify getting products by invalid special characters category handles gracefully
    ...                Test: tests/api/products/products_by_category_tests.robot:55
    ...                UC: UC-PROD-005-E1 - Special characters category edge case
    [Tags]    products    by-category    edge-case    special-chars
    Get Products By Invalid Special Characters Category
    
Get Products By Numeric Category Should Handle Gracefully
    [Documentation]    Verify getting products by numeric category handles gracefully
    ...                Test: tests/api/products/products_by_category_tests.robot:61
    ...                UC: UC-PROD-005-E2 - Numeric category edge case
    [Tags]    products    by-category    edge-case    numeric
    Get Products By Numeric Category

# ============================================================================
# UC-PROD-005: Get Products By Category - Response Validation
# ============================================================================

Validate Products By Category Response Structure
    [Documentation]    Verify products by category response contains all required fields and structure
    ...                Test: tests/api/products/products_by_category_tests.robot:70
    ...                UC: UC-PROD-005-V1 - Response structure validation
    [Tags]    products    by-category    validation    structure
    Validate Products By Category Response Structure
    
Validate All Products Belong To Requested Category
    [Documentation]    Verify all returned products belong to the requested category
    ...                Test: tests/api/products/products_by_category_tests.robot:76
    ...                UC: UC-PROD-005-V2 - Category matching validation
    [Tags]    products    by-category    validation    category-match
    Validate All Products Belong To Category
    
Validate Category Products Count Is Consistent
    [Documentation]    Verify category products count matches the actual number of products returned
    ...                Test: tests/api/products/products_by_category_tests.robot:82
    ...                UC: UC-PROD-005-V3 - Count consistency validation
    [Tags]    products    by-category    validation    count-consistency
    Validate Category Products Count
    
Validate Different Categories Return Different Products
    [Documentation]    Verify different categories return different sets of products
    ...                Test: tests/api/products/products_by_category_tests.robot:88
    ...                UC: UC-PROD-005-V4 - Different categories validation
    [Tags]    products    by-category    validation    different-products
    Validate Multiple Categories Have Different Products

# ============================================================================
# UC-PROD-005: Get Products By Category - Performance Validation
# ============================================================================

Validate Category Products Retrieval Performance
    [Documentation]    Verify category products retrieval meets performance benchmarks
    ...                Test: tests/api/products/products_by_category_tests.robot:97
    ...                UC: UC-PROD-005-V5 - Performance validation
    [Tags]    products    by-category    validation    performance
    Validate Category Products Performance

# ============================================================================
# UC-PROD-005: Get Products By Category - Comprehensive Category Testing
# ============================================================================

Test All Valid Categories Return Products
    [Documentation]    Verify all valid categories return appropriate products
    ...                Test: tests/api/products/products_by_category_tests.robot:105
    ...                UC: UC-PROD-005-C1 - All categories validation
    [Tags]    products    by-category    validation    all-categories
    # Test multiple known categories
    ${categories_to_test}=    Create List    smartphones    laptops    fragrances    home-decoration    skincare
    FOR    ${category}    IN    @{categories_to_test}
        _Execute Get Products By Category Request    ${category}
        _Validate Products List Response
        ${products_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
        Should Be True    ${products_count} > 0    msg=Category ${category} should have products
        _Validate Products By Category    ${category}
        Log    Category ${category} has ${products_count} products    INFO
    END
    
Test Category Case Sensitivity
    [Documentation]    Verify category filtering handles case sensitivity correctly
    ...                Test: tests/api/products/products_by_category_tests.robot:118
    ...                UC: UC-PROD-005-C2 - Case sensitivity validation
    [Tags]    products    by-category    validation    case-sensitivity
    # Test lowercase (expected)
    _Execute Get Products By Category Request    smartphones
    ${lowercase_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # Test uppercase (should handle gracefully)
    _Execute Get Products By Category Request    SMARTPHONES
    _Validate Empty Category Results    # Assuming API is case-sensitive
    
    # Test mixed case
    _Execute Get Products By Category Request    SmartPhones
    _Validate Empty Category Results    # Assuming API is case-sensitive
    
    Log    Lowercase 'smartphones' returned ${lowercase_count} products    INFO

# ============================================================================
# UC-PROD-005: Get Products By Category - Data Quality Validation
# ============================================================================

Validate Category Products Have Consistent Data Structure
    [Documentation]    Verify products returned by category have consistent data structure
    ...                Test: tests/api/products/products_by_category_tests.robot:135
    ...                UC: UC-PROD-005-Q1 - Data structure validation
    [Tags]    products    by-category    validation    data-quality
    _Execute Get Products By Category Request    smartphones
    _Validate Products List Response
    ${products_list}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    FOR    ${product}    IN    @{products_list}
        # Validate each product has required fields
        Dictionary Should Contain Key    ${product}    id
        Dictionary Should Contain Key    ${product}    title
        Dictionary Should Contain Key    ${product}    price
        Dictionary Should Contain Key    ${product}    category
        Dictionary Should Contain Key    ${product}    brand
        Dictionary Should Contain Key    ${product}    description
        
        # Validate data types
        Should Be True    isinstance($product['id'], int)
        Should Be String    ${product['title']}
        Should Be True    isinstance($product['price'], (int, float))
        Should Be String    ${product['category']}
        
        # Category should match requested category
        Should Be Equal As Strings    ${product['category']}    smartphones
    END
    
Validate Category Products Have Valid Prices
    [Documentation]    Verify products returned by category have valid price values
    ...                Test: tests/api/products/products_by_category_tests.robot:157
    ...                UC: UC-PROD-005-Q2 - Price validation
    [Tags]    products    by-category    validation    price-quality
    _Execute Get Products By Category Request    laptops
    _Validate Products List Response
    ${products_list}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    FOR    ${product}    IN    @{products_list}
        ${price}=    Set Variable    ${product['price']}
        Should Be True    ${price} > 0    msg=Product price should be positive
        Should Be True    ${price} < 100000    msg=Product price should be reasonable
    END

# ============================================================================
# UC-PROD-005: Get Products By Category - Cross-Validation
# ============================================================================

Validate Category Products Match Search Results
    [Documentation]    Verify category products match equivalent search results
    ...                Test: tests/api/products/products_by_category_tests.robot:172
    ...                UC: UC-PROD-005-X1 - Cross-reference validation
    [Tags]    products    by-category    validation    cross-validation
    # Get products by category
    _Execute Get Products By Category Request    smartphones
    _Validate Products List Response
    ${category_products}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    ${category_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # Search for products with category term
    _Execute Search Products Request    smartphone
    _Validate Products List Response
    ${search_products}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    ${search_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # Category results should be a subset or similar to search results
    # (search might return broader results)
    Should Be True    ${category_count} <= ${search_count}
    ...    msg=Category results should be subset of search results
    
    Log    Category returned ${category_count} products, search returned ${search_count}    INFO

# ============================================================================
# UC-PROD-005: Get Products By Category - Data Consistency
# ============================================================================

Get Same Category Multiple Times Should Return Consistent Results
    [Documentation]    Verify getting the same category multiple times returns consistent results
    ...                Test: tests/api/products/products_by_category_tests.robot:194
    ...                UC: UC-PROD-005-D1 - Data consistency validation
    [Tags]    products    by-category    validation    consistency
    _Execute Get Products By Category Request    fragrances
    ${first_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Sleep    1s    # Small delay between calls
    _Execute Get Products By Category Request    fragrances
    ${second_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${first_response['total']}    ${second_response['total']}
    Length Should Be    ${first_response['products']}    ${second_response['products'].__len__()}

# ============================================================================
# UC-PROD-005: Get Products By Category - Integration Tests
# ============================================================================

Products By Category Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of category filtering
    ...                Test: tests/api/products/products_by_category_tests.robot:207
    ...                UC: UC-PROD-005-I1 - Complete integration validation
    [Tags]    products    by-category    integration    comprehensive
    # Test multiple valid categories
    Get Products By Valid Category Smartphones
    ${smartphones_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    Get Products By Valid Category Laptops
    ${laptops_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    Get Products By Valid Category Fragrances
    ${fragrances_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # Test edge cases
    Get Products By Non-Existent Category
    Get Products By Invalid Special Characters Category
    Get Products By Numeric Category
    
    # Validate structure and content
    Validate Products By Category Response Structure
    Validate All Products Belong To Category
    Validate Category Products Count
    
    # Test performance
    Validate Category Products Performance
    
    # Data quality validations
    Test All Valid Categories Return Products
    Validate Category Products Have Consistent Data Structure
    
    # Cross-validation
    Validate Category Products Match Search Results
    
    # Log completion for reporting
    Log    Integration test completed - Smartphones: ${smartphones_count}, Laptops: ${laptops_count}, Fragrances: ${fragrances_count}    INFO

# ============================================================================
# UC-PROD-005: Get Products By Category - Security Tests
# ============================================================================

Category Filter Should Handle SQL Injection Attempts
    [Documentation]    Verify category filter handles SQL injection attempts safely
    ...                Test: tests/api/products/products_by_category_tests.robot:241
    ...                UC: UC-PROD-005-S1 - SQL injection security validation
    [Tags]    products    by-category    security    sql-injection
    _Execute Get Products By Category Request    smartphones'; DROP TABLE products; --
    _Validate Empty Category Results    # Should return empty results, not crash
    
Category Filter Should Handle XSS Attempts
    [Documentation]    Verify category filter handles XSS attempts safely
    ...                Test: tests/api/products/products_by_category_tests.robot:248
    ...                UC: UC-PROD-005-S2 - XSS security validation
    [Tags]    products    by-category    security    xss
    _Execute Get Products By Category Request    <script>alert('xss')</script>
    _Validate Empty Category Results    # Should return empty results, not execute script