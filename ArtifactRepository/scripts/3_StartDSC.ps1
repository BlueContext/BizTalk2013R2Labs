param
(
     [string]$pointless = " "    
)

$hostname = $env:computername
Start-Sleep -s 60
Start-DscConfiguration -Path "C:\DSC\" -ComputerName $hostname -Wait