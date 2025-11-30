<#
.SYNOPSIS
    Detection script for Intune Proactive Remediation:
    Detects whether Teams classic cache exists and should be cleaned.
.DESCRIPTION
    - Exit 0 = Compliant, no remediation needed
    - Exit 1 = Not compliant, remediation should run
#>

$profilesRoot = 'C:\Users'
$nonCompliant = $false

Get-ChildItem $profilesRoot -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $userProfile = $_.FullName
    $teamsPath   = Join-Path $userProfile 'AppData\Roaming\Microsoft\Teams'

    if (Test-Path $teamsPath) {
        # Look for one or more of the known cache folders
        $pathsToCheck = @(
            "application cache\cache",
            "blob_storage",
            "Cache",
            "databases",
            "GPUCache",
            "IndexedDB",
            "Local Storage",
            "tmp"
        )

        foreach ($relativePath in $pathsToCheck) {
            $fullPath = Join-Path $teamsPath $relativePath
            if (Test-Path $fullPath) {
                Write-Host "Found Teams cache path: $fullPath"
                $nonCompliant = $true
            }
        }
    }
}

if ($nonCompliant) {
    Write-Host "Teams cache detected. Device NOT compliant. Remediation required."
    exit 1
} else {
    Write-Host "No Teams cache paths detected. Device compliant."
    exit 0
}
