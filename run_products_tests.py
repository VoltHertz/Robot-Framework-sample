#!/usr/bin/env python3
"""
Products API Tests Execution Script
File: run_products_tests.py

This script executes the products API test suite and organizes results in dynamic date-time folders
following the project structure: results/api/products_api/[dynamic_date_time_folder]
"""

import os
import sys
import subprocess
from datetime import datetime
from pathlib import Path

def create_results_directory():
    """Create dynamic results directory with current date-time"""
    # Get current timestamp for folder name
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Create results path
    base_path = Path(__file__).parent
    results_path = base_path / "results" / "api" / "products_api" / timestamp
    
    # Create directory if it doesn't exist
    results_path.mkdir(parents=True, exist_ok=True)
    
    return results_path, timestamp

def run_robot_tests(test_path=None, output_dir=None, test_name=None, tags=None, include_tags=None, exclude_tags=None):
    """Execute Robot Framework tests with specified parameters"""
    
    # Base command
    cmd = [sys.executable, "-m", "robot"]
    
    # Add output directory
    if output_dir:
        cmd.extend(["--outputdir", str(output_dir)])
    
    # Add test selection
    if test_name:
        cmd.extend(["--test", test_name])
    
    # Add tag filtering
    if include_tags:
        for tag in include_tags:
            cmd.extend(["--include", tag])
    
    if exclude_tags:
        for tag in exclude_tags:
            cmd.extend(["--exclude", tag])
    
    # Add test path
    if test_path:
        cmd.append(test_path)
    else:
        cmd.append("tests/api/products/")
    
    print(f"Executing command: {' '.join(cmd)}")
    print("=" * 80)
    
    # Execute the command
    try:
        result = subprocess.run(cmd, capture_output=False, text=True)
        return result.returncode == 0
    except Exception as e:
        print(f"Error executing tests: {e}")
        return False

def show_menu():
    """Display execution options menu"""
    print("\n" + "=" * 80)
    print("PRODUCTS API TEST SUITE - EXECUTION MENU")
    print("=" * 80)
    print("1.  Execute ALL Products API tests")
    print("2.  Execute Get All Products tests only")
    print("3.  Execute Get Product By ID tests only")
    print("4.  Execute Search Products tests only")
    print("5.  Execute Categories tests only")
    print("6.  Execute Products By Category tests only")
    print("7.  Execute Add Product tests only")
    print("8.  Execute Update Product tests only")
    print("9.  Execute Delete Product tests only")
    print("10. Execute SMOKE tests only (quick validation)")
    print("11. Execute ERROR tests only (error scenarios)")
    print("12. Execute VALIDATION tests only (response validation)")
    print("13. Execute SIMULATED tests only (CRUD operations)")
    print("14. Execute EDGE-CASE tests only")
    print("15. Execute PERFORMANCE tests only")
    print("16. Execute SECURITY tests only")
    print("17. Execute INTEGRATION tests only")
    print("18. Execute BUSINESS-LOGIC tests only")
    print("19. Execute by custom TAG (user input)")
    print("20. Execute specific TEST by name (user input)")
    print("\n0.  Exit")
    print("=" * 80)

