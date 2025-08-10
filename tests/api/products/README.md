# Products API Test Suite - DummyJSON API

## Overview
Complete test implementation for DummyJSON Products API following Design Patterns principles and covering all use cases defined in `Documentation/Use_Cases/Products_Use_Cases.md`.

## Test Coverage

### Use Cases Implemented:
- **UC-PROD-001**: Get All Products (Pagination, Sorting, Filtering) - 15+ test cases
- **UC-PROD-002**: Get Product By ID (Success and Error scenarios) - 18+ test cases  
- **UC-PROD-003**: Search Products (Multiple criteria and Edge cases) - 22+ test cases
- **UC-PROD-004**: Get Categories (Structure validation and Consistency) - 15+ test cases
- **UC-PROD-005**: Get Products By Category (Filtering and Data quality) - 20+ test cases
- **UC-PROD-006**: Add Product - Simulated (Data validation and Creation) - 18+ test cases
- **UC-PROD-007**: Update Product - Simulated (PATCH operations and Validation) - 25+ test cases
- **UC-PROD-008**: Delete Product - Simulated (Deletion confirmation and Validation) - 22+ test cases

**Total: 155+ comprehensive test cases covering all scenarios**

### Design Patterns Applied:
- **Library-Keyword Pattern**: Implemented in `resources/apis/products_service.resource`
- **Data Organization**: Structured test data in `data/testdata/products_api/`
- **DRY Principle**: Reusable keywords and validation methods
- **Facade Pattern**: High-level business keywords for complex operations

## Test Files Structure

```
tests/api/products/
├── products_get_all_tests.robot       # UC-PROD-001 - Get all products with pagination
├── products_get_by_id_tests.robot     # UC-PROD-002 - Get individual products
├── products_search_tests.robot        # UC-PROD-003 - Search functionality
├── products_categories_tests.robot    # UC-PROD-004 - Categories functionality
├── products_by_category_tests.robot   # UC-PROD-005 - Products by category
├── products_add_tests.robot           # UC-PROD-006 - Add new products (simulated)
├── products_update_tests.robot        # UC-PROD-007 - Update products (simulated)
├── products_delete_tests.robot        # UC-PROD-008 - Delete products (simulated)
├── products_test_suite.robot          # Main suite runner with comprehensive tests
└── README.md                          # This file
```

## Execution Methods

### 1. Recommended Method - Execution Scripts

#### Interactive Mode:
```bash
# Python Script (Cross-platform)
python run_products_tests.py

# Windows Batch
run_products_tests.bat

# PowerShell
.\run_products_tests.ps1
```

#### Direct Execution with Parameters:
```bash
# All tests
python run_products_tests.py 1

# Specific test suites
python run_products_tests.py 2    # Get all products tests
python run_products_tests.py 3    # Get by ID tests
python run_products_tests.py 4    # Search tests
python run_products_tests.py 5    # Categories tests
python run_products_tests.py 6    # Products by category tests
python run_products_tests.py 7    # Add product tests
python run_products_tests.py 8    # Update product tests
python run_products_tests.py 9    # Delete product tests

# By test categories
python run_products_tests.py 10   # Smoke tests only
python run_products_tests.py 11   # Error tests only
python run_products_tests.py 12   # Success tests only
python run_products_tests.py 13   # Simulated tests only
python run_products_tests.py 14   # CRUD operations only
python run_products_tests.py 15   # Performance tests only
```

#### Available Execution Modes:
1. **All Products Tests** - Complete test suite execution (8 UC suites)
2. **Get All Products Tests Only** - UC-PROD-001 scenarios
3. **Get Product By ID Tests Only** - UC-PROD-002 scenarios
4. **Search Products Tests Only** - UC-PROD-003 scenarios
5. **Categories Tests Only** - UC-PROD-004 scenarios
6. **Products By Category Tests Only** - UC-PROD-005 scenarios
7. **Add Product Tests Only** - UC-PROD-006 scenarios
8. **Update Product Tests Only** - UC-PROD-007 scenarios
9. **Delete Product Tests Only** - UC-PROD-008 scenarios
10. **Smoke Tests Only** - Essential functionality verification
11. **Error Tests Only** - Error handling and validation
12. **Success Tests Only** - Positive scenario validation
13. **Simulated Tests Only** - Mock operations (Add/Update/Delete)
14. **CRUD Operations Only** - Create, Read, Update, Delete tests
15. **Performance Tests Only** - Response time and benchmark validation

### 2. Direct Robot Framework Execution

```bash
# All products tests
python -m robot --outputdir results/api/products_api/manual tests/api/products/

# Specific test files
python -m robot --outputdir results/api/products_api/manual tests/api/products/products_get_all_tests.robot

# By tags
python -m robot --outputdir results/api/products_api/manual --include smoke tests/api/products/
python -m robot --outputdir results/api/products_api/manual --include error tests/api/products/
python -m robot --outputdir results/api/products_api/manual --include simulated tests/api/products/

# Suite runner only
python -m robot --outputdir results/api/products_api/manual tests/api/products/products_test_suite.robot
```

## Results Organization

### Dynamic Results Folders:
- **Location**: `results/api/products_api/[YYYYMMDD_HHMMSS]/`
- **Automatic**: Each execution creates unique timestamped folder
- **Never Overwrites**: Previous execution results are preserved

