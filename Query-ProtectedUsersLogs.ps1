
<#
    .Description
    Query events related to protectedUsers for each DC
#>


$domain = Get-ADDomain
$dcList = Get-ADComputer -SearchBase $domain.DomainControllersContainer -filter *


$EventID = @()
$EventID += [pscustomobject]@{ ID = "104" ; "Logname"= "Microsoft-Windows-Authentication/ProtectedUser-Client"}
$EventID += [pscustomobject]@{ ID = "304" ; "Logname"= "Microsoft-Windows-Authentication/ProtectedUser-Client"}
$EventID += [pscustomobject]@{ ID = "100" ; "Logname"= "Microsoft-Windows-Authentication/ProtectedUserFailures-DomainController"}
$EventID += [pscustomobject]@{ ID = "104" ; "Logname"= "Microsoft-Windows-Authentication/ProtectedUserFailures-DomainController"}
$EventID += [pscustomobject]@{ ID = "303" ; "Logname"= "Microsoft-Windows-Authentication/ProtectedUserSuccesses-DomainController"}


$report += $EventID | %{ 
    Get-WinEvent -ComputerName $dcList -FilterHashtable @{Logname=$_.Logname;Id=$_.ID; StartTime=(get-date).AddHours("-24")}
    } | Export-Csv protectedUsersEvents.csv -Encoding Unicode
