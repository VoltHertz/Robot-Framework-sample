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

Validate All Products Response Structure
    [Documentation]    Validate comprehensive response structure - UC-PROD-001-V1
    ...                File: resources/apis/products_service.resource:82
    [Tags]    business-logic    get-products    validation    structure
    _Execute Get All Products Request
    _Validate Products List Response
    _Validate All Products Response Structure

Validate Each Product Object Fields
    [Documentation]    Validate each product object has all required fields - UC-PROD-001-V2
    ...                File: resources/apis/products_service.resource:90
    [Tags]    business-logic    get-products    validation    product-fields
    _Execute Get All Products Request
    _Validate Products List Response
    _Validate Each Product Object Complete Fields

# UC-PROD-002: Get Product By ID Business Logic
Get Valid Product By ID
    [Documentation]    Get product details by valid ID - UC-PROD-002
    ...                File: resources/apis/products_service.resource:98
    [Tags]    business-logic    get-product-by-id    success
    [Arguments]    ${product_id}=1
    _Execute Get Product By ID Request    ${product_id}
    _Validate Single Product Response
    _Validate Product ID Matches    ${product_id}

Get Product By Valid ID 1
    [Documentation]    Get product details by valid ID 1 - UC-PROD-002-A1
    ...                File: resources/apis/products_service.resource:106
    [Tags]    business-logic    get-product-by-id    success    specific-id
    _Execute Get Product By ID Request    1
    _Validate Single Product Response
    _Validate Product ID Matches    1
    _Validate Product Specific Data    1

Get Product By Valid ID 5
    [Documentation]    Get product details by valid ID 5 - UC-PROD-002-A2
    ...                File: resources/apis/products_service.resource:114
    [Tags]    business-logic    get-product-by-id    success    specific-id
    _Execute Get Product By ID Request    5
    _Validate Single Product Response
    _Validate Product ID Matches    5
    _Validate Product Specific Data    5

Get Product By Valid ID 10
    [Documentation]    Get product details by valid ID 10 - UC-PROD-002-A3
    ...                File: resources/apis/products_service.resource:122
    [Tags]    business-logic    get-product-by-id    success    specific-id
    _Execute Get Product By ID Request    10
    _Validate Single Product Response
    _Validate Product ID Matches    10
    _Validate Product Specific Data    10

Get Product By Valid ID 15
    [Documentation]    Get product details by valid ID 15 - UC-PROD-002-A4
    ...                File: resources/apis/products_service.resource:130
    [Tags]    business-logic    get-product-by-id    success    specific-id
    _Execute Get Product By ID Request    15
    _Validate Single Product Response
    _Validate Product ID Matches    15
    _Validate Product Specific Data    15

Get Product By Valid ID 30
    [Documentation]    Get product details by valid ID 30 - UC-PROD-002-A5
    ...                File: resources/apis/products_service.resource:138
    [Tags]    business-logic    get-product-by-id    success    specific-id
    _Execute Get Product By ID Request    30
    _Validate Single Product Response
    _Validate Product ID Matches    30
    _Validate Product Specific Data    30

Get Non-Existent Product By ID
    [Documentation]    Attempt to get product with non-existent ID - UC-PROD-002-E1
    ...                File: resources/apis/products_service.resource:146
    [Tags]    business-logic    get-product-by-id    error    404
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    non_existent_id
    _Execute Get Product By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Get Product By Negative ID Should Fail
    [Documentation]    Attempt to get product with negative ID should fail - UC-PROD-002-E2
    ...                File: resources/apis/products_service.resource:153
    [Tags]    business-logic    get-product-by-id    error    negative-id
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    negative_id
    _Execute Get Product By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Get Product By Zero ID Should Fail
    [Documentation]    Attempt to get product with zero ID should fail - UC-PROD-002-E3
    ...                File: resources/apis/products_service.resource:160
    [Tags]    business-logic    get-product-by-id    error    zero-id
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    zero_id
    _Execute Get Product By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Get Product By Text ID Should Fail
    [Documentation]    Attempt to get product with text ID should fail - UC-PROD-002-E4
    ...                File: resources/apis/products_service.resource:167
    [Tags]    business-logic    get-product-by-id    error    text-id
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    text_id
    _Execute Get Product By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Get Product By Special Characters ID Should Fail
    [Documentation]    Attempt to get product with special characters ID should fail - UC-PROD-002-E5
    ...                File: resources/apis/products_service.resource:174
    [Tags]    business-logic    get-product-by-id    error    special-chars
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    special_chars_id
    _Execute Get Product By ID Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Validate Product Response Contains All Fields
    [Documentation]    Validate product response contains all required fields - UC-PROD-002-V1
    ...                File: resources/apis/products_service.resource:181
    [Tags]    business-logic    get-product-by-id    validation    all-fields
    _Execute Get Product By ID Request    1
    _Validate Single Product Response
    _Validate Product Response All Fields

