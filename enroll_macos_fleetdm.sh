#!/bin/zsh
# Enroll macOS device into FleetDM using the provided enroll secret and server URL.

FLEET_URL="https://fleet.yourcompany.com"
ENROLL_SECRET="REPLACE_WITH_SECRET"
FLEETCTL_PKG="/tmp/fleet-osquery.pkg"

if [ ! -f "$FLEETCTL_PKG" ]; then
  echo "Please place fleet-osquery.pkg at $FLEETCTL_PKG before running."
  exit 1
fi

/usr/sbin/installer -pkg "$FLEETCTL_PKG" -target /

# Create secret file
mkdir -p /var/osquery
echo "$ENROLL_SECRET" > /var/osquery/osquery.enroll_secret
chmod 600 /var/osquery/osquery.enroll_secret

# Configure osquery
cat <<EOF >/var/osquery/osquery.conf
{
  "options": {
    "config_plugin": "tls",
    "logger_plugin": "tls",
    "tls_hostname": "$FLEET_URL",
    "enroll_tls_endpoint": "/api/osquery/enroll",
    "config_tls_endpoint": "/api/osquery/config",
    "logger_tls_endpoint": "/api/osquery/log",
    "disable_distributed": "false"
  }
}
EOF

chmod 600 /var/osquery/osquery.conf

# Start service (depending on install, may be launchd)
launchctl load /Library/LaunchDaemons/com.facebook.osqueryd.plist 2>/dev/null || true
launchctl start com.facebook.osqueryd 2>/dev/null || true

echo "Enrollment attempted. Check Fleet console for this host."
