#!/bin/zsh
# Collects key macOS inventory details.

OUTPUT_DIR="/var/log/client-platform"
mkdir -p "$OUTPUT_DIR"

HOSTNAME=$(scutil --get ComputerName)
SERIAL=$(system_profiler SPHardwareDataType | awk -F": " '/Serial Number/{print $2}')
OS_VERSION=$(sw_vers -productVersion)
OS_BUILD=$(sw_vers -buildVersion)
MODEL=$(system_profiler SPHardwareDataType | awk -F": " '/Model Identifier/{print $2}')
FDE_ENABLED=$(fdesetup status | grep -qi "FileVault is On" && echo "On" || echo "Off")

# Get list of installed profiles (MDM, etc.)
PROFILES=$(profiles list -output stdout 2>/dev/null | awk '{$1=$1};1')

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
OUTPUT_FILE="$OUTPUT_DIR/inventory_${HOSTNAME}_$(date +%Y%m%d-%H%M%S).txt"

cat <<EOF > "$OUTPUT_FILE"
{
  "hostname": "$HOSTNAME",
  "serial": "$SERIAL",
  "model_identifier": "$MODEL",
  "os_version": "$OS_VERSION",
  "os_build": "$OS_BUILD",
  "filevault": "$FDE_ENABLED",
  "timestamp_utc": "$TIMESTAMP",
  "profiles_raw": $(printf '%s\n' "$PROFILES" | jq -Rs '.')
}
EOF

echo "Inventory written to $OUTPUT_FILE"
