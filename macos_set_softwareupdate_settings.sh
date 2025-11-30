#!/bin/zsh
# Configures basic software update settings.

# Enable automatic check for updates
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download new updates when available
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true

# Enable app auto-updates from App Store
defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

# Trigger background check
softwareupdate --schedule on

echo "Software update settings applied."