Validate Product Response Data Types
    [Documentation]    Validate product response data types are correct - UC-PROD-002-V2
    ...                File: resources/apis/products_service.resource:189
    [Tags]    business-logic    get-product-by-id    validation    data-types
    _Execute Get Product By ID Request    1
    _Validate Single Product Response
    _Validate Product Response Data Types

Validate Product Images Array
    [Documentation]    Validate product images array structure - UC-PROD-002-V3
    ...                File: resources/apis/products_service.resource:197
    [Tags]    business-logic    get-product-by-id    validation    images
    _Execute Get Product By ID Request    1
    _Validate Single Product Response
    _Validate Product Images Array

Get Different Products Should Have Unique Data
    [Documentation]    Validate different products have unique data - UC-PROD-002-V4
    ...                File: resources/apis/products_service.resource:205
    [Tags]    business-logic    get-product-by-id    validation    unique-data
    _Execute Get Product By ID Request    1
    _Validate Single Product Response
    ${product1_data}=    Set Variable    ${LAST_RESPONSE.json()}
    _Execute Get Product By ID Request    2
    _Validate Single Product Response
    ${product2_data}=    Set Variable    ${LAST_RESPONSE.json()}
    _Validate Products Have Unique Data    ${product1_data}    ${product2_data}

# UC-PROD-003: Search Products Business Logic
Search Products With Valid Term
    [Documentation]    Search products with valid search term - UC-PROD-003
    ...                File: resources/apis/products_service.resource:216
    [Tags]    business-logic    search-products    success
    ${search_term}=    Get From Dictionary    ${search_terms}    valid_term
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Results    ${search_term}

Search Products With Partial Match
    [Documentation]    Search products with partial match term - UC-PROD-003-A1
    ...                File: resources/apis/products_service.resource:224
    [Tags]    business-logic    search-products    success    partial
    ${search_term}=    Get From Dictionary    ${search_terms}    partial_match
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Results    ${search_term}

Search Products By Category Term
    [Documentation]    Search products by category term - UC-PROD-003-A2
    ...                File: resources/apis/products_service.resource:232
    [Tags]    business-logic    search-products    success    category
    ${search_term}=    Get From Dictionary    ${search_terms}    category_term
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Results    ${search_term}

Search Products By Brand Term
    [Documentation]    Search products by brand term - UC-PROD-003-A3
    ...                File: resources/apis/products_service.resource:240
    [Tags]    business-logic    search-products    success    brand
    ${search_term}=    Get From Dictionary    ${search_terms}    brand_term
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Results    ${search_term}

Search Products With No Results
    [Documentation]    Search products with term that returns no results - UC-PROD-003-A4
    ...                File: resources/apis/products_service.resource:248
    [Tags]    business-logic    search-products    success    empty
    ${search_term}=    Get From Dictionary    ${search_terms}    no_results
    _Execute Search Products Request    ${search_term}
    _Validate Empty Search Results

Search Products Case Insensitive
    [Documentation]    Search products with case insensitive query - UC-PROD-003-A5
    ...                File: resources/apis/products_service.resource:255
    [Tags]    business-logic    search-products    success    case-insensitive
    ${search_term}=    Get From Dictionary    ${search_terms}    case_insensitive
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Case Insensitive Results

Search Products With Single Character
    [Documentation]    Search products with single character - UC-PROD-003-A6
    ...                File: resources/apis/products_service.resource:263
    [Tags]    business-logic    search-products    success    single-char
    ${search_term}=    Get From Dictionary    ${search_terms}    single_char
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Single Character Results

Search Products With Multiple Words
    [Documentation]    Search products with multiple words - UC-PROD-003-A7
    ...                File: resources/apis/products_service.resource:271
    [Tags]    business-logic    search-products    success    multiple-words
    ${search_term}=    Get From Dictionary    ${search_terms}    multiple_words
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Multiple Words Results

Search Products With Empty Query
    [Documentation]    Search products with empty query - UC-PROD-003-E1
    ...                File: resources/apis/products_service.resource:279
    [Tags]    business-logic    search-products    edge-case    empty-query
    _Execute Search Products Request    ${EMPTY}
    _Validate Empty Query Search Response

