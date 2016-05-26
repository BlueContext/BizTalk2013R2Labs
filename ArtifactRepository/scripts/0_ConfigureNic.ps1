param
(
    [string]$pointless = " "
)

$nic = Get-NetAdapter
$index = $nic.ifIndex
Set-NetConnectionProfile -InterfaceIndex $index -NetworkCategory Private
Set-DNSClientServerAddress -InterfaceIndex $index -ServerAddresses ("10.55.2.35");