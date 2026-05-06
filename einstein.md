# TABLE: CustomerService.einstein_cases

## 1. Purpose
Stores case-level records used for Einstein-based analysis of case reopenings.
Each record represents a **single closed case** evaluated by Einstein logic, including whether the case was reopened.

This table is the **authoritative source for Reopened vs Not Reopened metrics**, and is used to support:
- Reopen rate analysis
- Quality and resolution effectiveness KPIs
- Monthly Einstein reporting by department and support channel

It feeds the derived view:
- `CustomerService.MONTHLY_einstein`

---

## 2. Grain (CRITICAL)

**One row per case**.

More precisely:
- One row per `case_number`
- Associated to a specific date and (optionally) agent
- With a single reopened flag per case

⚠️ **This grain is critical** because:
- Reopen rate metrics assume *1 row = 1 case*
- Any duplication at source would directly corrupt:
  - Reopened percentage
  - Reopened vs Incoming ratios
- The derived monthly view relies on simple `COUNT(case_number)` logic

This table **must never contain duplicates per case** for accurate analytics.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000BiKBBMA3`
- **Report Name:** Einstein Cases

### Functional Definition
This Salesforce report contains case-level Einstein evaluation data with:
- One row per closed case
- Case reason and subreason at closure
- Resolution reason
- Reopen indicator (boolean)
- Support email / channel attribution

No aggregation is applied at source.

---

## 4. Physical Table Definition
``` sql
CREATE TABLE APP_FLOW.CustomerService.einstein_cases (
    einstein_cases_id INT IDENTITY(1,1) NOT NULL,
    [Date] DATE NULL,
    case_number INT NULL,
    agent_id INT NULL,
    case_reason NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    support_email_id INT NULL,
    subreason NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    reopened BIT NULL,
    resolution_reason NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT PK__einstein__95186CE8545800AB PRIMARY KEY (einstein_cases_id)
);
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| einstein_cases_id | int | Technical surrogate primary key. |
| Date | date | Case closure date used for reporting and aggregation. |
| case_number | int | Salesforce case number (unique per row by design). |
| agent_id | int | Agent associated with the case at resolution time. |
| case_reason | nvarchar | High-level case reason at closure. |
| support_email_id | int | Identifier of the support email/channel used. |
| subreason | nvarchar | Detailed subreason at closure. |
| reopened | bit | Indicates whether the case was reopened after closure. |
| resolution_reason | nvarchar | Resolution classification at closure. |

---

## 6. Business Rules & Assumptions

- Each closed case appears exactly once in this table.
- `reopened = 1` means the case was reopened at least once.
- Reopen logic is calculated upstream (Salesforce / Einstein).
- Case reasons and subreasons reflect values at closure time.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- Duplicate `case_number` rows would invalidate reopen metrics.
- `reopened` should always be populated for valid records.
- Free-text fields are not normalized.
- `agent_id` may be NULL depending on case attribution.
- Date is treated as a calendar date; no timezone logic is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- `CustomerService.MONTHLY_einstein`
- Quality and performance dashboards
- Management reporting on reopen rates

### Common Join Keys
- `case_number`
- `Date`
- `support_email_id`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a strict case-level fact table.
- Enforce uniqueness on `case_number` logically.
- Preserve 1‑row‑per‑case semantics.

⚠️ **Critical warning**
- Any duplication or pre-aggregation will break reopen percentages.
- Snowflake implementation should validate counts vs Salesforce.

---

## 10. Known Gaps / Technical Debt

- No explicit unique constraint on `case_number`
- Reopen event timing/history not stored (only boolean)
- No audit or ingestion metadata
- Case reason taxonomy not normalized
``
