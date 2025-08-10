*** Settings ***
Documentation    Products Search Tests - UC-PROD-003: Pesquisar Produtos
...              This suite tests all scenarios for searching products with various search criteria
...              File: tests/api/products/products_search_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-003: Search Products - Success Scenarios
# ============================================================================

Search Products With Valid Term Should Return Matching Results
    [Documentation]    Verify searching products with valid term returns relevant matching results
    ...                Test: tests/api/products/products_search_tests.robot:19
    ...                UC: UC-PROD-003 - Basic product search functionality
    [Tags]    products    search    success    smoke    valid-term
    Search Products With Valid Term
    
Search Products With Partial Match Should Return Results
    [Documentation]    Verify searching products with partial match term returns matching results
    ...                Test: tests/api/products/products_search_tests.robot:25
    ...                UC: UC-PROD-003-A1 - Partial match search functionality
    [Tags]    products    search    success    partial-match
    Search Products With Partial Match
    
Search Products By Category Term Should Return Category Results
    [Documentation]    Verify searching products by category term returns products from that category
    ...                Test: tests/api/products/products_search_tests.robot:31
    ...                UC: UC-PROD-003-A2 - Category-based search functionality
    [Tags]    products    search    success    category-search
    Search Products By Category Term
    
Search Products By Brand Term Should Return Brand Results
    [Documentation]    Verify searching products by brand term returns products from that brand
    ...                Test: tests/api/products/products_search_tests.robot:37
    ...                UC: UC-PROD-003-A3 - Brand-based search functionality
    [Tags]    products    search    success    brand-search
    Search Products By Brand Term
    
Search Products Case Insensitive Should Work Correctly
    [Documentation]    Verify searching products with different case returns consistent results
    ...                Test: tests/api/products/products_search_tests.robot:43
    ...                UC: UC-PROD-003-A5 - Case insensitive search functionality
    [Tags]    products    search    success    case-insensitive
    Search Products Case Insensitive
    
Search Products With Single Character Should Return Results
    [Documentation]    Verify searching products with single character returns relevant results
    ...                Test: tests/api/products/products_search_tests.robot:49
    ...                UC: UC-PROD-003-A6 - Single character search functionality
    [Tags]    products    search    success    single-char
    Search Products With Single Character
    
Search Products With Multiple Words Should Handle Complex Queries
    [Documentation]    Verify searching products with multiple words returns relevant results
    ...                Test: tests/api/products/products_search_tests.robot:55
    ...                UC: UC-PROD-003-A7 - Multiple words search functionality
    [Tags]    products    search    success    multiple-words
    Search Products With Multiple Words

# ============================================================================
# UC-PROD-003: Search Products - No Results Scenarios
# ============================================================================

Search Products With No Results Should Return Empty List
    [Documentation]    Verify searching products with term that has no matches returns empty results
    ...                Test: tests/api/products/products_search_tests.robot:64
    ...                UC: UC-PROD-003-A4 - No results search handling
    [Tags]    products    search    success    empty-results    no-matches
    Search Products With No Results

# ============================================================================
# UC-PROD-003: Search Products - Edge Cases
# ============================================================================

Search Products With Empty Query Should Handle Gracefully
    [Documentation]    Verify searching products with empty query handles edge case properly
    ...                Test: tests/api/products/products_search_tests.robot:72
    ...                UC: UC-PROD-003-E1 - Empty query edge case
    [Tags]    products    search    edge-case    empty-query
    Search Products With Empty Query

# ============================================================================
# UC-PROD-003: Search Products - Pagination Support
# ============================================================================

Search Products With Pagination Should Handle Parameters
    [Documentation]    Verify searching products with pagination parameters works correctly
    ...                Test: tests/api/products/products_search_tests.robot:80
    ...                UC: UC-PROD-003-A8 - Pagination in search results
    [Tags]    products    search    success    pagination
    Search Products With Pagination Parameters

# ============================================================================
# UC-PROD-003: Search Products - Validation Scenarios
# ============================================================================

Validate Search Results Have Correct Pagination Structure
    [Documentation]    Verify search results contain all required pagination fields and structure
    ...                Test: tests/api/products/products_search_tests.robot:88
    ...                UC: UC-PROD-003-V1 - Pagination structure validation
    [Tags]    products    search    validation    pagination
    Validate Search Results Pagination
    
Validate Search Results Product Fields Are Complete
    [Documentation]    Verify each product in search results contains all required fields
    ...                Test: tests/api/products/products_search_tests.robot:94
    ...                UC: UC-PROD-003-V2 - Product field validation
    [Tags]    products    search    validation    product-fields
    Validate Search Results Product Fields
    
Validate Search Results Relevance Is Appropriate
    [Documentation]    Verify search results are relevant to the search term provided
    ...                Test: tests/api/products/products_search_tests.robot:100
    ...                UC: UC-PROD-003-V3 - Search relevance validation
    [Tags]    products    search    validation    relevance
    Validate Search Results Relevance

# ============================================================================
# UC-PROD-003: Search Products - Performance Validation
# ============================================================================

Validate Search Performance Meets Requirements
    [Documentation]    Verify search operations meet performance benchmarks and response times
    ...                Test: tests/api/products/products_search_tests.robot:109
    ...                UC: UC-PROD-003-V4 - Performance validation
    [Tags]    products    search    validation    performance
    Validate Search Performance

# ============================================================================
# UC-PROD-003: Search Products - Search Functionality Depth
# ============================================================================

