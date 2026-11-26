SELECT
    'B0001' AS Brand_Code,
    COUNT(x.Email_Address) AS Volume_OptIn_WithBounces
FROM HNK_Email_FullAudience_OptIn_WithBounces x
UNION
SELECT
    'B0235' AS Brand_Code,
    COUNT(x.Email_Address) AS Volume_OptIn_WithBounces
FROM BM_Email_FullAudience_OptIn_WithBounces x
UNION
SELECT
    'B0286' AS Brand_Code,
    COUNT(x.Email_Address) AS Volume_OptIn_WithBounces
FROM Coors_Email_FullAudience_OptIn_WithBounces x
UNION
SELECT
    'B3632' AS Brand_Code,
    COUNT(x.Email_Address) AS Volume_OptIn_WithBounces
FROM OT_Email_FullAudience_OptIn_WithBounces x
UNION
SELECT
    'B5669' AS Brand_Code,
    COUNT(x.Email_Address) AS Volume_OptIn_WithBounces
FROM Madri_Email_FullAudience_OptIn_WithBounces x
UNION
SELECT
    'B0534' AS Brand_Code,
    COUNT(x.Email_Address) AS Volume_OptIn_WithBounces
FROM Beamish_Email_FullAudience_OptIn_WithBounces x