SELECT 
    Communication_Key,
    Communication_Type,
    Communication_Number,
    Communication_Address,
    Communication_Value_Hash,
    Country_Code,
    Language_Code,
    Is_Verified,
    Preferred,
    Record_Created_Date,
    Record_Modified_Date,
    Source,
    Consumer_Key
FROM
    (
    SELECT
        c.Communication_Key,
        c.Communication_Type,
        c.Communication_Number,
        LOWER(c.Communication_Address) as Communication_Address,
        LOWER(
            CONVERT(
                NVARCHAR(MAX),
                HASHBYTES('SHA2_256',
                    CONVERT(varchar(254), LOWER(c.Communication_Address))
                ),
                2
            )
        ) as Communication_Value_Hash,
        c.Country_Code,
        c.Language_Code,
        c.Is_Verified,
        c.Preferred,
        c.Record_Created_Date,
        c.Record_Modified_Date,
        c.Source,
        il.Unified_Consumer_Key AS Consumer_Key,
        ROW_NUMBER() OVER (
            PARTITION BY il.Unified_Consumer_Key 
            ORDER BY 
                CASE WHEN c.Communication_Address IS NOT NULL THEN 0 ELSE 1 END ASC,
                COALESCE(c.Record_Created_Date, c.Record_Modified_Date) DESC
        ) AS Rank
    FROM PDS_Communication c
    INNER JOIN PDS_IdentityLink il
      ON c.Consumer_Key = il.Consumer_Key
    WHERE c.Communication_Address IS NOT NULL
) AS RankedCommunications
WHERE Rank = 1
