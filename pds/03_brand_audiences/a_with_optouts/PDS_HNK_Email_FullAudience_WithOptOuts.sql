SELECT
  ce.Communication_Value_Hash AS Consumer_Key,
  ce.Communication_Address AS Email_Address,
  cp.Communication_Number AS Phone_Number,
  we.Brand_Code,
  c.First_Name,
  ech.Consent_Status,
  ce.Consumer_Key as Unified_Consumer_Key,
  CASE 
    WHEN am.Consumer_Key IS NOT NULL THEN 'True'
    ELSE 'False'
  END AS Music_Interest,
  CASE 
    WHEN asp.Consumer_Key IS NOT NULL THEN 'True'
    ELSE 'False'
  END AS Sports_Interest,
  CASE 
    WHEN ab.Consumer_Key IS NOT NULL THEN 'True'
    ELSE 'False'
  END AS Branding_Interest,
  we.First_HNK_InteractionDate AS First_HNK_InteractionDate
FROM PDS_Unified_Communication_Email ce
LEFT JOIN PDS_Unified_Communication_Phone cp
    ON ce.Consumer_Key = cp.Consumer_Key
LEFT JOIN PDS_Global_EmailConsent ec
    ON ce.Consumer_Key = ec.Consumer_Key
LEFT JOIN PDS_Brand_EmailConsent_Heineken ech
    ON ce.Consumer_Key = ech.Consumer_Key
INNER JOIN (
    SELECT 
        we.Consumer_Key,
        we.Brand_Code,
        MIN(we.Record_Created_Date) as First_HNK_InteractionDate
    FROM PDS_Unified_Website_Engagament we
    WHERE we.Brand_Code = 'B0001'
    GROUP BY 
        we.Consumer_Key,
        we.Brand_Code
    ) as we
  ON ce.Consumer_Key = we.Consumer_Key
INNER JOIN PDS_unified_Consumer c
  ON ce.Consumer_Key = c.Consumer_Key
LEFT JOIN (
    SELECT DISTINCT Consumer_Key
    FROM PDS_Unified_Affinity
    WHERE Affinity_Category = 'Music'
    ) as am
    ON ce.Consumer_Key = am.Consumer_Key
LEFT JOIN (
    SELECT DISTINCT Consumer_Key
    FROM PDS_Unified_Affinity
    WHERE Affinity_Category = 'Sports'
    ) as asp
    ON ce.Consumer_Key = asp.Consumer_Key
LEFT JOIN (
    SELECT DISTINCT Consumer_Key
    FROM PDS_Unified_Affinity
    WHERE Affinity_Category = 'Branding'
    ) as ab
    ON ce.Consumer_Key = ab.Consumer_Key
