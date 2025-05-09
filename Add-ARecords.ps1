param (
    [string]$ZoneName = "example.local"  # Replace with your actual DNS domain
)

# A records to create
$aRecords = @(
    @{ Name = "DDData";   IP = "10.0.1.20" },
    @{ Name = "DDIMGT";   IP = "10.0.2.20" },
    @{ Name = "PrivLin1"; IP = "10.0.1.12" },
    @{ Name = "PubLin1";  IP = "10.0.0.12" },
    @{ Name = "TSG";      IP = "10.0.0.13" }
)

# Loop and create A records
foreach ($record in $aRecords) {
    Write-Host "Creating A record: $($record.Name) -> $($record.IP)"
    Add-DnsServerResourceRecordA -Name $record.Name -ZoneName $ZoneName -IPv4Address $record.IP -TimeToLive 01:00:00 -ErrorAction Stop
}

Write-Host "`n? All A records added successfully to zone: $ZoneName"

 
