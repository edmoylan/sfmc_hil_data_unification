SELECT 
    consumer_key, 
    unified_consumer_key, 
    unified_Date 
FROM PDS_IdentityLink_Intermediate
UNION
SELECT
    mi.consumer_key,
    ag.unified_consumer_key,
    ag.unified_Date
FROM PDS_MergedIdentities mi
JOIN PDS_AllGroups ag
    ON mi.computed_group = ag.computed_group
LEFT JOIN PDS_IdentityLink_Intermediate ili
    ON mi.consumer_key = ili.consumer_key
WHERE ili.consumer_key IS NULL
