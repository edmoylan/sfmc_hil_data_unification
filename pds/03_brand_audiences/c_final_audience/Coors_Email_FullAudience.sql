SELECT
  co.Consumer_Key,
  co.Email_Address,
  co.Phone_Number,
  co.Brand_Code,
  co.First_Name,
  co.Consent_Status,
  co.Unified_Consumer_Key,
  co.First_Coors_InteractionDate
FROM Coors_Email_FullAudience_OptIn_WithBounces co
LEFT JOIN HIL_WebPower_ExclusionList wel
    ON co.Email_Address = wel.EmailAddress
WHERE wel.EmailAddress IS NULL