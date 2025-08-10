*** Settings ***
Documentation    Products Add Tests - UC-PROD-006: Adicionar Novo Produto (Simulação)
...              This suite tests all scenarios for adding new products using simulated CRUD operations
...              File: tests/api/products/products_add_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-006: Add Product - Success Scenarios
# ============================================================================

Add New Product With Valid Data Should Create Product Successfully
    [Documentation]    Verify adding new product with valid data creates product successfully (simulated)
    ...                Test: tests/api/products/products_add_tests.robot:19
    ...                UC: UC-PROD-006 - Basic product creation functionality
    [Tags]    products    add    success    smoke    simulated
    Add New Product With Valid Data
    
Add Product With Minimal Required Fields Should Work
    [Documentation]    Verify adding product with only minimal required fields works correctly
    ...                Test: tests/api/products/products_add_tests.robot:25
    ...                UC: UC-PROD-006-A1 - Minimal fields validation
    [Tags]    products    add    success    minimal-fields    simulated
    Add Product With Minimal Fields
    
Add Product With Complete Data Set Should Include All Fields
    [Documentation]    Verify adding product with complete data set includes all provided fields
    ...                Test: tests/api/products/products_add_tests.robot:31
    ...                UC: UC-PROD-006-A2 - Complete data validation
    [Tags]    products    add    success    complete-data    simulated
    Add Product With Complete Data

# ============================================================================
# UC-PROD-006: Add Product - Response Validation
# ============================================================================

Add Product Should Include Generated ID In Response
    [Documentation]    Verify added product response includes generated ID for the new product
    ...                Test: tests/api/products/products_add_tests.robot:40
    ...                UC: UC-PROD-006-V1 - Generated ID validation
    [Tags]    products    add    validation    generated-id    simulated
    Add Product Should Include Generated ID
    
Add Product Should Echo All Sent Fields In Response
    [Documentation]    Verify added product response echoes all fields that were sent in request
    ...                Test: tests/api/products/products_add_tests.robot:46
    ...                UC: UC-PROD-006-V2 - Field echo validation
    [Tags]    products    add    validation    echo-fields    simulated
    Add Product Should Echo All Sent Fields

# ============================================================================
# UC-PROD-006: Add Product - Different Data Types
# ============================================================================

Add Products With Different Categories Should Accept All Categories
    [Documentation]    Verify adding products with different categories accepts all valid categories
    ...                Test: tests/api/products/products_add_tests.robot:55
    ...                UC: UC-PROD-006-A3 - Different categories validation
    [Tags]    products    add    success    different-categories    simulated
    Add Product With Different Categories
    
Add Products With Different Price Ranges Should Accept All Prices
    [Documentation]    Verify adding products with different price ranges accepts all valid prices
    ...                Test: tests/api/products/products_add_tests.robot:61
    ...                UC: UC-PROD-006-A4 - Price ranges validation
    [Tags]    products    add    success    price-ranges    simulated
    Add Product With Different Price Ranges

# ============================================================================
# UC-PROD-006: Add Product - Edge Cases
# ============================================================================

Add Product With Special Characters Should Handle Correctly
    [Documentation]    Verify adding product with special characters in title handles correctly
    ...                Test: tests/api/products/products_add_tests.robot:70
    ...                UC: UC-PROD-006-A5 - Special characters edge case
    [Tags]    products    add    edge-case    special-characters    simulated
    Add Product With Special Characters

# ============================================================================
# UC-PROD-006: Add Product - Uniqueness Validation
# ============================================================================

Add Multiple Products Should Generate Different IDs
    [Documentation]    Verify adding multiple products generates different unique IDs for each
    ...                Test: tests/api/products/products_add_tests.robot:79
    ...                UC: UC-PROD-006-V3 - Unique IDs validation
    [Tags]    products    add    validation    unique-ids    simulated
    Add Multiple Products Should Generate Different IDs

# ============================================================================
# UC-PROD-006: Add Product - Performance Validation
# ============================================================================

Add Product Performance Should Meet Requirements
    [Documentation]    Verify adding product meets performance benchmarks and response times
    ...                Test: tests/api/products/products_add_tests.robot:88
    ...                UC: UC-PROD-006-V4 - Performance validation
    [Tags]    products    add    validation    performance    simulated
    Validate Add Product Performance

