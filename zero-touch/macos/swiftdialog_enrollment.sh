#!/bin/zsh
# SwiftDialog-based macOS enrollment UI

DIALOG="/usr/local/bin/dialog"
CONFIG="/var/tmp/swiftdialog_config.json"
LOG="/var/tmp/swiftdialog_enrollment.log"

# Ensure SwiftDialog is installed (usually via MDM policy)
if [ ! -x "$DIALOG" ]; then
  echo "SwiftDialog not installed. Triggering MDM policy..." | tee -a "$LOG"
  /usr/local/bin/jamf policy -event install_swiftdialog
fi

# Write config
cat <<EOF > "$CONFIG"
{
  "title": "YourCompany macOS Setup",
  "message": "We’re securing and configuring your Mac. This will only take a few minutes.",
  "icon": "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarCustomizeIcon.icns",
  "quitKey": "command+q",
  "progressBar": true
}
EOF

# Launch dialog with progress bar
"$DIALOG" --jsonfile "$CONFIG" --progress 0 &
DIALOG_PID=$!

update_progress() {
  local p=$1
  local m=$2
  echo "progress: $p"   >> /var/tmp/dialog.log
  echo "progresstext: $m" >> /var/tmp/dialog.log
}

sleep 2
update_progress 10 "Checking enrollment state..."
# (Add checks for profiles, MDM status, etc.)

update_progress 30 "Installing core applications..."
/usr/local/bin/jamf policy -event install_core_apps

update_progress 60 "Applying security baselines..."
/usr/local/bin/jamf policy -event apply_security_baseline

update_progress 80 "Running post-enrollment tasks..."
/var/tmp/post_enrollment_tasks.sh

update_progress 100 "Setup complete. You can start using your Mac."

sleep 2
kill "$DIALOG_PID" 2>/dev/null || true

echo "SwiftDialog enrollment workflow completed." | tee -a "$LOG"
