SELECT 
    'Music_Interest' AS Affinity,
    '2026' as Year,
    count(Consumer_Key) AS Volume_All
FROM HNK_Email_FullAudience_WithOptOuts
WHERE Music_Interest = 'True'
UNION
SELECT 
    'Sports_Interest' AS Affinity,
    '2026' as Year,
    count(Consumer_Key) AS Volume_All
FROM HNK_Email_FullAudience_WithOptOuts
WHERE Sports_Interest = 'True'
UNION
SELECT 
    'Branding_Interest' AS Affinity,
    '2026' as Year,
    count(Consumer_Key) AS Volume_All
FROM HNK_Email_FullAudience_WithOptOuts
WHERE Branding_Interest = 'True'
UNION
SELECT 
    'Music_Interest' AS Affinity,
    '2025' as Year,
    count(Consumer_Key) AS Volume_All
FROM HNK_Email_FullAudience_WithOptOuts
WHERE Music_Interest = 'True'
    AND YEAR(First_HNK_InteractionDate) < '2026'
UNION
SELECT 
    'Sports_Interest' AS Affinity,
    '2025' as Year,
    count(Consumer_Key) AS Volume_All
FROM HNK_Email_FullAudience_WithOptOuts
WHERE Sports_Interest = 'True'
    AND YEAR(First_HNK_InteractionDate) < '2026'
UNION
SELECT 
    'Branding_Interest' AS Affinity,
    '2025' as Year,
    count(Consumer_Key) AS Volume_All
FROM HNK_Email_FullAudience_WithOptOuts
WHERE Branding_Interest = 'True'
    AND YEAR(First_HNK_InteractionDate) < '2026'