Start-Sleep -Seconds 420

# Create domain user
$Username = "DomainJoin"
$Password = ConvertTo-SecureString "N0virus@123" -AsPlainText -Force

New-ADUser -Name $Username `
           -SamAccountName $Username `
           -AccountPassword $Password `
           -Enabled $true `
           -ChangePasswordAtLogon $false `
           -PasswordNeverExpires $true

# Add to Domain Admins
Add-ADGroupMember -Identity "Domain Admins" -Members $Username
 