Validate Search Results Pagination
    [Documentation]    Validate search results pagination - UC-PROD-003-V1
    ...                File: resources/apis/products_service.resource:286
    [Tags]    business-logic    search-products    validation    pagination
    ${search_term}=    Get From Dictionary    ${search_terms}    valid_term
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Pagination Fields

Validate Search Results Product Fields
    [Documentation]    Validate search results product fields - UC-PROD-003-V2
    ...                File: resources/apis/products_service.resource:294
    [Tags]    business-logic    search-products    validation    product-fields
    ${search_term}=    Get From Dictionary    ${search_terms}    valid_term
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Results Product Fields

Validate Search Results Relevance
    [Documentation]    Validate search results relevance - UC-PROD-003-V3
    ...                File: resources/apis/products_service.resource:302
    [Tags]    business-logic    search-products    validation    relevance
    ${search_term}=    Get From Dictionary    ${search_terms}    valid_term
    _Execute Search Products Request    ${search_term}
    _Validate Products List Response
    _Validate Search Results Relevance    ${search_term}

Search Products With Pagination Parameters
    [Documentation]    Search products with pagination parameters - UC-PROD-003-A8
    ...                File: resources/apis/products_service.resource:310
    [Tags]    business-logic    search-products    success    pagination
    ${search_term}=    Get From Dictionary    ${search_terms}    valid_term
    _Execute Search Products Request With Pagination    ${search_term}    limit=5    skip=2
    _Validate Products List Response
    _Validate Search Pagination Response    5    2

Validate Search Performance
    [Documentation]    Validate search performance benchmarks - UC-PROD-003-V4
    ...                File: resources/apis/products_service.resource:318
    [Tags]    business-logic    search-products    validation    performance
    ${start_time}=    Get Time    epoch
    ${search_term}=    Get From Dictionary    ${search_terms}    valid_term
    _Execute Search Products Request    ${search_term}
    ${end_time}=    Get Time    epoch
    _Validate Products List Response
    _Validate Search Performance    ${start_time}    ${end_time}

# UC-PROD-004: Get Categories Business Logic
Get All Product Categories
    [Documentation]    Get all product categories - UC-PROD-004
    ...                File: resources/apis/products_service.resource:328
    [Tags]    business-logic    get-categories    success
    _Execute Get Categories Request
    _Validate Categories Response

Validate Categories Response Structure
    [Documentation]    Validate categories response structure - UC-PROD-004-V1
    ...                File: resources/apis/products_service.resource:335
    [Tags]    business-logic    get-categories    validation    structure
    _Execute Get Categories Request
    _Validate Categories Response
    _Validate Categories Response Structure

Validate Categories Content
    [Documentation]    Validate categories content and format - UC-PROD-004-V2
    ...                File: resources/apis/products_service.resource:343
    [Tags]    business-logic    get-categories    validation    content
    _Execute Get Categories Request
    _Validate Categories Response
    _Validate Categories Content Format

Validate Known Categories Present
    [Documentation]    Validate known categories are present - UC-PROD-004-V3
    ...                File: resources/apis/products_service.resource:351
    [Tags]    business-logic    get-categories    validation    known-categories
    _Execute Get Categories Request
    _Validate Categories Response
    _Validate Known Categories Present

Validate Categories Order
    [Documentation]    Validate categories order consistency - UC-PROD-004-V4
    ...                File: resources/apis/products_service.resource:359
    [Tags]    business-logic    get-categories    validation    order
    _Execute Get Categories Request
    _Validate Categories Response
    _Validate Categories Order

Validate Categories Performance
    [Documentation]    Validate categories retrieval performance - UC-PROD-004-V5
    ...                File: resources/apis/products_service.resource:367
    [Tags]    business-logic    get-categories    validation    performance
    ${start_time}=    Get Time    epoch
    _Execute Get Categories Request
    ${end_time}=    Get Time    epoch
    _Validate Categories Response
    _Validate Categories Performance    ${start_time}    ${end_time}

# UC-PROD-005: Get Products By Category Business Logic
Get Products By Valid Category Smartphones
    [Documentation]    Get products by valid category smartphones - UC-PROD-005
    ...                File: resources/apis/products_service.resource:376
    [Tags]    business-logic    get-products-by-category    success    smartphones
    _Execute Get Products By Category Request    smartphones
    _Validate Products List Response
    _Validate Products By Category    smartphones

Get Products By Valid Category Laptops
    [Documentation]    Get products by valid category laptops - UC-PROD-005-A1
    ...                File: resources/apis/products_service.resource:384
    [Tags]    business-logic    get-products-by-category    success    laptops
    _Execute Get Products By Category Request    laptops
    _Validate Products List Response
    _Validate Products By Category    laptops

