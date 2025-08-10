*** Settings ***
Documentation    Products Delete Tests - UC-PROD-008: Deletar Produto (Simulação)
...              This suite tests all scenarios for deleting existing products using simulated CRUD operations
...              File: tests/api/products/products_delete_tests.robot

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

*** Variables ***
# Test data loaded from products_service.resource via Variables imports

*** Test Cases ***
# ============================================================================
# UC-PROD-008: Delete Product - Success Scenarios
# ============================================================================

Delete Product With Valid ID Should Remove Product Successfully
    [Documentation]    Verify deleting existing product with valid ID removes product successfully (simulated)
    ...                Test: tests/api/products/products_delete_tests.robot:19
    ...                UC: UC-PROD-008 - Basic product deletion functionality
    [Tags]    products    delete    success    smoke    simulated
    Delete Product With Valid ID
    
Delete Multiple Products Should Work Independently
    [Documentation]    Verify deleting multiple products works independently and correctly
    ...                Test: tests/api/products/products_delete_tests.robot:25
    ...                UC: UC-PROD-008-A1 - Multiple deletions validation
    [Tags]    products    delete    success    multiple-products    simulated
    Delete Multiple Products Successfully

# ============================================================================
# UC-PROD-008: Delete Product - Error Scenarios
# ============================================================================

Delete Product With Invalid ID Should Return Error
    [Documentation]    Verify deleting product with invalid ID returns appropriate error
    ...                Test: tests/api/products/products_delete_tests.robot:33
    ...                UC: UC-PROD-008-E1 - Invalid ID error handling
    [Tags]    products    delete    error    404    invalid-id
    Delete Product With Invalid ID
    
Delete Product With Non-Existent ID Should Return Error
    [Documentation]    Verify deleting product with non-existent ID returns appropriate error
    ...                Test: tests/api/products/products_delete_tests.robot:39
    ...                UC: UC-PROD-008-E2 - Non-existent ID error handling
    [Tags]    products    delete    error    404    non-existent
    Delete Product With Non-Existent ID
    
Delete Product With Zero ID Should Return Error
    [Documentation]    Verify deleting product with zero ID returns appropriate error
    ...                Test: tests/api/products/products_delete_tests.robot:45
    ...                UC: UC-PROD-008-E3 - Zero ID error handling
    [Tags]    products    delete    error    invalid-id    zero-id
    Delete Product With Zero ID
    
Delete Product With Negative ID Should Return Error
    [Documentation]    Verify deleting product with negative ID returns appropriate error
    ...                Test: tests/api/products/products_delete_tests.robot:51
    ...                UC: UC-PROD-008-E4 - Negative ID error handling
    [Tags]    products    delete    error    invalid-id    negative-id
    Delete Product With Negative ID
    
Delete Product With String ID Should Return Error
    [Documentation]    Verify deleting product with string ID returns appropriate error
    ...                Test: tests/api/products/products_delete_tests.robot:57
    ...                UC: UC-PROD-008-E5 - String ID error handling
    [Tags]    products    delete    error    invalid-id    string-id
    Delete Product With String ID

# ============================================================================
# UC-PROD-008: Delete Product - Response Validation
# ============================================================================

Delete Product Should Return Deleted Product Information
    [Documentation]    Verify delete response contains information about the deleted product
    ...                Test: tests/api/products/products_delete_tests.robot:65
    ...                UC: UC-PROD-008-V1 - Response content validation
    [Tags]    products    delete    validation    response-content    simulated
    Delete Product Should Return Product Information
    
Delete Product Should Preserve Original Product ID
    [Documentation]    Verify delete response preserves the original product ID that was deleted
    ...                Test: tests/api/products/products_delete_tests.robot:71
    ...                UC: UC-PROD-008-V2 - ID preservation validation
    [Tags]    products    delete    validation    preserve-id    simulated
    Delete Product Should Preserve ID
    
Delete Product Should Include Deletion Confirmation
    [Documentation]    Verify delete response includes confirmation that product was deleted
    ...                Test: tests/api/products/products_delete_tests.robot:77
    ...                UC: UC-PROD-008-V3 - Deletion confirmation validation
    [Tags]    products    delete    validation    deletion-confirmation    simulated
    Delete Product Should Include Confirmation

