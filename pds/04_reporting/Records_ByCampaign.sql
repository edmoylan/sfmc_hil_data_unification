SELECT TOP 10000
    y.Campaign_Key,
    y.Brand_Code,
    count(distinct x.Consumer_Key) as Volume_All,
    MAX(z.Campaign_Name) as Campaign_Name,
    MAX(z.Source) as Source,
    MIN(y.Record_Created_Date) AS Campaign_Start_Date, 
    MAX(y.Record_Created_Date) AS Campaign_End_Date
FROM PDS_Unified_Communication_Email x
INNER JOIN PDS_Unified_Website_Engagament y
    ON x.Consumer_Key = y.Consumer_Key
LEFT JOIN PDS_Campaign z
    ON y.Campaign_Key = z.Campaign_Key
WHERE y.Campaign_Key IS NOT NULL AND y.Brand_Code IS NOT NULL
GROUP BY
    y.Campaign_Key,
    y.Brand_Code
ORDER BY
    y.Campaign_Key,
    y.Brand_Code