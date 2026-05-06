# TABLE: CustomerService.billables

## 1. Purpose
Stores billable case-level records generated from Customer Service activity.
Each record represents a billable interaction, task, or case associated with a department and optionally an agent.

This table is used to support:
- Billing and revenue analysis
- Customer chargeability reporting
- Operational and financial reconciliation

It represents the **financial view of operational work**, complementary to productivity and transfer data.

---

## 2. Grain
One row per:
- Billable event
- Case (when applicable)
- Date

Each row represents **one billable item**, which may or may not be associated with:
- A specific case
- A specific agent

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000CBri1MAD`
- **Report Name:** Billables

### Functional Definition
This Salesforce report contains billable records with the following characteristics:
- Billable events linked to cases or operational work
- Associated account and department
- Optional agent attribution
- Revenue and time spent
- Case classification metadata (reason, subreason, issue)

No aggregation is applied at source.

---

## 4. Physical Table Definition

```sql

CREATE TABLE APP_FLOW.CustomerService.billables (
    billables_id INT IDENTITY(1,1) NOT NULL,
    [Date] DATE NOT NULL,
    department_id INT NOT NULL,
    case_number INT NULL,
    billable_type NVARCHAR(50) COLLATE Latin1_General_100_CI_AS_SC NULL,
    account_name NVARCHAR(255) COLLATE Latin1_General_100_CI_AS_SC NULL,
    date_opened DATE NULL,
    case_reason NVARCHAR(255) COLLATE Latin1_General_100_CI_AS_SC NULL,
    subreason NVARCHAR(255) COLLATE Latin1_General_100_CI_AS_SC NULL,
    age INT NULL,
    agent_id INT NULL,
    resolution_reason NVARCHAR(255) COLLATE Latin1_General_100_CI_AS_SC NULL,
    time_spent INT NULL,
    revenue INT NULL,
    issue VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    PMS_OnPrem_maintenance BIT NULL,
    CONSTRAINT PK_billables PRIMARY KEY (billables_id)
);

CREATE NONCLUSTERED INDEX IX_billables_Date_agent
    ON APP_FLOW.CustomerService.billables ([Date], agent_id);

CREATE NONCLUSTERED INDEX IX_billables_case_number
    ON APP_FLOW.CustomerService.billables (case_number);

ALTER TABLE APP_FLOW.CustomerService.billables
    WITH NOCHECK
    ADD CONSTRAINT CK_billables_department_id_4digits
    CHECK (department_id >= 0 AND department_id <= 9999);
```
## 5. Column Definitions

| Column name              | Type            | Description |
|--------------------------|-----------------|-------------|
| billables_id             | int             | Technical surrogate primary key. |
| Date                     | date            | Calendar date of the billable event. |
| department_id            | int             | Department associated with the billable item. |
| case_number              | int             | Salesforce case number (if applicable). |
| billable_type             | nvarchar(50)    | Type or category of billable work. |
| account_name             | nvarchar(255)   | Customer account associated with the billable item. |
| date_opened              | date            | Case opening date (if applicable). |
| case_reason              | nvarchar(255)   | High-level reason for the case. |
| subreason                | nvarchar(255)   | Sub-classification of the case reason. |
| age                      | int             | Case age at billing time (in days). |
| agent_id                 | int             | Agent associated with the billable item (if applicable). |
| resolution_reason        | nvarchar(255)   | Resolution reason for the case. |
| time_spent               | int             | Time spent on the billable work (business-defined unit). |
| revenue                  | int             | Revenue amount associated with the billable item. |
| issue                    | varchar(100)    | Issue classification or code. |
| PMS_OnPrem_maintenance   | bit             | Flag indicating on‑premise PMS maintenance billing. |

---

## 6. Business Rules & Assumptions

- Each billable event generates one record in this table.
- A billable item may or may not be associated with a case (`case_number` can be NULL).
- Agent attribution is optional; some billables are department-level.
- Revenue and time_spent are provided directly by Salesforce logic.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `department_id` is constrained to a 4‑digit numeric range (0–9999).
- `agent_id` may be NULL when billing is not agent-specific.
- `case_number` may be NULL for non-case billables.
- Free-text fields (`reason`, `subreason`, `issue`) are not standardized.
- Date values are treated as calendar dates; no timezone handling is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- Billing and revenue dashboards
- Financial reconciliation reports
- Customer chargeability analysis

### Common Join Keys
- `case_number`
- `(agent_id, Date)`
- `department_id`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw billable fact table.
- Preserve all descriptive and financial fields.
- Maintain event-level granularity.

⚠️ **Technical considerations**
- Replace `IDENTITY` with a Snowflake sequence if required.
- Review NVARCHAR / collation compatibility in Snowflake.
- Consider clustering by `Date`, `department_id`, or `case_number`.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on billable events
- Revenue currency handling not explicit
- No audit / lineage columns (e.g. insert timestamp, source system)
- No reference table enforcing billable_type standardization
