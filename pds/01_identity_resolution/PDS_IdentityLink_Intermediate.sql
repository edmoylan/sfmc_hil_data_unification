SELECT
    il.consumer_key,
    ag.unified_consumer_key,
    COALESCE(il.unified_Date, GETDATE()) AS unified_Date
FROM PDS_IdentityLink il
JOIN PDS_MergedIdentities mi 
    ON il.consumer_key = mi.consumer_key
JOIN PDS_AllGroups ag 
    ON mi.computed_group = ag.computed_group