SELECT
  bm.Consumer_Key,
  bm.Email_Address,
  bm.Phone_Number,
  bm.Brand_Code,
  bm.First_Name,
  bm.Consent_Status,
  bm.Unified_Consumer_Key,
  bm.First_BM_InteractionDate
FROM BM_Email_FullAudience_OptIn_WithBounces bm
LEFT JOIN HIL_WebPower_ExclusionList wel
    ON bm.Email_Address = wel.EmailAddress
WHERE wel.EmailAddress IS NULL