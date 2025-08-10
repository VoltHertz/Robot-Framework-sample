# Products API Tests Execution Script - PowerShell
# File: run_products_tests.ps1
#
# This PowerShell script executes the products API test suite with enhanced Windows integration
# Usage: .\run_products_tests.ps1 [option_number]
# Example: .\run_products_tests.ps1 10

param(
    [string]$Option = ""
)

# Enable colored output
$Host.UI.RawUI.ForegroundColor = "White"

function Write-ColorText {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = $originalColor
}

function Write-Header {
    param([string]$Title)
    Write-ColorText "================================================================================" "Cyan"
    Write-ColorText $Title "Yellow"
    Write-ColorText "================================================================================" "Cyan"
}

function Write-Success {
    param([string]$Message)
    Write-ColorText "✅ $Message" "Green"
}

function Write-Error {
    param([string]$Message)
    Write-ColorText "❌ $Message" "Red"
}

function Write-Info {
    param([string]$Message)
    Write-ColorText "ℹ️  $Message" "Blue"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorText "⚠️  $Message" "Yellow"
}

# Script header
Clear-Host
Write-Header "PRODUCTS API TEST SUITE - POWERSHELL EXECUTION"
Write-ColorText "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" "Gray"
Write-Host ""

# Check if Python is available
try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Python detected: $pythonVersion"
    } else {
        throw "Python command failed"
    }
} catch {
    Write-Error "Python is not installed or not in PATH"
    Write-Info "Please install Python 3.7+ and try again"
    Write-Info "Visit: https://www.python.org/downloads/"
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if Robot Framework is available
try {
    $robotVersion = python -m robot --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Robot Framework detected: $robotVersion"
    } else {
        throw "Robot Framework not found"
    }
} catch {
    Write-Warning "Robot Framework may not be installed"
    Write-Info "If tests fail, install with: pip install robotframework"
}

Write-Host ""

# Execute the Python script
if ($Option -eq "") {
    Write-Info "Starting interactive mode..."
    Write-Host ""
    python run_products_tests.py
} else {
    Write-Info "Starting direct execution mode with option: $Option"
    Write-Host ""
    python run_products_tests.py $Option
}

# Check execution result
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Success "Products API test execution completed successfully!"
} else {
    Write-Host ""
    Write-Error "Products API test execution completed with issues (Exit code: $LASTEXITCODE)"
}

Write-Host ""
Write-Header "EXECUTION COMPLETED"

# Don't auto-close if running in ISE or other interactive environments
if ($Host.Name -eq "ConsoleHost") {
    Write-ColorText "Press Enter to close this window..." "Gray"
    Read-Host
}