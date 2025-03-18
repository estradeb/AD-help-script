
<#
    .Description
    Query NTLM events  for each DC
#>


$domain = Get-ADDomain
$dcList = Get-ADComputer -SearchBase $domain.DomainControllersContainer -filter *

$EventID = @()
$EventID += [pscustomobject]@{ ID = "8001" ; "Logname"= "Microsoft-Windows-NTLM/Operational"}
$EventID += [pscustomobject]@{ ID = "8003" ; "Logname"= "Microsoft-Windows-NTLM/Operational"}
$EventID += [pscustomobject]@{ ID = "8004" ; "Logname"= "Microsoft-Windows-NTLM/Operational"}



$report += $EventID | %{ 
    Get-WinEvent -ComputerName $dcList -FilterHashtable @{Logname=$_.Logname;Id=$_.ID; StartTime=(get-date).AddHours("-24")}
    } | Export-Csv protectedUsersEvents.csv -Encoding Unicode
