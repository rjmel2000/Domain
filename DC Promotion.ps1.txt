<powershell>
# 1. Install SSM Agent
$region = (Invoke-RestMethod -Uri http://169.254.169.254/latest/dynamic/instance-identity/document).region
$ssmUrl = "https://s3.amazonaws.com/amazon-ssm-$region/latest/windows_amd64/AmazonSSMAgentSetup.exe"
Invoke-WebRequest -Uri $ssmUrl -OutFile "$env:TEMP\AmazonSSMAgentSetup.exe"
Start-Process "$env:TEMP\AmazonSSMAgentSetup.exe" -ArgumentList '/quiet' -NoNewWindow -Wait

# 2. Install AD DS and DNS roles
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-WindowsFeature DNS

# 3. Promote to domain controller
$domainName = "dobidoo.com"
$adminPass = ConvertTo-SecureString "N0virus@123" -AsPlainText -Force
$params = @{
    DomainName = $domainName
    SafeModeAdministratorPassword = $adminPass
    InstallDNS = $true
    Force = $true
}
Install-ADDSForest @params

# Create script folder to add user
New-Item -Path "C:\Scripts" -ItemType Directory -Force | Out-Null

# Define script path
$PostScriptPath = "C:\Scripts\PostDomainJoin.ps1"

# Write domain join user creation logic (includes internal delay)
@'
Start-Sleep -Seconds 90  # Wait longer to ensure AD DS is up

# Log file to track if script ran
$Log = "C:\Scripts\PostDomainJoin.log"
"[$(Get-Date)] Starting PostDomainJoin.ps1" | Out-File -Append $Log

# Load Active Directory module
Import-Module ActiveDirectory -ErrorAction Stop

# Create domain user
$Username = "DomainJoin"
$Password = ConvertTo-SecureString "N0virus@123" -AsPlainText -Force

try {
    New-ADUser -Name $Username `
               -SamAccountName $Username `
               -AccountPassword $Password `
               -Enabled $true `
               -ChangePasswordAtLogon $false `
               -PasswordNeverExpires $true

    "[$(Get-Date)] User '$Username' created." | Out-File -Append $Log

    # Add to Domain Admins group
    Add-ADGroupMember -Identity "Domain Admins" -Members $Username
    "[$(Get-Date)] User '$Username' added to Domain Admins." | Out-File -Append $Log

} catch {
    "[$(Get-Date)] ERROR: $_" | Out-File -Append $Log
}

</powershell>