### Generated Reports:
- **log.html** - Detailed execution log with step-by-step results
- **report.html** - Summary report with statistics and test results  
- **output.xml** - Raw XML data for further processing/CI integration

## Test Scenarios Coverage

### Success Scenarios:
- ✅ Retrieve all products with different pagination settings
- ✅ Get individual products by valid IDs
- ✅ Search products with various criteria and filters
- ✅ Get complete categories list with validation
- ✅ Filter products by specific categories
- ✅ Add new products with valid data (simulated)
- ✅ Update existing products with various data (simulated)
- ✅ Delete products with confirmation (simulated)

### Error Scenarios:
- ✅ Non-existent product IDs
- ✅ Invalid search parameters and edge cases
- ✅ Invalid category filters
- ✅ Boundary value validation
- ✅ Empty and null value handling
- ✅ Security validation (SQL injection, XSS protection)

### Edge Cases:
- ✅ Special characters in search terms
- ✅ Large data sets and pagination limits
- ✅ Performance validation and response times
- ✅ Data consistency across operations
- ✅ Cross-validation between different endpoints

### Advanced Scenarios:
- ✅ Complete CRUD lifecycle simulation
- ✅ Data integrity verification
- ✅ Multi-field updates and validations
- ✅ Boundary value testing for all operations
- ✅ Load testing with sequential operations

## Prerequisites

### Dependencies (from root requirements.txt):
- Robot Framework 7.0+
- RequestsLibrary 0.9.7+
- JSONLibrary 0.5.0+
- Collections (built-in)
- Python 3.8+

### API Access:
- **Base URL**: https://dummyjson.com
- **Documentation**: https://dummyjson.com/docs/products
- **No Authentication Required** for read operations
- **Simulated Operations** for write operations (Add/Update/Delete)

## Validation and Health Checks

### Connectivity Test:
```bash
python run_products_tests.py 10  # Smoke tests
```

### Data Integrity Test:
```bash
python -m robot --outputdir results/api/products_api/manual --test "Products API Complete Test Suite Validation" tests/api/products/products_test_suite.robot
```

### Performance Baseline:
```bash
python -m robot --outputdir results/api/products_api/manual --test "Products API Performance Test Suite" tests/api/products/products_test_suite.robot
```

### Cross-Validation Test:
```bash
python -m robot --outputdir results/api/products_api/manual --test "Products API Cross-Validation Test Suite" tests/api/products/products_test_suite.robot
```

## Troubleshooting

### Common Issues:
1. **Connection Errors**: Check internet connectivity and API availability
2. **Import Errors**: Ensure all dependencies are installed (`pip install -r requirements.txt`)
3. **Path Issues**: Run scripts from project root directory
4. **Permission Errors**: Ensure write permissions for results directory

### Debug Mode:
```bash
# Enable verbose logging
python -m robot --outputdir results/api/products_api/debug --loglevel DEBUG tests/api/products/

# Single test debug
python -m robot --outputdir results/api/products_api/debug --test "Get All Products Default Should Return Products List" tests/api/products/products_get_all_tests.robot
```

### Test Data Verification:
```bash
# Verify test data accessibility
python -m robot --outputdir results/api/products_api/verify --test "Products API Test Suite Health Check" tests/api/products/products_test_suite.robot
```

## Integration with CI/CD

The test suite is designed for CI/CD integration:

- **Exit Codes**: Scripts return appropriate exit codes for CI/CD decisions
- **XML Output**: Generates standard Robot Framework XML for parsing
- **Parallel Execution Ready**: Tests are independent and can run in parallel
- **Environment Agnostic**: Works across different platforms and environments

Example CI/CD usage:
```yaml
# Example GitHub Actions step
- name: Run Products API Tests
  run: python run_products_tests.py 10  # Smoke tests
  
- name: Upload Test Results
  uses: actions/upload-artifact@v3
  with:
    name: products-api-test-results
    path: results/api/products_api/
```

## API Endpoints Covered

### Read Operations:
- `GET /products` - Retrieve all products with pagination
- `GET /products/{id}` - Get specific product by ID
- `GET /products/search` - Search products by query
- `GET /products/categories` - Get all product categories
- `GET /products/category/{category}` - Get products by category

### Write Operations (Simulated):
- `POST /products/add` - Add new product (returns simulated response)
- `PUT /products/{id}` - Update product (returns simulated response)
- `DELETE /products/{id}` - Delete product (returns simulated response)

## Test Suite Architecture

### Service Objects (Library-Keyword Pattern):
- **Business Logic Keywords**: High-level operations (UC-PROD-001 through UC-PROD-008)
- **Technical Keywords**: Low-level API operations and validations
- **Validation Keywords**: Comprehensive response and data validation
- **Utility Keywords**: Helper functions for data manipulation

### Data Management:
- **Valid Products**: `data/testdata/products_api/valid_products.json`
- **Invalid Products**: `data/testdata/products_api/invalid_products.json`
- **Endpoints Config**: `data/testdata/products_api/products_endpoints.json`

This test suite provides comprehensive coverage of the DummyJSON Products API following industry best practices and design patterns, ensuring robust validation of all product-related operations.