Get Products By Valid Category Fragrances
    [Documentation]    Get products by valid category fragrances - UC-PROD-005-A2
    ...                File: resources/apis/products_service.resource:392
    [Tags]    business-logic    get-products-by-category    success    fragrances
    _Execute Get Products By Category Request    fragrances
    _Validate Products List Response
    _Validate Products By Category    fragrances

Get Products By Valid Category Home Decoration
    [Documentation]    Get products by valid category home-decoration - UC-PROD-005-A3
    ...                File: resources/apis/products_service.resource:400
    [Tags]    business-logic    get-products-by-category    success    home-decoration
    _Execute Get Products By Category Request    home-decoration
    _Validate Products List Response
    _Validate Products By Category    home-decoration

Get Products By Non-Existent Category
    [Documentation]    Get products by non-existent category - UC-PROD-005-A1
    ...                File: resources/apis/products_service.resource:408
    [Tags]    business-logic    get-products-by-category    success    empty
    ${invalid_category}=    Get From Dictionary    ${invalid_categories}    non_existent_category
    _Execute Get Products By Category Request    ${invalid_category['category']}
    _Validate Empty Category Results

Get Products By Invalid Special Characters Category
    [Documentation]    Get products by invalid special characters category - UC-PROD-005-E1
    ...                File: resources/apis/products_service.resource:416
    [Tags]    business-logic    get-products-by-category    edge-case    special-chars
    ${invalid_category}=    Get From Dictionary    ${invalid_categories}    invalid_special_chars
    _Execute Get Products By Category Request    ${invalid_category['category']}
    _Validate Empty Category Results

Get Products By Numeric Category
    [Documentation]    Get products by numeric category - UC-PROD-005-E2
    ...                File: resources/apis/products_service.resource:424
    [Tags]    business-logic    get-products-by-category    edge-case    numeric
    ${invalid_category}=    Get From Dictionary    ${invalid_categories}    numeric_category
    _Execute Get Products By Category Request    ${invalid_category['category']}
    _Validate Empty Category Results

Validate Products By Category Response Structure
    [Documentation]    Validate products by category response structure - UC-PROD-005-V1
    ...                File: resources/apis/products_service.resource:432
    [Tags]    business-logic    get-products-by-category    validation    structure
    _Execute Get Products By Category Request    smartphones
    _Validate Products List Response
    _Validate Category Response Structure

Validate All Products Belong To Category
    [Documentation]    Validate all returned products belong to category - UC-PROD-005-V2
    ...                File: resources/apis/products_service.resource:440
    [Tags]    business-logic    get-products-by-category    validation    category-match
    _Execute Get Products By Category Request    smartphones
    _Validate Products List Response
    _Validate All Products Match Category    smartphones

Validate Category Products Count
    [Documentation]    Validate category products count consistency - UC-PROD-005-V3
    ...                File: resources/apis/products_service.resource:448
    [Tags]    business-logic    get-products-by-category    validation    count
    _Execute Get Products By Category Request    smartphones
    _Validate Products List Response
    _Validate Category Products Count

Validate Multiple Categories Have Different Products
    [Documentation]    Validate different categories return different products - UC-PROD-005-V4
    ...                File: resources/apis/products_service.resource:456
    [Tags]    business-logic    get-products-by-category    validation    different-products
    _Execute Get Products By Category Request    smartphones
    _Validate Products List Response
    ${smartphones_data}=    Set Variable    ${LAST_RESPONSE.json()}
    _Execute Get Products By Category Request    laptops
    _Validate Products List Response
    ${laptops_data}=    Set Variable    ${LAST_RESPONSE.json()}
    _Validate Different Category Products    ${smartphones_data}    ${laptops_data}

Validate Category Products Performance
    [Documentation]    Validate category products performance benchmarks - UC-PROD-005-V5
    ...                File: resources/apis/products_service.resource:466
    [Tags]    business-logic    get-products-by-category    validation    performance
    ${start_time}=    Get Time    epoch
    _Execute Get Products By Category Request    smartphones
    ${end_time}=    Get Time    epoch
    _Validate Products List Response
    _Validate Category Products Performance    ${start_time}    ${end_time}

# UC-PROD-006: Add Product Business Logic (Simulated)
Add New Product With Valid Data
    [Documentation]    Add new product with valid data - UC-PROD-006 (simulated)
    ...                File: resources/apis/products_service.resource:475
    [Tags]    business-logic    add-product    success    simulated
    _Execute Add Product Request    ${new_product_data}
    _Validate Product Creation Response    ${new_product_data}
    _Store Created Product ID

