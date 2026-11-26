SELECT TOP 10000
    x.Campaign_Key,
    x.Brand_Code,
    COUNT(distinct x.Consumer_Key) AS Volume_OptIn
FROM (
    SELECT
        y.Campaign_Key,
        y.Brand_Code,
        x.Consumer_Key,
        y.Record_Created_Date AS Website_Engagement_Date
    FROM PDS_Unified_Communication_Email x
    INNER JOIN PDS_Unified_Website_Engagament y
        ON x.Consumer_Key = y.Consumer_Key
    INNER JOIN HNK_Email_FullAudience z
        ON x.Communication_Address = z.Email_Address AND y.Brand_Code = z.Brand_Code
    UNION
    SELECT
        y.Campaign_Key,
        y.Brand_Code,
        x.Consumer_Key,
        y.Record_Created_Date AS Website_Engagement_Date
    FROM PDS_Unified_Communication_Email x
    INNER JOIN PDS_Unified_Website_Engagament y
        ON x.Consumer_Key = y.Consumer_Key
    INNER JOIN BM_Email_FullAudience z
        ON x.Communication_Address = z.Email_Address AND y.Brand_Code = z.Brand_Code
    UNION
    SELECT
        y.Campaign_Key,
        y.Brand_Code,
        x.Consumer_Key,
        y.Record_Created_Date AS Website_Engagement_Date
    FROM PDS_Unified_Communication_Email x
    INNER JOIN PDS_Unified_Website_Engagament y
        ON x.Consumer_Key = y.Consumer_Key
    INNER JOIN Coors_Email_FullAudience z
        ON x.Communication_Address = z.Email_Address AND y.Brand_Code = z.Brand_Code
    UNION
    SELECT
        y.Campaign_Key,
        y.Brand_Code,
        x.Consumer_Key,
        y.Record_Created_Date AS Website_Engagement_Date
    FROM PDS_Unified_Communication_Email x
    INNER JOIN PDS_Unified_Website_Engagament y
        ON x.Consumer_Key = y.Consumer_Key
    INNER JOIN OT_Email_FullAudience z
        ON x.Communication_Address = z.Email_Address AND y.Brand_Code = z.Brand_Code
    UNION
    SELECT
        y.Campaign_Key,
        y.Brand_Code,
        x.Consumer_Key,
        y.Record_Created_Date AS Website_Engagement_Date
    FROM PDS_Unified_Communication_Email x
    INNER JOIN PDS_Unified_Website_Engagament y
        ON x.Consumer_Key = y.Consumer_Key
    INNER JOIN Madri_Email_FullAudience z
        ON x.Communication_Address = z.Email_Address AND y.Brand_Code = z.Brand_Code
    UNION
    SELECT
        y.Campaign_Key,
        y.Brand_Code,
        x.Consumer_Key,
        y.Record_Created_Date AS Website_Engagement_Date
    FROM PDS_Unified_Communication_Email x
    INNER JOIN PDS_Unified_Website_Engagament y
        ON x.Consumer_Key = y.Consumer_Key
    INNER JOIN Beamish_Email_FullAudience z
        ON x.Communication_Address = z.Email_Address AND y.Brand_Code = z.Brand_Code
) AS x
LEFT JOIN PDS_Campaign z
    ON x.Campaign_Key = z.Campaign_Key
GROUP BY
    x.Campaign_Key,
    x.Brand_Code
ORDER BY
    x.Campaign_Key,
    x.Brand_Code