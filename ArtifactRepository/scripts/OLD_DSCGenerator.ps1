Param
(
	[string]$targetNode,
	[string]$targetConfiguration = "BaseConfiguration.ps1",
	[string]$dnsServerAddress = "10.55.2.35",
	[string]$domainName = "BTS13R2DEV.lab",
	[string]$userName = "BTS13R2DEV\LabAdmin",
	[string]$password = "Welcome123456",
	[string]$outputPath = "C:\DSC"
)

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


. .\BaseConfiguration.ps1
BaseConfiguration -targetNode $targetNode -dnsServerAddress $dnsServerAddress -domainName $domainName -credential $cred -ConfigurationData $cd -OutputPath $outputPath