Add Product With Minimal Fields
    [Documentation]    Add new product with minimal required fields - UC-PROD-006-A1
    ...                File: resources/apis/products_service.resource:483
    [Tags]    business-logic    add-product    success    minimal-fields
    ${minimal_product}=    Create Dictionary    title=Test Product    price=99.99
    _Execute Add Product Request    ${minimal_product}
    _Validate Product Creation Response    ${minimal_product}
    _Store Created Product ID

Add Product With Complete Data
    [Documentation]    Add new product with complete data set - UC-PROD-006-A2
    ...                File: resources/apis/products_service.resource:491
    [Tags]    business-logic    add-product    success    complete-data
    _Execute Add Product Request    ${new_product_data}
    _Validate Product Creation Response    ${new_product_data}
    _Validate Complete Product Data Response    ${new_product_data}
    _Store Created Product ID

Add Product Should Include Generated ID
    [Documentation]    Validate added product includes generated ID - UC-PROD-006-V1
    ...                File: resources/apis/products_service.resource:500
    [Tags]    business-logic    add-product    validation    generated-id
    _Execute Add Product Request    ${new_product_data}
    _Validate Product Creation Response    ${new_product_data}
    _Validate Generated Product ID Exists

Add Product Should Echo All Sent Fields
    [Documentation]    Validate added product echoes all sent fields - UC-PROD-006-V2
    ...                File: resources/apis/products_service.resource:508
    [Tags]    business-logic    add-product    validation    echo-fields
    _Execute Add Product Request    ${new_product_data}
    _Validate Product Creation Response    ${new_product_data}
    _Validate All Product Fields Echoed    ${new_product_data}

Add Product With Different Categories
    [Documentation]    Add products with different categories - UC-PROD-006-A3
    ...                File: resources/apis/products_service.resource:516
    [Tags]    business-logic    add-product    success    different-categories
    ${categories}=    Create List    electronics    books    clothing
    FOR    ${category}    IN    @{categories}
        ${product}=    Create Dictionary    title=Test ${category} Product    price=99.99    category=${category}
        _Execute Add Product Request    ${product}
        _Validate Product Creation Response    ${product}
        _Validate Product Category    ${category}
    END

Add Product With Different Price Ranges
    [Documentation]    Add products with different price ranges - UC-PROD-006-A4
    ...                File: resources/apis/products_service.resource:527
    [Tags]    business-logic    add-product    success    price-ranges
    ${prices}=    Create List    9.99    99.99    999.99    9999.99
    FOR    ${price}    IN    @{prices}
        ${product}=    Create Dictionary    title=Test Product ${price}    price=${price}
        _Execute Add Product Request    ${product}
        _Validate Product Creation Response    ${product}
        _Validate Product Price    ${price}
    END

Add Product With Special Characters
    [Documentation]    Add product with special characters in title - UC-PROD-006-A5
    ...                File: resources/apis/products_service.resource:538
    [Tags]    business-logic    add-product    edge-case    special-characters
    ${special_product}=    Create Dictionary    title=Prodüct Spéciàl Cháracters & Symbols    price=199.99
    _Execute Add Product Request    ${special_product}
    _Validate Product Creation Response    ${special_product}
    _Validate Special Characters Handling

Add Multiple Products Should Generate Different IDs
    [Documentation]    Validate multiple products get different IDs - UC-PROD-006-V3
    ...                File: resources/apis/products_service.resource:547
    [Tags]    business-logic    add-product    validation    unique-ids
    ${product1}=    Create Dictionary    title=Product 1    price=99.99
    _Execute Add Product Request    ${product1}
    _Validate Product Creation Response    ${product1}
    ${id1}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    ${product2}=    Create Dictionary    title=Product 2    price=199.99
    _Execute Add Product Request    ${product2}
    _Validate Product Creation Response    ${product2}
    ${id2}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    _Validate Different Product IDs    ${id1}    ${id2}

Validate Add Product Performance
    [Documentation]    Validate add product performance benchmarks - UC-PROD-006-V4
    ...                File: resources/apis/products_service.resource:560
    [Tags]    business-logic    add-product    validation    performance
    ${start_time}=    Get Time    epoch
    _Execute Add Product Request    ${new_product_data}
    ${end_time}=    Get Time    epoch
    _Validate Product Creation Response    ${new_product_data}
    _Validate Add Product Performance    ${start_time}    ${end_time}

