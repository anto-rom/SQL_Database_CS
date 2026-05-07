# TABLE: CustomerService.MNG_discretion

## 1. Purpose
Stores **Manager discretionary scores** assigned to Team Leaders (TLs).
Each record represents a **qualitative, discretionary assessment** performed by a Manager, focused on leadership, engagement, ownership and behavioural performance.

This table is used to:
- Capture qualitative performance signals for Team Leaders
- Support leadership coaching and development discussions
- Complement quantitative KPIs and TL scorecards

⚠️ This is a **MANUAL REPORT**, not a Salesforce‑native dataset.

---

## 2. Report Type
**Manual Report**

Data is not sourced from Salesforce reports.
It originates from Microsoft Forms and is manually processed before ingestion into SQL.

---

## 3. Grain (CRITICAL)
One row per:
- Team Leader
- Evaluation date
- Discretionary assessment

Each row represents **one discretionary score given by a Manager to a Team Leader**.

⚠️ **Why grain matters**
- Multiple discretionary entries may exist for the same TL in the same period.
- Scores are point‑in‑time and subjective.
- This table must not be deduplicated or aggregated at TL level without explicit business rules.

---

## 4. Functional Source (Microsoft Forms)

### Primary Source
- **Microsoft Forms – Manager Discretion Survey**

Responses are consolidated in:
- **TLs Discretion Scores.xlsx**

The Excel file acts as a **controlled consolidation layer** for both:
- TL discretionary inputs
- Manager discretionary inputs

---

## 5. Ingestion & Transformation Process (IMPORTANT)

This table follows a **manual ingestion pipeline**, similar to `TL_discretion`.

### Current process
1. Managers submit discretionary feedback via **Microsoft Forms**.
2. Responses are consolidated in:
   - `TLs Discretion Scores.xlsx`
3. The Excel file contains a dedicated macro that:
   - Reads curated columns from the Main sheet
   - Maps Team Leader names to `tl_id`
   - Normalises dates and scores
   - Escapes free‑text comments
   - Generates a SQL INSERT file
4. The generated SQL file is executed to load data into:
   - `CustomerService.MNG_discretion`

📄 Macro logic is documented in:
- `[Managers_discretion.txt](https://fintraxgroupholdings.sharepoint.com/teams/CSCITeam-Qualitystatsshared/Shared%20Documents/DATA%20BASE/DB%20documents%20%26%20Training/Managers_discretion.txt?EntityRepresentationId=cedabbf7-beb8-4458-8540-4e12bd231c35)` [1](https://fintraxgroupholdings.sharepoint.com/teams/CSCITeam-Qualitystatsshared/Shared%20Documents/DATA%20BASE/DB%20documents%20%26%20Training/Managers_discretion.txt)

---

## 6. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.MNG_discretion (
    MNG_discretion_id INT IDENTITY(1,1) NOT NULL,
    tl_id INT NOT NULL,
    discretion_score FLOAT NULL,
    record_date DATE NOT NULL,
    evaluator_comment NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT PK__MNG_discr__49A1F1F89E99D10E PRIMARY KEY (MNG_discretion_id)
);

```
## 7. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| MNG_discretion_id | int | Technical surrogate primary key. |
| tl_id | int | Team Leader receiving the discretionary score. |
| discretion_score | float | Discretionary score assigned by the Manager. |
| record_date | date | Date when the discretionary score was recorded. |
| evaluator_comment | nvarchar(MAX) | Free‑text qualitative feedback from the Manager. |

---

## 8. Business Rules & Assumptions

- Scores are subjective and non‑standardised.
- There is no enforced scoring range at database level.
- Manager discretion is independent from:
  - TL KPIs
  - Agent quality scores
  - Operational performance metrics
- Comments may include coaching, recognition, corrective or strategic feedback.
- TL mapping depends on a maintained TL reference sheet in Excel.

---

## 9. Data Quality Considerations

- Manual process introduces operational risk.
- No evaluator identifier (manager_id) is stored.
- Scores may vary significantly between Managers.
- Free‑text comments are unstructured.
- TL mapping failures result in NULL `tl_id` at export time.

---

## 10. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Preserve as a standalone manual fact table.
- Maintain raw discretionary scores without recalculation.
- Restrict write access to CI / leadership ownership.

⚠️ **Do not**
- Blend automatically with TL KPIs
- Average scores without agreed business logic
- Treat as an objective or contractual metric

---

## 11. Known Gaps / Technical Debt

- Manual ingestion via Excel + VBA
- No enforced scoring scale
- No evaluator identifier stored
- No historical versioning or review cycle indicator
- No audit or lineage metadata
