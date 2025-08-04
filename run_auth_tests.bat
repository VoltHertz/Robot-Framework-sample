@echo off
REM Authentication Tests Execution Script (Windows Batch)
REM File: run_auth_tests.bat
REM
REM This batch script executes the authentication test suite with dynamic results folder

echo ================================================================================
echo Authentication Test Suite Execution
echo Design Patterns ROBOT - DummyJSON Auth API Tests  
echo ================================================================================

REM Change to script directory
cd /d "%~dp0"

REM Execute Python script
python run_auth_tests.py %*

REM Pause to see results (only if run directly, not from command line with params)
if "%1"=="" pause

exit /b %ERRORLEVEL%