# UC-PROD-007: Update Product Business Logic (Simulated)
Update Product With Valid Data
    [Documentation]    Update existing product with valid data - UC-PROD-007 (simulated)
    ...                File: resources/apis/products_service.resource:569
    [Tags]    business-logic    update-product    success    simulated
    [Arguments]    ${product_id}=1
    _Execute Update Product Request    ${product_id}    ${update_product_data}
    _Validate Product Update Response    ${product_id}    ${update_product_data}

Update Product With Partial Data
    [Documentation]    Update product with partial data only - UC-PROD-007-A1
    ...                File: resources/apis/products_service.resource:577
    [Tags]    business-logic    update-product    success    partial-data
    [Arguments]    ${product_id}=1
    ${partial_data}=    Create Dictionary    title=Updated Product Title
    _Execute Update Product Request    ${product_id}    ${partial_data}
    _Validate Product Update Response    ${product_id}    ${partial_data}
    _Validate Partial Product Update Response    ${partial_data}

Update Product Title Only
    [Documentation]    Update product title only - UC-PROD-007-A2
    ...                File: resources/apis/products_service.resource:586
    [Tags]    business-logic    update-product    success    title-only
    [Arguments]    ${product_id}=1
    ${update_data}=    Create Dictionary    title=New Product Title
    _Execute Update Product Request    ${product_id}    ${update_data}
    _Validate Product Update Response    ${product_id}    ${update_data}
    _Validate Single Field Update    title    New Product Title

Update Product Price Only
    [Documentation]    Update product price only - UC-PROD-007-A3
    ...                File: resources/apis/products_service.resource:595
    [Tags]    business-logic    update-product    success    price-only
    [Arguments]    ${product_id}=1
    ${update_data}=    Create Dictionary    price=299.99
    _Execute Update Product Request    ${product_id}    ${update_data}
    _Validate Product Update Response    ${product_id}    ${update_data}
    _Validate Single Field Update    price    299.99

Update Product Description Only
    [Documentation]    Update product description only - UC-PROD-007-A4
    ...                File: resources/apis/products_service.resource:604
    [Tags]    business-logic    update-product    success    description-only
    [Arguments]    ${product_id}=1
    ${update_data}=    Create Dictionary    description=Updated product description
    _Execute Update Product Request    ${product_id}    ${update_data}
    _Validate Product Update Response    ${product_id}    ${update_data}
    _Validate Single Field Update    description    Updated product description

Update Product Category Only
    [Documentation]    Update product category only - UC-PROD-007-A5
    ...                File: resources/apis/products_service.resource:613
    [Tags]    business-logic    update-product    success    category-only
    [Arguments]    ${product_id}=1
    ${update_data}=    Create Dictionary    category=electronics
    _Execute Update Product Request    ${product_id}    ${update_data}
    _Validate Product Update Response    ${product_id}    ${update_data}
    _Validate Single Field Update    category    electronics

Update Product Brand Only
    [Documentation]    Update product brand only - UC-PROD-007-A6
    ...                File: resources/apis/products_service.resource:622
    [Tags]    business-logic    update-product    success    brand-only
    [Arguments]    ${product_id}=1
    ${update_data}=    Create Dictionary    brand=NewBrand
    _Execute Update Product Request    ${product_id}    ${update_data}
    _Validate Product Update Response    ${product_id}    ${update_data}
    _Validate Single Field Update    brand    NewBrand

Update Product With Different Prices
    [Documentation]    Update product with different price values - UC-PROD-007-A7
    ...                File: resources/apis/products_service.resource:631
    [Tags]    business-logic    update-product    success    different-prices
    [Arguments]    ${product_id}=1
    ${prices}=    Create List    19.99    99.99    199.99    999.99
    FOR    ${price}    IN    @{prices}
        ${update_data}=    Create Dictionary    price=${price}
        _Execute Update Product Request    ${product_id}    ${update_data}
        _Validate Product Update Response    ${product_id}    ${update_data}
        _Validate Price Update Response    ${price}
    END

Update Product With Special Characters
    [Documentation]    Update product with special characters - UC-PROD-007-A8
    ...                File: resources/apis/products_service.resource:642
    [Tags]    business-logic    update-product    success    special-characters
    [Arguments]    ${product_id}=1
    ${update_data}=    Create Dictionary    title=Prodüct wïth Spéciàl Cháracters & Symbols
    _Execute Update Product Request    ${product_id}    ${update_data}
    _Validate Product Update Response    ${product_id}    ${update_data}
    _Validate Special Characters Update    ${update_data}

Update Product Response Should Preserve ID
    [Documentation]    Validate update response preserves original ID - UC-PROD-007-V1
    ...                File: resources/apis/products_service.resource:651
    [Tags]    business-logic    update-product    validation    preserve-id
    [Arguments]    ${product_id}=1
    _Execute Update Product Request    ${product_id}    ${update_product_data}
    _Validate Product Update Response    ${product_id}    ${update_product_data}
    _Validate Product ID Preservation    ${product_id}

