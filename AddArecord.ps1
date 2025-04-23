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

$aRecords = @(
    @{ Name = "DDData";   IP = "10.0.1.20" },
    @{ Name = "DDIMGT";   IP = "10.0.2.20" },
    @{ Name = "PrivLin1"; IP = "10.0.1.12" },
    @{ Name = "PubLin1";  IP = "10.0.0.12" },
    @{ Name = "TSG";      IP = "10.0.0.13" }
)

foreach ($record in $aRecords) {
    Write-Host "Creating A record: $($record.Name) -> $($record.IP)"
    Add-DnsServerResourceRecordA -Name $record.Name -ZoneName $ZoneName -IPv4Address $record.IP -TimeToLive 01:00:00 -ErrorAction Stop
}

Write-Host "`n✅ All A records added successfully to zone: $ZoneName"
#.\AddArecord.ps1 -ZoneName "yourdomain.com>" to override or explicit the domain name
