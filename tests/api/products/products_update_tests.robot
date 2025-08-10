*** Settings ***
Documentation    Products Update Tests - UC-PROD-007: Atualizar Produto (Simulação)
...              This suite tests all scenarios for updating existing products using simulated CRUD operations
...              File: tests/api/products/products_update_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-007: Update Product - Success Scenarios
# ============================================================================

Update Product With Valid Data Should Update Successfully
    [Documentation]    Verify updating existing product with valid data updates successfully (simulated)
    ...                Test: tests/api/products/products_update_tests.robot:19
    ...                UC: UC-PROD-007 - Basic product update functionality
    [Tags]    products    update    success    smoke    simulated
    Update Product With Valid Data
    
Update Product With Partial Data Should Update Only Specified Fields
    [Documentation]    Verify updating product with partial data updates only specified fields
    ...                Test: tests/api/products/products_update_tests.robot:25
    ...                UC: UC-PROD-007-A1 - Partial data update
    [Tags]    products    update    success    partial-data    simulated
    Update Product With Partial Data

# ============================================================================
# UC-PROD-007: Update Product - Single Field Updates
# ============================================================================

Update Product Title Only Should Update Title Field
    [Documentation]    Verify updating only product title updates title field correctly
    ...                Test: tests/api/products/products_update_tests.robot:34
    ...                UC: UC-PROD-007-A2 - Title-only update
    [Tags]    products    update    success    title-only    simulated
    Update Product Title Only
    
Update Product Price Only Should Update Price Field
    [Documentation]    Verify updating only product price updates price field correctly
    ...                Test: tests/api/products/products_update_tests.robot:40
    ...                UC: UC-PROD-007-A3 - Price-only update
    [Tags]    products    update    success    price-only    simulated
    Update Product Price Only
    
Update Product Description Only Should Update Description Field
    [Documentation]    Verify updating only product description updates description field correctly
    ...                Test: tests/api/products/products_update_tests.robot:46
    ...                UC: UC-PROD-007-A4 - Description-only update
    [Tags]    products    update    success    description-only    simulated
    Update Product Description Only
    
Update Product Category Only Should Update Category Field
    [Documentation]    Verify updating only product category updates category field correctly
    ...                Test: tests/api/products/products_update_tests.robot:52
    ...                UC: UC-PROD-007-A5 - Category-only update
    [Tags]    products    update    success    category-only    simulated
    Update Product Category Only
    
Update Product Brand Only Should Update Brand Field
    [Documentation]    Verify updating only product brand updates brand field correctly
    ...                Test: tests/api/products/products_update_tests.robot:58
    ...                UC: UC-PROD-007-A6 - Brand-only update
    [Tags]    products    update    success    brand-only    simulated
    Update Product Brand Only

# ============================================================================
# UC-PROD-007: Update Product - Multiple Value Testing
# ============================================================================

Update Product With Different Prices Should Accept All Price Values
    [Documentation]    Verify updating product with different price values accepts all valid prices
    ...                Test: tests/api/products/products_update_tests.robot:67
    ...                UC: UC-PROD-007-A7 - Different price values update
    [Tags]    products    update    success    different-prices    simulated
    Update Product With Different Prices

# ============================================================================
# UC-PROD-007: Update Product - Edge Cases
# ============================================================================

Update Product With Special Characters Should Handle Correctly
    [Documentation]    Verify updating product with special characters handles correctly
    ...                Test: tests/api/products/products_update_tests.robot:76
    ...                UC: UC-PROD-007-A8 - Special characters edge case
    [Tags]    products    update    edge-case    special-characters    simulated
    Update Product With Special Characters

# ============================================================================
# UC-PROD-007: Update Product - Response Validation
# ============================================================================

Update Product Response Should Preserve Original ID
    [Documentation]    Verify update response preserves the original product ID
    ...                Test: tests/api/products/products_update_tests.robot:85
    ...                UC: UC-PROD-007-V1 - ID preservation validation
    [Tags]    products    update    validation    preserve-id    simulated
    Update Product Response Should Preserve ID
    
Update Product Response Should Echo Updated Fields
    [Documentation]    Verify update response echoes all updated fields correctly
    ...                Test: tests/api/products/products_update_tests.robot:91
    ...                UC: UC-PROD-007-V2 - Field echo validation
    [Tags]    products    update    validation    echo-fields    simulated
    Update Product Response Should Echo Updated Fields

# ============================================================================
# UC-PROD-007: Update Product - Edge Cases and Error Handling
# ============================================================================

Update Product With Empty Data Should Handle Gracefully
    [Documentation]    Verify updating product with empty data handles gracefully
    ...                Test: tests/api/products/products_update_tests.robot:100
    ...                UC: UC-PROD-007-E1 - Empty data edge case
    [Tags]    products    update    edge-case    empty-data    simulated
    Update Product With Empty Data
    
Update Same Product Multiple Times Should Work Consistently
    [Documentation]    Verify updating the same product multiple times works consistently
    ...                Test: tests/api/products/products_update_tests.robot:106
    ...                UC: UC-PROD-007-A9 - Multiple updates consistency
    [Tags]    products    update    success    multiple-updates    simulated
    Update Same Product Multiple Times
    
Update Non-Existent Product Should Return Error
    [Documentation]    Verify updating non-existent product returns appropriate error
    ...                Test: tests/api/products/products_update_tests.robot:112
    ...                UC: UC-PROD-007-E2 - Non-existent product error
    [Tags]    products    update    error    404    non-existent
    Update Non-Existent Product

# ============================================================================
# UC-PROD-007: Update Product - Performance Validation
# ============================================================================

Update Product Performance Should Meet Requirements
    [Documentation]    Verify updating product meets performance benchmarks and response times
    ...                Test: tests/api/products/products_update_tests.robot:121
    ...                UC: UC-PROD-007-V3 - Performance validation
    [Tags]    products    update    validation    performance    simulated
    Validate Update Product Performance

# ============================================================================
# UC-PROD-007: Update Product - Complex Update Scenarios
# ============================================================================

Update Product With Multiple Fields Should Update All Fields
    [Documentation]    Verify updating product with multiple fields updates all specified fields
    ...                Test: tests/api/products/products_update_tests.robot:130
    ...                UC: UC-PROD-007-MF1 - Multiple fields update
    [Tags]    products    update    success    multiple-fields    simulated
    ${multi_field_update}=    Create Dictionary
    ...    title=Updated Multi-Field Product
    ...    price=399.99
    ...    description=Updated product with multiple field changes
    ...    category=electronics
    ...    brand=UpdatedBrand
    
    _Execute Update Product Request    1    ${multi_field_update}
    _Validate Product Update Response    1    ${multi_field_update}
    
    # Validate each field was updated
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Strings    ${response_json['title']}    Updated Multi-Field Product
    Should Be Equal As Numbers    ${response_json['price']}    399.99
    Should Be Equal As Strings    ${response_json['description']}    Updated product with multiple field changes
    Should Be Equal As Strings    ${response_json['category']}    electronics
    Should Be Equal As Strings    ${response_json['brand']}    UpdatedBrand
    
