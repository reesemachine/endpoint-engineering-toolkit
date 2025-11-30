<#
.SYNOPSIS
    Clears Microsoft Teams classic cache for all user profiles.
.DESCRIPTION
    Intended as an Intune Proactive Remediation "Remediation" script.
    Safely removes Teams cache while leaving login tokens intact.
#>

$profilesRoot = 'C:\Users'

Get-ChildItem $profilesRoot -Directory | ForEach-Object {
    $userProfile = $_.FullName
    $teamsPath   = Join-Path $userProfile 'AppData\Roaming\Microsoft\Teams'

    if (Test-Path $teamsPath) {
        Write-Host "Found Teams profile at $teamsPath"

        $pathsToRemove = @(
            "application cache\cache",
            "blob_storage",
            "Cache",
            "databases",
            "GPUCache",
            "IndexedDB",
            "Local Storage",
            "tmp"
        )

        foreach ($relativePath in $pathsToRemove) {
            $fullPath = Join-Path $teamsPath $relativePath
            if (Test-Path $fullPath) {
                Write-Host "Removing $fullPath"
                Remove-Item -Path $fullPath -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
}
