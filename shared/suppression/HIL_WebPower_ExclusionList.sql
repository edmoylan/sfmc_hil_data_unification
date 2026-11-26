SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_WebPower_GlobalOptOuts x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_OneTrust_GlobalOptOuts x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_WebPower_SpamComplaint x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_WebPower_SoftBouncedef x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_WebPower_HardBouncedef x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_WebPower_HardBounce2 x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_WebPower_HardBounce1 x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    x.ConsentDate
FROM HIL_OneTrust_EmailReject x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM Bounce x
WHERE x.EmailAddress IS NOT NULL
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM Complaints x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM Unsubscribes x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM SubscriberStatus_HeldUnsub x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM TrackingAudit_NotSent x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM TrackingAudit_Unsubs x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM TrackingAudit_Complaints x
UNION
SELECT
    LOWER(x.EmailAddress) as EmailAddress,
    NULL as ConsentDate
FROM TrackingAudit_Bounces x
UNION
SELECT
    LOWER(x.email) as EmailAddress,
    NULL as ConsentDate
FROM HIL_WebPower_EmailEngagements x
WHERE x.DMDtype IN ('Unsubscribe', 'SpamComplaint')
    OR x.DMDtype LIKE '%Bounce%'