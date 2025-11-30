# Client Platform Engineering Samples

This repository contains cross-platform samples for client / endpoint engineering across:

- Windows (Intune, Defender, firewall baselines, proactive remediation)
- macOS (Jamf extension attributes, inventory, update management)
- iOS / Android (Managed App Config examples)
- Entra ID & Intune (Graph automation: compliance exports, conditional access)
- FleetDM / osquery (enrollment scripts and query packs)

## Structure

- `windows/` – PowerShell scripts for inventory and remediation
- `macos/` – Bash scripts and Jamf EA for macOS
- `entra-intune/` – Microsoft Graph automation samples
- `ios-android/` – Managed App Configuration examples
- `fleetdm/` – FleetDM enrollment and osquery queries
- `common/` – Utility scripts used across platforms

### Intune Proactive Remediation Samples

- `Intune-ProactiveRemediation-ClearTeamsCache-Detect.ps1` – Detection script that signals when Teams cache cleanup is required.
- `Intune-ProactiveRemediation-ClearTeamsCache.ps1` – Remediation script that safely clears per-user Teams cache.

### Jamf Configuration Profile Example

- `jamf_password_policy_example.plist` – Example plist payload for a password policy configuration profile, designed for upload into Jamf Pro.

### FleetDM / osquery Packs

- `queries/*.sql` – Individual queries for disk encryption, Defender status, local admins, outdated OS, and firewall status.
- `security_hardening_pack.yml` – Example osquery pack bundling multiple security posture checks.

Each script is documented with comments describing its purpose and usage.
