$ErrorActionPreference = "Stop"

# Configuration
$BinaryName   = "ai.exe"
$ConfigDir    = Join-Path $env:APPDATA "ai"
$EnvFile      = Join-Path $ConfigDir ".env"
$InstallDir   = Join-Path $env:LOCALAPPDATA "Programs\ai"
$SourceBinary = Join-Path $PSScriptRoot $BinaryName

Write-Host "=== Setting up $BinaryName ==="

# 1. Create config directory if it doesn't exist
if (-not (Test-Path $ConfigDir)) {
    Write-Host "Creating directory: $ConfigDir"
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

# 2. Handle .env file creation
if (-not (Test-Path $EnvFile)) {
    Write-Host "Configuration file not found."
    $UserToken = Read-Host "Enter your TOKEN"

    if ([string]::IsNullOrWhiteSpace($UserToken)) {
        Write-Host "Error: Token cannot be empty. Aborting installation."
        exit 1
    }

    # ASCII on purpose: PowerShell 5.1 "UTF8" adds a BOM that breaks python-dotenv
    Set-Content -Path $EnvFile -Value "TOKEN=$($UserToken.Trim())" -Encoding ascii
    Write-Host "Created config file at: $EnvFile"
}
else {
    Write-Host "Config file already exists at: $EnvFile"
}

# 3. Check if binary exists next to this script
if (-not (Test-Path $SourceBinary)) {
    Write-Host "Error: Binary '$BinaryName' not found in $PSScriptRoot"
    Write-Host "Please make sure '$BinaryName' is in the same directory as setup.ps1"
    exit 1
}

# 4. Copy binary to a per-user install dir (no admin rights needed)
Write-Host "Installing binary to $InstallDir\$BinaryName"
New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
Copy-Item -Path $SourceBinary -Destination (Join-Path $InstallDir $BinaryName) -Force

# 5. Add install dir to the user's PATH if it isn't there yet
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $UserPath) { $UserPath = "" }

if (($UserPath -split ";") -notcontains $InstallDir) {
    $NewPath = ($UserPath.TrimEnd(";") + ";" + $InstallDir).TrimStart(";")
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    Write-Host "Added $InstallDir to your PATH."
}

Write-Host "=== Installation complete ==="
Write-Host "Open a NEW terminal window, then run '$($BinaryName -replace '\.exe$','')' from anywhere."
