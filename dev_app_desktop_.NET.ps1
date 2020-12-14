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
choco install -y sql-server-management-studio
choco install -y sqlsearch
choco install -y screentogif
choco install -y monosnap
choco install -y sqltoolbelt

choco install hackfont firacode inconsolata dejavufonts robotofonts droidfonts -y
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart
Enable-WindowsOptionalFeature -FeatureName Containers -Online -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart

#--- Ubuntu ---
# TODO: Move this to choco install once --root is included in that package
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx
# run the distro once and have it install locally with root user, unset password

RefreshEnv
Ubuntu2004 install --root
Ubuntu2004 run apt update
Ubuntu2004 run apt upgrade -y

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

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
