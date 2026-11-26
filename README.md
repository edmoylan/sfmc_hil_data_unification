# sfmc_hil_data_unification

SQL query activities used in Salesforce Marketing Cloud (SFMC) to unify HIL consumer data into a single customer view, and to build brand email audiences and reporting on top of it.

| Phase | Source | Status | Folder |
|---|---|---|---|
| **1** | PDS (legacy consumer data) → Unified PDS | ✅ Built (this repo) | [`pds/`](pds/) |
| **2** | CIAM (cidaas) data streamed into SFMC tables | 🔜 Planned | [`ciam/`](ciam/) |

Queries used by both phases (OneTrust consent, email suppression) live in [`shared/`](shared/).

---

## Why unification is needed

The original PDS data extensions (`PDS_Consumer`, `PDS_Communication`, `PDS_Consent_Event`, etc.) were **not unified**. The same person can appear under several `Consumer_Key`s, for example once per source system or sign-up. Without unification, one person can be counted several times, receive duplicate sends, or have their consent and engagement split across records.

Phase 1 resolves those duplicates into a single **`Unified_Consumer_Key`** per person and rebuilds every PDS table keyed on it (the `PDS_Unified_*` tables). Everything downstream (audiences and reporting) reads only from the unified tables.

---

## Repository layout

```
pds/                                  Phase 1 – PDS unification
  01_identity_resolution/             Match records and assign Unified_Consumer_Keys
  02_unified_tables/                  Rebuild each PDS table on the unified key
  03_brand_audiences/
    a_with_optouts/                   Per-brand audience incl. opt-outs
    b_optin_with_bounces/             … filtered to OneTrust opt-ins
    c_final_audience/                 … minus bounces / suppressions (sendable)
  04_reporting/                       Volume reporting by brand, campaign, affinity
shared/
  onetrust_consent/                   Latest OneTrust consent record per user, per brand
  suppression/                        Global email exclusion list (WebPower, OneTrust, SFMC)
ciam/                                 Phase 2 – CIAM (cidaas) unification (placeholder)
```

