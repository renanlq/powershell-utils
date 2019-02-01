# Install the Azure PowerShell module
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0

# Set user environment variable
# PS: [Environment]::SetEnvironmentVariable("name", "value", "User")
# See all env variables
# PS: Get-ChildItem env:

# Previous insert user credentials in systen environment variables
# $user = "$($env:script_user)"
# $pass =  "$($env:script_pass)"

# $securepass = $pass | ConvertTo-SecureString -AsPlainText -Force
# $userCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $securepass

# Manual credentials
$userCredential = Get-Credential
Connect-AzAccount -Credential $userCredential
