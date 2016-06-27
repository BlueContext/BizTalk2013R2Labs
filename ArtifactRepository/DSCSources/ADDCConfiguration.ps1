#Configuration for a domain controller in a new domain and forest

configuration ADDCConfiguration
{
	param
	(
		[string]$targetNode,
        [Parameter(Mandatory)]
        [pscredential]$domainCred
	)

    Import-DscResource -ModuleName xTimeZone
    Import-DscResource -ModuleName xActiveDirectory
    Import-DscResource -ModuleName xDnsServer
    Import-DscResource -ModuleName PSDesiredStateConfiguration
	
	Node $AllNodes.Where{$_.Role -eq "Primary DC"}.Nodename
	{
        LocalConfigurationManager            
        {
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true            
        }

        xTimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone = "Central Standard Time"
        }
            
        File ADFiles
        {
            DestinationPath = 'C:\NTDS'
            Type = 'Directory'
            Ensure = 'Present'
        }
                    
#        WindowsFeature ADDSInstall             
#        {
#            Ensure = "Present"
#            Name = "AD-Domain-Services"
#        }
#            
#        # Optional GUI tools            
#        WindowsFeature ADDSTools            
#        {
#            Ensure = "Present"             
#            Name = "RSAT-ADDS"
#            DependsOn = "[WindowsFeature]ADDSInstall"             
#        }
#
#        WindowsFeature ADDSPowershell
#        {
#            Ensure = "Present"
#            Name = "RSAT-AD-PowerShell"
#            DependsOn = "[WindowsFeature]ADDSTools"
#        }
#        #WindowsFeature ADDSCommands
#        {
#            Ensure = "Present"
#            Name = "RSAT-ADDS-Tools"
#            DependsOn = "[WindowsFeature]ADDSTools"
#        }  
            
        # No slash at end of folder paths
        xADDomain FirstDS
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $domainCred
            DatabasePath = 'C:\NTDS'
            LogPath = 'C:\NTDS'
            DependsOn = "[File]ADFiles"            
        }

        xDnsServerForwarder RemoveAllForwarders
        {
            IsSingleInstance = 'Yes'
            IPAddresses = @()
            DependsOn = "[xADDomain]FirstDS"
        }

        xDnsServerForwarder SetForwarders
        {
            IsSingleInstance = 'Yes'
            IPAddresses = '10.71.26.84','10.71.26.85'
            DependsOn = "[xDnsServerForwarder]RemoveAllForwarders"
        }

        # Script RunAdPopulationScripts
        # {
        #     GetScript = { return @{
        #         GetScript = $GetScript
        #         SetScript = $SetScript
        #         TestScript = $TestScript
        #         Result = "Rando string"
        #     }}
        #     SetScript = {
        #         [string[]]$files = @("create-ad-groups.ps1","create-ad-svcaccts.ps1","create-ad-users.ps1","import_create_ad_groups.csv","import_create_ad_svcaccts.csv","import_create_ad_users.csv")
        #         [string[]]$scripts = @("create-ad-groups.ps1","create-ad-svcaccts.ps1","create-ad-users.ps1")
        #         New-Item C:\DSC\ADscripts -ItemType Directory
        #         Set-Location C:\DSC\ADscripts
        #         $i = 0
        #         foreach($f in $files)
        #         {
        #             $url = "http://10.71.184.182:8089/Scripts/populate-ad/$f"
        #             $destination = "C:\DSC\ADscripts\$f"
        #             $wc = New-Object System.Net.WebClient
        #             $wc.DownloadFile($url, $destination)
        #             $wc.Dispose()
        #             $i++
        #         }
        #         Start-Sleep -Seconds 20

        #         foreach($s in $scripts)
        #         {
        #             $commandText = "./" + $s + " -Wait"
        #             $command = [scriptblock]::create($commandText) 
        #             Invoke-Command -ScriptBlock $command -Credential $domainCred
        #         }
        #      }
        #     TestScript =  {
        #         $test = Test-Path -Path C:\DSC\ADscripts
        #         if($test -eq $true)
        #         {
        #             return $true
        #         }
        #         else
        #         {
        #             return $false
        #         }
        #     }
        #     DependsOn = "[xDnsServerForwarder]SetForwarders"
        # }
	}
}