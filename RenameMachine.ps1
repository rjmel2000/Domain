param (
    [string]$NewName = "DC1"
)

# Check if running as Administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

# Relaunch script with elevation if not already elevated
if (-not $IsAdmin) {
Write-Host "This script must be run as Administrator. Relaunching elevated..."
$ScriptPath = $MyInvocation.MyCommand.Definition
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`" -NewName `"$NewName`"" -Verb RunAs
exit
}

# Rename the computer
Write-Host "Renaming computer to '$NewName'..."
Rename-Computer -NewName $NewName -Force -Restart

 
