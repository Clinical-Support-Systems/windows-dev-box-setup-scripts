# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for desktop app development

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";

#--- Tools ---
choco install -y powershell-core
choco install -y visualstudio2019enterprise
Update-SessionEnvironment #refreshing env due to Git install

#--- UWP Workload and installing Windows Template Studio ---
choco install -y visualstudio2019-workload-azure
choco install -y visualstudio2019-workload-netcoretools
choco install -y visualstudio2019-workload-netweb
choco install -y visualstudio2019-workload-universal
choco install -y visualstudio2019-workload-xamarinbuildtools
choco install -y visualstudio2019-workload-netcrossplat
choco install -y visualstudio2019-workload-webbuildtools

choco install -y vscode
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y nodejs
choco install -y poshgit
choco install -y python
choco install -y 7zip.install
choco install -y winrar
choco install -y sysinternals
choco install -y fiddler
choco install -y git-credential-winstore
choco install -y microsoft-windows-terminal
choco install -y putty.install
choco install -y gitkraken
choco install -y filezilla
choco install sql-server-management-studio
RefreshEnv
choco install -y ssms
RefreshEnv
choco install -y sqlsearch
choco install -y screentogif
choco install -y monosnap
choco install -y sqltoolbelt
choco install -y azure-data-studio

choco install hackfont firacode inconsolata dejavufonts robotofonts droidfonts -y
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart
Enable-WindowsOptionalFeature -FeatureName Containers -Online -NoRestart
choco install wsl2
RefreshEnv

#--- Ubuntu ---
choco install wsl-ubuntu-2004 --params "/InstallRoot:true"
RefreshEnv

winget install --name PowerShell --exact
RefreshEnv

choco install -y googlechrome
choco install -y firefox
choco install -y microsoft-edge-insider

choco install -y IIS-WebServerRole -source windowsfeatures

code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

choco install -y github-desktop
choco install -y googlechrome-authy
choco install -y 1password
choco install -y dropbox
choco install -y notepadplusplus
choco install -y paint.net
choco install -y nugetpackageexplorer
choco install -y nuget.commandline
choco install -y insomnia-rest-api-client
choco install lsagent

# Disable cortana
Write-Host "Disabling Cortana..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0

# Hide Task View button
Write-Host "Hiding Task View button..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

# Turn off search box in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Type DWord -Value 0

# Turn off cortana in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowCortanaButton -Type DWord -Value 0

# Turn off task view button in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Type DWord -Value 0

# Disable one-drive
Write-Host "Disabling OneDrive..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
