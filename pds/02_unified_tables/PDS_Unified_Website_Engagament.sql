SELECT
  il.Unified_Consumer_Key AS Consumer_Key,
  w.Webpage_Url,
  w.Source,
  w.Website_Engagement_Type,
  w.Website_Engagement_Key,
  w.Campaign_Key,
  w.Domain_Name,
  w.Social_Event_Key,
  w.Page_Name, 
   w.Referral_Url,
  w.Record_Created_Date,
   w.Brand_Code,
  w.Line_Extension_Code
FROM PDS_Website_Engagament w
RIGHT JOIN PDS_IdentityLink il
  ON w.Consumer_Key = il.Consumer_Key
WHERE w.Website_Engagement_Key IS NOT NULL
