SELECT
  Consumer_Key,
  LOWER(Communication_Address) AS Match_Key
FROM PDS_Communication
WHERE Communication_Address IS NOT NULL