SELECT
  orc.Consumer_Key,
  orc.Email_Address,
  orc.Phone_Number,
  orc.Brand_Code,
  orc.First_Name,
  orc.Consent_Status,
  orc.Unified_Consumer_Key,
  orc.First_Orchard_InteractionDate
FROM OT_Email_FullAudience_OptIn_WithBounces orc
LEFT JOIN HIL_WebPower_ExclusionList wel
    ON orc.Email_Address = wel.EmailAddress
WHERE wel.EmailAddress IS NULL