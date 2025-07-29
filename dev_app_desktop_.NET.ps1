# Modern Developer Machine Setup Script for Windows 11 (2025)
# Save as .txt file and host on GitHub Gist for Boxstarter
# Usage: START http://boxstarter.org/package/nr/url?<raw-github-url>

# Boxstarter Configuration
$Boxstarter.RebootOk = $true
$Boxstarter.NoPassword = $false
$Boxstarter.AutoLogin = $true

Write-Host "Setting up modern Windows 11 development environment..." -ForegroundColor Green

# Enable Windows Features for Development
Write-Host "Enabling Windows features..." -ForegroundColor Yellow
choco install -y Microsoft-Windows-Subsystem-Linux --source windowsfeatures
choco install -y VirtualMachinePlatform --source windowsfeatures
choco install -y Microsoft-Hyper-V-All --source windowsfeatures

# Windows 11 Settings and Optimizations
Write-Host "Configuring Windows 11 developer settings..." -ForegroundColor Yellow

# Ultimate Performance power scheme
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61

# Privacy and telemetry settings
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

# Windows 11 UI improvements
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /d "" /f  # Classic context menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f  # Left-aligned taskbar
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f  # Disable widgets

# File Explorer developer settings
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
Set-TaskbarOptions -Size Small -Dock Bottom

# Essential Development Tools
Write-Host "Installing essential development tools..." -ForegroundColor Yellow

# Core Development IDEs and Editors
choco install visualstudio2022community -y --package-parameters "--add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Azure --includeRecommended --passive --locale en-US"
choco install vscode -y

# Version Control
choco install git -y
choco install github-desktop -y

# Programming Languages and Runtimes
choco install python -y                    # Python 3.13+
choco install nodejs -y                    # Node.js latest LTS
winget install Astral-sh.uv               # Modern Python package manager (10-100x faster than pip)

# Modern Terminal and Shell
winget install Microsoft.WindowsTerminal
winget install Microsoft.PowerShell       # PowerShell 7+
winget install JanDeDobbeleer.OhMyPosh    # Terminal customization

# Container and Cloud Development
choco install docker-desktop -y
choco install kubernetes-cli -y           # kubectl
winget install Rancher.k3d               # Fast local Kubernetes (recommended)
choco install kubernetes-helm -y          # Helm package manager
choco install terraform -y               # Infrastructure as Code

# Cloud CLI Tools
choco install awscli -y                  # AWS CLI v2
choco install azure-cli -y               # Azure CLI

# Modern Browsers
choco install microsoft-edge -y           # Built-in AI features
choco install brave -y                    # Privacy-focused with ad blocking
choco install firefox -y                  # Non-Chromium alternative

# Development Fonts (Nerd Fonts for icon support)
choco install nerd-fonts-cascadiamono -y  # Microsoft's modern programming font
choco install sourcecodepro -y            # Adobe's professional font

# Essential Utilities
choco install 7zip -y
choco install notepadplusplus -y
choco install postman -y                  # API development and testing
winget install Microsoft.PowerToys       # Enhanced productivity tools

# WSL2 Setup and Configuration
Write-Host "Configuring WSL2..." -ForegroundColor Yellow

# Install WSL2 kernel update
$wslUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$wslUpdatePath = "$env:TEMP\wsl_update_x64.msi"
try {
    Invoke-WebRequest -Uri $wslUpdateUrl -OutFile $wslUpdatePath
    Start-Process msiexec.exe -Wait -ArgumentList "/i $wslUpdatePath /quiet"
    wsl --set-default-version 2
} catch {
    Write-Host "WSL2 kernel update installation failed. Please install manually." -ForegroundColor Red
}

# Create optimized .wslconfig
$wslConfig = @"
[wsl2]
memory=8GB
processors=4
localhostForwarding=true
swap=4GB
pageReporting=true
nestedVirtualization=true
guiApplications=true
networkingMode=mirrored
dnsTunneling=true
autoProxy=true

[experimental]
autoMemoryReclaim=gradual
sparseVhd=true
"@

$wslConfig | Out-File -FilePath "$env:USERPROFILE\.wslconfig" -Encoding UTF8

