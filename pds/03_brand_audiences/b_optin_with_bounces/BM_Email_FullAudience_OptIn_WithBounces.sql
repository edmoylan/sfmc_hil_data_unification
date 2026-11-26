SELECT
  bm.Consumer_Key,
  bm.Email_Address,
  bm.Phone_Number,
  bm.Brand_Code,
  bm.First_Name,
  bm.Consent_Status,
  bm.Unified_Consumer_Key,
  bm.First_BM_InteractionDate
FROM BM_Email_FullAudience_WithOptOuts bm
INNER JOIN OT_IRELAND_PROD_TABLE_IRELANDMARKETING_Transformed otim
    ON bm.Email_Address = otim.identifier
INNER JOIN OT_IRELAND_PROD_TABLE_BIRRAMORETTI_Transformed otbm
    ON bm.Email_Address = otbm.identifier
WHERE otim.option_status = 'CONFIRMED'
    AND otbm.option_status = 'CONFIRMED'