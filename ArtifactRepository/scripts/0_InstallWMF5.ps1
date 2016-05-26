param
(
    [string]$pointless = " "
)

wusa Win8.1AndW2K12R2-KB3134758-x64.msu /quiet /forcerestart | out-null