param (
    [string]$DomainName = "example.local"
)

# Reverse zones to create
$reverseZones = @(
    @{ Zone = "0.0.10.in-addr.arpa"; Network = "10.0.0.0" },
    @{ Zone = "1.0.10.in-addr.arpa"; Network = "10.0.1.0" },
    @{ Zone = "2.0.10.in-addr.arpa"; Network = "10.0.2.0" }
)

# PTR records
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

# Create reverse zones if not already present
foreach ($zone in $reverseZones) {
    if (-not (Get-DnsServerZone -Name $zone.Zone -ErrorAction SilentlyContinue)) {
        Write-Host "Creating reverse zone: $($zone.Zone)"
        Add-DnsServerPrimaryZone -ZoneName $zone.Zone -ZoneFile "$($zone.Zone).dns"
    } else {
        Write-Host "Zone $($zone.Zone) already exists — skipping."
    }
}




# Add PTR records
foreach ($record in $ptrRecords) {
    $ipParts = $record.IP.Split('.')
    $zoneName = "$($ipParts[2]).$($ipParts[1]).$($ipParts[0]).in-addr.arpa"
    $ptrName = "$($ipParts[3])"
    $fqdn = "$($record.Name).$DomainName."

    Write-Host "Adding PTR: $record.IP -> $fqdn"
    Add-DnsServerResourceRecordPtr -ZoneName $zoneName -Name $ptrName -PtrDomainName $fqdn -ErrorAction Stop
}

Write-Host "`n? Reverse zones and PTR records created successfully for domain: $DomainName"
 
