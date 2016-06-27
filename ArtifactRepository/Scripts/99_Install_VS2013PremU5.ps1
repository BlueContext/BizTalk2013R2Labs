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

$url1 = "http://10.71.184.182:8089/Installers/VS2013PremiumU5/en_visual_studio_premium_2013_with_update_5_x86_dvd_6815742.iso"
$url2 = "http://10.71.184.182:8089/Installers/VS2013PremiumU5/AdminDeployment.xml"
$output1 = "C:\Installers\en_visual_studio_premium_2013_with_update_5_x86_dvd_6815742.iso"
$output2 = "C:\Installers\AdminDeployment.xml"

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

$m = Mount-DiskImage -Verbose -StorageType "ISO" -ImagePath "C:\Installers\en_visual_studio_premium_2013_with_update_5_x86_dvd_6815742.iso" -PassThru
$vol = Get-DiskImage -ImagePath $m.ImagePath | Get-Volume
$drive = $vol.DriveLetter

$filepath = $drive + ":\vs_premium.exe"
[string]$VsArgs = "/AdminFile C:\Installers\AdminDeployment.xml /quiet /norestart"
Start-Process -FilePath $filepath -ArgumentList $VsArgs -Wait -RedirectStandardOutput VsInstaller.txt -RedirectStandardError VsErrors.txt

Dismount-DiskImage -ImagePath $m.ImagePath

Remove-Item -Path "C:\Installers\VS2013PremiumU5\en_visual_studio_premium_2013_with_update_5_x86_dvd_6815742.iso" -Force
Remove-Item -Path "C:\Installers\AdminDeployment.xml"