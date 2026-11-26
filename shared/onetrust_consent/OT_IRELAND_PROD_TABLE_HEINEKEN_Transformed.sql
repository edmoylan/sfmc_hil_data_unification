SELECT 
    id,
    user_id,
    identifier,
    identifier_email,
    identifier_phone,
    collection_point_id,
    collection_point_version,
    purpose_id,
    purpose_version,
    purpose_status,
    custom_preferences_id,
    option_id,
    option_name,
    option_status,
    last_transaction_date,
    consent_date,
    expiry_date,
    last_updated_date,
    last_interaction_date,
    magic_link_token,
    data_elements,
    timestamp
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY consent_date DESC
        ) AS rn
    FROM OT_IRELAND_PROD_TABLE_HEINEKEN
    WHERE option_id IS NOT NULL 
      AND option_id <> ''
) ranked
WHERE rn = 1