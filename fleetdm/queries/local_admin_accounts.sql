-- List local admin accounts on macOS and Windows.
SELECT
  si.hostname,
  u.username,
  u.uid,
  u.gid,
  u.description
FROM users u
JOIN system_info si
WHERE u.uid = 0
   OR u.username IN (
       SELECT username
       FROM user_groups
       WHERE groupname IN ('admin', 'Administrators')
   );
