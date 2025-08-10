*** Settings ***
Documentation    Products API Test Suite - Complete Suite Orchestrator
...              This is the main orchestrator suite that manages and executes all Products API tests
...              File: tests/api/products/products_test_suite.robot
...
...              Test Coverage:
...              - UC-PROD-001: Get All Products (pagination, sorting, validation)
...              - UC-PROD-002: Get Product By ID (success, errors, validation)
...              - UC-PROD-003: Search Products (terms, filters, performance)
...              - UC-PROD-004: Get Categories (structure, validation, consistency)
...              - UC-PROD-005: Get Products By Category (filtering, validation)
...              - UC-PROD-006: Add Product (CRUD simulation, validation)
...              - UC-PROD-007: Update Product (CRUD simulation, validation)
...              - UC-PROD-008: Delete Product (CRUD simulation, validation)
...
...              Total Test Cases: 150+ comprehensive scenarios
...              Execution Modes: All tests, by operation, by tag, smoke tests only
...              Design Patterns: Library-Keyword Pattern, Service Objects, Facade Pattern

Resource         ${CURDIR}/../../../resources/apis/products_service.resource
Suite Setup      Initialize Products Test Suite
Suite Teardown   Finalize Products Test Suite
Test Setup       Initialize Products Service  
Test Teardown    Cleanup Products Service

# Test data and configuration
Variables        ${CURDIR}/../../../data/testdata/products_api/products_endpoints.json
Variables        ${CURDIR}/../../../data/testdata/products_api/valid_products.json
Variables        ${CURDIR}/../../../data/testdata/products_api/invalid_products.json

*** Variables ***
${SUITE_START_TIME}         ${EMPTY}
${SUITE_END_TIME}           ${EMPTY}
${TOTAL_TESTS_RUN}          0
${TESTS_PASSED}             0
${TESTS_FAILED}             0
${SUITE_STATUS}             UNKNOWN

# Test execution control flags
${RUN_SMOKE_ONLY}           ${False}
${RUN_INTEGRATION_ONLY}     ${False}
${RUN_PERFORMANCE_ONLY}     ${False}
${RUN_SECURITY_ONLY}        ${False}
${SKIP_LONG_TESTS}          ${False}

*** Test Cases ***
# ============================================================================
# Products Test Suite - Main Orchestrator Tests
# ============================================================================

Products API Test Suite Health Check
    [Documentation]    Verify the Products API test suite is properly configured and ready
    ...                Test: tests/api/products/products_test_suite.robot:46
    ...                Validates test environment, data availability, and service connectivity
    [Tags]    products    suite    health-check    smoke
    # Validate test data is loaded
    Should Not Be Empty    ${valid_products}
    Should Not Be Empty    ${invalid_products}
    Should Not Be Empty    ${endpoints}
    
    # Validate service connectivity
    Validate Products API Connectivity
    
    # Validate test suite configuration
    Should Not Be Empty    ${BASE_URL}
    Should Not Be Empty    ${PRODUCTS_ENDPOINTS}
    
    Log    Products API Test Suite health check completed successfully    INFO

