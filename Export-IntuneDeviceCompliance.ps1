<#
.SYNOPSIS
    Exports Intune device compliance states via Microsoft Graph.
#>

param(
    [string]$OutputPath = ".\Intune_DeviceCompliance.csv"
)

# Requires Microsoft.Graph.Intune or Graph modules to be installed and permissions granted.
Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All","DeviceManagementManagedDevices.Read.All"
Select-MgProfile -Name "beta"

$devices = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/managedDevices?`$top=999"

$results = @()

foreach ($device in $devices.value) {
    $results += [PSCustomObject]@{
        DeviceName           = $device.deviceName
        UPN                  = $device.userPrincipalName
        OS                   = $device.operatingSystem
        ComplianceState      = $device.complianceState
        JailBroken           = $device.jailBroken
        AzureADDeviceId      = $device.azureADDeviceId
        LastSyncDateTime     = $device.lastSyncDateTime
        ManagementAgent      = $device.managementAgent
    }
}

$results | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "Compliance export written to $OutputPath"
Disconnect-MgGraph
