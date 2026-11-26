SELECT
  ma.Consumer_Key,
  ma.Email_Address,
  ma.Phone_Number,
  ma.Brand_Code,
  ma.First_Name,
  ma.Consent_Status,
  ma.Unified_Consumer_Key,
  ma.First_Madri_InteractionDate
FROM Madri_Email_FullAudience_WithOptOuts ma
INNER JOIN OT_IRELAND_PROD_TABLE_IRELANDMARKETING_Transformed otim
    ON ma.Email_Address = otim.identifier
INNER JOIN OT_IRELAND_PROD_TABLE_MADRI_Transformed otma
    ON ma.Email_Address = otma.identifier
WHERE otim.option_status = 'CONFIRMED'
    AND otma.option_status = 'CONFIRMED'