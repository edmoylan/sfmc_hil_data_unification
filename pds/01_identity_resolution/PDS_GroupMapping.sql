SELECT
   mi.computed_group AS computed_group,
   MIN(il.unified_consumer_key) AS existing_unified_consumer_key,
   MIN(il.unified_Date) AS unified_Date
FROM PDS_MergedIdentities mi
LEFT JOIN PDS_Identitylink il
   ON mi.consumer_key = il.consumer_key
GROUP BY mi.computed_group
