SELECT
  ce.Communication_Value_Hash AS Consumer_Key,
  ce.Communication_Address AS Email_Address,
  cp.Communication_Number AS Phone_Number,
  we.Brand_Code,
  c.First_Name,
  ecc.Consent_Status,
  ce.Consumer_Key as Unified_Consumer_Key,
  we.First_Coors_InteractionDate
FROM PDS_Unified_Communication_Email ce
LEFT JOIN PDS_Unified_Communication_Phone cp
    ON ce.Consumer_Key = cp.Consumer_Key
LEFT JOIN PDS_Global_EmailConsent ec
    ON ce.Consumer_Key = ec.Consumer_Key
LEFT JOIN PDS_Brand_EmailConsent_Coors ecc
    ON ce.Consumer_Key = ecc.Consumer_Key
INNER JOIN (
    SELECT 
        we.Consumer_Key,
        we.Brand_Code,
        MIN(we.Record_Created_Date) as First_Coors_InteractionDate
    FROM PDS_Unified_Website_Engagament we
    WHERE we.Brand_Code = 'B0286'
    GROUP BY 
        we.Consumer_Key,
        we.Brand_Code
    ) as we
  ON ce.Consumer_Key = we.Consumer_Key
INNER JOIN PDS_Unified_Consumer c
  ON ce.Consumer_Key = c.Consumer_Key