def get_test_configuration(option):
    """Get test configuration based on selected option"""
    configurations = {
        "1": {
            "description": "All Products API Tests",
            "test_path": "tests/api/products/",
            "include_tags": None,
            "exclude_tags": None
        },
        "2": {
            "description": "Get All Products Tests",
            "test_path": "tests/api/products/products_get_all_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "3": {
            "description": "Get Product By ID Tests",
            "test_path": "tests/api/products/products_get_by_id_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "4": {
            "description": "Search Products Tests",
            "test_path": "tests/api/products/products_search_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "5": {
            "description": "Categories Tests",
            "test_path": "tests/api/products/products_categories_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "6": {
            "description": "Products By Category Tests",
            "test_path": "tests/api/products/products_by_category_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "7": {
            "description": "Add Product Tests",
            "test_path": "tests/api/products/products_add_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "8": {
            "description": "Update Product Tests",
            "test_path": "tests/api/products/products_update_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "9": {
            "description": "Delete Product Tests",
            "test_path": "tests/api/products/products_delete_tests.robot",
            "include_tags": None,
            "exclude_tags": None
        },
        "10": {
            "description": "Smoke Tests (Quick Validation)",
            "test_path": "tests/api/products/",
            "include_tags": ["smoke"],
            "exclude_tags": None
        },
        "11": {
            "description": "Error Tests (Error Scenarios)",
            "test_path": "tests/api/products/",
            "include_tags": ["error"],
            "exclude_tags": None
        },
        "12": {
            "description": "Validation Tests (Response Validation)",
            "test_path": "tests/api/products/",
            "include_tags": ["validation"],
            "exclude_tags": None
        },
        "13": {
            "description": "Simulated Tests (CRUD Operations)",
            "test_path": "tests/api/products/",
            "include_tags": ["simulated"],
            "exclude_tags": None
        },
        "14": {
            "description": "Edge Case Tests",
            "test_path": "tests/api/products/",
            "include_tags": ["edge-case"],
            "exclude_tags": None
        },
        "15": {
            "description": "Performance Tests",
            "test_path": "tests/api/products/",
            "include_tags": ["performance"],
            "exclude_tags": None
        },
        "16": {
            "description": "Security Tests",
            "test_path": "tests/api/products/",
            "include_tags": ["security"],
            "exclude_tags": None
        },
        "17": {
            "description": "Integration Tests",
            "test_path": "tests/api/products/",
            "include_tags": ["integration"],
            "exclude_tags": None
        },
        "18": {
            "description": "Business Logic Tests",
            "test_path": "tests/api/products/",
            "include_tags": ["business-logic"],
            "exclude_tags": None
        }
    }
    
    return configurations.get(option, None)

def main():
    """Main execution function"""
    print("\nProducts API Test Suite Execution Script")
    print(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Check if option provided as command line argument
    if len(sys.argv) > 1:
        option = sys.argv[1]
        if option == "0":
            print("Exiting...")
            return
    else:
        # Show interactive menu
        while True:
            show_menu()
            option = input("Select option (0-20): ").strip()
            
            if option == "0":
                print("Exiting...")
                return
            
            if option in [str(i) for i in range(1, 21)]:
                break
            else:
                print("Invalid option. Please select 0-20.")
                continue
    
    # Handle custom options
    if option == "19":
        custom_tag = input("Enter custom tag to filter by: ").strip()
        if not custom_tag:
            print("No tag provided. Exiting...")
            return
        config = {
            "description": f"Custom Tag Tests ({custom_tag})",
            "test_path": "tests/api/products/",
            "include_tags": [custom_tag],
            "exclude_tags": None
        }
    elif option == "20":
        test_name = input("Enter specific test name: ").strip()
        if not test_name:
            print("No test name provided. Exiting...")
            return
        config = {
            "description": f"Specific Test ({test_name})",
            "test_path": "tests/api/products/",
            "test_name": test_name,
            "include_tags": None,
            "exclude_tags": None
        }
    else:
        # Get predefined configuration
        config = get_test_configuration(option)
        if not config:
            print(f"Invalid option: {option}")
            return
    
    # Create results directory
    results_dir, timestamp = create_results_directory()
    
    print(f"\nExecuting: {config['description']}")
    print(f"Results will be saved to: {results_dir}")
    print(f"Timestamp: {timestamp}")
    print("=" * 80)
    
    # Execute tests
    success = run_robot_tests(
        test_path=config["test_path"],
        output_dir=results_dir,
        test_name=config.get("test_name"),
        include_tags=config.get("include_tags"),
        exclude_tags=config.get("exclude_tags")
    )
    
    print("=" * 80)
    if success:
        print("✅ Test execution completed successfully!")
    else:
        print("❌ Test execution completed with issues!")
    
    print(f"📁 Results location: {results_dir}")
    print(f"📊 Report files: log.html, report.html, output.xml")
    print("=" * 80)

if __name__ == "__main__":
    main()