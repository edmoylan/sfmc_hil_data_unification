SELECT
    'B0001' AS Brand_Code,
    'Heineken' AS Brand_Name,
    COUNT(x.Email_Address) AS Volume_All
FROM HNK_Email_FullAudience_WithOptOuts x
UNION
SELECT
    'B0235' AS Brand_Code,
    'Birra Moretti' AS Brand_Name,
    COUNT(x.Email_Address) AS Volume_All
FROM BM_Email_FullAudience_WithOptOuts x
UNION
SELECT
    'B0286' AS Brand_Code,
    'Coors' AS Brand_Name,
    COUNT(x.Email_Address) AS Volume_All
FROM Coors_Email_FullAudience_WithOptOuts x
UNION
SELECT
    'B3632' AS Brand_Code,
    'Orchard Thieves' AS Brand_Name,
    COUNT(x.Email_Address) AS Volume_All
FROM OT_Email_FullAudience_WithOptOuts x
UNION
SELECT
    'B5669' AS Brand_Code,
    'Madri' AS Brand_Name,
    COUNT(x.Email_Address) AS Volume_All
FROM Madri_Email_FullAudience_WithOptOuts x
UNION
SELECT
    'B0534' AS Brand_Code,
    'Beamish' AS Brand_Name,
    COUNT(x.Email_Address) AS Volume_All
FROM Beamish_Email_FullAudience_WithOptOuts x