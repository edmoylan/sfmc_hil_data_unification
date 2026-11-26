SELECT
  ce.Data_Use_Channel,
  ce.Data_Use_Purpose,
  ce.Record_Modified_Date,
  ce.Consent_Event_Key,
  ce.Source,
  ce.Data_Collection_Party_Name,
  ce.Legal_Text,
  ce.Legal_Entity_Code,
  ce.Data_Collection_Type,
  ce.Consent_Opt_Out_Reason,
  ce.Consent_Sharing,
  ce.Record_Created_Date,
  ce.OpCo_Code,
  ce.Consent_Status,
  ce.Consent_Sub_Level,
  il.Unified_Consumer_Key AS Consumer_Key
FROM PDS_Consent_Event ce
RIGHT JOIN PDS_IdentityLink il
  ON ce.Consumer_Key = il.Consumer_Key
WHERE ce.Consent_Event_Key IS NOT NULL
    AND ce.Source != 'OTR372'
UNION
SELECT
  ce.Data_Use_Channel,
  ce.Data_Use_Purpose,
  ce.Record_Modified_Date,
  LOWER(
        CONVERT(
            NVARCHAR(MAX),
            HASHBYTES('SHA2_256',
                CONVERT(varchar(254), CONCAT(LOWER(ce.Consumer_Key) , ce.Data_Use_Channel, ce.Data_Use_Purpose, ce.Consent_Sub_Level, ce.Consent_Status, CONVERT(varchar(254), ce.Record_Modified_Date)))
            ),
            2
        )
    ) as Consent_Event_Key,
  ce.Source,
  ce.Data_Collection_Party_Name,
  ce.Legal_Text,
  ce.Legal_Entity_Code,
  ce.Data_Collection_Type,
  ce.Consent_Opt_Out_Reason,
  ce.Consent_Sharing,
  ce.Record_Created_Date,
  ce.OpCo_Code,
  ce.Consent_Status,
  ce.Consent_Sub_Level,
  il.Unified_Consumer_Key AS Consumer_Key
FROM PDS_Consent_Event ce
RIGHT JOIN PDS_IdentityLink il
  ON ce.Consumer_Key = il.Consumer_Key
WHERE ce.Consent_Event_Key IS NOT NULL
    AND ce.Source = 'OTR372'