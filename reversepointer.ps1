param (
    [string]$ZoneName = 'almost.net'
)

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "This script must be run as Administrator. Relaunching elevated..."
    $ScriptPath = $MyInvocation.MyCommand.Definition
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`" -ZoneName `"$ZoneName`"" -Verb RunAs
    exit
}

$reverseZones = @(
    @{ Zone = "0.0.10.in-addr.arpa"; Network = "10.0.0.0" },
    @{ Zone = "1.0.10.in-addr.arpa"; Network = "10.0.1.0" },
    @{ Zone = "2.0.10.in-addr.arpa"; Network = "10.0.2.0" }
)

$ptrRecords = @(
    @{ Name = "DC1";       IP = "10.0.1.10" },
    @{ Name = "PrivWin1";  IP = "10.0.1.11" },
    @{ Name = "PrivLin1";  IP = "10.0.1.12" },
    @{ Name = "DDData";    IP = "10.0.1.20" },
    @{ Name = "DDIMGT";    IP = "10.0.2.20" },
    @{ Name = "PubWin1";   IP = "10.0.0.11" },
    @{ Name = "PubLin1";   IP = "10.0.0.12" },
    @{ Name = "TSG";       IP = "10.0.0.13" }
)

foreach ($zone in $reverseZones) {
    if (-not (Get-DnsServerZone -Name $zone.Zone -ErrorAction SilentlyContinue)) {
        Write-Host "Creating reverse zone: $($zone.Zone)"
        Add-DnsServerPrimaryZone -ZoneName $zone.Zone -ZoneFile "$($zone.Zone).dns"
    } else {
        Write-Host "Zone $($zone.Zone) already exists — skipping."
    }
}

foreach ($record in $ptrRecords) {
    $ipParts = $record.IP.Split('.')
    $zoneName = "$($ipParts[2]).$($ipParts[1]).$($ipParts[0]).in-addr.arpa"
    $ptrName = "$($ipParts[3])"
    $fqdn = "$($record.Name).$ZoneName."

    Write-Host "Adding PTR: $($record.IP) -> $fqdn"
    Add-DnsServerResourceRecordPtr -ZoneName $zoneName -Name $ptrName -PtrDomainName $fqdn -ErrorAction Stop
}

Write-Host "`n✅ Reverse zones and PTR records created successfully for domain: $ZoneName"

#param (
    [string]$ZoneName = 'almost.net'
)

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "This script must be run as Administrator. Relaunching elevated..."
    $ScriptPath = $MyInvocation.MyCommand.Definition
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`" -ZoneName `"$ZoneName`"" -Verb RunAs
    exit
}

$reverseZones = @(
    @{ Zone = "0.0.10.in-addr.arpa"; Network = "10.0.0.0" },
    @{ Zone = "1.0.10.in-addr.arpa"; Network = "10.0.1.0" },
    @{ Zone = "2.0.10.in-addr.arpa"; Network = "10.0.2.0" }
)

$ptrRecords = @(
    @{ Name = "DC1";       IP = "10.0.1.10" },
    @{ Name = "PrivWin1";  IP = "10.0.1.11" },
    @{ Name = "PrivLin1";  IP = "10.0.1.12" },
    @{ Name = "DDData";    IP = "10.0.1.20" },
    @{ Name = "DDIMGT";    IP = "10.0.2.20" },
    @{ Name = "PubWin1";   IP = "10.0.0.11" },
    @{ Name = "PubLin1";   IP = "10.0.0.12" },
    @{ Name = "TSG";       IP = "10.0.0.13" }
)

foreach ($zone in $reverseZones) {
    if (-not (Get-DnsServerZone -Name $zone.Zone -ErrorAction SilentlyContinue)) {
        Write-Host "Creating reverse zone: $($zone.Zone)"
        Add-DnsServerPrimaryZone -ZoneName $zone.Zone -ZoneFile "$($zone.Zone).dns"
    } else {
        Write-Host "Zone $($zone.Zone) already exists — skipping."
    }
}

foreach ($record in $ptrRecords) {
    $ipParts = $record.IP.Split('.')
    $zoneName = "$($ipParts[2]).$($ipParts[1]).$($ipParts[0]).in-addr.arpa"
    $ptrName = "$($ipParts[3])"
    $fqdn = "$($record.Name).$ZoneName."

    Write-Host "Adding PTR: $($record.IP) -> $fqdn"
    Add-DnsServerResourceRecordPtr -ZoneName $zoneName -Name $ptrName -PtrDomainName $fqdn -ErrorAction Stop
}

Write-Host "`n✅ Reverse zones and PTR records created successfully for domain: $ZoneName"
#.\reverse.ps1 -ZoneName "<yourdomain.com>" to override or specify your domain