File names match the SFMC **query activity names** exactly. Some activities write to a target data extension (DE) with a different name; these are listed under [Naming gotchas](#naming-gotchas).

---

## Phase 1: PDS → Unified PDS

Everything runs in the SFMC automation **`PDS_IdentityResolution`** (18 steps, all SQL query activities, scheduled daily).

### Steps 1–8: identity resolution (`pds/01_identity_resolution/`)

Records are matched on **lower-cased email address** (`PDS_Communication.Communication_Address`).

| Step | Query | Action | What it does |
|---|---|---|---|
| 1 | `PDS_MatchKeys` | Overwrite | One row per consumer/email: `Consumer_Key` → `LOWER(email)` as `Match_Key`. |
| 2 | `PDS_InitialIdentity` | Overwrite | Self-joins on `Match_Key`. Each consumer's `group_id` is the lowest `Consumer_Key` that shares any of its emails. |
| 3 | `PDS_MergedIdentities` | Overwrite | Follows one more hop (`group_id` of the `group_id`) to merge chained groups into a final `computed_group`. |
| 4 | `PDS_DistinctGroups` | Overwrite | Distinct list of `computed_group`s. |
| 5 | `PDS_GroupMapping` | Overwrite | Looks up any **existing** `unified_consumer_key` (and its date) already assigned to a group's members in `PDS_IdentityLink`. |
| 6 | `PDS_AllGroups` | Overwrite | Every group gets a key: it reuses the existing key or generates a new `NEWID()` GUID. |
| 7 | `PDS_IdentityLink_Intermediate` | Overwrite | Re-maps already-linked consumers to their group's current unified key. |
| 8 | `PDS_IdentityLink` | **Update** | Final `Consumer_Key` → `Unified_Consumer_Key` mapping: intermediate rows plus newly seen consumers. |

**Key stability:** `PDS_IdentityLink` is the persistent output and uses *Update*, not Overwrite. Steps 5–6 read it back, so a person keeps the same `Unified_Consumer_Key` across daily runs, and new GUIDs are only created for genuinely new groups.

### Step 9: unified tables (`pds/02_unified_tables/`)

Each query joins a source PDS table to `PDS_IdentityLink` and outputs the `Unified_Consumer_Key` **as `Consumer_Key`**. All use Overwrite and write to DEs in `System/PDS/Unified_PDS`.

| Query | Source | Rows per unified consumer | Survivorship / notes |
|---|---|---|---|
| `PDS_Unified_Consumer` | `PDS_Consumer` | 1 | Prefers a record with `First_Name`, then the most recently modified. |
| `PDS_Unified_Consumer_Address` | `PDS_Consumer_Address` | 1 | Prefers a postcode, then non-`OTR372` source, then city/region, then most recent. Rows with an empty address are excluded. |
| `PDS_Unified_Communication_Email` | `PDS_Communication` | 1 | Lower-cases the email and adds a SHA-256 `Communication_Value_Hash`. Keeps the most recently created. |
| `PDS_Unified_Communication_Phone` | `PDS_Communication` | 1 | Strips `( ) - + space * = "` from the number and adds a SHA-256 hash. Keeps the most recently modified. |
| `PDS_Unified_Consent_Event` | `PDS_Consent_Event` | all | Re-keyed only. For source `OTR372`, a deterministic `Consent_Event_Key` is generated (SHA-256 of consumer, channel, purpose, sub-level, status and date). |
| `PDS_Unified_Affinity` | `PDS_Affinity_Key` | all | Re-keyed only. |
| `PDS_Unified_Website_Engagament` | `PDS_Website_Engagament` | all | Re-keyed only. |

### Step 10: OneTrust consent (`shared/onetrust_consent/`)

`OT_IRELAND_PROD_TABLE_<BRAND>_Transformed` takes the raw OneTrust export DEs (`OT Integration/V2`) and keeps the **latest consent record per `user_id`** (by `consent_date`, where `option_id` is populated). The output goes to `OT Integration/Transformed`. There is one query per brand, plus `IRELANDMARKETING` for global Ireland marketing consent.

These depend only on OneTrust, not on PDS, so phase 2 can reuse them.

### Steps 11–14: brand email audiences (`pds/03_brand_audiences/`)

Each brand is built in three stages:

| Step | Stage | Query pattern | Logic |
|---|---|---|---|
| 11 | a | `PDS_<Brand>_Email_FullAudience_WithOptOuts` | Unified email + phone + first name + brand consent. Restricted to consumers with website engagement for the brand's `Brand_Code` and records their first interaction date. Heineken also gets Music / Sports / Branding interest flags from `PDS_Unified_Affinity`. The audience `Consumer_Key` is the **email hash**; `Unified_Consumer_Key` is kept alongside. |
| 12 | b | `<Brand>_Email_FullAudience_OptIn_WithBounces` | Inner-joins to OneTrust: the email must be `CONFIRMED` in **both** the IRELANDMARKETING (global) and brand `_Transformed` tables. |
| 13 | – | `HIL_WebPower_ExclusionList` (`shared/suppression/`) | Union of all suppressions: WebPower global opt-outs, spam complaints and bounces; OneTrust global opt-outs and rejects; SFMC Bounce, Complaints, Unsubscribes, held subscribers and tracking audits; and WebPower engagement unsubscribes, spam and bounces. Uses Update. |
| 14 | c | `<Brand>_Email_FullAudience` | Stage b minus anything on the exclusion list. **This is the sendable audience.** |

| Brand | Prefix | Brand_Code | OneTrust table |
|---|---|---|---|
| Heineken | `HNK` | B0001 | `HEINEKEN` |
| Birra Moretti | `BM` | B0235 | `BIRRAMORETTI` |
| Coors | `Coors` | B0286 | `COORS` |
| Orchard Thieves | `OT` | B3632 | `ORCHARDTHIEVES` |
| Madri | `Madri` | B5669 | `MADRI` |
| Beamish | `Beamish` | B0534 | `BEAMISH` |

### Steps 15–18: reporting (`pds/04_reporting/`)

Several queries write into each reporting DE with **Update**, and each adds a volume column for one funnel stage:

| Target DE | Queries (in step order) | Columns |
|---|---|---|
| `Records_ByBrand` | `Records_ByBrand`, `_WithBounces`, `_OptIn` | `Volume_All`, `Volume_OptIn_WithBounces`, `Volume_OptIn` per brand |
| `Records_ByCampaign` | `Records_ByCampaign`, `_WithBounces`, `_OptIn`, `_WithBounces_New` | Volumes per `Campaign_Key` × `Brand_Code`. `_New` (step 18) counts each consumer only against their **first** campaign per brand. |
| `HNKRecords_ByAffinity` | `HNKRecords_ByAffinity`, `_OptIn_WithBounces`, `_OptIn` | Heineken Music / Sports / Branding volumes for 2026 and pre-2026 |

The stages map to audience DEs as follows: *All* = stage a, *OptIn_WithBounces* = stage b, *OptIn* = stage c (final).

---

## Naming gotchas

- **Activity name ≠ target DE.** The `PDS_<Brand>_Email_FullAudience_WithOptOuts` activities write to `<Brand>_Email_FullAudience_WithOptOuts` (no `PDS_` prefix), and downstream queries read that name.
  - `PDS_Madri_Email_FullAudience_WithOptOut` has no trailing "s", but its DE does.
  - The activities named `PDS_Unified_Affinities` and `PDS_Unified_Website_Engagement` in SFMC write to `PDS_Unified_Affinity` and `PDS_Unified_Website_Engagament`. The files here are named after the DEs.
- **"Engagament"** is misspelled in both the source and unified DE names. It is kept as-is because the queries must match the real DE names.
- **SFMC folders are inconsistent.** HNK and Madri audience activities sit in the root `Query` folder, while the other brands are in `Query/PDS`. The structure in this repo is what to aim for.

## Known issues / limitations

- ⚠️ **Beamish consent bug (likely):** `PDS_Beamish_Email_FullAudience_WithOptOuts` filters on Beamish (`B0534`) but joins `PDS_Brand_EmailConsent_BirraMoretti` for `Consent_Status`. This looks like a copy-paste slip and should probably join a Beamish consent DE.
- **Email-only matching.** Phone numbers and names are not used to link records.
- **Transitive merge depth.** Step 3 resolves one extra hop. Long chains of records linked through different emails (A–B via one email, B–C via another, C–D…) may not fully collapse into one group in a single run.
- **One email per unified consumer.** `PDS_Unified_Communication_Email` keeps only the most recent address, so other addresses for the same person are not carried into audiences.
- `PDS_Unified_Consumer` uses a `RIGHT JOIN`, so every linked consumer gets a row even if the `PDS_Consumer` fields are empty.

---

## Phase 2: CIAM (cidaas), planned

cidaas CIAM data streams into SFMC tables. Phase 2 will apply the same approach to it and add it to the unified view. Expected structure, mirroring `pds/`:

```
ciam/
  01_identity_resolution/
  02_unified_tables/
  03_brand_audiences/
  04_reporting/
```

Open design questions for phase 2:

- Should CIAM identities be resolved into the **same** `Unified_Consumer_Key` space as PDS (a cross-source identity link), or into a separate one first?
- Which match keys to use: email only, or also the cidaas `sub` / user ID and phone?
- Survivorship between PDS and CIAM attributes when both exist.
- Whether `shared/` (OneTrust consent, suppression) needs CIAM-specific additions.
