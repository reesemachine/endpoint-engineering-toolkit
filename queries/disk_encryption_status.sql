-- Disk encryption status across Windows and macOS
SELECT
  hostname,
  platform,
  CASE
    WHEN platform = 'darwin' THEN
      (SELECT encryption_status FROM disk_encryption)
    WHEN platform = 'windows' THEN
      (SELECT protection_status FROM bitlocker_info)
    ELSE 'unknown'
  END AS encryption_status
FROM system_info;
