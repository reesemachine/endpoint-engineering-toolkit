-- Identify hosts running OS versions below a defined minimum.
-- Adjust min_* variables for your environment.
SELECT
  hostname,
  platform,
  os_version,
  CASE
    WHEN platform = 'darwin'  AND os_version < '13.0.0' THEN 'Outdated macOS'
    WHEN platform = 'windows' AND os_version < '10.0.19045' THEN 'Outdated Windows'
    ELSE 'OK'
  END AS status
FROM os_version;