Search Products Should Find Items In Title
    [Documentation]    Verify search functionality correctly finds products matching title content
    ...                Test: tests/api/products/products_search_tests.robot:117
    ...                UC: UC-PROD-003-F1 - Title search validation
    [Tags]    products    search    functionality    title-search
    _Execute Search Products Request    iPhone
    _Validate Products List Response
    ${products_list}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    FOR    ${product}    IN    @{products_list}
        ${title_lower}=    Convert To Lower Case    ${product['title']}
        Should Contain    ${title_lower}    iphone
    END
    
Search Products Should Find Items In Description
    [Documentation]    Verify search functionality correctly finds products matching description content
    ...                Test: tests/api/products/products_search_tests.robot:128
    ...                UC: UC-PROD-003-F2 - Description search validation
    [Tags]    products    search    functionality    description-search
    _Execute Search Products Request    mobile
    _Validate Products List Response
    ${products_list}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    ${found_in_description}=    Set Variable    ${False}
    FOR    ${product}    IN    @{products_list}
        ${desc_lower}=    Convert To Lower Case    ${product['description']}
        ${found}=    Run Keyword And Return Status    Should Contain    ${desc_lower}    mobile
        ${found_in_description}=    Set Variable If    ${found}    ${True}    ${found_in_description}
    END
    Should Be True    ${found_in_description}    msg=Search term 'mobile' should be found in at least one product description
    
Search Products Should Find Items In Category
    [Documentation]    Verify search functionality correctly finds products by category matching
    ...                Test: tests/api/products/products_search_tests.robot:142
    ...                UC: UC-PROD-003-F3 - Category search validation
    [Tags]    products    search    functionality    category-match
    _Execute Search Products Request    smartphone
    _Validate Products List Response
    ${products_list}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    FOR    ${product}    IN    @{products_list}
        ${category_lower}=    Convert To Lower Case    ${product['category']}
        ${title_lower}=    Convert To Lower Case    ${product['title']}
        ${desc_lower}=    Convert To Lower Case    ${product['description']}
        ${found}=    Evaluate    "smartphone" in "${category_lower}" or "smartphone" in "${title_lower}" or "smartphone" in "${desc_lower}"
        Should Be True    ${found}    msg=Product should contain 'smartphone' in category, title, or description
    END
    
Search Products Should Find Items In Brand
    [Documentation]    Verify search functionality correctly finds products by brand matching
    ...                Test: tests/api/products/products_search_tests.robot:156
    ...                UC: UC-PROD-003-F4 - Brand search validation
    [Tags]    products    search    functionality    brand-match
    _Execute Search Products Request    Apple
    _Validate Products List Response
    ${products_list}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    FOR    ${product}    IN    @{products_list}
        ${brand_lower}=    Convert To Lower Case    ${product['brand']}
        ${title_lower}=    Convert To Lower Case    ${product['title']}
        ${desc_lower}=    Convert To Lower Case    ${product['description']}
        ${found}=    Evaluate    "apple" in "${brand_lower}" or "apple" in "${title_lower}" or "apple" in "${desc_lower}"
        Should Be True    ${found}    msg=Product should contain 'apple' in brand, title, or description
    END

# ============================================================================
# UC-PROD-003: Search Products - Data Consistency
# ============================================================================

Search Same Term Multiple Times Should Return Consistent Results
    [Documentation]    Verify searching the same term multiple times returns consistent results
    ...                Test: tests/api/products/products_search_tests.robot:170
    ...                UC: UC-PROD-003-D1 - Search consistency validation
    [Tags]    products    search    validation    consistency
    _Execute Search Products Request    phone
    ${first_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Sleep    1s    # Small delay between calls
    _Execute Search Products Request    phone
    ${second_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${first_response['total']}    ${second_response['total']}
    Length Should Be    ${first_response['products']}    ${second_response['products'].__len__()}

# ============================================================================
# UC-PROD-003: Search Products - Integration Tests
# ============================================================================

Search Products Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of product search
    ...                Test: tests/api/products/products_search_tests.robot:183
    ...                UC: UC-PROD-003-I1 - Complete integration validation
    [Tags]    products    search    integration    comprehensive
    # Test various search types
    Search Products With Valid Term
    ${valid_term_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    Search Products By Category Term
    ${category_term_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    Search Products By Brand Term
    ${brand_term_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # Test edge cases
    Search Products With No Results
    Search Products With Empty Query
    
    # Test validation scenarios
    Validate Search Results Pagination
    Validate Search Results Product Fields
    Validate Search Results Relevance
    
    # Test performance
    Validate Search Performance
    
    # Log completion for reporting
    Log    Integration test completed - Valid term: ${valid_term_count}, Category: ${category_term_count}, Brand: ${brand_term_count} results    INFO

# ============================================================================
# UC-PROD-003: Search Products - Security Tests
# ============================================================================

Search Products Should Handle SQL Injection Attempts
    [Documentation]    Verify search endpoint handles SQL injection attempts safely
    ...                Test: tests/api/products/products_search_tests.robot:210
    ...                UC: UC-PROD-003-S1 - SQL injection security validation
    [Tags]    products    search    security    sql-injection
    _Execute Search Products Request    '; DROP TABLE products; --
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    # Search should not crash and should return proper empty or valid response
    
Search Products Should Handle XSS Attempts
    [Documentation]    Verify search endpoint handles XSS attempts safely
    ...                Test: tests/api/products/products_search_tests.robot:218
    ...                UC: UC-PROD-003-S2 - XSS security validation
    [Tags]    products    search    security    xss
    _Execute Search Products Request    <script>alert('xss')</script>
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    # Search should handle XSS attempts gracefully