# PowerShell Configuration
Write-Host "Configuring PowerShell 7..." -ForegroundColor Yellow

# Install PowerShell modules for enhanced experience
try {
    pwsh -Command "Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Scope AllUsers" -ErrorAction SilentlyContinue
    pwsh -Command "Install-Module -Name PSReadLine -Repository PSGallery -Force -AllowPrerelease -Scope AllUsers" -ErrorAction SilentlyContinue
} catch {
    Write-Host "PowerShell module installation encountered issues. Modules can be installed manually later." -ForegroundColor Yellow
}

# Create PowerShell profile with modern configuration
$profileContent = @"
# Oh My Posh initialization with atomic theme
oh-my-posh init pwsh --config "`$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression

# Terminal Icons for better file listings
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

# Enhanced PSReadLine configuration
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Useful aliases for development
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name grep -Value Select-String
Set-Alias -Name which -Value Get-Command

# Docker and Kubernetes shortcuts
function d { docker @args }
function dc { docker-compose @args }
function k { kubectl @args }

# Quick WSL access
function ubuntu { wsl -d Ubuntu @args }
"@

try {
    pwsh -Command "
    if (!(Test-Path (Split-Path `$PROFILE -Parent))) {
        New-Item -Path (Split-Path `$PROFILE -Parent) -ItemType Directory -Force
    }
    '$profileContent' | Out-File -FilePath `$PROFILE -Encoding UTF8
    "
} catch {
    Write-Host "PowerShell profile creation encountered issues. Can be configured manually later." -ForegroundColor Yellow
}

# Windows Defender Exclusions for Development
Write-Host "Configuring Windows Defender exclusions..." -ForegroundColor Yellow
Add-MpPreference -ExclusionPath "C:\Development" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath "C:\Source" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Roaming\npm" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.nuget" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionProcess "node.exe" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionProcess "git.exe" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionProcess "code.exe" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionProcess "docker.exe" -ErrorAction SilentlyContinue

# Taskbar Pinning for Essential Apps
Write-Host "Pinning essential applications to taskbar..." -ForegroundColor Yellow
try {
    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles)\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles)\Microsoft VS Code\Code.exe"
    Install-ChocolateyPinnedTaskBarItem "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe"  # Windows Terminal
} catch {
    Write-Host "Some taskbar pinning operations failed. Applications can be pinned manually." -ForegroundColor Yellow
}

# Clean up and restart explorer
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer

# Final Instructions
Write-Host "===========================================" -ForegroundColor Green
Write-Host "Modern Windows 11 Developer Setup Complete!" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer to apply all Windows features and WSL2 setup" -ForegroundColor White
Write-Host "2. After restart, run: wsl --install -d Ubuntu" -ForegroundColor White
Write-Host "3. Open Windows Terminal and configure your preferred shell" -ForegroundColor White
Write-Host "4. Consider setting up a Dev Drive (Format D: -DevDrive) for optimal performance" -ForegroundColor White
Write-Host "5. Install VS Code extensions: GitHub Copilot, Python, Docker, Kubernetes" -ForegroundColor White
Write-Host ""
Write-Host "Installed Tools Summary:" -ForegroundColor Cyan
Write-Host "✓ Visual Studio 2022 Community with .NET, Web, and Azure workloads" -ForegroundColor Green
Write-Host "✓ VS Code with modern development support" -ForegroundColor Green
Write-Host "✓ Docker Desktop with Kubernetes support" -ForegroundColor Green
Write-Host "✓ Modern Python environment with uv package manager" -ForegroundColor Green
Write-Host "✓ Node.js latest LTS with npm" -ForegroundColor Green
Write-Host "✓ PowerShell 7 with Oh My Posh theming" -ForegroundColor Green
Write-Host "✓ WSL2 with optimized configuration" -ForegroundColor Green
Write-Host "✓ Cloud CLI tools (AWS, Azure)" -ForegroundColor Green
Write-Host "✓ Modern browsers and development fonts" -ForegroundColor Green
Write-Host ""
Write-Host "Your machine is now ready for modern 2025 development workflows!" -ForegroundColor Green
