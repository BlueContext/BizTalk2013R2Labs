[string[]]$features = @("File-Services","FS-FileServer","FS-DFS-Namespace","FS-DFS-Replication","FS-Resource-Manager","RSAT-File-Services","RSAT-DFS-Mgmt-Con","RSAT-FSRM-Mgmt","RSAT-CoreFile-Mgmt")

foreach ($f in $features) {
    Add-WindowsFeature $f
} 

Import-Module DFSN

#Create Directories 
# -- this needs to be a parameterized function; what's here is just a placeholder.

F