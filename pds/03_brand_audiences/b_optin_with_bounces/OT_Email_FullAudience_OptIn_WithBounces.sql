SELECT
  orc.Consumer_Key,
  orc.Email_Address,
  orc.Phone_Number,
  orc.Brand_Code,
  orc.First_Name,
  orc.Consent_Status,
  orc.Unified_Consumer_Key,
  orc.First_Orchard_InteractionDate
FROM OT_Email_FullAudience_WithOptOuts orc
INNER JOIN OT_IRELAND_PROD_TABLE_IRELANDMARKETING_Transformed otim
    ON orc.Email_Address = otim.identifier
INNER JOIN OT_IRELAND_PROD_TABLE_ORCHARDTHIEVES_Transformed otor
    ON orc.Email_Address = otor.identifier
WHERE otim.option_status = 'CONFIRMED'
    AND otor.option_status = 'CONFIRMED'