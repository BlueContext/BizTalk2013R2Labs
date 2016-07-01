#
# Main.ps1
#



Set-ExecutionPolicy Bypass -Force

md D:\ConfigurationScripts

$urls = @()
$urls += "http://gthou-wwsvc01d.energy.sug.pri:8089/MO_Scripts/0_InstallWmf5.ps1"
$urls += "http://gthou-wwsvc01d.energy.sug.pri:8089/MO_Scripts/1_ConfigurePmAndDsc.ps1"


.\0_InstallWmf5.ps1 -Verbose



Set-ExecutionPolicy RemoteSigned -Force