Update Product With Incremental Changes Should Track Changes
    [Documentation]    Verify updating product with incremental changes tracks all changes properly
    ...                Test: tests/api/products/products_update_tests.robot:150
    ...                UC: UC-PROD-007-IC1 - Incremental changes tracking
    [Tags]    products    update    success    incremental-changes    simulated
    # First update - title only
    ${update1}=    Create Dictionary    title=First Update Title
    _Execute Update Product Request    1    ${update1}
    _Validate Product Update Response    1    ${update1}
    ${title_after_first}=    Set Variable    ${LAST_RESPONSE.json()['title']}
    
    # Second update - price only
    ${update2}=    Create Dictionary    price=299.99
    _Execute Update Product Request    1    ${update2}
    _Validate Product Update Response    1    ${update2}
    ${price_after_second}=    Set Variable    ${LAST_RESPONSE.json()['price']}
    ${title_after_second}=    Set Variable    ${LAST_RESPONSE.json()['title']}
    
    # Third update - description only
    ${update3}=    Create Dictionary    description=Third update description
    _Execute Update Product Request    1    ${update3}
    _Validate Product Update Response    1    ${update3}
    
    # Validate incremental changes
    Should Be Equal As Strings    ${title_after_first}    First Update Title
    Should Be Equal As Numbers    ${price_after_second}    299.99
    Should Be Equal As Strings    ${title_after_second}    First Update Title    # Title should be preserved

# ============================================================================
# UC-PROD-007: Update Product - Data Type Validation
# ============================================================================

Update Product With Different Data Types Should Validate Types
    [Documentation]    Verify updating product with different data types validates types correctly
    ...                Test: tests/api/products/products_update_tests.robot:175
    ...                UC: UC-PROD-007-DT1 - Data type validation
    [Tags]    products    update    validation    data-types    simulated
    # Update with numeric price
    ${numeric_update}=    Create Dictionary    price=149.99
    _Execute Update Product Request    1    ${numeric_update}
    _Validate Product Update Response    1    ${numeric_update}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be True    isinstance($response_json['price'], (int, float))
    
    # Update with string title
    ${string_update}=    Create Dictionary    title=String Title Test
    _Execute Update Product Request    1    ${string_update}
    _Validate Product Update Response    1    ${string_update}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be String    ${response_json['title']}
    
Update Product With Boundary Values Should Handle Boundaries
    [Documentation]    Verify updating product with boundary values handles boundaries correctly
    ...                Test: tests/api/products/products_update_tests.robot:191
    ...                UC: UC-PROD-007-BV1 - Boundary values validation
    [Tags]    products    update    validation    boundary-values    simulated
    # Test minimum price boundary
    ${min_price_update}=    Create Dictionary    price=0.01
    _Execute Update Product Request    1    ${min_price_update}
    _Validate Product Update Response    1    ${min_price_update}
    
    # Test maximum reasonable price boundary
    ${max_price_update}=    Create Dictionary    price=99999.99
    _Execute Update Product Request    1    ${max_price_update}
    _Validate Product Update Response    1    ${max_price_update}
    
    # Test long title
    ${long_title}=    Set Variable    This is a very long product title that tests the boundary limits of title field length to ensure proper handling
    ${long_title_update}=    Create Dictionary    title=${long_title}
    _Execute Update Product Request    1    ${long_title_update}
    _Validate Product Update Response    1    ${long_title_update}

# ============================================================================
# UC-PROD-007: Update Product - Category and Brand Updates
# ============================================================================

Update Product Category To All Valid Categories Should Work
    [Documentation]    Verify updating product category to all valid categories works correctly
    ...                Test: tests/api/products/products_update_tests.robot:211
    ...                UC: UC-PROD-007-CAT1 - Category update validation
    [Tags]    products    update    success    category-updates    simulated
    ${test_categories}=    Create List    electronics    smartphones    laptops    books    clothing
    FOR    ${category}    IN    @{test_categories}
        ${category_update}=    Create Dictionary    category=${category}
        _Execute Update Product Request    1    ${category_update}
        _Validate Product Update Response    1    ${category_update}
        _Validate Product Category    ${category}
        Log    Successfully updated product category to: ${category}    INFO
    END
    
