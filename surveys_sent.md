# TABLE: CustomerService.surveys_sent

## 1. Purpose
Stores records of **customer surveys sent** for Customer Service cases.
Each record represents a survey invitation sent to a customer, regardless of whether the survey was later answered.

This table is used to:
- Measure survey coverage (sent vs received)
- Calculate response rates when combined with `CustomerService.VoC`
- Support Quality and Customer Experience reporting

It represents the **denominator** for VoC response analysis.

---

## 2. Grain (CRITICAL)
One row per:
- Survey sent
- Case
- Date

Each row represents **one survey invitation sent to a customer**.

⚠️ **Why grain matters**
- Response rate calculations assume *1 row = 1 survey sent*
- Any duplication will:
  - Inflate sent volumes
  - Artificially lower response rates
- This table must not be aggregated before being joined to `VoC`

---

## 3. Functional Source (Salesforce – Transitional)

### Salesforce Report
- **Report ID:** `00OR600000AWEA9MAP`
- **Report Name:** Surveys Sent

### Important Note on Source Change
⚠️ **Source transition in progress**

- Historically, surveys were managed via **Vicasso**.
- Vicasso license is being **discontinued**.
- A **new internal Salesforce survey solution** has been developed by the Salesforce Team.
- The Salesforce report backing this table **will change** accordingly.

📅 **Expected go‑live:** *June (tentative)*

This table should be treated as **source‑stable in schema but source‑unstable in origin**.

---

## 4. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.surveys_sent (
    surveys_sent_id INT IDENTITY(1,1) NOT NULL,
    [Date] DATE NULL,
    department_id INT NULL,
    case_number INT NULL,
    account_name VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    managed_account BIT NULL,
    CONSTRAINT surveys_sent_pk PRIMARY KEY (surveys_sent_id)
);
``
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| surveys_sent_id | int | Technical surrogate primary key. |
| Date | date | Date when the survey invitation was sent. |
| department_id | int | Department associated with the case. |
| case_number | int | Salesforce case number linked to the survey. |
| account_name | varchar(MAX) | Customer account name. |
| managed_account | bit | Flag indicating whether the account is managed. |

---

## 6. Business Rules & Assumptions

- Each survey invitation generates one record.
- A case may receive more than one survey over time.
- Sending a survey does not imply survey completion.
- Account and department reflect values at the time of survey sending.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `case_number` may be NULL for edge cases.
- No uniqueness constraint exists on `(case_number, Date)`.
- Managed account logic depends on Salesforce configuration.
- Date is treated as calendar date; no timezone logic is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- Quality & VoC dashboards
- Survey response rate calculations
- Customer Experience reporting

### Typical Joins
- `surveys_sent.case_number = VoC.case_number`
- `department_id`
- `Date`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw survey‑sent fact table.
- Preserve schema even if Salesforce report changes.
- Validate counts before and after the Salesforce survey migration.

⚠️ **Critical migration note**
- Expect changes in:
  - Survey identifiers
  - Survey logic
  - Timing of survey sending
- Snowflake models must be flexible to accommodate the new Salesforce‑native survey source.

---

## 10. Known Gaps / Technical Debt

- No explicit link to specific survey IDs
- No indicator for **newly boarded customers**
- No indicator for **premium customers**
- Dependency on a Salesforce report that is about to change
- No audit or ingestion metadata
