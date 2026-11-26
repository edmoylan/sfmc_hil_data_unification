SELECT
    Geographical_Location_Key,
    Record_Created_Date,
    Record_Modified_Date,
    Address_Line_1,
    Address_Line_2,
    Postal_Code,
    City,
    Region_Code,
    Country_Code,
    Latitude,
    Longitude,
    Source,
    Consumer_Key
FROM
    (
    SELECT
        originalDE.Geographical_Location_Key,
        originalDE.Record_Created_Date,
        originalDE.Record_Modified_Date,
        originalDE.Address_Line_1,
        originalDE.Address_Line_2,
        originalDE.Postal_Code,
        originalDE.City,
        originalDE.Region_Code,
        originalDE.Country_Code,
        originalDE.Latitude,
        originalDE.Longitude,
        originalDE.Source,
        il.Unified_Consumer_Key AS Consumer_Key,
        ROW_NUMBER() OVER (
            PARTITION BY il.Unified_Consumer_Key 
            ORDER BY 
                CASE WHEN originalDE.Postal_Code IS NOT NULL THEN 0 ELSE 1 END ASC,
                CASE WHEN originalDE.Source <> 'OTR372' THEN 0 ELSE 1 END ASC,
                CASE WHEN originalDE.City IS NOT NULL OR originalDE.Region_Code IS NOT NULL THEN 0 ELSE 1 END ASC,
                COALESCE(originalDE.Record_Modified_Date, originalDE.Record_Created_Date) DESC
        ) AS Rank
    FROM PDS_Consumer_Address originalDE
    INNER JOIN PDS_IdentityLink il
      ON originalDE.Consumer_Key = il.Consumer_Key
    WHERE (
        originalDE.Address_Line_1 IS NOT NULL OR 
        originalDE.Address_Line_2 IS NOT NULL OR 
        originalDE.Postal_Code IS NOT NULL OR 
        originalDE.City IS NOT NULL OR 
        originalDE.Region_Code IS NOT NULL
    )
) AS RankedAddresses
WHERE Rank = 1