# ============================================================================
# UC-PROD-006: Add Product - Data Quality Validation
# ============================================================================

Add Product With Valid Price Boundaries Should Work
    [Documentation]    Verify adding products with various price boundary values works correctly
    ...                Test: tests/api/products/products_add_tests.robot:97
    ...                UC: UC-PROD-006-B1 - Price boundary validation
    [Tags]    products    add    validation    price-boundaries    simulated
    # Test minimum valid price
    ${min_price_product}=    Create Dictionary    title=Minimum Price Product    price=0.01
    _Execute Add Product Request    ${min_price_product}
    _Validate Product Creation Response    ${min_price_product}
    
    # Test reasonable maximum price
    ${max_price_product}=    Create Dictionary    title=Maximum Price Product    price=99999.99
    _Execute Add Product Request    ${max_price_product}
    _Validate Product Creation Response    ${max_price_product}
    
    # Test common price points
    ${common_prices}=    Create List    9.99    19.99    99.99    199.99    999.99
    FOR    ${price}    IN    @{common_prices}
        ${price_product}=    Create Dictionary    title=Price Test ${price}    price=${price}
        _Execute Add Product Request    ${price_product}
        _Validate Product Creation Response    ${price_product}
    END
    
Add Product With Various Title Lengths Should Work
    [Documentation]    Verify adding products with various title lengths works correctly
    ...                Test: tests/api/products/products_add_tests.robot:116
    ...                UC: UC-PROD-006-B2 - Title length validation
    [Tags]    products    add    validation    title-lengths    simulated
    # Short title
    ${short_title_product}=    Create Dictionary    title=Phone    price=99.99
    _Execute Add Product Request    ${short_title_product}
    _Validate Product Creation Response    ${short_title_product}
    
    # Long but reasonable title
    ${long_title_product}=    Create Dictionary    title=Premium High-Quality Smartphone With Advanced Features And Long Battery Life    price=299.99
    _Execute Add Product Request    ${long_title_product}
    _Validate Product Creation Response    ${long_title_product}
    
Add Product With Different Description Lengths Should Work
    [Documentation]    Verify adding products with different description lengths works correctly
    ...                Test: tests/api/products/products_add_tests.robot:129
    ...                UC: UC-PROD-006-B3 - Description length validation
    [Tags]    products    add    validation    description-lengths    simulated
    # No description
    ${no_desc_product}=    Create Dictionary    title=No Description Product    price=49.99
    _Execute Add Product Request    ${no_desc_product}
    _Validate Product Creation Response    ${no_desc_product}
    
    # Short description
    ${short_desc_product}=    Create Dictionary    title=Short Desc Product    price=49.99    description=Great product!
    _Execute Add Product Request    ${short_desc_product}
    _Validate Product Creation Response    ${short_desc_product}
    
    # Long description
    ${long_description}=    Set Variable    This is a comprehensive product with many features and benefits. It includes high-quality materials, excellent craftsmanship, and provides great value for money. Perfect for various use cases and suitable for all users.
    ${long_desc_product}=    Create Dictionary    title=Long Desc Product    price=149.99    description=${long_description}
    _Execute Add Product Request    ${long_desc_product}
    _Validate Product Creation Response    ${long_desc_product}

# ============================================================================
# UC-PROD-006: Add Product - Category Validation
# ============================================================================

Add Products With All Valid Categories Should Work
    [Documentation]    Verify adding products with all valid categories works correctly
    ...                Test: tests/api/products/products_add_tests.robot:149
    ...                UC: UC-PROD-006-C1 - All categories validation
    [Tags]    products    add    validation    all-categories    simulated
    ${test_categories}=    Create List    electronics    smartphones    laptops    books    clothing    furniture
    FOR    ${category}    IN    @{test_categories}
        ${category_product}=    Create Dictionary    title=Test ${category} Product    price=99.99    category=${category}
        _Execute Add Product Request    ${category_product}
        _Validate Product Creation Response    ${category_product}
        _Validate Product Category    ${category}
        Log    Successfully added product with category: ${category}    INFO
    END

# ============================================================================
# UC-PROD-006: Add Product - Brand Validation
# ============================================================================

