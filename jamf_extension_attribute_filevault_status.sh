#!/bin/zsh
# Jamf Extension Attribute: FileVault Status

FDE_STATUS=$(fdesetup status)

if echo "$FDE_STATUS" | grep -qi "FileVault is On"; then
  RESULT="On"
elif echo "$FDE_STATUS" | grep -qi "FileVault is Off"; then
  RESULT="Off"
else
  RESULT="Unknown"
fi

echo "<result>$RESULT</result>"
