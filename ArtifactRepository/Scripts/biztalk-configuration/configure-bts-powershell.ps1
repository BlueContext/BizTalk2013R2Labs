#Put this in an invoke-command structure
C:\Program Files (x86)\Microsoft BizTalk Server 2013 R2\SDK\Utilities\PowerShell>"C:\windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe" BizTalkFactory.PowerShell.Extensions.Dll


#in 32-BIT PowerShell ONLY!!!, run 
Add-PsSnapin -Name BiztalkFactory.PowerShell.Extensions
get-command -module BizTalk*

#there is also a BizTalk PSProvider:
Get-PsProvider
cd BizTalk: