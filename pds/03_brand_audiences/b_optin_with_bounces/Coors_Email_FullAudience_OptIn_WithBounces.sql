SELECT
  co.Consumer_Key,
  co.Email_Address,
  co.Phone_Number,
  co.Brand_Code,
  co.First_Name,
  co.Consent_Status,
  co.Unified_Consumer_Key,
  co.First_Coors_InteractionDate
FROM Coors_Email_FullAudience_WithOptOuts co
INNER JOIN OT_IRELAND_PROD_TABLE_IRELANDMARKETING_Transformed otim
    ON co.Email_Address = otim.identifier
INNER JOIN OT_IRELAND_PROD_TABLE_COORS_Transformed otco
    ON co.Email_Address = otco.identifier
WHERE otim.option_status = 'CONFIRMED'
    AND otco.option_status = 'CONFIRMED'