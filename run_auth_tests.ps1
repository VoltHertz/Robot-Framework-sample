# Authentication Tests Execution Script (PowerShell)
# File: run_auth_tests.ps1
#
# This PowerShell script executes the authentication test suite with dynamic results folder

param(
    [string]$Mode = "",
    [string]$TestPath = "",
    [switch]$Help
)

function Show-Help {
    Write-Host "Authentication Test Suite Execution" -ForegroundColor Green
    Write-Host "====================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\run_auth_tests.ps1 [mode]"
    Write-Host ""
    Write-Host "Modes:"
    Write-Host "  1  - All Auth Tests"
    Write-Host "  2  - Login Tests Only"
    Write-Host "  3  - User Info Tests Only"
    Write-Host "  4  - Token Refresh Tests Only"
    Write-Host "  5  - Integration Tests Only"
    Write-Host "  6  - Smoke Tests Only"
    Write-Host "  7  - Error Tests Only"
    Write-Host "  8  - Success Tests Only"
    Write-Host "  9  - Connectivity Test Only"
    Write-Host "  10 - Single Login Test"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\run_auth_tests.ps1        # Interactive mode"
    Write-Host "  .\run_auth_tests.ps1 1      # Run all tests"
    Write-Host "  .\run_auth_tests.ps1 6      # Run smoke tests only"
    Write-Host ""
}

function Create-ResultsDirectory {
    # Get current timestamp for folder name
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    # Create results path
    $resultsPath = Join-Path $PSScriptRoot "results\api\auth_api\$timestamp"
    
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
        [string[]]$IncludeTags = @()
    )
    
    # Build command
    $cmd = @("python", "-m", "robot")
    
    if ($OutputDir) {
        $cmd += "--outputdir", $OutputDir
    }
    
    if ($TestName) {
        $cmd += "--test", $TestName
    }
    
    foreach ($tag in $IncludeTags) {
        $cmd += "--include", $tag
    }
    
    $cmd += $TestPath
    
    Write-Host "Executing: $($cmd -join ' ')" -ForegroundColor Yellow
    Write-Host "Working Directory: $(Get-Location)" -ForegroundColor Yellow
    
    # Execute command
    try {
        $process = Start-Process -FilePath "python" -ArgumentList ($cmd[1..($cmd.Length-1)]) -Wait -PassThru -NoNewWindow
        return $process.ExitCode -eq 0
    }
    catch {
        Write-Host "Error executing tests: $_" -ForegroundColor Red
        return $false
    }
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

Write-Host "================================================================================" -ForegroundColor Green
Write-Host "Authentication Test Suite Execution" -ForegroundColor Green
Write-Host "Design Patterns ROBOT - DummyJSON Auth API Tests" -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green

# Set location to script directory
Set-Location $PSScriptRoot

# Create results directory
$resultsPath, $timestamp = Create-ResultsDirectory
Write-Host "Results will be saved to: $resultsPath" -ForegroundColor Cyan

# Execution modes
$executionModes = @{
    "1" = @("All Auth Tests", "tests\api\auth", "", @())
    "2" = @("Login Tests Only", "tests\api\auth\auth_login_tests.robot", "", @())
    "3" = @("User Info Tests Only", "tests\api\auth\auth_user_info_tests.robot", "", @())
    "4" = @("Token Refresh Tests Only", "tests\api\auth\auth_refresh_token_tests.robot", "", @())
    "5" = @("Integration Tests Only", "tests\api\auth\auth_integration_tests.robot", "", @())
    "6" = @("Smoke Tests Only", "tests\api\auth", "", @("smoke"))
    "7" = @("Error Tests Only", "tests\api\auth", "", @("error"))
    "8" = @("Success Tests Only", "tests\api\auth", "", @("success"))
    "9" = @("Connectivity Test Only", "tests\api\auth\auth_test_suite.robot", "Authentication Service Connectivity Test", @())
    "10" = @("Single Login Test", "tests\api\auth\auth_login_tests.robot", "Successful Login With Valid Credentials - Emily", @())
}

# Get mode
if (-not $Mode) {
    Write-Host ""
    Write-Host "Select execution mode:" -ForegroundColor Yellow
    foreach ($key in 1..10) {
        $description = $executionModes[$key.ToString()][0]
        Write-Host "$key. $description"
    }
    
    $Mode = Read-Host "`nEnter mode (1-10)"
}

# Validate mode
if (-not $executionModes.ContainsKey($Mode)) {
    Write-Host "Invalid mode: $Mode" -ForegroundColor Red
    Write-Host "Valid modes: 1-10" -ForegroundColor Red
    exit 1
}

# Get execution parameters
$description, $testPath, $testName, $includeTags = $executionModes[$Mode]

Write-Host ""
Write-Host "Executing: $description" -ForegroundColor Green
Write-Host "Test path: $testPath" -ForegroundColor Yellow
if ($testName) {
    Write-Host "Test name: $testName" -ForegroundColor Yellow
}
if ($includeTags.Count -gt 0) {
    Write-Host "Include tags: $($includeTags -join ', ')" -ForegroundColor Yellow
}

# Execute tests
$success = Execute-RobotTests -TestPath $testPath -OutputDir $resultsPath -TestName $testName -IncludeTags $includeTags

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
if ($success) {
    Write-Host "✅ Tests executed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Tests execution failed!" -ForegroundColor Red
}

Write-Host "📁 Results location: $resultsPath" -ForegroundColor Cyan
Write-Host "📊 Check log.html and report.html in the results folder" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Green

exit $(if ($success) { 0 } else { 1 })