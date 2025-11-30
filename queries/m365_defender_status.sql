-- Basic Microsoft Defender status on Windows
SELECT
  hostname,
  av_product_name,
  av_product_state
FROM windows_security_center;
