@echo off
REM Users API Tests Execution Script (Windows Batch)
REM File: run_users_tests.bat
REM
REM This batch script executes the users API test suite with dynamic results folder

echo ================================================================================
echo Users API Test Suite Execution
echo Design Patterns ROBOT - DummyJSON Users API Tests  
echo ================================================================================

REM Change to script directory
cd /d "%~dp0"

REM Execute Python script
python run_users_tests.py %*

REM Pause to see results (only if run directly, not from command line with params)
if "%1"=="" pause

exit /b %ERRORLEVEL%