Update Product Brand To Different Brands Should Work
    [Documentation]    Verify updating product brand to different brands works correctly
    ...                Test: tests/api/products/products_update_tests.robot:223
    ...                UC: UC-PROD-007-BR1 - Brand update validation
    [Tags]    products    update    success    brand-updates    simulated
    ${test_brands}=    Create List    Apple    Samsung    Sony    Microsoft    TestBrand
    FOR    ${brand}    IN    @{test_brands}
        ${brand_update}=    Create Dictionary    brand=${brand}
        _Execute Update Product Request    1    ${brand_update}
        _Validate Product Update Response    1    ${brand_update}
        ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
        Should Be Equal As Strings    ${response_json['brand']}    ${brand}
        Log    Successfully updated product brand to: ${brand}    INFO
    END

# ============================================================================
# UC-PROD-007: Update Product - Data Consistency
# ============================================================================

Update Same Product With Same Data Should Be Idempotent
    [Documentation]    Verify updating the same product with same data is idempotent
    ...                Test: tests/api/products/products_update_tests.robot:238
    ...                UC: UC-PROD-007-ID1 - Idempotency validation
    [Tags]    products    update    validation    idempotency    simulated
    ${same_data}=    Create Dictionary    title=Idempotent Test Product    price=199.99
    
    # First update
    _Execute Update Product Request    1    ${same_data}
    _Validate Product Update Response    1    ${same_data}
    ${first_response}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Second update with same data
    _Execute Update Product Request    1    ${same_data}
    _Validate Product Update Response    1    ${same_data}
    ${second_response}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Responses should be identical (idempotent)
    Should Be Equal    ${first_response}    ${second_response}

# ============================================================================
# UC-PROD-007: Update Product - Integration Tests
# ============================================================================

Update Product Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of product updates
    ...                Test: tests/api/products/products_update_tests.robot:257
    ...                UC: UC-PROD-007-I1 - Complete integration validation
    [Tags]    products    update    integration    comprehensive    simulated
    # Test basic update
    Update Product With Valid Data    1
    
    # Test partial updates
    Update Product With Partial Data    1
    
    # Test single field updates
    Update Product Title Only    1
    Update Product Price Only    1
    Update Product Description Only    1
    Update Product Category Only    1
    Update Product Brand Only    1
    
    # Test edge cases
    Update Product With Special Characters    1
    Update Product With Empty Data    1
    Update Same Product Multiple Times    1
    
    # Test validation scenarios
    Update Product Response Should Preserve ID    1
    Update Product Response Should Echo Updated Fields    1
    
    # Test error scenarios
    Update Non-Existent Product
    
    # Test performance
    Validate Update Product Performance    1
    
    # Test complex scenarios
    ${complex_update}=    Create Dictionary    
    ...    title=Integration Test Final Update
    ...    price=999.99
    ...    description=Final integration test update with all fields
    ...    category=electronics
    ...    brand=IntegrationTestBrand
    
    _Execute Update Product Request    1    ${complex_update}
    _Validate Product Update Response    1    ${complex_update}
    
    # Log completion for reporting
    ${final_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Log    Integration test completed successfully - Final product state: ${final_response}    INFO

# ============================================================================
# UC-PROD-007: Update Product - Simulation Validation
# ============================================================================

Update Product Should Simulate Real CRUD Behavior
    [Documentation]    Verify update product simulates real CRUD behavior appropriately
    ...                Test: tests/api/products/products_update_tests.robot:297
    ...                UC: UC-PROD-007-SIM1 - CRUD simulation validation
    [Tags]    products    update    validation    simulation    crud
    # Update a product and verify simulation behavior
    ${test_update}=    Create Dictionary    title=CRUD Simulation Update Test    price=399.99
    _Execute Update Product Request    1    ${test_update}
    _Validate Product Update Response    1    ${test_update}
    
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Verify simulation characteristics
    Should Be Equal As Numbers    ${response_json['id']}    1    # ID should be preserved
    Should Be Equal As Strings    ${response_json['title']}    CRUD Simulation Update Test
    Should Be Equal As Numbers    ${response_json['price']}    399.99
    
    # Log simulation details
    Log    Simulated product update for ID: ${response_json['id']}    INFO