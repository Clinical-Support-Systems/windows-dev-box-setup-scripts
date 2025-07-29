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
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /d "" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f

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
choco install python -y
choco install nodejs -y

# Modern Terminal and Shell
choco install microsoft-windows-terminal -y
choco install powershell-core -y

# Container and Cloud Development
choco install docker-desktop -y
choco install kubernetes-cli -y
choco install terraform -y

# Cloud CLI Tools
choco install awscli -y
choco install azure-cli -y

# Modern Browsers
choco install microsoft-edge -y
choco install brave -y
choco install firefox -y

# Development Fonts
choco install cascadiafonts -y
choco install sourcecodepro -y

# Essential Utilities
choco install 7zip -y
choco install notepadplusplus -y
choco install postman -y

# WSL2 Setup and Configuration
Write-Host "Configuring WSL2..." -ForegroundColor Yellow

$wslConfig = @"
[wsl2]
memory=8GB
processors=4
localhostForwarding=true
swap=4GB
pageReporting=true
nestedVirtualization=true
guiApplications=true

[experimental]
autoMemoryReclaim=gradual
sparseVhd=true
"@

$wslConfig | Out-File -FilePath "$env:USERPROFILE\.wslconfig" -Encoding UTF8

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
Write-Host "4. Consider setting up a Dev Drive for optimal performance" -ForegroundColor White
Write-Host "5. Install VS Code extensions: GitHub Copilot, Python, Docker, Kubernetes" -ForegroundColor White
Write-Host ""
Write-Host "Installed Tools Summary:" -ForegroundColor Cyan
Write-Host "- Visual Studio 2022 Community with .NET, Web, and Azure workloads" -ForegroundColor Green
Write-Host "- VS Code with modern development support" -ForegroundColor Green
Write-Host "- Docker Desktop with Kubernetes support" -ForegroundColor Green
Write-Host "- Modern Python environment and Node.js" -ForegroundColor Green
Write-Host "- PowerShell 7 and Windows Terminal" -ForegroundColor Green
Write-Host "- WSL2 with optimized configuration" -ForegroundColor Green
Write-Host "- Cloud CLI tools (AWS, Azure)" -ForegroundColor Green
Write-Host "- Modern browsers and development fonts" -ForegroundColor Green
Write-Host ""
Write-Host "Your machine is now ready for modern 2025 development workflows!" -ForegroundColor Green
