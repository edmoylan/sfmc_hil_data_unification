SELECT
  be.Consumer_Key,
  be.Email_Address,
  be.Phone_Number,
  be.Brand_Code,
  be.First_Name,
  be.Consent_Status,
  be.Unified_Consumer_Key,
  be.First_Beamish_InteractionDate
FROM Beamish_Email_FullAudience_OptIn_WithBounces be
LEFT JOIN HIL_WebPower_ExclusionList wel
    ON be.Email_Address = wel.EmailAddress
WHERE wel.EmailAddress IS NULL