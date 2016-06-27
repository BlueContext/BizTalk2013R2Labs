[string[]]$files = @("create-ad-groups.ps1","create-ad-svcaccts.ps1","create-ad-users.ps1","import_create_ad_groups.csv","import_create_ad_svcaccts.csv","import_create_ad_users.csv")
[string[]]$scripts = @("create-ad-groups.ps1","create-ad-svcaccts.ps1","create-ad-users.ps1")
New-Item C:\DSC\ADscripts -ItemType Directory
Set-Location C:\DSC\ADscripts
$i = 0
foreach($f in $files)
{
    $url = "http://10.71.184.182:8089/Scripts/populate-ad/$f"
    $destination = "C:\DSC\ADscripts\$f"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $destination)
    $wc.Dispose()
    $i++
}
Start-Sleep -Seconds 20
foreach($s in $scripts)
{
    $commandText = "./" + $s + " -Wait"
    $command = [scriptblock]::create($commandText) 
    Invoke-Command -ScriptBlock $command
}