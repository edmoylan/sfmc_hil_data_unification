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
FROM HNK_Email_FullAudience_WithOptOuts hnk
INNER JOIN OT_IRELAND_PROD_TABLE_IRELANDMARKETING_Transformed otim
    ON hnk.Email_Address = otim.identifier
INNER JOIN OT_IRELAND_PROD_TABLE_HEINEKEN_Transformed oth
    ON hnk.Email_Address = oth.identifier
WHERE otim.option_status = 'CONFIRMED'
    AND oth.option_status = 'CONFIRMED'