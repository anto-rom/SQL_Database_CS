# VIEW: CustomerService.agent_productivity_new_daily

## 1. Purpose
Provides the daily productivity view per agent, used for Team Leader Scorecards and operational performance tracking.
The view combines case resolution, transfers, outbound activity and Vonage time data to calculate productivity volumes, targets and achievement ratios.

## 2. Grain
One row per:
- Agent
- Calendar Date

Includes days with no activity if the agent exists in Vonage, Productivity or Transfer data for that date.

## 3. Functional Source (Salesforce)

This model is originally sourced from two Salesforce reports:

### 3.1 Report 00OR600000BZourMAD – Agent Productivity
Represents one row per resolved case:
- Case resolution events
- Agent owning the case
- Department at resolution moment
- Case age at resolution

### 3.2 Report 00OR600000BkWzYMAV – Agent Transfer
Represents one row per transferred case:
- Transfer events between departments
- Agent performing the transfer
- Target department after transfer
- Case language and origin

These reports are materialised into SQL tables for performance and historical consistency.

## 4. Physical Source Tables

### APP_FLOW.CustomerService.agent_productivity
Stores resolved cases per agent/day.

### APP_FLOW.CustomerService.agent_transfer
Stores transfer events per agent/day.
Indexed by Date and new_department to support volume joins.

Additional dependencies:
- CustomerService.vonage_status (time tracking)
- CustomerService.outbounds (outbound contacts)
- CustomerService.agent_target (daily productivity targets)
- CustomerService.agent (agent master data)
- CustomerService.department
- CustomerService.date (calendar)

## 5. Transformation Logic (High‑level)

1. A base key set is generated using UNION of all agents and dates appearing in:
   - Vonage
   - Productivity
   - Transfers

2. Daily aggregations are calculated:
   - Resolved cases
   - Transfers
   - Outbounds
   - Vonage productive / non‑productive / total time

3. Targets are determined dynamically based on:
   - Department
   - Agent tenure (months of service)

4. Productivity ratios are calculated using productive time vs total time.

5. Two productivity target models are exposed:
   - Existing adjusted target (legacy)
   - FTE‑adjusted target (new model)

6. Achievement percentage is calculated only for eligible departments and sufficient productive time.

## 6. Key Output Metrics

- resolved_total
- transfer_total
- outbound_total
- productive / non_productive / total_time
- adjusted_target_calc (legacy model)
- fte_adjusted_target_calc (new model)
- achieved_pct

## 7. Known Gaps / Technical Debt

- "Newly boarded" indicator not implemented
- Premium agent logic not yet included
- Non‑Vonage department list is hardcoded
- Multiple business rules embedded in SQL (should be externalised)

## 8. Migration Notes (Azure → Snowflake)

✅ Recommended approach:
- Migrate source tables at raw grain (not aggregated views)
- Rebuild this logic as a Snowflake view or dbt model
- Externalise hardcoded department logic into reference tables
- Replace CROSS APPLY logic with Snowflake‑compatible patterns

⚠️ Avoid:
- Migrating the final view only (loss of flexibility)
- Pre‑aggregating before Snowflake

## 9. Final SQL (Reference)

