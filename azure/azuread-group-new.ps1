# Install the Azure PowerShell module
# httPS:>//docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0
# References:
# - https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0#groups
# - https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0#users

# Dependencies:
#   Set user environment variable:and see them:
#     PS:> [Environment]::SetEnvironmentVariable("name", "value", "User")
#     PS:> Get-ChildItem env:
#   Modules: AzureAD

# Previous insert user credentials in systen environment variables
$user = "$($env:script_user)"
$pass =  "$($env:script_pass)"

$azgroups = @("group01","group02")
$azgroupowneremail = "name@domain.com"

Try {
    # Auth
    $securepass = $pass | ConvertTo-SecureString -AsPlainText -Force
    $UserCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $securepass
    Connect-AzureAD -Credential $UserCredential

    # Get owner ObjectId
    $azgroupowner = Get-AzureADUser -ObjectId "$azgroupowneremail"

    Foreach ($g in $azgroups)
    {
        $adgroup = Get-AzureADGroup -Filter "DisplayName eq '$g'"
        If(($adgroup).ObjectId) { 
            Write-Host -Foreground DarkYellow "$(Get-Date) - Group $g already exists"
            Continue
        }
        # Create group
        $azgroup = New-AzureADGroup -DisplayName $g -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
        Write-Host "$(Get-Date) - Group $($g) created"

        # Add owner
        Add-AzureADGroupOwner -ObjectId ($azgroup).ObjectId -RefObjectId ($azgroupowner).ObjectId
        Write-Host "$(Get-Date) - Add $azgroupowneremail as group owner"
    }
}
Catch {
    $formatstring = "{0} : {1}`n{2}`n" +
                    "    + CategoryInfo          : {3}`n" +
                    "    + FullyQualifiedErrorId : {4}`n"
    $fields = $_.InvocationInfo.MyCommand.Name, $_.ErrorDetails.Message,
            $_.InvocationInfo.PositionMessage, $_.CategoryInfo.ToString(),
            $_.FullyQualifiedErrorId

    Write-Host -Foreground Red ($formatstring -f $fields)
    Break
}
Finally {
    Write-Host -Foreground Green -Background Black "$(Get-Date) - End of the script. $count processed repositories"
}