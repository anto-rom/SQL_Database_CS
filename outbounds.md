# TABLE: CustomerService.outbounds

## 1. Purpose
Stores outbound interaction events performed by Customer Service agents.
Each record represents a single outbound action initiated by an agent, optionally linked to a case.

This table captures **outbound workload not reflected in case resolutions or transfers** and is used to:
- Complete productivity volume calculations
- Measure agent outbound activity
- Complement Vonage and productivity metrics

It is a supporting input for:
- `CustomerService.agent_productivity_new_daily`

---

## 2. Grain
One row per:
- Outbound event
- Agent
- Date

Each row represents **one outbound interaction**, which may or may not be associated with a case.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR6000004woOjMAI`
- **Report Name:** Outbounds

### Functional Definition
This Salesforce report contains outbound interaction records with the following characteristics:
- One row per outbound action
- Agent performing the outbound
- Optional linkage to a Salesforce case
- Department attribution

No aggregation is applied at source.

---

## 4. Physical Table Definition

```sql

CREATE TABLE APP_FLOW.CustomerService.outbounds (
    outbound_id INT IDENTITY(1,1) NOT NULL,
    agent_id INT NULL,
    [Date] DATE NULL,
    department_id INT NULL,
    case_number INT NULL,
    CONSTRAINT outbounds_pk PRIMARY KEY (outbound_id)
);
```
## 5. Column Definitions

| Column name   | Type | Description |
|--------------|------|-------------|
| outbound_id  | int  | Technical surrogate primary key. |
| agent_id     | int  | Identifier of the agent performing the outbound interaction. |
| Date         | date | Calendar date when the outbound occurred. |
| department_id| int  | Department associated with the outbound interaction. |
| case_number  | int  | Salesforce case number associated with the outbound (if applicable). |

---

## 6. Business Rules & Assumptions

- Each outbound interaction generates exactly one record in this table.
- An outbound may or may not be linked to a case (`case_number` can be NULL).
- Agent attribution is optional depending on Salesforce data availability.
- Multiple outbounds per agent and day are expected and valid.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `agent_id`, `Date`, and `department_id` may be NULL due to source limitations.
- No uniqueness constraint exists beyond the surrogate key.
- No validation exists to ensure outbounds correspond to existing cases.
- Date values are treated as calendar dates; no timezone handling is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- `CustomerService.agent_productivity_new_daily`
- Productivity and outbound activity dashboards
- Operational performance reporting

### Common Join Keys
- `(agent_id, Date)`
- `case_number`
- `department_id`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw event-level table.
- Preserve one row per outbound interaction.
- Maintain compatibility with productivity aggregation logic.

⚠️ **Technical considerations**
- Replace `IDENTITY` with a Snowflake sequence if required.
- No indexes required; use clustering if large volumes are expected.
- Consider enforcing NOT NULL rules upstream if data quality improves.

---

## 10. Known Gaps / Technical Debt

- No classification of outbound types
- No duration or effort metrics associated with outbounds
- No audit or lineage columns
- Weak referential integrity with cases and agents