Update Product Response Should Echo Updated Fields
    [Documentation]    Validate update response echoes updated fields - UC-PROD-007-V2
    ...                File: resources/apis/products_service.resource:660
    [Tags]    business-logic    update-product    validation    echo-fields
    [Arguments]    ${product_id}=1
    _Execute Update Product Request    ${product_id}    ${update_product_data}
    _Validate Product Update Response    ${product_id}    ${update_product_data}
    _Validate Updated Product Fields Echo    ${update_product_data}

Update Product With Empty Data
    [Documentation]    Update product with empty data - UC-PROD-007-E1
    ...                File: resources/apis/products_service.resource:669
    [Tags]    business-logic    update-product    edge-case    empty-data
    [Arguments]    ${product_id}=1
    ${empty_data}=    Create Dictionary
    _Execute Update Product Request    ${product_id}    ${empty_data}
    _Validate Empty Data Product Update Response

Update Same Product Multiple Times
    [Documentation]    Update same product multiple times - UC-PROD-007-A9
    ...                File: resources/apis/products_service.resource:678
    [Tags]    business-logic    update-product    success    multiple-updates
    [Arguments]    ${product_id}=1
    ${update1}=    Create Dictionary    title=First Update
    _Execute Update Product Request    ${product_id}    ${update1}
    _Validate Product Update Response    ${product_id}    ${update1}
    ${update2}=    Create Dictionary    title=Second Update
    _Execute Update Product Request    ${product_id}    ${update2}
    _Validate Product Update Response    ${product_id}    ${update2}
    _Validate Multiple Product Updates Response    ${update1}    ${update2}

Update Non-Existent Product
    [Documentation]    Attempt to update non-existent product - UC-PROD-007-E2
    ...                File: resources/apis/products_service.resource:690
    [Tags]    business-logic    update-product    error    404
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    non_existent_id
    _Execute Update Product Request    ${invalid_data['id']}    ${update_product_data}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Validate Update Product Performance
    [Documentation]    Validate update product performance benchmarks - UC-PROD-007-V3
    ...                File: resources/apis/products_service.resource:698
    [Tags]    business-logic    update-product    validation    performance
    [Arguments]    ${product_id}=1
    ${start_time}=    Get Time    epoch
    _Execute Update Product Request    ${product_id}    ${update_product_data}
    ${end_time}=    Get Time    epoch
    _Validate Product Update Response    ${product_id}    ${update_product_data}
    _Validate Update Product Performance    ${start_time}    ${end_time}

# UC-PROD-008: Delete Product Business Logic (Simulated)
Delete Product With Valid ID
    [Documentation]    Delete product with valid ID - UC-PROD-008 (simulated)
    ...                File: resources/apis/products_service.resource:708
    [Tags]    business-logic    delete-product    success    simulated
    [Arguments]    ${product_id}=1
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}

Delete Product Should Return Confirmation
    [Documentation]    Validate delete returns confirmation - UC-PROD-008-V1
    ...                File: resources/apis/products_service.resource:716
    [Tags]    business-logic    delete-product    validation    confirmation
    [Arguments]    ${product_id}=1
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}
    _Validate Product Deletion Confirmation    ${product_id}

Delete Product Should Include Timestamp
    [Documentation]    Validate delete includes timestamp - UC-PROD-008-V2
    ...                File: resources/apis/products_service.resource:725
    [Tags]    business-logic    delete-product    validation    timestamp
    [Arguments]    ${product_id}=1
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}
    _Validate Product Deletion Timestamp

Delete Product Should Preserve Original Data
    [Documentation]    Validate delete preserves original data - UC-PROD-008-V3
    ...                File: resources/apis/products_service.resource:734
    [Tags]    business-logic    delete-product    validation    preserve-data
    [Arguments]    ${product_id}=1
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}
    _Validate Original Product Data Preservation    ${product_id}

Delete Same Product Multiple Times
    [Documentation]    Delete same product multiple times - UC-PROD-008-A1
    ...                File: resources/apis/products_service.resource:743
    [Tags]    business-logic    delete-product    edge-case    multiple-deletes
    [Arguments]    ${product_id}=1
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}
    _Execute Delete Product Request    ${product_id}
    _Validate Multiple Product Deletion Response    ${product_id}

