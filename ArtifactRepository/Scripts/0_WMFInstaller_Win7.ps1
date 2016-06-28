param
(
    [string]$pointless = " "
)
Set-ExecutionPolicy Bypass -Force

#wusa Win8.1AndW2K12R2-KB3134758-x64.msu /quiet /norestart | out-null
Win7AndW2K8R2-KB3134760-x64.msu /quiet /forcerestart | out-null