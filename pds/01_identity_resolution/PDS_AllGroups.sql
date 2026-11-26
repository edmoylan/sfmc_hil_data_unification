SELECT
   dg.computed_group,
   COALESCE(
       gm.existing_unified_consumer_key,
       CAST(NEWID() AS VARCHAR(36))
   ) AS unified_consumer_key,
   COALESCE(
       gm.unified_Date,
       GETDATE()
   ) AS date_added
FROM PDS_DistinctGroups dg
LEFT JOIN PDS_GroupMapping gm
   ON dg.computed_group = gm.computed_group