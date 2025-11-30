<#
.SYNOPSIS
    Creates a simple Conditional Access policy template:
    Require MFA for all cloud apps for a specific group, excluding compliant devices.
#>

param(
    [Parameter(Mandatory)]
    [string]$TargetGroupId
)

Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess","Directory.Read.All"
Select-MgProfile -Name "beta"

$policyBody = @{
    displayName = "Require MFA for Cloud Apps - Portfolio Example"
    state       = "disabled"   # Start disabled for safety
    conditions  = @{
        users = @{
            includeGroups = @($TargetGroupId)
            excludeGuestsOrExternalUsers = @{
                guestOrExternalUserTypes = @("externalGuest","b2bCollaborationGuest")
            }
        }
        applications = @{
            includeApplications = @("All")
        }
        clientAppTypes = @("browser","mobileAppsAndDesktopClients")
    }
    grantControls = @{
        operator = "OR"
        builtInControls = @("mfa")
    }
    sessionControls = @{
        signInFrequency = @{
            isEnabled = $true
            value     = 12
            type      = "hours"
        }
    }
}

$newPolicy = Invoke-MgGraphRequest -Method POST `
    -Uri "https://graph.microsoft.com/beta/identity/conditionalAccess/policies" `
    -Body ($policyBody | ConvertTo-Json -Depth 10) `
    -ContentType "application/json"

Write-Host "Created Conditional Access policy with id: $($newPolicy.id)"
Disconnect-MgGraph
