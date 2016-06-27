param
(
    [string]$pointless = " "
)

function Resolve-Error ($ErrorRecord=$Error[0])
{
   $ErrorRecord | Format-List * -Force
   $ErrorRecord.InvocationInfo |Format-List *
   $Exception = $ErrorRecord.Exception
   for ($i = 0; $Exception; $i++, ($Exception = $Exception.InnerException))
   {   "$i" * 80
       $Exception |Format-List * -Force
   }
}

$url1 = "http://gthou-wwsvc01d.energy.sug.pri:8089/Installers/SQL2014SP1DevEdition/en_sql_server_2014_developer_edition_with_service_pack_1_x64_dvd_6668542.iso"
$url2 = "http://gthou-wwsvc01d.energy.sug.pri:8089/Installers/SQL2014SP1DevEdition/ConfigurationFile.ini"
$output1 = "C:\Installers\en_sql_server_2014_developer_edition_with_service_pack_1_x64_dvd_6668542.iso"
$output2 = "C:\Installers\ConfigurationFile.ini"

$test = Test-Path "C:\Installers"
if ($test -eq $false)
{
    md "C:\Installers"
}


$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url1, $output1)
$wc.DownloadFile($url2, $output2) 

$wc.Dispose()

Start-Sleep -Seconds 180

$m = Mount-DiskImage -Verbose -StorageType "ISO" -ImagePath "C:\Installers\en_sql_server_2014_developer_edition_with_service_pack_1_x64_dvd_6668542.iso" -PassThru
$vol = Get-DiskImage -ImagePath $m.ImagePath | Get-Volume
$drive = $vol.DriveLetter

$filepath = $drive + ":\setup.exe"
[string]$VsArgs = '/ConfigurationFile="C:\Installers\ConfigurationFile.ini"'
Start-Process -FilePath $filepath -ArgumentList $VsArgs -Wait -RedirectStandardOutput VsInstaller.txt -RedirectStandardError VsErrors.txt

Dismount-DiskImage -ImagePath $m.ImagePath

Remove-Item -Path "C:\Installers\VS2013PremiumU5\en_sql_server_2014_developer_edition_with_service_pack_1_x64_dvd_6668542.iso" -Force
Remove-Item -Path "C:\Installers\ConfigurationFile.ini"