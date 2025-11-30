function Get-EndpointInventory {
    <#
    .SYNOPSIS
        Returns basic endpoint inventory.
    .DESCRIPTION
        Wraps CIM calls so they can be reused across scripts or runbooks.
    #>
    [CmdletBinding()]
    param()

    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    $os            = Get-CimInstance -ClassName Win32_OperatingSystem
    $bios          = Get-CimInstance -ClassName Win32_BIOS

    [PSCustomObject]@{
        ComputerName = $env:COMPUTERNAME
        Manufacturer = $computerSystem.Manufacturer
        Model        = $computerSystem.Model
        SerialNumber = $bios.SerialNumber
        OSName       = $os.Caption
        OSVersion    = $os.Version
        OSBuild      = $os.BuildNumber
    }
}

function Set-EndpointSecurityBaseline {
    <#
    .SYNOPSIS
        Applies a simple security baseline to the local machine.
    .DESCRIPTION
        Example wrapper that could be extended for more complex baselines.
    #>
    [CmdletBinding()]
    param()

    # Ensure Defender and firewall are enabled
    Write-Verbose "Enforcing Defender + firewall baseline..."
    Set-MpPreference -DisableRealtimeMonitoring $false

    Get-NetFirewallProfile | ForEach-Object {
        if (-not $_.Enabled) {
            Set-NetFirewallProfile -Name $_.Name -Enabled True
        }
    }

    Write-Output "Security baseline applied."
}