Products API Complete Smoke Test Suite
    [Documentation]    Execute comprehensive smoke tests for all major Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:60
    ...                Covers basic functionality of all 8 UC operations with minimal test scenarios
    [Tags]    products    suite    smoke    comprehensive
    # UC-PROD-001: Get All Products - Basic smoke test
    Get All Products Default Should Return Products List
    ${get_all_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # UC-PROD-002: Get Product By ID - Basic smoke test  
    Get Product By Valid ID Should Return Product Details    1
    ${get_by_id_title}=    Set Variable    ${LAST_RESPONSE.json()['title']}
    
    # UC-PROD-003: Search Products - Basic smoke test
    Search Products With Valid Term
    ${search_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # UC-PROD-004: Get Categories - Basic smoke test
    Get All Product Categories
    ${categories_count}=    Set Variable    ${LAST_RESPONSE.json().__len__()}
    
    # UC-PROD-005: Get Products By Category - Basic smoke test
    Get Products By Valid Category Smartphones
    ${category_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # UC-PROD-006: Add Product - Basic smoke test (simulated)
    Add New Product With Valid Data
    ${add_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # UC-PROD-007: Update Product - Basic smoke test (simulated)
    Update Product With Valid Data    1
    ${update_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # UC-PROD-008: Delete Product - Basic smoke test (simulated)
    Delete Product With Valid ID    1
    ${delete_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # Validate smoke test results
    Should Be True    ${get_all_count} > 0
    Should Not Be Empty    ${get_by_id_title}
    Should Be True    ${search_count} > 0
    Should Be True    ${categories_count} > 0
    Should Be True    ${category_count} > 0
    Should Be True    ${add_id} > 100    # Simulated IDs are > 100
    Should Be Equal As Numbers    ${update_id}    1
    Should Be Equal As Numbers    ${delete_id}    1
    
    Log    Smoke test completed - All: ${get_all_count}, Search: ${search_count}, Categories: ${categories_count}, By Category: ${category_count}    INFO

Products API Comprehensive Integration Test Suite
    [Documentation]    Execute comprehensive integration tests across all Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:97
    ...                Tests inter-operation dependencies, data consistency, and end-to-end workflows
    [Tags]    products    suite    integration    comprehensive
    # Test complete product lifecycle (simulated CRUD)
    # 1. Create a product
    ${new_product}=    Create Dictionary    title=Integration Test Product    price=299.99    category=electronics
    _Execute Add Product Request    ${new_product}
    _Validate Product Creation Response    ${new_product}
    ${created_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    # 2. Retrieve the created product by ID
    _Execute Get Product By ID Request    ${created_id}
    _Validate Single Product Response
    Should Be Equal As Strings    ${LAST_RESPONSE.json()['title']}    Integration Test Product
    
    # 3. Update the created product
    ${update_data}=    Create Dictionary    title=Updated Integration Product    price=399.99
    _Execute Update Product Request    ${created_id}    ${update_data}
    _Validate Product Update Response    ${created_id}    ${update_data}
    
    # 4. Search for the updated product
    _Execute Search Products Request    Updated Integration
    _Validate Products List Response
    ${found_in_search}=    Set Variable    ${False}
    FOR    ${product}    IN    @{LAST_RESPONSE.json()['products']}
        ${found}=    Run Keyword And Return Status    Should Contain    ${product['title']}    Updated Integration
        ${found_in_search}=    Set Variable If    ${found}    ${True}    ${found_in_search}
    END
    Should Be True    ${found_in_search}
    
    # 5. Delete the product
    _Execute Delete Product Request    ${created_id}
    _Validate Product Deletion Response    ${created_id}
    
    # Test data consistency across operations
    Validate Categories Match Products Categories
    Validate Multiple Categories Have Different Products
    
    Log    Integration test completed successfully for product lifecycle with ID: ${created_id}    INFO

Products API Performance Test Suite
    [Documentation]    Execute performance tests for all Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:131
    ...                Validates response times, throughput, and performance benchmarks
    [Tags]    products    suite    performance    validation
    # Test performance of all major operations
    Validate All Products Performance
    Validate Product By ID Performance    1
    Validate Search Performance
    Validate Categories Performance
    Validate Category Products Performance
    Validate Add Product Performance
    Validate Update Product Performance    1
    Validate Delete Product Performance    1
    
    Log    Performance test suite completed successfully    INFO

Products API Error Handling Test Suite
    [Documentation]    Execute comprehensive error handling tests across all Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:145
    ...                Validates error scenarios, edge cases, and proper error responses
    [Tags]    products    suite    error    validation
    # Test error handling across all operations
    # UC-PROD-002 errors
    Get Product By Invalid ID
    Get Product By Non-Existent ID    99999
    Get Product By Zero ID
    Get Product By Negative ID    -1
    Get Product By String ID    "invalid"
    
    # UC-PROD-003 errors
    Search Products With Empty Query
    
    # UC-PROD-005 errors
    Get Products By Non-Existent Category
    Get Products By Invalid Special Characters Category
    
    # UC-PROD-008 errors
    Delete Product With Invalid ID
    Delete Product With Non-Existent ID    88888
    Delete Product With Zero ID
    Delete Product With Negative ID    -5
    Delete Product With String ID    "invalid"
    
    Log    Error handling test suite completed successfully    INFO

Products API Security Test Suite
    [Documentation]    Execute security validation tests for all Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:168
    ...                Validates security measures, injection protection, and safe handling
    [Tags]    products    suite    security    validation
    # Test security across search and filter operations
    Search Products Should Handle SQL Injection Attempts
    Search Products Should Handle XSS Attempts
    Category Filter Should Handle SQL Injection Attempts
    Category Filter Should Handle XSS Attempts
    Delete Product Should Handle SQL Injection Attempts
    Delete Product Should Handle Path Traversal Attempts
    
    Log    Security test suite completed successfully    INFO

Products API Data Quality Test Suite
    [Documentation]    Execute data quality validation tests across all Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:181
    ...                Validates data integrity, consistency, and quality standards
    [Tags]    products    suite    data-quality    validation
    # Test data quality across all read operations
    Validate All Products Response Structure
    Validate All Products Data Quality
    Validate Product By ID Response Structure    1
    Validate Product By ID Data Quality    1
    Validate Search Results Pagination
    Validate Search Results Product Fields
    Validate Categories Response Structure
    Validate Categories Content
    Validate Products By Category Response Structure
    Validate All Products Belong To Category
    
    # Test data consistency
    Get All Products Multiple Times Should Return Same Count
    Get Same Product Multiple Times Should Return Consistent Data    1
    Search Same Term Multiple Times Should Return Consistent Results
    Get Categories Multiple Times Should Return Same Results
    Get Same Category Multiple Times Should Return Consistent Results
    
    Log    Data quality test suite completed successfully    INFO

# ============================================================================
# Products Test Suite - Specialized Test Categories
# ============================================================================

Products API Boundary Value Test Suite
    [Documentation]    Execute boundary value tests for all Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:205
    ...                Validates handling of boundary conditions and edge values
    [Tags]    products    suite    boundary    validation
    # Test boundary values across operations
    Get All Products With Minimum Limit
    Get All Products With Maximum Limit
    Get All Products With Different Skip Values
    Get Product By Minimum Valid ID    1
    Get Product By Maximum Reasonable ID    100
    Search Products With Single Character
    Search Products With Very Long Term
    Add Product With Valid Price Boundaries
    Update Product With Boundary Values    1
    Delete Product With Boundary ID Values
    
    Log    Boundary value test suite completed successfully    INFO

Products API Edge Case Test Suite
    [Documentation]    Execute edge case tests for all Products API operations  
    ...                Test: tests/api/products/products_test_suite.robot:221
    ...                Validates handling of unusual conditions and special cases
    [Tags]    products    suite    edge-case    validation
    # Test edge cases across operations
    Get All Products With Zero Limit
    Get All Products With Large Skip Value
    Get Product By Zero ID
    Get Product By Negative ID    -1
    Search Products With Special Characters
    Get Products By Invalid Special Characters Category
    Get Products By Numeric Category
    Add Product With Special Characters
    Update Product With Special Characters    1
    Update Product With Empty Data    1
    Delete Same Product Multiple Times    1
    Delete Product With Special Values
    
    Log    Edge case test suite completed successfully    INFO

Products API Cross-Validation Test Suite
    [Documentation]    Execute cross-validation tests between different Products API operations
    ...                Test: tests/api/products/products_test_suite.robot:240
    ...                Validates data consistency and relationships across operations
    [Tags]    products    suite    cross-validation    consistency
    # Cross-validate data across different operations
    Validate Categories Match Products Categories
    Validate Multiple Categories Have Different Products
    Validate Category Products Match Search Results
    
    # Test data relationships
    _Execute Get All Products Request
    ${all_products}=    Set Variable    ${LAST_RESPONSE.json()['products']}
    
    # Validate individual products exist
    FOR    ${product}    IN    @{all_products[:5]}    # Test first 5 products
        Get Product By Valid ID Should Return Product Details    ${product['id']}
        Should Be Equal As Strings    ${LAST_RESPONSE.json()['title']}    ${product['title']}
    END
    
    # Validate categories consistency
    _Execute Get Categories Request
    ${categories}=    Set Variable    ${LAST_RESPONSE.json()}
    
    FOR    ${category}    IN    @{categories[:3]}    # Test first 3 categories
        _Execute Get Products By Category Request    ${category}
        _Validate Products List Response
        ${category_products}=    Set Variable    ${LAST_RESPONSE.json()['products']}
        FOR    ${product}    IN    @{category_products[:2]}    # Test first 2 products in category
            Should Be Equal As Strings    ${product['category']}    ${category}
        END
    END
    
    Log    Cross-validation test suite completed successfully    INFO

# ============================================================================
# Products Test Suite - Final Validation and Reporting
# ============================================================================

Products API Complete Test Suite Validation
    [Documentation]    Final comprehensive validation of the entire Products API test suite
    ...                Test: tests/api/products/products_test_suite.robot:268
    ...                Validates overall system functionality, generates final report
    [Tags]    products    suite    final-validation    comprehensive
    # Execute final comprehensive validations
    
    # 1. Validate all major operations work
    Log    Executing final validation of all major operations    INFO
    
    # Get All Products
    _Execute Get All Products Request
    ${final_all_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    Should Be True    ${final_all_count} > 0
    
    # Get Product By ID
    _Execute Get Product By ID Request    1
    Should Be Equal As Numbers    ${LAST_RESPONSE.json()['id']}    1
    
    # Search Products
    _Execute Search Products Request    phone
    ${final_search_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # Get Categories
    _Execute Get Categories Request
    ${final_categories_count}=    Set Variable    ${LAST_RESPONSE.json().__len__()}
    Should Be True    ${final_categories_count} > 0
    
    # Get Products By Category
    _Execute Get Products By Category Request    smartphones
    ${final_category_products_count}=    Set Variable    ${LAST_RESPONSE.json()['total']}
    
    # CRUD Operations (simulated)
    ${final_product}=    Create Dictionary    title=Final Test Product    price=199.99
    _Execute Add Product Request    ${final_product}
    ${final_add_id}=    Set Variable    ${LAST_RESPONSE.json()['id']}
    
    _Execute Update Product Request    1    ${final_product}
    _Execute Delete Product Request    1
    
    # 2. Generate final test suite report
    ${final_report}=    Create Dictionary
    Set To Dictionary    ${final_report}    total_products    ${final_all_count}
    Set To Dictionary    ${final_report}    search_results    ${final_search_count}
    Set To Dictionary    ${final_report}    categories_count    ${final_categories_count}
    Set To Dictionary    ${final_report}    category_products    ${final_category_products_count}
    Set To Dictionary    ${final_report}    final_created_id    ${final_add_id}
    Set To Dictionary    ${final_report}    test_suite_status    COMPLETED
    
    Log    Products API Test Suite Final Report: ${final_report}    INFO
    Log    All Products API operations validated successfully    INFO
    
    # 3. Validate test environment cleanup
    Cleanup Products Service
    
    Set Suite Variable    ${SUITE_STATUS}    PASSED

*** Keywords ***
# ============================================================================
# Products Test Suite - Setup and Teardown Keywords
# ============================================================================

Initialize Products Test Suite
    [Documentation]    Initialize the Products API test suite with comprehensive setup
    ${start_time}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Set Suite Variable    ${SUITE_START_TIME}    ${start_time}
    
    Log    Starting Products API Test Suite at ${start_time}    INFO
    Log    Test Suite Configuration: ${TEST_CONFIG}    INFO
    
    # Validate test environment
    Should Not Be Empty    ${BASE_URL}
    Should Not Be Empty    ${PRODUCTS_ENDPOINTS}
    
    # Initialize counters
    Set Suite Variable    ${TOTAL_TESTS_RUN}    0
    Set Suite Variable    ${TESTS_PASSED}    0
    Set Suite Variable    ${TESTS_FAILED}    0
    Set Suite Variable    ${SUITE_STATUS}    RUNNING
    
    # Log suite initialization
    Log    Products API Test Suite initialized successfully    INFO

Finalize Products Test Suite
    [Documentation]    Finalize the Products API test suite with comprehensive cleanup and reporting
    ${end_time}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Set Suite Variable    ${SUITE_END_TIME}    ${end_time}
    
    # Calculate suite duration
    ${start_epoch}=    Convert Date    ${SUITE_START_TIME}    result_format=epoch
    ${end_epoch}=    Convert Date    ${SUITE_END_TIME}    result_format=epoch
    ${duration}=    Evaluate    ${end_epoch} - ${start_epoch}
    
    # Generate final suite report
    Log    ================================================================================    INFO
    Log    PRODUCTS API TEST SUITE EXECUTION REPORT                                         INFO
    Log    ================================================================================    INFO
    Log    Suite Start Time: ${SUITE_START_TIME}                                            INFO
    Log    Suite End Time: ${SUITE_END_TIME}                                                INFO
    Log    Total Execution Duration: ${duration} seconds                                    INFO
    Log    Suite Status: ${SUITE_STATUS}                                                    INFO
    Log    ================================================================================    INFO
    
    # Log test coverage summary
    Log    TEST COVERAGE SUMMARY:                                                           INFO
    Log    - UC-PROD-001: Get All Products (pagination, sorting, validation)               INFO
    Log    - UC-PROD-002: Get Product By ID (success, errors, validation)                  INFO
    Log    - UC-PROD-003: Search Products (terms, filters, performance)                    INFO
    Log    - UC-PROD-004: Get Categories (structure, validation, consistency)              INFO
    Log    - UC-PROD-005: Get Products By Category (filtering, validation)                 INFO
    Log    - UC-PROD-006: Add Product (CRUD simulation, validation)                        INFO
    Log    - UC-PROD-007: Update Product (CRUD simulation, validation)                     INFO
    Log    - UC-PROD-008: Delete Product (CRUD simulation, validation)                     INFO
    Log    ================================================================================    INFO
    
    # Cleanup test environment
    Log    Cleaning up Products API test environment                                        INFO
    
    Log    Products API Test Suite finalized successfully                                   INFO