SELECT
  hnk.Consumer_Key,
  hnk.Email_Address,
  hnk.Phone_Number,
  hnk.Brand_Code,
  hnk.First_Name,
  hnk.Consent_Status,
  hnk.Unified_Consumer_Key,
  hnk.Music_Interest,
  hnk.Sports_Interest,
  hnk.Branding_Interest,
  hnk.First_HNK_InteractionDate
FROM HNK_Email_FullAudience_OptIn_WithBounces hnk
LEFT JOIN HIL_WebPower_ExclusionList wel
    ON hnk.Email_Address = wel.EmailAddress
WHERE wel.EmailAddress IS NULL