$m = Mount-DiskImage -ImagePath "C:\Installers\VS2013PremiumU5\en_visual_studio_premium_2013_with_update_5_x86_dvd_6815742.iso" -PassThru

Dismount-DiskImage -ImagePath $m.ImagePath

Remove-Item -Path "C:\Installers\VS2013PremiumU5\en_visual_studio_premium_2013_with_update_5_x86_dvd_6815742.iso" -Force
Remove-Item -Path "C:\Installers\AdminDeployment.xml"