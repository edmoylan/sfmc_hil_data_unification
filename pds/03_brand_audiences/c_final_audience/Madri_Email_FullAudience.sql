SELECT
  ma.Consumer_Key,
  ma.Email_Address,
  ma.Phone_Number,
  ma.Brand_Code,
  ma.First_Name,
  ma.Consent_Status,
  ma.Unified_Consumer_Key,
  ma.First_Madri_InteractionDate
FROM Madri_Email_FullAudience_OptIn_WithBounces ma
LEFT JOIN HIL_WebPower_ExclusionList wel
    ON ma.Email_Address = wel.EmailAddress
WHERE wel.EmailAddress IS NULL