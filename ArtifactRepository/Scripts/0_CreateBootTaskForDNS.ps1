param
(
    [string]$pointless = " "
)

$url1 = "http://gthou-wwsvc01d.energy.sug.pri:8089/Scripts/0_SetNetworkProfile.ps1"
$output1 = "C:\Scripts\0_SetNetworkProfile.ps1"

$test = Test-Path "C:\Scripts"
if ($test -eq $false)
{
    md "C:\Scripts"
}

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url1, $output1)

$wc.Dispose()

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel "Highest"
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -File "C:\Scripts\0_SetNetworkProfile.ps1"'
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -Action $action -Trigger $trigger -Settings (New-ScheduledTaskSettingsSet) -TaskName "NicConfiguration" -Description "Sets DNS address and network profile if needed" -Principal $principal

Start-ScheduleTask -TaskName "NicConfiguration"