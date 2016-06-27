Param
(
    [string]$pointless = " ",
	[string]$targetNode = $env:computername,
	[string]$targetConfiguration = "ADDCConfiguration.ps1",
#	[string]$dnsServerAddress = "10.56.10.5",
	[string]$domainName = "BTS13R2DEV.lab",
	[string]$userName = "BTS13R2DEV\LabAdmin",
	[string]$password = "Welcome123456",
    #[string]$safeModePassword = "Welcome123456",
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

Install-WindowsFeature AD-Domain-Services -Restart
Install-WindowsFeature RSAT-ADDS -Restart
Install-WindowsFeature RSAT-AD-PowerShell -Restart
Install-WindowsFeature RSAT-ADDS-Tools -Restart


md c:\DSC

$pwrd = ConvertTo-SecureString -String $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($userName, $pwrd)
#$safeCred = New-Object System.Management.Automation.PSCredential ($safeModePassword)
$cd = @{
    AllNodes = @(
        @{
            NodeName = $targetNode            
            Role = "Primary DC"             
            DomainName = "bts13R2DEV.lab"             
            RetryCount = 20              
            RetryIntervalSec = 30            
            PsDscAllowPlainTextPassword = $true
            PsDscAllowDomainUser = $true
         }
    )
}


. .\ADDCConfiguration.ps1
ADDCConfiguration -targetNode $targetNode -domainCred $cred -ConfigurationData $cd -OutputPath $outputPath