# ============================================================================
# UC-PROD-008: Delete Product - Edge Cases
# ============================================================================

Delete Same Product Multiple Times Should Handle Gracefully
    [Documentation]    Verify deleting the same product multiple times handles gracefully
    ...                Test: tests/api/products/products_delete_tests.robot:85
    ...                UC: UC-PROD-008-E6 - Multiple deletion attempts edge case
    [Tags]    products    delete    edge-case    multiple-attempts    simulated
    Delete Same Product Multiple Times
    
Delete Product With Special ID Values Should Handle Correctly
    [Documentation]    Verify deleting product with special ID values handles correctly
    ...                Test: tests/api/products/products_delete_tests.robot:91
    ...                UC: UC-PROD-008-E7 - Special values edge case
    [Tags]    products    delete    edge-case    special-values
    Delete Product With Special Values

# ============================================================================
# UC-PROD-008: Delete Product - Performance Validation
# ============================================================================

Delete Product Performance Should Meet Requirements
    [Documentation]    Verify deleting product meets performance benchmarks and response times
    ...                Test: tests/api/products/products_delete_tests.robot:99
    ...                UC: UC-PROD-008-V4 - Performance validation
    [Tags]    products    delete    validation    performance    simulated
    Validate Delete Product Performance

# ============================================================================
# UC-PROD-008: Delete Product - Boundary Testing
# ============================================================================

Delete Product With Boundary ID Values Should Work
    [Documentation]    Verify deleting products with boundary ID values works correctly
    ...                Test: tests/api/products/products_delete_tests.robot:107
    ...                UC: UC-PROD-008-B1 - Boundary values validation
    [Tags]    products    delete    validation    boundary-values    simulated
    # Test deletion with minimum valid ID
    _Execute Delete Product Request    1
    _Validate Product Deletion Response    1
    
    # Test deletion with maximum reasonable ID
    _Execute Delete Product Request    100
    _Validate Product Deletion Response    100
    
    # Test deletion with common ID values
    ${common_ids}=    Create List    5    10    25    50    99
    FOR    ${id}    IN    @{common_ids}
        _Execute Delete Product Request    ${id}
        _Validate Product Deletion Response    ${id}
        Log    Successfully deleted product with ID: ${id}    INFO
    END

# ============================================================================
# UC-PROD-008: Delete Product - Data Consistency Validation
# ============================================================================

