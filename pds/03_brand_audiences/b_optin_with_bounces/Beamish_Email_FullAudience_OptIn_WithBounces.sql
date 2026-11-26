SELECT
  be.Consumer_Key,
  be.Email_Address,
  be.Phone_Number,
  be.Brand_Code,
  be.First_Name,
  be.Consent_Status,
  be.Unified_Consumer_Key,
  be.First_Beamish_InteractionDate
FROM Beamish_Email_FullAudience_WithOptOuts be
INNER JOIN OT_IRELAND_PROD_TABLE_IRELANDMARKETING_Transformed otim
    ON be.Email_Address = otim.identifier
INNER JOIN OT_IRELAND_PROD_TABLE_BEAMISH_Transformed otbe
    ON be.Email_Address = otbe.identifier
WHERE otim.option_status = 'CONFIRMED'
    AND otbe.option_status = 'CONFIRMED'