# TABLE: CustomerService.spam

## 1. Purpose
Stores spam-related cases identified in Salesforce.
Each record represents a **case classified as spam**, typically excluded from operational, productivity and quality metrics.

This table is used to:
- Monitor spam volumes over time
- Exclude spam cases from incoming ticket calculations
- Support data quality and volume cleansing analysis

It acts as a **filtering/enrichment dataset**, not a core operational fact.

---

## 2. Grain (CRITICAL)
One row per:
- Case
- Date

Each row represents **one case identified as spam**.

⚠️ **Why grain matters**
- Spam cases must be excluded at **case level**
- Any duplication would:
  - Overstate spam volumes
  - Incorrectly reduce valid incoming ticket counts
- This table should maintain a strict **1 row = 1 spam case** logic

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000C1fF7MAJ`
- **Report Name:** Spam Cases

### Functional Definition
This Salesforce report contains cases that have been:
- Classified as spam according to Salesforce rules
- Associated with a department and case number
- Flagged for exclusion from standard reporting

No aggregation is applied at source.

---

## 4. Physical Table Definition
```sql
CREATE TABLE APP_FLOW.CustomerService.spam (
    spam_id INT IDENTITY(1,1) NOT NULL,
    [Date] DATE NULL,
    department_id INT NULL,
    case_number INT NULL,
    CONSTRAINT PK__spam__8D33759EBA4A4F79 PRIMARY KEY (spam_id)
);
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| spam_id | int | Technical surrogate primary key. |
| Date | date | Date when the case was identified as spam. |
| department_id | int | Department associated with the spam case. |
| case_number | int | Salesforce case number classified as spam. |

---

## 6. Business Rules & Assumptions

- Each spam case appears once in this table.
- Spam classification logic is fully managed in Salesforce.
- Spam cases should be **excluded** from:
  - Incoming ticket volume
  - Productivity metrics
  - SLA calculations
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `case_number` may be NULL for incomplete or legacy records.
- No uniqueness constraint exists on `case_number`.
- No validation ensures that spam cases exist in `incoming_tickets`.
- Date values are treated as calendar dates; no timezone logic is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- Incoming ticket cleansing logic
- Volume and trend analysis (spam vs valid tickets)
- Data quality monitoring dashboards

### Common Join Keys
- `case_number`
- `department_id`
- `Date`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw exclusion/enrichment table.
- Preserve all spam records for traceability.
- Apply spam exclusion logic downstream (semantic layer).

⚠️ **Important considerations**
- Do not delete spam cases from source fact tables.
- Exclusion should be explicit and auditable.
- Snowflake models should clearly document spam filtering rules.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on `case_number`
- No classification of spam type or reason
- No audit or ingestion metadata
- Weak referential integrity with incoming ticket datasets
