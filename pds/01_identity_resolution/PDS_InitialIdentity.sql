SELECT
  mk.consumer_key,
  MIN(mk2.consumer_key) AS group_id
FROM PDS_MatchKeys mk
JOIN PDS_MatchKeys mk2 ON mk.match_key = mk2.match_key
GROUP BY mk.consumer_key