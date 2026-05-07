# TABLE: CustomerService.first_response_sla

## 1. Purpose
Stores First Response SLA information at case level.
Each record represents the **difference between the expected and actual first response time** for a customer support case, based on Salesforce milestone tracking.

This table is the **authoritative source for First Response SLA analysis**, used to:
- Measure SLA compliance for first reply
- Identify delays in initial customer response
- Support SLA performance reporting by department

---

## 2. Grain (CRITICAL)
One row per:
- Case
- First response milestone

Each row represents **the first response SLA outcome for a single case**.

⚠️ **Why grain matters**
- SLA calculations assume *one record per case*
- Any duplication per `case_number` would:
  - Inflate SLA breach counts
  - Distort SLA averages and compliance ratios
- This table must not contain multiple rows for the same case unless explicitly versioned

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000BvCqwMAF`
- **Report Type:** Report with milestones
- **Metric:** First Response SLA

### Functional Definition
This Salesforce report contains milestone-based SLA tracking data with:
- Case opening date
- First reply date
- SLA difference calculated by Salesforce
- Department attribution

No aggregation is applied at source.

---

## 4. Physical Table Definition
```sql

CREATE TABLE APP_FLOW.CustomerService.first_response_sla (
    ticket_sla_id INT IDENTITY(1,1) NOT NULL,
    SLA_difference DECIMAL(10,2) NULL,
    Date_open DATE NULL,
    case_number INT NULL,
    department_id INT NULL,
    Date_replied DATE NULL,
    CONSTRAINT PK__ticket_s__3C803FB4F76BE481 PRIMARY KEY (ticket_sla_id)
);
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| ticket_sla_id | int | Technical surrogate primary key. |
| SLA_difference | decimal(10,2) | Difference between SLA target and actual first response time (business-defined unit). |
| Date_open | date | Case opening date. |
| case_number | int | Salesforce case number. |
| department_id | int | Department responsible for the case. |
| Date_replied | date | Date when the first response was sent to the customer. |

---

## 6. Business Rules & Assumptions

- Each case generates at most one first response SLA record.
- SLA calculation logic is fully managed by Salesforce milestones.
- `SLA_difference` interpretation:
  - Negative value → SLA breached
  - Zero or positive value → SLA met
- This table tracks **first response only**, not resolution SLA.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `case_number` may be NULL for incomplete milestone records.
- `Date_replied` may be NULL if no reply was registered.
- No explicit validation of SLA thresholds at database level.
- Date fields are treated as calendar dates; no timezone logic is applied.
- Duplicate cases would directly impact SLA compliance metrics.

---

## 8. Downstream Dependencies

### Direct Consumers
- First Response SLA dashboards
- SLA compliance reporting
- Operational performance scorecards

### Common Join Keys
- `case_number`
- `department_id`
- `Date_open`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a case-level SLA fact table.
- Preserve raw `SLA_difference` values from Salesforce.
- Enforce one-row-per-case logic during migration validation.

⚠️ **Technical considerations**
- Replace `IDENTITY` with a Snowflake sequence if required.
- Consider adding a uniqueness check on `case_number`.
- SLA logic should not be recalculated downstream.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on `case_number`
- No historical versioning of SLA changes
- SLA thresholds not stored (only the difference)
- No audit or ingestion metadata
