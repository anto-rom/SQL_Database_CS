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
-- FULL VIEW DEFINITION (as‑is from Azure)
ALTER VIEW CustomerService.agent_productivity_new_daily
AS
...
