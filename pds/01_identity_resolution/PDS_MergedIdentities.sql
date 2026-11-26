SELECT
  i.consumer_key,
  MIN(ISNULL(j.group_id, i.group_id)) AS computed_group
FROM PDS_InitialIdentity i
LEFT JOIN PDS_InitialIdentity j ON i.group_id = j.consumer_key
GROUP BY i.consumer_key
