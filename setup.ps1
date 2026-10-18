$ErrorActionPreference = "Stop"

# Configuration
$BinaryName   = "ai.exe"
$ConfigDir    = Join-Path $env:APPDATA "ai"
$EnvFile      = Join-Path $ConfigDir ".env"
$InstallDir   = Join-Path $env:LOCALAPPDATA "Programs\ai"
$TargetBinary = Join-Path $InstallDir $BinaryName
$LocalBinary  = Join-Path $PSScriptRoot $BinaryName

# GitHub Releases URL for the latest version
$DownloadUrl  = "https://github.com/TYUFUN/AiSearch/releases/latest/download/$BinaryName"

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

# 3. Pick the binary source
#    - ai.exe next to this script (e.g. built from source) -> install that one
#    - otherwise download the latest release (asking first if already installed)
$UseLocal       = Test-Path $LocalBinary
$ShouldDownload = -not $UseLocal

if ($ShouldDownload -and (Test-Path $TargetBinary)) {
    Write-Host "Binary '$BinaryName' is already installed at $TargetBinary."

    # Default to 'y' on Enter
    $UpdateChoice = Read-Host "Do you want to download and update to the latest version? [Y/n]"
    if ([string]::IsNullOrWhiteSpace($UpdateChoice)) { $UpdateChoice = "y" }

    if ($UpdateChoice -notmatch '^[Yy]$') {
        Write-Host "Skipping update."
        $ShouldDownload = $false
    }
}

# 4. Download (or copy) and install the binary
New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

if ($UseLocal) {
    Write-Host "Found local $BinaryName next to the script, installing it to $TargetBinary"
    try {
        Copy-Item -Path $LocalBinary -Destination $TargetBinary -Force
    }
    catch {
        Write-Host "Error: Could not write $TargetBinary. Is 'ai' still running? Close it and try again."
        exit 1
    }
    Write-Host "Binary installed/updated successfully!"
}
elseif ($ShouldDownload) {
    Write-Host "Downloading latest $BinaryName from GitHub Releases..."
    $TempFile = Join-Path $env:TEMP $BinaryName

    # Windows PowerShell 5.1 may default to old TLS versions; GitHub needs TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # The progress bar makes Invoke-WebRequest very slow on PowerShell 5.1
    $ProgressPreference = "SilentlyContinue"

    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempFile -UseBasicParsing
    }
    catch {
        Write-Host "Error: Failed to download binary from GitHub Releases."
        Write-Host "Make sure you have created a Release and attached a file named '$BinaryName'."
        exit 1
    }

    if ((-not (Test-Path $TempFile)) -or ((Get-Item $TempFile).Length -eq 0)) {
        Write-Host "Error: Downloaded file is empty."
        exit 1
    }

    Write-Host "Installing binary to $TargetBinary"
    try {
        Move-Item -Path $TempFile -Destination $TargetBinary -Force
    }
    catch {
        Write-Host "Error: Could not write $TargetBinary. Is 'ai' still running? Close it and try again."
        exit 1
    }
    Write-Host "Binary installed/updated successfully!"
}

# 5. Add install dir to the user's PATH if it isn't there yet (no admin rights needed)
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $UserPath) { $UserPath = "" }

if (($UserPath -split ";") -notcontains $InstallDir) {
    $NewPath = ($UserPath.TrimEnd(";") + ";" + $InstallDir).TrimStart(";")
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    Write-Host "Added $InstallDir to your PATH."
}

Write-Host "=== Installation complete ==="
Write-Host "Open a NEW terminal window, then run 'ai' from anywhere."
