# TABLE: CustomerService.agent_productivity

## 1. Purpose
Stores case-level productivity data for Customer Service agents.
Each record represents a single resolved case handled by an agent on a specific date.

This table is a foundational fact table used to calculate:
- Agent productivity volumes
- Daily performance metrics
- Downstream achievement and target calculations

It is a core input for the following view:
- `CustomerService.agent_productivity_new_daily`

---

## 2. Grain
One row per:
- Case
- Agent
- Resolution date

Each row corresponds to **one resolved case** performed by one agent on a given calendar day.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000BZourMAD`
- **Report Name:** Agent Productivity (Resolved Cases)

### Functional Definition
This Salesforce report contains resolved case events with the following characteristics:
- One row per resolved case
- Agent responsible for the resolution
- Department at the moment of resolution
- Case age at resolution time


This report contains resolved case events with the following key characteristics:
- One row per resolved case
- Agent who resolved the case
- Department at time of resolution
- Case age

No aggregation is applied at source.

---

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
```

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
- `department_id` reflects the department at the moment of resolution.
- Reopened cases are only included if a new resolution event is generated.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `agent_id` must exist in `CustomerService.agent`.
- No uniqueness constraint is enforced on `case_number`.
- Date is treated as a calendar date (no timezone handling).
- Null values are allowed only for the `age` column.

---

## 8. Downstream Dependencies

**Direct consumers:**
- `CustomerService.agent_productivity_new_daily`
- Productivity and performance dashboards (Power BI)
- Team Leader scorecards

**Common join keys:**
- `(agent_id, Date)`
- `department_id`

---

## 9. Migration Notes (Azure → Snowflake)

**Recommended:**
- Migrate as a raw fact table (case-level granularity).
- Avoid pre-aggregation prior to Snowflake.
- Preserve historical data.

**Considerations:**
- Replace `IDENTITY` with a Snowflake sequence if required.
- Enforce foreign keys logically, not physically.
- Consider clustering on `Date` and `agent_id`.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on `(case_number, Date)`
- Case reopen history not explicitly modeled
- Missing audit / lineage columns
- Department history beyond resolution date not tracked