```sql
ALTER VIEW CustomerService.agent_productivity_new_daily
AS
WITH keys AS (
    SELECT CAST(vs.[Date] AS date) AS [Date], vs.agent_id
    FROM CustomerService.vonage_status AS vs
    UNION
    SELECT CAST(ap.[Date] AS date), ap.agent_id
    FROM CustomerService.agent_productivity AS ap
    UNION
    SELECT CAST(atf.[Date] AS date), atf.agent_id
    FROM CustomerService.agent_transfer AS atf
),
vonage AS (
    SELECT
        CAST(vs.[Date] AS date) AS [Date],
        vs.agent_id,
        SUM(vs.productive) AS productive,
        SUM(vs.[non_productive]) AS [non_productive],
        SUM(vs.total_time) AS total_time
    FROM CustomerService.vonage_status AS vs
    GROUP BY CAST(vs.[Date] AS date), vs.agent_id
),
resolved AS (
    SELECT CAST([Date] AS date) AS [Date], agent_id, COUNT(*) AS resolved_total
    FROM CustomerService.agent_productivity
    GROUP BY CAST([Date] AS date), agent_id
),
transferred AS (
    SELECT CAST([Date] AS date) AS [Date], agent_id, COUNT(*) AS transfer_total
    FROM CustomerService.agent_transfer
    GROUP BY CAST([Date] AS date), agent_id
),
outbounds AS (
    SELECT CAST([Date] AS date) AS [Date], agent_id, COUNT(DISTINCT outbound_id) AS outbound_total
    FROM CustomerService.outbounds
    GROUP BY CAST([Date] AS date), agent_id
)
SELECT
    d.[Date],
    a.agent_id,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    dep.department_id,
    dep.department_name,
    -- Full FTE daily target
    COALESCE(tgt.item_target_day, 0) AS item_target_day,
    -- Time
    COALESCE(vg.productive, 0) AS productive,
    COALESCE(vg.non_productive, 0) AS non_productive,
    COALESCE(vg.total_time, 0) AS total_time,
    -- Volumes
    COALESCE(rs.resolved_total, 0) AS resolved_total,
    COALESCE(tf.transfer_total, 0) AS transfer_total,
    COALESCE(ob.outbound_total, 0) AS outbound_total,
    -- Non‑Vonage flag
    CASE
        WHEN dep.department_id IN (2,3,12,13,14,15,16,18,21,58,60) THEN 1
        ELSE 0
    END AS is_non_vonage_dept,
    -- Ratio productive
    r.ratio_productive,
    ----------------------------------------------------------------
    -- ✅ EXISTING MODEL (kept as‑is)
    ----------------------------------------------------------------
    at.adjusted_target_calc AS adjusted_target_calc,
    ----------------------------------------------------------------
    -- ✅ NEW MODEL: FTE‑adjusted target
    -- Full FTE target × FTE % × ratio_productive
    ----------------------------------------------------------------
    at_fte.fte_adjusted_target_calc AS fte_adjusted_target_calc,
    ----------------------------------------------------------------
    -- Productivity total
    ----------------------------------------------------------------
    CAST(
        COALESCE(rs.resolved_total, 0)
        + COALESCE(tf.transfer_total, 0)
        AS DECIMAL(19,4)
    ) AS prod_total_model,
    -- Achievement %
    ca.achieved_pct
FROM keys k
JOIN CustomerService.[date] d
    ON CAST(d.[Date] AS date) = k.[Date]
JOIN CustomerService.agent a
    ON a.agent_id = k.agent_id
LEFT JOIN CustomerService.department dep
    ON dep.department_id = a.department_id
LEFT JOIN vonage vg
    ON vg.[Date] = k.[Date] AND vg.agent_id = k.agent_id
LEFT JOIN resolved rs
    ON rs.[Date] = k.[Date] AND rs.agent_id = k.agent_id
LEFT JOIN transferred tf
    ON tf.[Date] = k.[Date] AND tf.agent_id = k.agent_id
LEFT JOIN outbounds ob
    ON ob.[Date] = k.[Date] AND ob.agent_id = k.agent_id
OUTER APPLY (
    SELECT
        CASE
            WHEN a.start_date IS NOT NULL
            THEN DATEDIFF(MONTH, CAST(a.start_date AS date), d.[Date])
            ELSE 0
        END AS months_of_service
) ms
OUTER APPLY (
    SELECT TOP (1) t.item_target_day
    FROM CustomerService.agent_target t
    WHERE t.department_id = dep.department_id
      AND ms.months_of_service BETWEEN t.min_months AND t.max_months
    ORDER BY t.min_months DESC
) tgt
CROSS APPLY (
    SELECT
        CASE
            WHEN COALESCE(vg.total_time, 0) > 0
            THEN CAST(vg.productive AS DECIMAL(19,4))
                 / NULLIF(CAST(vg.total_time AS DECIMAL(19,4)), 0)
            ELSE NULL
        END AS ratio_productive
) r
-- Existing adjusted target
CROSS APPLY (
    SELECT CAST(
        CASE
            WHEN dep.department_id IN (2,3,12,13,14,15,16,18,21)
            THEN tgt.item_target_day
            WHEN r.ratio_productive IS NOT NULL
            THEN tgt.item_target_day * r.ratio_productive
            ELSE NULL
        END
    AS DECIMAL(19,4)) AS adjusted_target_calc
) at
-- ✅ NEW FTE‑adjusted target
CROSS APPLY (
    SELECT CAST(
        CASE
            WHEN r.ratio_productive IS NOT NULL
            THEN tgt.item_target_day
                 * COALESCE(a.fte_pct, 1)
                 * r.ratio_productive
            ELSE NULL
        END
    AS DECIMAL(19,4)) AS fte_adjusted_target_calc
) at_fte
CROSS APPLY (
    SELECT CAST(
        CASE
            WHEN dep.department_id NOT IN (2,3,12,13,14,15,16,18,21)
                 AND COALESCE(vg.productive,0) < 7200
            THEN NULL
            WHEN at.adjusted_target_calc > 0
            THEN
                (COALESCE(rs.resolved_total,0) + COALESCE(tf.transfer_total,0))
                / at.adjusted_target_calc
            ELSE NULL
        END
    AS DECIMAL(12,6)) AS achieved_pct
) ca;
