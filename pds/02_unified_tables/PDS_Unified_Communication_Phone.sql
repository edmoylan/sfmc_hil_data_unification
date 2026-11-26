SELECT 
    Communication_Key,
    Communication_Type,
    Communication_Number,
    Communication_Address,
    LOWER(
        CONVERT(
            NVARCHAR(MAX),
            HASHBYTES('SHA2_256',
                CONVERT(varchar(254), Communication_Number)
            ),
            2
        )
    ) as Communication_Value_Hash,
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
        /* Replace the original field with the cleaned logic */
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(c.Communication_Number, '(', ''), 
                    ')', ''), 
                  '-', ''), 
                '+', ''), 
              ' ', ''), 
            '*', ''),
          '=', ''),
        '"', '') AS Communication_Number,
        c.Communication_Address,
        c.Communication_Value_Hash,
        c.Country_Code,
        c.Language_Code,
        c.Is_Verified,
        c.Preferred,
        c.Record_Created_Date,
        c.Record_Modified_Date,
        c.Source,
        il.Unified_Consumer_Key AS Consumer_Key,
        /* Deduplication: Rank 1 is the latest record */
        ROW_NUMBER() OVER (
            PARTITION BY il.Unified_Consumer_Key 
            ORDER BY 
                COALESCE(c.Record_Modified_Date, c.Record_Created_Date) DESC
        ) AS Rank
    FROM PDS_Communication c
    INNER JOIN PDS_IdentityLink il
      ON c.Consumer_Key = il.Consumer_Key
    WHERE c.Communication_Number IS NOT NULL
) AS RankedCommunications
WHERE Rank = 1