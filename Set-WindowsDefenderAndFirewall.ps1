<#
.SYNOPSIS
    Ensures Microsoft Defender AV and Windows Firewall are enabled.
#>

# Ensure Defender real-time protection is on
$defender = Get-MpPreference
if (-not $defender.DisableRealtimeMonitoring) {
    Write-Host "Defender real-time protection already enabled."
} else {
    Write-Host "Enabling Defender real-time protection..."
    Set-MpPreference -DisableRealtimeMonitoring $false
}

# Ensure firewall enabled on all profiles
$profiles = Get-NetFirewallProfile
foreach ($profile in $profiles) {
    if (-not $profile.Enabled) {
        Write-Host "Enabling firewall for profile: $($profile.Name)"
        Set-NetFirewallProfile -Name $profile.Name -Enabled True
    } else {
        Write-Host "Firewall already enabled for profile: $($profile.Name)"
    }
}
