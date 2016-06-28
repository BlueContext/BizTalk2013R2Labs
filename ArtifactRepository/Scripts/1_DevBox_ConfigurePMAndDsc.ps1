Param
(
	[string]$pointless = " ",
    [string]$targetNode = $env:computername,
	[string]$targetConfiguration = "DevBoxConfiguration.ps1",
	[string]$dnsServerAddress = "10.56.10.5",
	[string]$domainName = "BTS13R2DEV.lab",
	[string]$userName = "BTS13R2DEV\LabAdmin",
	[string]$password = "Welcome123456",
	[string]$outputPath = "C:\DSC"
)

Import-Module PackageManagement
Import-Module PowerShellGet
Import-Module PSDesiredStateConfiguration
Import-Module ServerManager
Import-Module ServerCore
Install-PackageProvider Chocolatey -Force

Set-PackageSource PSGallery
install-package xDnsServer -Force
Install-Package xActiveDirectory -Force
Install-Package xStorage -Force
Install-Package xNetworking -Force
Install-Package xComputerManagement -Force
Install-Package xTimeZone -Force

Set-PackageSource Chocolatey
Install-Package 

md c:\DSC

$pwrd = ConvertTo-SecureString -String $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($userName, $pwrd)
$cd = @{
    AllNodes = @(
        @{
            NodeName = $targetNode
            PsDscAllowDomainUser = $true
            PsDscAllowPlainTextPassword = $true
         }
    )
}

. .\DevBoxConfiguration.ps1
DevBoxConfiguration -targetNode $targetNode -dnsServerAddress $dnsServerAddress -domainName $domainName -credential $cred -ConfigurationData $cd -OutputPath $outputPath