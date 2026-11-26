SELECT TOP 10000
    fe.Campaign_Key AS Campaign_Key,
    fe.Brand_Code AS Brand_Code,
    COUNT(DISTINCT fe.Consumer_Key) AS Volume_OptIn_WithBounces_New
FROM (
    SELECT
        y.Consumer_Key AS Consumer_Key,
        y.Brand_Code AS Brand_Code,
        y.Campaign_Key AS Campaign_Key,
        y.Record_Created_Date AS Website_Engagement_Date,
        ROW_NUMBER() OVER (
            PARTITION BY x.Consumer_Key, y.Brand_Code 
            ORDER BY y.Record_Created_Date ASC
        ) AS RowNum
    FROM PDS_Unified_Communication_Email x
    INNER JOIN PDS_Unified_Website_Engagament y
        ON x.Consumer_Key = y.Consumer_Key
    INNER JOIN (
        SELECT Email_Address, Brand_Code FROM HNK_Email_FullAudience_OptIn_WithBounces
        UNION
        SELECT Email_Address, Brand_Code FROM BM_Email_FullAudience_OptIn_WithBounces
        UNION
        SELECT Email_Address, Brand_Code FROM Coors_Email_FullAudience_OptIn_WithBounces
        UNION
        SELECT Email_Address, Brand_Code FROM OT_Email_FullAudience_OptIn_WithBounces
        UNION
        SELECT Email_Address, Brand_Code FROM Madri_Email_FullAudience_OptIn_WithBounces
        UNION
        SELECT Email_Address, Brand_Code FROM Beamish_Email_FullAudience_OptIn_WithBounces
    ) z
        ON x.Communication_Address = z.Email_Address 
       AND y.Brand_Code = z.Brand_Code
) fe
LEFT JOIN PDS_Campaign c
    ON fe.Campaign_Key = c.Campaign_Key
WHERE fe.RowNum = 1
GROUP BY
    fe.Campaign_Key,
    fe.Brand_Code
ORDER BY
    fe.Campaign_Key,
    fe.Brand_Code