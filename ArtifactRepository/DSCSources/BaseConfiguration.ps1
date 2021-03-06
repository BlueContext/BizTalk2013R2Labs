configuration BaseConfiguration
{
	param
	(
		[string]$targetNode,
		[string]$dnsServerAddress,
		[string]$domainName,
		[pscredential]$credential
	)

    Import-DscResource -ModuleName xTimeZone
	Import-DscResource -Module xNetworking
	Import-DscResource -Module xComputerManagement
	
	node $targetNode
	{
		xDNSServerAddress dnsServer
		{
			Address = $dnsServerAddress
			AddressFamily = 'IPv4'
			InterfaceAlias = 'Ethernet'
		}

		xTimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone = "Central Standard Time"
        }
		
		xComputer JoinComputer
		{
			Name = $targetNode
			DomainName =$domainName
			Credential = $Credential
		}
	}
}