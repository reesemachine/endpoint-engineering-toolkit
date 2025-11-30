<#
.SYNOPSIS
    Example script to enroll Windows into FleetDM.
#>

param(
    [Parameter(Mandatory)]
    [string]$FleetUrl,
    [Parameter(Mandatory)]
    [string]$EnrollSecret
)

$OSQUERY_DIR = "C:\Program Files\osquery"
$CONF_DIR    = "C:\Program Files\osquery"

if (-not (Test-Path $OSQUERY_DIR)) {
    Write-Host "Please install osquery before running this script."
    exit 1
}

# Write enroll secret
$secretPath = Join-Path $CONF_DIR "osquery.enroll_secret"
$EnrollSecret | Out-File -FilePath $secretPath -Encoding ascii -Force

# Write config
$configPath = Join-Path $CONF_DIR "osquery.conf"
$config = @{
    options = @{
        config_plugin          = "tls"
        logger_plugin          = "tls"
        tls_hostname           = $FleetUrl
        enroll_tls_endpoint    = "/api/osquery/enroll"
        config_tls_endpoint    = "/api/osquery/config"
        logger_tls_endpoint    = "/api/osquery/log"
        disable_distributed    = "false"
    }
} | ConvertTo-Json -Depth 5

$config | Out-File -FilePath $configPath -Encoding ascii -Force

Write-Host "Configuration written. Ensure osqueryd service is running."
