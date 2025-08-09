# Users API Tests Execution Script (PowerShell)
# File: run_users_tests.ps1
#
# This PowerShell script executes the users API test suite with dynamic results folder

param(
    [string]$Mode = "",
    [string]$TestPath = "",
    [switch]$Help
)

function Show-Help {
    Write-Host "Users API Test Suite Execution" -ForegroundColor Green
    Write-Host "==============================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\run_users_tests.ps1 [mode]"
    Write-Host ""
    Write-Host "Modes:"
    Write-Host "  1  - All Users Tests"
    Write-Host "  2  - Login Tests Only"
    Write-Host "  3  - Get All Users Tests Only"
    Write-Host "  4  - Get User By ID Tests Only"
    Write-Host "  5  - Search Users Tests Only"
    Write-Host "  6  - Add User Tests Only"
    Write-Host "  7  - Update User Tests Only"
    Write-Host "  8  - Delete User Tests Only"
    Write-Host "  9  - Smoke Tests Only"
    Write-Host "  10 - Error Tests Only"
    Write-Host "  11 - Success Tests Only"
    Write-Host "  12 - Simulated Tests Only"
    Write-Host "  13 - CRUD Operations Only"
    Write-Host "  14 - Single Login Test"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\run_users_tests.ps1        # Interactive mode"
    Write-Host "  .\run_users_tests.ps1 1      # Run all tests"
    Write-Host "  .\run_users_tests.ps1 9      # Run smoke tests only"
    Write-Host "  .\run_users_tests.ps1 12     # Run simulated tests only"
    Write-Host ""
}

function Create-ResultsDirectory {
    # Get current timestamp for folder name
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    # Create results path
    $resultsPath = Join-Path $PSScriptRoot "results\api\users_api\$timestamp"
    
    # Create directory if it doesn't exist
    if (!(Test-Path $resultsPath)) {
        New-Item -ItemType Directory -Path $resultsPath -Force | Out-Null
    }
    
    return $resultsPath, $timestamp
}

function Execute-RobotTests {
    param(
        [string]$TestPath,
        [string]$OutputDir,
        [string]$TestName = "",
        [array]$IncludeTags = @(),
        [array]$ExcludeTags = @()
    )
    
    # Build Robot Framework command
    $cmd = @("python", "-m", "robot")
    
    # Add output directory
    if ($OutputDir) {
        $cmd += "--outputdir", $OutputDir
    }
    
    # Add specific test
    if ($TestName) {
        $cmd += "--test", $TestName
    }
    
    # Add include tags
    foreach ($tag in $IncludeTags) {
        $cmd += "--include", $tag
    }
    
    # Add exclude tags
    foreach ($tag in $ExcludeTags) {
        $cmd += "--exclude", $tag
    }
    
    # Add test path
    if ($TestPath) {
        $cmd += $TestPath
    } else {
        $cmd += "tests\api\users"
    }
    
    Write-Host "Executing command: $($cmd -join ' ')" -ForegroundColor Yellow
    Write-Host "Working directory: $(Get-Location)" -ForegroundColor Yellow
    Write-Host ""
    
    # Execute command
    try {
        $process = Start-Process -FilePath "python" -ArgumentList ($cmd | Select-Object -Skip 1) -Wait -PassThru -NoNewWindow
        return $process.ExitCode -eq 0
    }
    catch {
        Write-Host "Error executing tests: $_" -ForegroundColor Red
        return $false
    }
}

# Show help if requested
if ($Help) {
    Show-Help
    exit 0
}

# Main execution
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "Users API Test Suite Execution" -ForegroundColor Cyan
Write-Host "Design Patterns ROBOT - DummyJSON Users API Tests" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

# Create results directory
$resultsPath, $timestamp = Create-ResultsDirectory
Write-Host "Results will be saved to: $resultsPath" -ForegroundColor Green
Write-Host ""

# Available execution modes
$executionModes = @{
    "1" = @("All Users Tests", "tests\api\users", "", @())
    "2" = @("Login Tests Only", "tests\api\users\users_login_tests.robot", "", @())
    "3" = @("Get All Users Tests Only", "tests\api\users\users_get_all_tests.robot", "", @())
    "4" = @("Get User By ID Tests Only", "tests\api\users\users_get_by_id_tests.robot", "", @())
    "5" = @("Search Users Tests Only", "tests\api\users\users_search_tests.robot", "", @())
    "6" = @("Add User Tests Only", "tests\api\users\users_add_tests.robot", "", @())
    "7" = @("Update User Tests Only", "tests\api\users\users_update_tests.robot", "", @())
    "8" = @("Delete User Tests Only", "tests\api\users\users_delete_tests.robot", "", @())
    "9" = @("Smoke Tests Only", "tests\api\users", "", @("smoke"))
    "10" = @("Error Tests Only", "tests\api\users", "", @("error"))
    "11" = @("Success Tests Only", "tests\api\users", "", @("success"))
    "12" = @("Simulated Tests Only", "tests\api\users", "", @("simulated"))
    "13" = @("CRUD Operations Only", "tests\api\users", "", @("add-user", "update-user", "delete-user"))
    "14" = @("Single Login Test", "tests\api\users\users_login_tests.robot", "Admin User Emily Can Login Successfully", @())
}

# Get mode selection
if (-not $Mode) {
    Write-Host "Available execution modes:" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------" -ForegroundColor Yellow
    foreach ($key in $executionModes.Keys | Sort-Object {[int]$_}) {
        $description = $executionModes[$key][0]
        Write-Host ("{0,2}. {1}" -f $key, $description)
    }
    Write-Host "--------------------------------------------------" -ForegroundColor Yellow
    Write-Host ""
    
    $Mode = Read-Host "Select execution mode (1-14)"
}

# Validate mode selection
if (-not $executionModes.ContainsKey($Mode)) {
    Write-Host "Invalid mode selection: $Mode" -ForegroundColor Red
    Write-Host "Available modes: 1-14" -ForegroundColor Red
    exit 1
}

# Get execution configuration
$description, $testPath, $testName, $tags = $executionModes[$Mode]

Write-Host "Executing: $description" -ForegroundColor Green
Write-Host "Test Path: $testPath" -ForegroundColor White
if ($testName) {
    Write-Host "Specific Test: $testName" -ForegroundColor White
}
if ($tags.Count -gt 0) {
    Write-Host "Tags: $($tags -join ', ')" -ForegroundColor White
}
Write-Host "Output Directory: $resultsPath" -ForegroundColor White
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# Execute tests
$success = Execute-RobotTests -TestPath $testPath -OutputDir $resultsPath -TestName $testName -IncludeTags $tags

# Display results
Write-Host ""
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Cyan
if ($success) {
    Write-Host "✅ Tests completed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Tests completed with errors!" -ForegroundColor Red
}

Write-Host ""
Write-Host "📁 Results saved to: $resultsPath" -ForegroundColor Yellow
Write-Host "📊 Reports available:" -ForegroundColor Yellow
Write-Host "   - Log: $resultsPath\log.html" -ForegroundColor White
Write-Host "   - Report: $resultsPath\report.html" -ForegroundColor White
Write-Host "   - Output: $resultsPath\output.xml" -ForegroundColor White
Write-Host "================================================================================" -ForegroundColor Cyan

# Exit with appropriate code
exit $(if ($success) { 0 } else { 1 })