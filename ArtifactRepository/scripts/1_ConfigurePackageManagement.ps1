param
(
     [string]$pointless = " "
)

Import-Module PackageManagement
Import-Module PowerShellGet
Import-Module PSDesiredStateConfiguration
Import-Module ServerManager
Import-Module ServerCore
Install-PackageProvider Chocolatey -Force
Set-PackageSource PSGallery
Install-Package xActiveDirectory -Force
Install-Package xStorage -Force
Install-Package xNetworking -Force
Install-Package xComputerManagement -Force