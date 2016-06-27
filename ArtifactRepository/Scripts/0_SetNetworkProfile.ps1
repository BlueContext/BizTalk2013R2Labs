param
(
    [string]$pointless = " "
)

$nic = Get-NetAdapter
$index = $nic.ifIndex
$dns = Get-DnsClientServerAddress -InterfaceIndex $index -AddressFamily IPv4
if($dns.ServerAddresses[0] -ne "10.56.10.5")
{
    #Set-NetConnectionProfile -InterfaceIndex $index -NetworkCategory Private
    Set-DNSClientServerAddress -InterfaceIndex $index -ServerAddresses ("10.56.10.5")
    Restart-Computer -Force
}

