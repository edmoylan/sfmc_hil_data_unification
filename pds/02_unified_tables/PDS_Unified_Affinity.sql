SELECT
  a.Engagement_Key,
  a.Affinity_Type,
  a.Venue_Key,
  a.Brand_Code,
  a.Social_Event_Key,
  a.Affinity_Value,
  a.Source,
  a.Related_Consumer_Key,
  a.Record_Created_Date,
  a.Geographical_Location_Key,
  a.Affinity_Score,
  a.Affinity_Category,
  a.Record_Modified_Date,
  a.Engagement_Channel,
  a.Affinity_Subcategory,
  a.Affinity_Key,
  a.Campaign_Key,
  a.Line_Extension_Code,
  il.Unified_Consumer_Key AS Consumer_Key
FROM PDS_Affinity_Key a
RIGHT JOIN PDS_IdentityLink il
  ON a.Consumer_Key = il.Consumer_Key
 WHERE a.Affinity_Key is not null