Delete Product Should Be Idempotent For Error Cases
    [Documentation]    Verify deleting non-existent product multiple times returns consistent errors
    ...                Test: tests/api/products/products_delete_tests.robot:125
    ...                UC: UC-PROD-008-ID1 - Error idempotency validation
    [Tags]    products    delete    validation    idempotency    error-consistency
    ${non_existent_id}=    Set Variable    99999
    
    # First attempt - should return 404
    _Execute Delete Product Request    ${non_existent_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    404
    ${first_error_response}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Second attempt - should return same 404
    _Execute Delete Product Request    ${non_existent_id}
    Should Be Equal As Numbers    ${LAST_RESPONSE.status_code}    404
    ${second_error_response}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Error responses should be consistent
    Should Be Equal    ${first_error_response}    ${second_error_response}

# ============================================================================
# UC-PROD-008: Delete Product - Comprehensive ID Testing
# ============================================================================

Delete Products With Various Valid IDs Should Work
    [Documentation]    Verify deleting products with various valid ID formats works correctly
    ...                Test: tests/api/products/products_delete_tests.robot:143
    ...                UC: UC-PROD-008-VID1 - Various IDs validation
    [Tags]    products    delete    success    various-ids    simulated
    ${test_ids}=    Create List    1    2    3    15    30    45    75    100
    FOR    ${product_id}    IN    @{test_ids}
        _Execute Delete Product Request    ${product_id}
        _Validate Product Deletion Response    ${product_id}
        
        # Validate response contains expected product ID
        ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
        Should Be Equal As Numbers    ${response_json['id']}    ${product_id}
        Should Be True    ${response_json['isDeleted']}    # Simulated deletion flag
        
        Log    Successfully deleted product ID: ${product_id}    INFO
    END
    
Delete Products Sequential IDs Should Work Independently
    [Documentation]    Verify deleting products with sequential IDs works independently
    ...                Test: tests/api/products/products_delete_tests.robot:158
    ...                UC: UC-PROD-008-SEQ1 - Sequential deletion validation
    [Tags]    products    delete    success    sequential-ids    simulated
    ${sequential_ids}=    Create List    10    11    12    13    14
    FOR    ${product_id}    IN    @{sequential_ids}
        _Execute Delete Product Request    ${product_id}
        _Validate Product Deletion Response    ${product_id}
        Should Be Equal As Numbers    ${LAST_RESPONSE.json()['id']}    ${product_id}
    END

# ============================================================================
# UC-PROD-008: Delete Product - Error Response Structure Validation
# ============================================================================

Delete Product Error Responses Should Have Consistent Structure
    [Documentation]    Verify delete product error responses have consistent structure
    ...                Test: tests/api/products/products_delete_tests.robot:171
    ...                UC: UC-PROD-008-ERR1 - Error structure validation
    [Tags]    products    delete    validation    error-structure
    ${invalid_ids}=    Create List    0    -1    999999    abc
    FOR    ${invalid_id}    IN    @{invalid_ids}
        _Execute Delete Product Request    ${invalid_id}
        Should Not Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
        
        # Error response should contain message
        ${error_response}=    Set Variable    ${LAST_RESPONSE.json()}
        Dictionary Should Contain Key    ${error_response}    message
        Should Not Be Empty    ${error_response['message']}
        
        Log    Invalid ID ${invalid_id} returned proper error structure    INFO
    END

# ============================================================================
# UC-PROD-008: Delete Product - Integration Scenarios
# ============================================================================

Delete Product After Creation Should Work End-to-End
    [Documentation]    Verify creating then deleting a product works in complete workflow
    ...                Test: tests/api/products/products_delete_tests.robot:187
    ...                UC: UC-PROD-008-I1 - Create-delete integration
    [Tags]    products    delete    integration    create-delete    simulated
    # Create a product first (simulated)
    ${new_product}=    Create Dictionary    title=Product To Be Deleted    price=99.99
    _Execute Add Product Request    ${new_product}
    _Validate Product Creation Response    ${new_product}
    ${created_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # Now delete the created product
    _Execute Delete Product Request    ${created_id}
    _Validate Product Deletion Response    ${created_id}
    
    # Verify deletion response
    ${delete_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${delete_response['id']}    ${created_id}
    Should Be True    ${delete_response['isDeleted']}
    
    Log    Successfully created and deleted product with ID: ${created_id}    INFO
    
Delete Product After Update Should Work End-to-End
    [Documentation]    Verify updating then deleting a product works in complete workflow
    ...                Test: tests/api/products/products_delete_tests.robot:204
    ...                UC: UC-PROD-008-I2 - Update-delete integration
    [Tags]    products    delete    integration    update-delete    simulated
    ${target_id}=    Set Variable    1
    
    # Update the product first
    ${update_data}=    Create Dictionary    title=Updated Before Deletion    price=199.99
    _Execute Update Product Request    ${target_id}    ${update_data}
    _Validate Product Update Response    ${target_id}    ${update_data}
    
    # Now delete the updated product
    _Execute Delete Product Request    ${target_id}
    _Validate Product Deletion Response    ${target_id}
    
    # Verify deletion response
    ${delete_response}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Be Equal As Numbers    ${delete_response['id']}    ${target_id}
    Should Be True    ${delete_response['isDeleted']}

# ============================================================================
# UC-PROD-008: Delete Product - Complete Integration Test
# ============================================================================

Delete Product Complete Integration Test
    [Documentation]    Comprehensive integration test covering multiple aspects of product deletion
    ...                Test: tests/api/products/products_delete_tests.robot:224
    ...                UC: UC-PROD-008-COMP1 - Complete integration validation
    [Tags]    products    delete    integration    comprehensive    simulated
    # Test successful deletions
    Delete Product With Valid ID    1
    ${valid_delete_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    Delete Multiple Products Successfully
    
    # Test error scenarios
    Delete Product With Invalid ID
    Delete Product With Non-Existent ID    99999
    Delete Product With Zero ID
    Delete Product With Negative ID    -5
    Delete Product With String ID    "invalid"
    
    # Test response validations
    Delete Product Should Return Product Information    5
    Delete Product Should Preserve ID    10
    Delete Product Should Include Confirmation    15
    
    # Test edge cases
    Delete Same Product Multiple Times    20
    Delete Product With Special Values
    
    # Test performance
    Validate Delete Product Performance    25
    
    # Test various IDs
    ${integration_ids}=    Create List    30    35    40
    FOR    ${id}    IN    @{integration_ids}
        _Execute Delete Product Request    ${id}
        _Validate Product Deletion Response    ${id}
    END
    
    # Log completion for reporting
    Log    Integration test completed successfully - Deleted products including ID: ${valid_delete_id}    INFO

# ============================================================================
# UC-PROD-008: Delete Product - Security Validation
# ============================================================================

Delete Product Should Handle SQL Injection Attempts
    [Documentation]    Verify delete product handles SQL injection attempts safely
    ...                Test: tests/api/products/products_delete_tests.robot:256
    ...                UC: UC-PROD-008-S1 - SQL injection security validation
    [Tags]    products    delete    security    sql-injection
    _Execute Delete Product Request    1; DROP TABLE products; --
    Should Not Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    # Should return error, not execute malicious SQL
    
Delete Product Should Handle Path Traversal Attempts
    [Documentation]    Verify delete product handles path traversal attempts safely
    ...                Test: tests/api/products/products_delete_tests.robot:263
    ...                UC: UC-PROD-008-S2 - Path traversal security validation
    [Tags]    products    delete    security    path-traversal
    _Execute Delete Product Request    ../../../etc/passwd
    Should Not Be Equal As Numbers    ${LAST_RESPONSE.status_code}    200
    # Should return error, not access file system

# ============================================================================
# UC-PROD-008: Delete Product - Simulation Validation
# ============================================================================

Delete Product Should Simulate Real CRUD Behavior
    [Documentation]    Verify delete product simulates real CRUD behavior appropriately
    ...                Test: tests/api/products/products_delete_tests.robot:272
    ...                UC: UC-PROD-008-SIM1 - CRUD simulation validation
    [Tags]    products    delete    validation    simulation    crud
    # Delete a product and verify simulation behavior
    ${target_id}=    Set Variable    1
    _Execute Delete Product Request    ${target_id}
    _Validate Product Deletion Response    ${target_id}
    
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    
    # Verify simulation characteristics
    Should Be Equal As Numbers    ${response_json['id']}    ${target_id}    # Original ID preserved
    Should Be True    ${response_json['isDeleted']}    # Deletion flag set
    
    # Product data should still be present (soft delete simulation)
    Dictionary Should Contain Key    ${response_json}    title
    Dictionary Should Contain Key    ${response_json}    price
    
    # Log simulation details
    Log    Simulated product deletion for ID: ${target_id}    INFO

# ============================================================================
# UC-PROD-008: Delete Product - Stress Testing
# ============================================================================

Delete Multiple Products In Sequence Should Handle Load
    [Documentation]    Verify deleting multiple products in sequence handles load correctly
    ...                Test: tests/api/products/products_delete_tests.robot:294
    ...                UC: UC-PROD-008-LOAD1 - Sequential load validation
    [Tags]    products    delete    performance    load-testing    simulated
    ${stress_test_ids}=    Create List    50    51    52    53    54    55    56    57    58    59
    ${start_time}=    Get Current Date    result_format=epoch
    
    FOR    ${product_id}    IN    @{stress_test_ids}
        _Execute Delete Product Request    ${product_id}
        _Validate Product Deletion Response    ${product_id}
    END
    
    ${end_time}=    Get Current Date    result_format=epoch
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    
    # Should complete within reasonable time
    Should Be True    ${duration} < 30    msg=Sequential deletions should complete within 30 seconds
    
    Log    Deleted ${stress_test_ids.__len__()} products in ${duration} seconds    INFO