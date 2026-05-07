# TABLE: CustomerService.ticket_SLA

## 1. Purpose
Stores **Resolution SLA** information at case level, based on Salesforce milestone tracking.
Each record represents the **final SLA outcome for case resolution**, including whether the case was resolved within or outside the SLA.

This table is the **authoritative source for Resolution SLA analysis**, used to:
- Measure SLA compliance for case resolution
- Analyse SLA breaches and breacher attribution
- Support operational and quality performance reporting

⚠️ This table does **not** represent First Response SLA (covered separately by `first_response_sla`).

---

## 2. Grain (CRITICAL)
One row per:
- Case
- Resolution milestone

Each row represents **the resolution SLA result for a single case**.

⚠️ **Why grain matters**
- Resolution SLA metrics assume *1 row = 1 case*
- Any duplication per `case_number` would:
  - Inflate SLA breach counts
  - Distort SLA compliance ratios
- This table must not contain multiple resolution SLA rows per case unless explicitly versioned

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000CrpThMAJ`
- **Report Type:** Salesforce report with milestones
- **Metric:** Resolution SLA

### Functional Definition
This Salesforce report contains milestone-based SLA data with:
- Case completion date
- Resolution SLA duration
- Milestone name and SLA timing
- SLA compliance flags
- Breacher attribution (agent)

No aggregation is applied at source.

---

## 4. Physical Table Definition

```sql

CREATE TABLE APP_FLOW.CustomerService.ticket_SLA (
    ticket_SLA_id INT IDENTITY(1,1) NOT NULL,
    completed_date DATE NULL,
    department_id INT NULL,
    case_number INT NULL,
    agent_id INT NULL,
    case_subreason VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    age INT NULL,
    resolution_sla NUMERIC(18,0) NULL,
    agent_id_breacher INT NULL,
    milestone_name VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    SLA_timing VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    Premium VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    status VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    in_SLA VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    case_origin VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    case_reason VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| ticket_SLA_id | int | Technical surrogate primary key. |
| completed_date | date | Date when the case was completed/resolved. |
| department_id | int | Department responsible for resolving the case. |
| case_number | int | Salesforce case number. |
| agent_id | int | Agent who resolved the case. |
| case_subreason | varchar(50) | Case subreason at resolution time. |
| age | int | Case age at resolution (in days). |
| resolution_sla | numeric(18,0) | Resolution SLA duration (business-defined unit). |
| agent_id_breacher | int | Agent responsible for the SLA breach (if applicable). |
| milestone_name | varchar(100) | Name of the SLA milestone evaluated. |
| SLA_timing | varchar(100) | SLA timing classification (e.g. 1–2 days, 5+ days). |
| Premium | varchar(20) | Premium flag as provided by Salesforce. |
| status | varchar(100) | Final case status at resolution. |
| in_SLA | varchar(20) | Indicates whether the case was resolved within SLA. |
| case_origin | varchar(100) | Origin or channel of the case. |
| case_reason | varchar(100) | High-level case reason. |

---

## 6. Business Rules & Assumptions

- Each case generates at most one resolution SLA record.
- SLA logic is fully calculated by Salesforce milestones.
- `in_SLA` is treated as the authoritative SLA compliance flag.
- `agent_id_breacher` is populated only for breached cases.
- Premium logic is sourced directly from Salesforce.

---

## 7. Data Quality Considerations

- `case_number` may be NULL for incomplete milestone records.
- No explicit uniqueness constraint exists on `case_number`.
- SLA units are not explicitly documented in the table.
- Free-text SLA timing labels are not standardised.
- Date fields are treated as calendar dates; no timezone logic is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- Resolution SLA dashboards
- SLA compliance scorecards
- Quality and performance reporting

### Common Join Keys
- `case_number`
- `department_id`
- `completed_date`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a case-level SLA fact table.
- Preserve raw milestone outputs from Salesforce.
- Enforce one-row-per-case logic during migration validation.

⚠️ **Important considerations**
- Do not recalculate SLA logic downstream.
- Replace `IDENTITY` with a Snowflake sequence if required.
- Validate SLA counts vs Salesforce post-migration.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on `case_number`
- No historical SLA versioning
- Premium flag not normalised
- SLA thresholds not stored explicitly
- No audit or ingestion metadata
