# TABLE: CustomerService.TL_discretion

## 1. Purpose
Stores **Team Leader discretionary scores** assigned to agents.
Each record represents a **qualitative, discretionary assessment** performed by a Team Leader, independent from formal quality evaluations.

This table is used to:
- Capture qualitative performance signals not reflected in KPIs
- Support coaching, recognition and development discussions
- Complement Quality, Productivity and VoC metrics

⚠️ This is a **MANUAL REPORT**, not a Salesforce‑native dataset.

---

## 2. Report Type
**Manual Report**

Data is not sourced from Salesforce reports.
It originates from Microsoft Forms and is manually processed before ingestion into SQL.

---

## 3. Grain (CRITICAL)
One row per:
- Agent
- Evaluation date
- Discretionary assessment

Each row represents **one discretionary score given by a Team Leader to an agent**.

⚠️ **Why grain matters**
- Multiple discretionary entries may exist for the same agent in the same month.
- Scores are point‑in‑time assessments.
- This table must not be aggregated or deduplicated at agent level.

---

## 4. Functional Source (Microsoft Forms)

### Primary Source
- **Microsoft Forms – TL Discretion Survey**

Responses are consolidated in:
- **TLs Discretion Scores.xlsx**

This Excel file acts as a **controlled consolidation layer**.

---

## 5. Ingestion & Transformation Process (IMPORTANT)

This table follows a **manual ingestion pipeline**.

### Current process
1. Team Leaders submit discretionary feedback via **Microsoft Forms**.
2. Responses are consolidated in:
   - `TLs Discretion Scores.xlsx`
3. The Excel file contains a dedicated macro that:
   - Reads curated columns from the Main sheet
   - Maps agent names to `agent_id`
   - Normalises dates and scores
   - Escapes free‑text comments
   - Generates a SQL INSERT file
4. The generated SQL file is executed to load data into:
   - `CustomerService.TL_discretion`

📄 Macro logic is documented in:
- `TL_discretion.txt`

---

## 6. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.TL_discretion (
    TL_discretion_id INT IDENTITY(1,1) NOT NULL,
    agent_id INT NOT NULL,
    discretion_score FLOAT NULL,
    record_date DATE NOT NULL,
    evaluator_comment NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT PK__TL_discr__49A1F1F89E99D10E PRIMARY KEY (TL_discretion_id)
);
```
## 7. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| TL_discretion_id | int | Technical surrogate primary key. |
| agent_id | int | Agent receiving the discretionary score. |
| discretion_score | float | Discretionary score assigned by the Team Leader. |
| record_date | date | Date when the discretionary score was recorded. |
| evaluator_comment | nvarchar(MAX) | Free‑text qualitative feedback from the Team Leader. |

---

## 8. Business Rules & Assumptions

- Scores are subjective and non‑standardised.
- There is no enforced scoring range at database level.
- Discretionary scores are independent from formal Quality evaluations.
- Comments may include coaching, recognition or corrective feedback.
- Agent mapping depends on a maintained agent reference sheet.

---

## 9. Data Quality Considerations

- Manual process introduces operational risk.
- No validation against agent tenure, role or activity volume.
- Scores may vary significantly between Team Leaders.
- Free‑text comments are unstructured.
- Agent mapping failures result in NULL agent_id at export time.

---

## 10. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Preserve as a standalone manual fact table.
- Maintain raw discretionary scores without recalculation.
- Ensure Snowflake permissions restrict write access.

⚠️ **Do not**
- Blend with Quality scores automatically
- Average or normalise scores without business agreement
- Treat as an objective KPI

---

## 11. Known Gaps / Technical Debt

- Manual ingestion via Excel + VBA
- No enforced scoring scale
- No evaluator identifier stored
- No versioning or history tracking
- No audit or lineage metadata
