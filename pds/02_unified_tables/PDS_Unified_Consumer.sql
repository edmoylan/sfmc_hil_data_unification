SELECT 
    First_Name,
    Middle_Name,
    Last_Name,
    Gender,
    Birthdate,
    Salutation,
    Suffix,
    Deletion_Flag,
    Record_Created_Date,
    Record_Modified_Date,
    Source,
    Load_Date,
    Consumer_Key
FROM
    (
    SELECT
        originalDE.First_Name,
        originalDE.Middle_Name,
        originalDE.Last_Name,
        originalDE.Gender,
        originalDE.Birthdate,
        originalDE.Salutation,
        originalDE.Suffix,
        originalDE.Deletion_Flag,
        originalDE.Record_Created_Date,
        originalDE.Record_Modified_Date,
        originalDE.Source,
        originalDE.Load_Date,
        il.Unified_Consumer_Key AS Consumer_Key,
        ROW_NUMBER() OVER (
            PARTITION BY il.Unified_Consumer_Key 
            ORDER BY 
                CASE WHEN originalDE.First_Name IS NOT NULL THEN 0 ELSE 1 END ASC,
                COALESCE(originalDE.Record_Modified_Date, originalDE.Record_Created_Date) DESC
        ) AS Rank
    FROM PDS_Consumer originalDE
    RIGHT JOIN PDS_IdentityLink il
      ON originalDE.Consumer_Key = il.Consumer_Key
) as RankedConsumers
WHERE Rank = 1