#Requires -Version 5.1
<#
.SYNOPSIS
    Sets up the portable Neovim configuration on Windows.
.DESCRIPTION
    This script checks for dependencies like Git, Neovim, Ripgrep, fd, and PowerShell Core.
    It then clones or updates the Neovim configuration from GitHub.
.NOTES
    Run this script from PowerShell. Administrator privileges might be needed for Winget installations.
#>

Write-Host "🚀 Starting Neovim Portable Setup for Windows..." -ForegroundColor Yellow

# --- Configuration ---
$NvimConfigPath = "$env:LOCALAPPDATA\nvim"
$RepoUrl = "https://github.com/MissinLinkk05551/NeovimPortable.git"

# --- Helper Functions ---
function Test-CommandExists {
    param($Command)
    return (Get-Command $Command -ErrorAction SilentlyContinue) -ne $null
}

function Install-WingetPackage {
    param(
        [string]$PackageId,
        [string]$PackageName
    )
    if (-not (Test-CommandExists $PackageName.Split(' ')[0])) { # Check by executable name if possible
        Write-Host "⏳ $PackageName not found. Attempting to install with Winget ($PackageId)..."
        try {
            winget install --id $PackageId -e --accept-package-agreements --accept-source-agreements
            if (-not (Test-CommandExists $PackageName.Split(' ')[0])) {
                Write-Error "❌ Failed to install $PackageName ($PackageId) with Winget. Please install it manually and re-run."
                exit 1
            }
            Write-Host "✅ $PackageName installed successfully."
        } catch {
            Write-Error "❌ Error installing $PackageName ($PackageId) with Winget. $_"
            Write-Host "   Please ensure Winget is installed and working, or install $PackageName manually."
            exit 1
        }
    } else {
        Write-Host "✅ $PackageName found."
    }
}

# --- Main Setup ---

# 0. Check for PowerShell Core (pwsh)
Write-Host ""
Write-Host "--- Step 0: Checking PowerShell Version ---"
if ($PSVersionTable.PSEdition -ne "Core") {
    Write-Host "⚠️ You are running Windows PowerShell (powershell.exe)."
    Write-Host "   While this script might work, Neovim often integrates better with PowerShell Core (pwsh.exe)."
    Write-Host "   Consider installing PowerShell Core: winget install Microsoft.PowerShell"
    Write-Host "   The Neovim config will attempt to set 'pwsh' as the default shell."
} else {
    Write-Host "✅ PowerShell Core (pwsh) detected."
}


# 1. Check/Install Neovim
Write-Host ""
Write-Host "--- Step 1: Checking Neovim ---"
if (-not (Test-CommandExists "nvim")) {
    Write-Host "⏳ Neovim (nvim) not found. Attempting to install with Winget..."
    Install-WingetPackage -PackageId "Neovim.Neovim" -PackageName "Neovim (nvim)"
} else {
    Write-Host "✅ Neovim found."
    # You could add a version check here if desired
}

# 2. Check/Install Essential Dependencies
Write-Host ""
Write-Host "--- Step 2: Checking Essential Dependencies ---"
if (-not (Test-CommandExists "winget")) {
    Write-Error "❌ Winget not found. Please install Winget (App Installer) from the Microsoft Store or https://aka.ms/getwinget"
    exit 1
}
Install-WingetPackage -PackageId "Git.Git" -PackageName "Git"
Install-WingetPackage -PackageId "BurntSushi.Ripper.MSVC" -PackageName "Ripgrep (rg)" # Ripgrep
Install-WingetPackage -PackageId "sharkdp.fd" -PackageName "fd"

# Check for a C/C++ compiler (e.g., MSVC from Visual Studio Build Tools)
# This is harder to automate fully with winget for just the compiler.
# For now, a note is sufficient.
Write-Host "ℹ️ For some Mason packages (like C/C++ LSPs or debuggers), a C/C++ toolchain (e.g., MSVC Build Tools) might be required."
Write-Host "   If you plan to do C/C++ development, ensure you have Visual Studio with C++ workload or Visual Studio Build Tools installed."

# 3. Clone/Update Neovim Configuration
Write-Host ""
Write-Host "--- Step 3: Setting up Neovim Configuration ---"
if (Test-Path (Join-Path $NvimConfigPath ".git")) {
    Write-Host "⏳ Neovim config directory exists. Pulling latest changes from $RepoUrl..."
    Push-Location $NvimConfigPath
    try {
        git pull
        Write-Host "✅ Configuration updated."
    } catch {
        Write-Error "❌ Failed to pull updates. $_"
    } finally {
        Pop-Location
    }
} elseif ((Test-Path $NvimConfigPath) -and (Get-ChildItem $NvimConfigPath)) {
    Write-Warning "⚠️ Directory $NvimConfigPath exists but is not a git repository or is not empty."
    Write-Warning "   Please back it up or remove it, then re-run this script."
    Write-Warning "   Example: Move-Item -Path \"$NvimConfigPath\" -Destination \"$NvimConfigPath.backup\""
    exit 1
} else {
    Write-Host "⏳ Cloning Neovim configuration from $RepoUrl to $NvimConfigPath..."
    if (-not (Test-Path (Split-Path $NvimConfigPath))) {
        New-Item -ItemType Directory -Path (Split-Path $NvimConfigPath) -Force | Out-Null
    }
    try {
        git clone $RepoUrl $NvimConfigPath
        Write-Host "✅ Configuration cloned."
    } catch {
        Write-Error "❌ Failed to clone repository. $_"
        exit 1
    }
}

# 4. Nerd Fonts Reminder
Write-Host ""
Write-Host "--- Step 4: Nerd Fonts ---" -ForegroundColor Cyan
Write-Host "ℹ️ For icons and a better UI, please install a Nerd Font and set it in your terminal." -ForegroundColor Cyan
Write-Host "   Popular choices: FiraCode Nerd Font, JetBrainsMono Nerd Font, Hack Nerd Font." -ForegroundColor Cyan
Write-Host "   Download from: https://www.nerdfonts.com/" -ForegroundColor Cyan
Write-Host "   After installing, select the Nerd Font in your terminal emulator's settings (e.g., Windows Terminal, Alacritty, WezTerm)." -ForegroundColor Cyan

# 5. Final Instructions
Write-Host ""
Write-Host "🎉 Neovim Portable Setup Complete! 🎉" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Green
Write-Host "1. Open Neovim by typing 'nvim'." -ForegroundColor Green
Write-Host "2. On the first run, Lazy.nvim will install plugins." -ForegroundColor Green
Write-Host "3. Mason will then install configured LSPs, linters, formatters, and debuggers." -ForegroundColor Green
Write-Host "   You can monitor this with :Mason or check :checkhealth." -ForegroundColor Green
Write-Host "Enjoy your portable Neovim setup! ✨" -ForegroundColor Green