Add Products With Different Brands Should Work
    [Documentation]    Verify adding products with different brand names works correctly
    ...                Test: tests/api/products/products_add_tests.robot:163
    ...                UC: UC-PROD-006-BR1 - Brand validation
    [Tags]    products    add    validation    brands    simulated
    ${test_brands}=    Create List    TestBrand    Apple    Samsung    Nike    Microsoft    Sony
    FOR    ${brand}    IN    @{test_brands}
        ${brand_product}=    Create Dictionary    title=Test Product    price=199.99    brand=${brand}
        _Execute Add Product Request    ${brand_product}
        _Validate Product Creation Response    ${brand_product}
        ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
        Should Be Equal As Strings    ${response_json['brand']}    ${brand}
        Log    Successfully added product with brand: ${brand}    INFO
    END

# ============================================================================
# UC-PROD-006: Add Product - Complex Data Structures
# ============================================================================

Add Product With Complete Product Information Should Work
    [Documentation]    Verify adding product with complete product information structure works
    ...                Test: tests/api/products/products_add_tests.robot:178
    ...                UC: UC-PROD-006-CO1 - Complete information validation
    [Tags]    products    add    validation    complete-info    simulated
    ${complete_product}=    Create Dictionary    
    ...    title=Complete Test Product
    ...    description=This is a complete test product with all possible fields
    ...    price=299.99
    ...    discountPercentage=15.5
    ...    rating=4.5
    ...    stock=100
    ...    brand=TestBrand
    ...    category=electronics
    ...    thumbnail=https://test.example.com/thumbnail.jpg
    
    _Execute Add Product Request    ${complete_product}
    _Validate Product Creation Response    ${complete_product}
    _Validate Complete Product Data Response    ${complete_product}
    
    # Validate specific fields
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${response_json['discountPercentage']}    15.5
    Should Be Equal As Numbers    ${response_json['rating']}    4.5
    Should Be Equal As Numbers    ${response_json['stock']}    100

# ============================================================================
# UC-PROD-006: Add Product - Integration Tests
# ============================================================================

Add Product Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of product addition
    ...                Test: tests/api/products/products_add_tests.robot:201
    ...                UC: UC-PROD-006-I1 - Complete integration validation
    [Tags]    products    add    integration    comprehensive    simulated
    # Test basic product addition
    Add New Product With Valid Data
    ${valid_product_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # Test minimal fields
    Add Product With Minimal Fields
    ${minimal_product_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # Test complete data
    Add Product With Complete Data
    ${complete_product_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # Validate IDs are different
    Should Not Be Equal As Numbers    ${valid_product_id}    ${minimal_product_id}
    Should Not Be Equal As Numbers    ${valid_product_id}    ${complete_product_id}
    Should Not Be Equal As Numbers    ${minimal_product_id}    ${complete_product_id}
    
    # Test validation scenarios
    Add Product Should Include Generated ID
    Add Product Should Echo All Sent Fields
    
    # Test different data types
    Add Product With Different Categories
    Add Product With Different Price Ranges
    
    # Test edge cases
    Add Product With Special Characters
    
    # Test uniqueness
    Add Multiple Products Should Generate Different IDs
    
    # Test performance
    Validate Add Product Performance
    
    # Log completion for reporting
    Log    Integration test completed successfully - Created products with IDs: ${valid_product_id}, ${minimal_product_id}, ${complete_product_id}    INFO

# ============================================================================
# UC-PROD-006: Add Product - Data Simulation Validation
# ============================================================================

Add Product Should Simulate Real CRUD Behavior
    [Documentation]    Verify add product simulates real CRUD behavior appropriately
    ...                Test: tests/api/products/products_add_tests.robot:238
    ...                UC: UC-PROD-006-SIM1 - CRUD simulation validation
    [Tags]    products    add    validation    simulation    crud
    # Add a product and verify simulation behavior
    ${test_product}=    Create Dictionary    title=CRUD Simulation Test Product    price=199.99
    _Execute Add Product Request    ${test_product}
    _Validate Product Creation Response    ${test_product}
    
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${created_id}=    Set Variable    ${response_json['id']}
    
    # Verify simulation characteristics
    Should Be True    ${created_id} > 100    msg=Simulated IDs should be greater than existing product range
    Should Be Equal As Strings    ${response_json['title']}    CRUD Simulation Test Product
    Should Be Equal As Numbers    ${response_json['price']}    199.99
    
    # Log simulation details
    Log    Simulated product creation with ID: ${created_id}    INFO