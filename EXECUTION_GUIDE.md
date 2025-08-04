# Authentication Test Suite - Execution Guide

## Overview
This guide provides complete instructions for executing the DummyJSON Authentication API test suite with organized results output.

## Quick Start

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Run Tests (Recommended Method)
```bash
# Interactive mode - choose from menu
python run_auth_tests.py

# Or direct execution
python run_auth_tests.py 1    # Run all tests
```

### 3. Check Results
Results are automatically saved to: `results/api/auth_api/[YYYYMMDD_HHMMSS]/`

## Execution Options

| Mode | Description | Command |
|------|-------------|---------|
| 1 | All Auth Tests | `python run_auth_tests.py 1` |
| 2 | Login Tests Only | `python run_auth_tests.py 2` |
| 3 | User Info Tests Only | `python run_auth_tests.py 3` |
| 4 | Token Refresh Tests Only | `python run_auth_tests.py 4` |
| 5 | Integration Tests Only | `python run_auth_tests.py 5` |
| 6 | Smoke Tests Only | `python run_auth_tests.py 6` |
| 7 | Error Tests Only | `python run_auth_tests.py 7` |
| 8 | Success Tests Only | `python run_auth_tests.py 8` |
| 9 | Connectivity Test Only | `python run_auth_tests.py 9` |
| 10 | Single Login Test | `python run_auth_tests.py 10` |

## Alternative Execution Methods

### Windows Batch Script
```cmd
run_auth_tests.bat 1
```

### PowerShell Script
```powershell
.\run_auth_tests.ps1 1
```

### Direct Robot Framework
```bash
# Manual execution with timestamp
python -m robot --outputdir results/api/auth_api/$(date +%Y%m%d_%H%M%S) tests/api/auth/
```

## Results Structure

```
results/
└── api/
    └── auth_api/
        ├── 20250804_145615/    # First execution
        │   ├── log.html
        │   ├── report.html
        │   └── output.xml
        └── 20250804_150245/    # Second execution
            ├── log.html
            ├── report.html
            └── output.xml
```

## Test Coverage Summary

- ✅ **UC-AUTH-001**: User Login (8 test cases)
- ✅ **UC-AUTH-002**: Get User Info (4 test cases)  
- ✅ **UC-AUTH-003**: Token Refresh (4 test cases)
- ✅ **Integration**: End-to-end workflows (4 test cases)
- ✅ **Total**: 20+ comprehensive test cases

## Success Criteria

All executions should result in:
- Dynamic timestamped results folders
- Comprehensive HTML reports with detailed logs
- XML output for CI/CD integration
- 100% test pass rate for functional tests
- Proper error handling validation

## Troubleshooting

### Common Issues
1. **Import Errors**: Ensure `pip install -r requirements.txt` was run
2. **Network Issues**: Check internet connectivity to `https://dummyjson.com`
3. **Permission Issues**: Ensure write permissions to `results/` directory

### Execution Logs
Check the generated `log.html` file in the results folder for detailed execution information and any error messages.

This execution system ensures organized, timestamped results that never overwrite previous test runs.