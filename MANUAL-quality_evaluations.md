# TABLE: CustomerService.quality_evaluations

## 1. Purpose
Stores **manual quality evaluations** performed by Team Leaders on Customer Service cases.
Each record represents the outcome of a **single quality evaluation** for an agent–case interaction.

This table is the **authoritative source for Quality metrics**, used to:
- Calculate quality scores at agent, team and department level
- Support Quality scorecards and performance reviews
- Enable root cause and coaching analysis

⚠️ This is a **MANUAL REPORT**, not a Salesforce‑native dataset.

---

## 2. Report Type
**Manual Report**

Data is not sourced directly from Salesforce.
It is collected via Microsoft Forms and processed manually before being loaded into SQL.

---

## 3. Grain (CRITICAL)
One row per:
- Quality evaluation
- Agent
- Case

Each row represents **one completed quality evaluation form**.

⚠️ **Why grain matters**
- Multiple evaluations may exist for the same agent or case across time.
- Aggregations assume evaluations are independent events.
- This table must not be deduplicated at case or agent level.

---

## 4. Functional Source (Microsoft Forms)

### Primary Source
- **Microsoft Forms – Quality Evaluation Form**
- Responses are consolidated in:
  - **Scoring_sheet_2026.xlsx**

🔒 **Access restriction**
- Only the **Continuous Improvement team** has edit access.
- This is intentional to prevent:
  - Accidental overwrites
  - Formula corruption
  - Historical score manipulation

---

## 5. Ingestion & Transformation Process (IMPORTANT)

This table follows a **manual ingestion pipeline**.

### Current process
1. Team Leaders complete quality evaluations in **Microsoft Forms**.
2. Responses are consolidated in:
   - `Scoring_sheet_2026.xlsx`
3. A dedicated Excel macro:
   - Selects relevant columns
   - Normalises headers and text
   - Maps agent and evaluator identifiers
   - Validates required fields
   - Generates SQL INSERT statements
4. The SQL file is executed to load data into:
   - `CustomerService.quality_evaluations`

📄 Macro logic is documented in:
- `quality_evaluations.txt`

---

## 6. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.quality_evaluations (
    quality_evaluations_id INT IDENTITY(1,1) NOT NULL,
    department_id INT NOT NULL,
    agent_id INT NOT NULL,
    [Date] DATE NULL,
    quality_total DECIMAL(18,2) NULL,
    case_number BIGINT NULL,
    evaluator INT NULL,
    case_type VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    related_topic1 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    related_topic2 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    related_topic3 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    related_topic4 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    evaluator_comment VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Friendliness_&_Professionalism] INT NULL,
    Clear_Communication INT NULL,
    [Practices_&_Processes] INT NULL,
    Problem_resolution INT NULL,
    Request_feedback INT NULL,
    CONSTRAINT quality_evaluations_pkey PRIMARY KEY (quality_evaluations_id)
);
```
## 7. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| quality_evaluations_id | int | Technical surrogate primary key. |
| department_id | int | Department evaluated. |
| agent_id | int | Agent being evaluated. |
| Date | date | Evaluation date. |
| quality_total | decimal | Total quality score for the evaluation. |
| case_number | bigint | Salesforce case number evaluated. |
| evaluator | int | Evaluator identifier (Team Leader / QA). |
| case_type | varchar | Type of case evaluated (email, call, portal, etc.). |
| related_topic1–4 | varchar | Topics associated with the case. |
| evaluator_comment | varchar(500) | Free‑text evaluator feedback. |
| Friendliness_&_Professionalism | int | Score for friendliness and professionalism. |
| Clear_Communication | int | Score for communication clarity. |
| Practices_&_Processes | int | Score for process adherence. |
| Problem_resolution | int | Score for resolution quality. |
| Request_feedback | int | Score for request feedback handling. |

---

## 8. Business Rules & Assumptions

- Evaluations are subjective but follow a standardised scoring rubric.
- Scores are provided by Team Leaders.
- All dimensions contribute to `quality_total`.
- A case can be evaluated multiple times by different evaluators.

---

## 9. Data Quality Considerations

- Manual process introduces operational risk.
- No automated validation against Salesforce case lifecycle.
- Evaluator mapping may fail if new evaluators are not added to mapping sheets.
- Text fields are free‑form and not standardised.

---

## 10. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Treat as a **manual semantic fact table**.
- Preserve structure and scoring logic.
- Ensure Snowflake permissions reflect restricted ownership.

⚠️ **Do not**
- Attempt to auto‑rebuild from Salesforce
- Deduplicate at case level
- Recalculate scores downstream

---

## 11. Known Gaps / Technical Debt

- Manual ingestion process (Excel + VBA)
- No explicit flags for **newly boarded customers**
- No explicit flags for **premium customers**
- Evaluator logic embedded in macro
- No audit or lineage metadata



