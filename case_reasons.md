# TABLE: CustomerService.case_reason

## 1. Purpose
Stores case-level classification data related to case reasons and subreasons.
Each record represents the **reason categorisation of a case** at a given point in time, enriched with basic contextual information.

This table is primarily used to support:
- Case mix analysis (reasons / subreasons)
- Root Cause Analysis (RCA)
- Premium vs non‑premium segmentation
- Quality and operational breakdowns

It complements core productivity and VoC datasets by adding **reason-level context**.

---

## 2. Grain
One row per:
- Case
- Date

Each row represents **one case reason record**, associated with a case and optionally an agent and department.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR60000063JYvMAM`
- **Report Name:** Case Reason

### Functional Definition
This Salesforce report contains case classification information with the following characteristics:
- One row per case
- Case reason and subreason as defined in Salesforce
- Case age and premium flag
- Basic contextual attributes (account, department, agent)

No aggregation is applied at source.

---

## 4. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.case_reason (
    case_reason_id INT IDENTITY(1,1) NOT NULL,
    department_id INT NULL,
    case_number INT NULL,
    age INT NULL,
    [Date] DATE NULL,
    case_reason VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    case_subreason VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    premium BIT NULL,
    account_name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT case_reason_pk PRIMARY KEY (case_reason_id)
);
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| case_reason_id | int | Technical surrogate primary key. |
| department_id | int | Department associated with the case. |
| case_number | int | Salesforce case number. |
| age | int | Case age at the time of extraction (in days). |
| Date | date | Reference date for the case reason record. |
| case_reason | varchar | High-level reason assigned to the case. |
| case_subreason | varchar | Detailed subreason assigned to the case. |
| premium | bit | Flag indicating whether the case belongs to a Premium customer. |
| account_name | nvarchar(100) | Customer account name. |

---

## 6. Business Rules & Assumptions

- Each case generates at most one reason/subreason record per extraction.
- Case reasons and subreasons are assigned and maintained in Salesforce.
- Premium flag is sourced directly from Salesforce logic.
- The table does not track historical changes of reasons over time.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `case_number` may be NULL for edge cases or incomplete records.
- Case reasons and subreasons are free‑text or semi‑structured fields.
- No reference tables enforce valid reason/subreason combinations.
- Date is treated as a calendar date; no timezone logic is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- Case mix and RCA dashboards
- Quality analysis and reporting
- Premium vs non‑Premium segmentation analyses

### Common Join Keys
- `case_number`
- `department_id`
- `Date`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw enrichment table.
- Preserve original reason and subreason values.
- Join downstream to factual datasets using `case_number`.

⚠️ **Technical considerations**
- Replace `IDENTITY` with a Snowflake sequence if required.
- Consider normalising reasons/subreasons into reference tables.
- No clustering required unless volume grows significantly.

---

## 10. Known Gaps / Technical Debt

- No historical tracking of reason changes
- No standardised reason/subreason taxonomy
- No audit or ingestion metadata
- Weak referential integrity with case core tables
