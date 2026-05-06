# TABLE: CustomerService.vonage_status

## 1. Purpose
Stores daily time allocation and status metrics per agent as recorded by the Vonage system.
Each record represents the distribution of an agent’s time across multiple activity states for a given calendar day.

This table is the **authoritative source for productive vs non‑productive time** and is a core input for:
- Productivity calculations
- FTE and target adjustments
- Achievement ratio metrics

It is a primary dependency of:
- `CustomerService.agent_productivity_new_daily`

---

## 2. Grain
One row per:
- Agent
- Calendar date

Each row contains the **daily aggregated time (in seconds)** spent by an agent across multiple Vonage activity states.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000CCwFqMAL`
- **Source System:** Vonage (via Salesforce reporting layer)

### Functional Definition
This report contains daily agent activity metrics with the following characteristics:
- One row per agent and day
- Time spent in each Vonage status (ready, calls, breaks, meetings, etc.)
- First and last activity timestamps

The report is extracted already aggregated at daily level per agent.

---

## 4. Physical Table Definition
```sql
CREATE TABLE APP_FLOW.CustomerService.vonage_status (
    vonage_status_id BIGINT IDENTITY(1,1) NOT NULL,
    [Date] DATE NOT NULL,
    agent_id INT NOT NULL,
    department_id INT NOT NULL,
    ready_time INT NULL,
    inbound_call_time INT NULL,
    transfer_time INT NULL,
    outbound_time INT NULL,
    ready_for_outbound INT NULL,
    prayers INT NULL,
    training INT NULL,
    no_answer INT NULL,
    [hold] INT NULL,
    wrap_up INT NULL,
    total_state_time INT NULL,
    in_meeting INT NULL,
    [break] INT NULL,
    comfort_break INT NULL,
    ready_installations INT NULL,
    ready_offline INT NULL,
    team_meeting INT NULL,
    lunch INT NULL,
    total_time AS (
        ISNULL(ready_time,0)
      + ISNULL(inbound_call_time,0)
      + ISNULL(transfer_time,0)
      + ISNULL(outbound_time,0)
      + ISNULL(ready_for_outbound,0)
      + ISNULL(ready_offline,0)
      + ISNULL(no_answer,0)
      + ISNULL([hold],0)
      + ISNULL(wrap_up,0)
      + ISNULL(prayers,0)
      + ISNULL(training,0)
      + ISNULL(in_meeting,0)
      + ISNULL([break],0)
      + ISNULL(comfort_break,0)
      + ISNULL(ready_installations,0)
      + ISNULL(team_meeting,0)
      + ISNULL(lunch,0)
    ) PERSISTED,
    productive AS (
        ISNULL(ready_time,0)
      + ISNULL(inbound_call_time,0)
      + ISNULL(transfer_time,0)
      + ISNULL(outbound_time,0)
      + ISNULL(ready_for_outbound,0)
      + ISNULL(ready_offline,0)
      + ISNULL(no_answer,0)
      + ISNULL([hold],0)
      + ISNULL(wrap_up,0)
      + ISNULL([break],0)
    ) PERSISTED,
    non_productive AS (
        ISNULL(prayers,0)
      + ISNULL(training,0)
      + ISNULL(in_meeting,0)
      + ISNULL(comfort_break,0)
      + ISNULL(ready_installations,0)
      + ISNULL(team_meeting,0)
      + ISNULL(lunch,0)
    ) PERSISTED,
    first_activity_time DATETIME2(0) NULL,
    last_activity_time DATETIME2(0) NULL,
    CONSTRAINT PK_vonage_status PRIMARY KEY (vonage_status_id)
);

CREATE NONCLUSTERED INDEX IX_vonage_status_Date
    ON APP_FLOW.CustomerService.vonage_status ([Date]);

CREATE NONCLUSTERED INDEX IX_vonage_status_agent
    ON APP_FLOW.CustomerService.vonage_status (agent_id);

CREATE NONCLUSTERED INDEX IX_vonage_status_agent_date
    ON APP_FLOW.CustomerService.vonage_status (agent_id, [Date]);

CREATE NONCLUSTERED INDEX IX_vonage_status_department
    ON APP_FLOW.CustomerService.vonage_status (department_id);

CREATE NONCLUSTERED INDEX IX_vonage_status_dept_date
    ON APP_FLOW.CustomerService.vonage_status (department_id, [Date]);
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| vonage_status_id | bigint | Technical surrogate primary key. |
| Date | date | Calendar date of the activity record. |
| agent_id | int | Agent associated with the Vonage activity. |
| department_id | int | Department of the agent on that date. |
| ready_time | int | Time spent in ready state. |
| inbound_call_time | int | Time spent handling inbound calls. |
| transfer_time | int | Time spent on transfer calls. |
| outbound_time | int | Time spent on outbound calls. |
| ready_for_outbound | int | Time marked as ready for outbound activity. |
| no_answer | int | Time spent on no‑answer outcomes. |
| hold | int | Time spent placing callers on hold. |
| wrap_up | int | Post‑call wrap‑up time. |
| break | int | Standard break time. |
| comfort_break | int | Short comfort breaks. |
| prayers | int | Time spent in prayer status. |
| training | int | Time spent in training activities. |
| in_meeting | int | Time spent in meetings. |
| team_meeting | int | Time spent in team meetings. |
| ready_installations | int | Time marked as ready for installations. |
| ready_offline | int | Offline ready time. |
| lunch | int | Lunch break time. |
| total_time | computed | Total time across all activity states (in seconds). |
| productive | computed | Sum of productive activity time (in seconds). |
| non_productive | computed | Sum of non‑productive activity time (in seconds). |
| first_activity_time | datetime2 | First Vonage activity timestamp of the day. |
| last_activity_time | datetime2 | Last Vonage activity timestamp of the day. |

---

## 6. Business Rules & Assumptions

- One row per agent and date is expected.
- All time values are stored as integers representing seconds.
- Productive and non‑productive times are derived using predefined business logic.
- Computed columns are persisted and reused downstream.
- Department reflects the agent’s department for that date.

---

## 7. Data Quality Considerations

- `agent_id` must exist in `CustomerService.agent`.
- Time metrics may be NULL if Vonage data is missing.
- Sum of activity states may not match full contracted hours.
- No validation enforcing total_time consistency vs source system.
- Date is treated as a calendar date (no timezone logic).

---

## 8. Downstream Dependencies

### Direct Consumers
- `CustomerService.agent_productivity_new_daily`
- Productivity and FTE dashboards
- Operational performance reporting

### Common Join Keys
- `(agent_id, Date)`
- `department_id`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate this table as a daily fact table.
- Re‑implement computed columns (`total_time`, `productive`, `non_productive`) as Snowflake expressions or dbt models.
- Preserve second‑level granularity of time values.

⚠️ **Technical considerations**
- Snowflake does not support persisted computed columns: recompute logically.
- Replace `IDENTITY` with a Snowflake sequence if required.
- Indexes should be replaced by clustering strategies as needed.

---

## 10. Known Gaps / Technical Debt

- Hardcoded categorization of productive vs non‑productive time
- No audit or lineage columns
- No validation of missing or partial Vonage days
- Activity taxonomy not normalized in reference tables
