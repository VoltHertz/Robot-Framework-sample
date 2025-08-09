#!/usr/bin/env python3
"""
Users API Tests Execution Script
File: run_users_tests.py

This script executes the users API test suite and organizes results in dynamic date-time folders
following the project structure: results/api/users_api/[dynamic_date_time_folder]
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
    results_path = base_path / "results" / "api" / "users_api" / timestamp
    
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
        cmd.append(str(test_path))
    else:
        cmd.append("tests/api/users")
    
    print(f"Executing command: {' '.join(cmd)}")
    print(f"Working directory: {os.getcwd()}")
    
    # Execute command
    try:
        result = subprocess.run(cmd, capture_output=False, text=True)
        return result.returncode == 0
    except Exception as e:
        print(f"Error executing tests: {e}")
        return False

def main():
    """Main execution function"""
    print("=" * 80)
    print("Users API Test Suite Execution")
    print("Design Patterns ROBOT - DummyJSON Users API Tests")
    print("=" * 80)
    
    # Create results directory
    results_path, timestamp = create_results_directory()
    print(f"Results will be saved to: {results_path}")
    
    # Available execution modes
    execution_modes = {
        "1": ("All Users Tests", "tests/api/users", None, None),
        "2": ("Login Tests Only", "tests/api/users/users_login_tests.robot", None, None),
        "3": ("Get All Users Tests Only", "tests/api/users/users_get_all_tests.robot", None, None),
        "4": ("Get User By ID Tests Only", "tests/api/users/users_get_by_id_tests.robot", None, None),
        "5": ("Search Users Tests Only", "tests/api/users/users_search_tests.robot", None, None),
        "6": ("Add User Tests Only", "tests/api/users/users_add_tests.robot", None, None),
        "7": ("Update User Tests Only", "tests/api/users/users_update_tests.robot", None, None),
        "8": ("Delete User Tests Only", "tests/api/users/users_delete_tests.robot", None, None),
        "9": ("Smoke Tests Only", "tests/api/users", None, ["smoke"]),
        "10": ("Error Tests Only", "tests/api/users", None, ["error"]),
        "11": ("Success Tests Only", "tests/api/users", None, ["success"]),
        "12": ("Simulated Tests Only", "tests/api/users", None, ["simulated"]),
        "13": ("CRUD Operations Only", "tests/api/users", None, ["add-user", "update-user", "delete-user"]),
        "14": ("Single Login Test", "tests/api/users/users_login_tests.robot", "Admin User Emily Can Login Successfully", None)
    }
    
    # Check if command line arguments provided
    if len(sys.argv) > 1:
        mode = sys.argv[1]
    else:
        # Interactive mode selection
        print("\nAvailable execution modes:")
        print("-" * 50)
        for key, (name, _, _, _) in execution_modes.items():
            print(f"{key:2s}. {name}")
        print("-" * 50)
        
        mode = input("Select execution mode (1-14): ").strip()
    
    # Validate mode selection
    if mode not in execution_modes:
        print(f"Invalid mode selection: {mode}")
        print("Available modes: 1-14")
        return False
    
    # Get execution configuration
    description, test_path, test_name, tags = execution_modes[mode]
    
    print(f"\nExecuting: {description}")
    print(f"Test Path: {test_path}")
    if test_name:
        print(f"Specific Test: {test_name}")
    if tags:
        print(f"Tags: {', '.join(tags)}")
    print(f"Output Directory: {results_path}")
    print("-" * 80)
    
    # Execute tests
    success = run_robot_tests(
        test_path=test_path,
        output_dir=results_path,
        test_name=test_name,
        include_tags=tags
    )
    
    print("-" * 80)
    if success:
        print("✅ Tests completed successfully!")
    else:
        print("❌ Tests completed with errors!")
    
    print(f"📁 Results saved to: {results_path}")
    print(f"📊 Reports available:")
    print(f"   - Log: {results_path}/log.html")
    print(f"   - Report: {results_path}/report.html") 
    print(f"   - Output: {results_path}/output.xml")
    print("=" * 80)
    
    return success

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n⚠️  Execution interrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        sys.exit(1)