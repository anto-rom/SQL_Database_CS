# TABLE: CustomerService.agent_productivity

## 1. Purpose
Stores one record per resolved case handled by an agent on a specific date.
This table represents agent productivity at case‑level granularity and acts as a core fact table for productivity, volume and performance reporting.

It is one of the foundational sources for the view:
- `CustomerService.agent_productivity_new_daily`

## 2. Grain
One row per:
- Case
- Agent
- Resolution date

Each row represents **one resolved case** performed by a specific agent on a given day.

## 3. Functional Source (Salesforce)

### Salesforce Report
**Report ID:** `00OR600000BZourMAD`

This report contains resolved case events with the following key characteristics:
- One row per resolved case
- Agent who resolved the case
- Department at time of resolution
- Case age

No aggregation is applied at source.

## 4. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.agent_productivity (
    agent_prod_id INT IDENTITY(1,1) NOT NULL,
    [Date] DATE NOT NULL,
    agent_id INT NOT NULL,
    case_number INT NOT NULL,
    department_id INT NOT NULL,
    age INT NULL,
    CONSTRAINT PK__agent_pr__963B65ACBB683AB7 PRIMARY KEY (agent_prod_id),
    CONSTRAINT agent_productivity_agent_FK 
        FOREIGN KEY (agent_id) 
        REFERENCES APP_FLOW.CustomerService.agent(agent_id)
);
## 5. Column Definitions

| Column name     | Type | Description |
|-----------------|------|-------------|
| agent_prod_id   | int  | Technical surrogate primary key. Used only for internal identification. |
| Date            | date | Calendar date when the case was resolved. |
| agent_id        | int  | Identifier of the agent who resolved the case. |
| case_number     | int  | Salesforce case number associated with the resolution event. |
| department_id   | int  | Department owning the case at the time of resolution. |
| age             | int  | Age of the case at the resolution moment (in days). |

---

## 6. Business Rules & Assumptions

- Each resolved case generates exactly one record in this table.
- Multiple rows per agent and day are expected and correct.
- `department_id` reflects the department **at the moment of resolution**, not the initial case assignment.
- Reopened cases are only included if Salesforce generates a new resolution event.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `agent_id` must exist in `CustomerService.agent`.
- No uniqueness constraint is enforced on `case_number`.
- Duplicate records are assumed to be prevented at the Salesforce extraction layer.
- Date values are treated as calendar dates; no timezone normalization is applied.
- Null values are allowed only for the `age` column.

---

## 8. Downstream Dependencies

### Direct Consumers
- `CustomerService.agent_productivity_new_daily`
- Productivity and performance dashboards (Power BI)
- Team Leader and Manager scorecards

### Common Join Keys
- `(agent_id, Date)`
- `department_id`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate this table as a **raw fact table**, preserving case‑level granularity.
- Avoid pre‑aggregating data before loading into Snowflake.
- Preserve historical data for longitudinal analysis.

⚠️ **Technical considerations**
- Replace `IDENTITY` with a Snowflake sequence or remove if not required.
- Foreign key constraints should be enforced logically, not physically.
- Consider clustering by `Date` and `agent_id` for performance.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on `(case_number, Date)`.
- Case reopen history is not explicitly modeled.
- No audit or lineage columns (e.g. `insert_ts`, `source_system`).
- Department historical changes beyond resolution date are not tracked.
