-- Basic firewall status for macOS and Windows.

SELECT
  si.hostname,
  si.platform,
  CASE
    WHEN si.platform = 'darwin' THEN
      (SELECT
         CASE
           WHEN global_state = 1 THEN 'Enabled'
           ELSE 'Disabled'
         END
       FROM alf)
    WHEN si.platform = 'windows' THEN
      (SELECT
         CASE
           WHEN enabled = 1 THEN 'Enabled'
           ELSE 'Disabled'
         END
       FROM windows_firewall)
    ELSE 'Unknown'
  END AS firewall_status
FROM system_info si;
