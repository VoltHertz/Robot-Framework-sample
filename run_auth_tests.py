#!/usr/bin/env python3
"""
Authentication Tests Execution Script
File: run_auth_tests.py

This script executes the authentication test suite and organizes results in dynamic date-time folders
following the project structure: results/api/auth_api/[dynamic_date_time_folder]
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
    results_path = base_path / "results" / "api" / "auth_api" / timestamp
    
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
        cmd.append("tests/api/auth")
    
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
    print("Authentication Test Suite Execution")
    print("Design Patterns ROBOT - DummyJSON Auth API Tests")
    print("=" * 80)
    
    # Create results directory
    results_path, timestamp = create_results_directory()
    print(f"Results will be saved to: {results_path}")
    
    # Available execution modes
    execution_modes = {
        "1": ("All Auth Tests", "tests/api/auth", None, None),
        "2": ("Login Tests Only", "tests/api/auth/auth_login_tests.robot", None, None),
        "3": ("User Info Tests Only", "tests/api/auth/auth_user_info_tests.robot", None, None),
        "4": ("Token Refresh Tests Only", "tests/api/auth/auth_refresh_token_tests.robot", None, None),
        "5": ("Integration Tests Only", "tests/api/auth/auth_integration_tests.robot", None, None),
        "6": ("Smoke Tests Only", "tests/api/auth", None, ["smoke"]),
        "7": ("Error Tests Only", "tests/api/auth", None, ["error"]),
        "8": ("Success Tests Only", "tests/api/auth", None, ["success"]),
        "9": ("Connectivity Test Only", "tests/api/auth/auth_test_suite.robot", "Authentication Service Connectivity Test", None),
        "10": ("Single Login Test", "tests/api/auth/auth_login_tests.robot", "Successful Login With Valid Credentials - Emily", None)
    }
    
    # Check if command line arguments provided
    if len(sys.argv) > 1:
        mode = sys.argv[1]
    else:
        # Interactive mode selection
        print("\nSelect execution mode:")
        for key, (description, _, _, _) in execution_modes.items():
            print(f"{key}. {description}")
        
        mode = input("\nEnter mode (1-10): ").strip()
    
    # Validate mode
    if mode not in execution_modes:
        print(f"Invalid mode: {mode}")
        print("Valid modes: 1-10")
        return False
    
    # Get execution parameters
    description, test_path, test_name, include_tags = execution_modes[mode]
    
    print(f"\nExecuting: {description}")
    print(f"Test path: {test_path}")
    if test_name:
        print(f"Test name: {test_name}")
    if include_tags:
        print(f"Include tags: {include_tags}")
    
    # Execute tests
    success = run_robot_tests(
        test_path=test_path,
        output_dir=results_path,
        test_name=test_name,
        include_tags=include_tags
    )
    
    print("\n" + "=" * 80)
    if success:
        print("[SUCCESS] Tests executed successfully!")
    else:
        print("[FAILED] Tests execution failed!")
    
    print(f"Results location: {results_path}")
    print(f"Check log.html and report.html in the results folder")
    print("=" * 80)
    
    return success

if __name__ == "__main__":
    main()