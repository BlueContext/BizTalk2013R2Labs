#This assumes you have added an AzureRm account and selected an AzureRm Subscription
#Import-Module Azure
#Add-AzureRmAccount
#Select-AzureRmSubscription -SubscriptionName "Energytransfer Azure Hybrid - Dev"

#This step is critical -- We're going to issue the Start-AzureRmVm commands in PS jobs, which run in different app domains from the parent host;
#they therefore do not share the context/subscription/account that you have invoked in the main host. So, we save that context to disk, and then re-load it 
#from disk 
Save-AzureRmProfile -Path C:\MyStuff\Azure\Profiles\Profile1.json

Function Start-AllAzureRmVms
{
    $vms = Get-AzureRmVm
    $dc = $vms | Where Name -like "BTLAB1-INFRA01"
    $dcVm = Get-AzureRmVm -ResourceGroupName $dc.ResourceGroupName -Name $dc.Name -Status
    if ($dcVm.Statuses[1].Code -eq "PowerState/deallocated")
    {
        Start-AzureRmVm -ResourceGroupName $dcVm.ResourceGroupName -Name $dcVm.Name -Verbose
    }
    
    foreach($v in $vms)
    {
        if($v.Name -ne "BTLAB1-INFRA01")
        {
            $vm = Get-AzureRmVm -ResourceGroupName $v.ResourceGroupName -Name $v.Name -Status
            if($vm.Statuses[1].Code -eq "PowerState/deallocated")
            {
                $scriptblock = { param($vm) 
                        Select-AzureRmProfile -Path "C:\MyStuff\Azure\Profiles\Profile1.json"
                        Start-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name }
                Start-Job -ScriptBlock $scriptblock -Arg $vm
            }
        }
    }
}