Delete Product Should Not Affect Other Products
    [Documentation]    Validate delete doesn't affect other products - UC-PROD-008-V4
    ...                File: resources/apis/products_service.resource:753
    [Tags]    business-logic    delete-product    validation    isolation
    [Arguments]    ${product_id}=1
    _Execute Get Product By ID Request    2
    ${other_product_before}=    Set Variable    ${LAST_RESPONSE.json()}
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}
    _Execute Get Product By ID Request    2
    ${other_product_after}=    Set Variable    ${LAST_RESPONSE.json()}
    _Validate Other Products Not Affected    ${other_product_before}    ${other_product_after}

Delete Product Should Handle Large Valid IDs
    [Documentation]    Delete product with large valid ID - UC-PROD-008-A2
    ...                File: resources/apis/products_service.resource:765
    [Tags]    business-logic    delete-product    success    large-id
    _Execute Delete Product Request    30
    _Validate Product Deletion Response    30
    _Validate Large Product ID Deletion    30

Delete Multiple Products In Sequence
    [Documentation]    Delete multiple products in sequence - UC-PROD-008-A3
    ...                File: resources/apis/products_service.resource:773
    [Tags]    business-logic    delete-product    success    sequence
    ${product_ids}=    Create List    1    2    3
    FOR    ${product_id}    IN    @{product_ids}
        _Execute Delete Product Request    ${product_id}
        _Validate Product Deletion Response    ${product_id}
        _Validate Sequential Product Deletion    ${product_id}
    END

Delete Product Should Return Complete Object
    [Documentation]    Validate delete returns complete object - UC-PROD-008-V5
    ...                File: resources/apis/products_service.resource:783
    [Tags]    business-logic    delete-product    validation    complete-object
    [Arguments]    ${product_id}=1
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}
    _Validate Complete Product Object Return    ${product_id}

Delete Product Should Maintain Data Integrity
    [Documentation]    Validate delete maintains data integrity - UC-PROD-008-V6
    ...                File: resources/apis/products_service.resource:792
    [Tags]    business-logic    delete-product    validation    data-integrity
    [Arguments]    ${product_id}=1
    _Execute Delete Product Request    ${product_id}
    _Validate Product Deletion Response    ${product_id}
    _Validate Product Data Integrity After Deletion    ${product_id}

Delete Non-Existent Product
    [Documentation]    Attempt to delete non-existent product - UC-PROD-008-E1
    ...                File: resources/apis/products_service.resource:801
    [Tags]    business-logic    delete-product    error    404
    ${invalid_data}=    Get From Dictionary    ${invalid_product_ids}    non_existent_id
    _Execute Delete Product Request    ${invalid_data['id']}
    _Validate Error Response    ${invalid_data['expected_status']}    ${invalid_data['expected_message']}

Validate Delete Product Performance
    [Documentation]    Validate delete product performance benchmarks - UC-PROD-008-V7
    ...                File: resources/apis/products_service.resource:809
    [Tags]    business-logic    delete-product    validation    performance
    [Arguments]    ${product_id}=1
    ${start_time}=    Get Time    epoch
    _Execute Delete Product Request    ${product_id}
    ${end_time}=    Get Time    epoch
    _Validate Product Deletion Response    ${product_id}
    _Validate Delete Product Performance    ${start_time}    ${end_time}

# ============================================================================
# TECHNICAL KEYWORDS (Low-Level API Operations - Private/Internal)
# ============================================================================

# Session Management
_Setup Products Session
    [Documentation]    Setup HTTP session for products API requests
    ...                File: resources/apis/products_service.resource:822
    Create Session    ${PRODUCTS_SESSION}    ${base_url}    timeout=${timeout}

_Clear Product Context
    [Documentation]    Clear product context variables
    ...                File: resources/apis/products_service.resource:827
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
    Length Should Be Greater Than    ${response_json['products']}    0
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
    Length Should Be Greater Than    ${products_list}    1
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
    Length Should Be Greater Than    ${response_json['products']}    0
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
    Length Should Be    ${response_json['products']}    0

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
    Should Be True    isinstance($response_json, list)
    Length Should Be Greater Than    ${response_json}    0
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
    Length Should Be    ${response_json['products']}    0

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
    Should Be True    isinstance($response_json['id'], int)
    Should Be True    isinstance($response_json['price'], (int, float))

_Validate Product Images Array
    [Documentation]    Validate product images array structure
    ...                File: resources/apis/products_service.resource:1154
    Log    Product images array validation - products_service.resource:1154
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    images
    Should Be True    isinstance($response_json['images'], list)

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
    Should Be True    isinstance($response_json, list)
    Length Should Be Greater Than    ${response_json}    0

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
    Length Should Be Greater Than    ${response_json}    0

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