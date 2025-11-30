<#
.SYNOPSIS
    Collects basic Windows device inventory and saves to CSV and JSON.
.DESCRIPTION
    Gathers hardware, OS, disk, and installed application info.
    Designed to be run as a one-off inventory script or scheduled task.
#>

[CmdletBinding()]
param(
    [string]$OutputFolder = "C:\Temp\Inventory"
)

# Ensure output folder exists
if (-not (Test-Path -Path $OutputFolder)) {
    New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null
}

$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
$os            = Get-CimInstance -ClassName Win32_OperatingSystem
$bios          = Get-CimInstance -ClassName Win32_BIOS
$disks         = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"

$diskInfo = $disks | Select-Object `
    DeviceID,
    @{Name="SizeGB";Expression={[math]::Round($_.Size / 1GB, 2)}},
    @{Name="FreeGB";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}

$installedApps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*,
                                      HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
    -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

$inventory = [PSCustomObject]@{
    ComputerName     = $env:COMPUTERNAME
    Manufacturer     = $computerSystem.Manufacturer
    Model            = $computerSystem.Model
    SerialNumber     = $bios.SerialNumber
    OSName           = $os.Caption
    OSVersion        = $os.Version
    OSBuild          = $os.BuildNumber
    LastBootUpTime   = $os.LastBootUpTime
    TotalPhysicalGB  = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
    Disks            = $diskInfo
    InstalledApps    = $installedApps
    Timestamp        = (Get-Date)
}

# Export
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$jsonPath  = Join-Path $OutputFolder "Inventory_$($env:COMPUTERNAME)_$timestamp.json"
$csvPath   = Join-Path $OutputFolder "InstalledApps_$($env:COMPUTERNAME)_$timestamp.csv"

$inventory | ConvertTo-Json -Depth 5 | Out-File -FilePath $jsonPath -Encoding UTF8
$installedApps | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Host "Inventory written to:"
Write-Host "JSON: $jsonPath"
Write-Host "CSV : $csvPath"
