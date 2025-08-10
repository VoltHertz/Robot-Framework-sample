@echo off
REM Products API Tests Execution Script - Windows Batch
REM File: run_products_tests.bat
REM 
REM This batch script executes the products API test suite with dynamic results organization
REM Usage: run_products_tests.bat [option_number]
REM Example: run_products_tests.bat 10

echo ================================================================================
echo PRODUCTS API TEST SUITE - WINDOWS BATCH EXECUTION
echo ================================================================================
echo Timestamp: %date% %time%
echo.

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python and try again.
    pause
    exit /b 1
)

REM Check if option provided as argument
if "%~1"=="" (
    echo Interactive mode - calling Python script without arguments
    python run_products_tests.py
) else (
    echo Direct execution mode with option: %~1
    python run_products_tests.py %~1
)

echo.
echo ================================================================================
echo Products API test execution completed
echo ================================================================================
pause