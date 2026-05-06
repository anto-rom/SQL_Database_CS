# TABLE: CustomerService.calls_not_indexed

## 1. Purpose
Stores call handling records that could not be properly indexed or mapped to standard productivity datasets.
Each record represents a call interaction that occurred but is **not fully integrated into the core Vonage or case-based models**.

This table is primarily used for:
- Gap analysis between call systems and indexed data
- Operational monitoring of unclassified calls
- Data quality and reconciliation purposes

It is **not a core productivity fact table**, but an auxiliary dataset.

---

## 2. Grain
One row per:
- Call interaction
- Agent (when available)
- Date

Each row represents **one non-indexed call event**, potentially lacking full contextual linkage.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000AlYq7MAF`
- **Report Name:** Calls Not Indexed

### Functional Definition
This Salesforce report contains call events that:
- Were handled by Customer Service
- Could not be fully indexed or classified in standard datasets
- May be missing complete case or agent attribution

No aggregation is applied at source.

---

## 4. Physical Table Definition
```sql
CREATE TABLE APP_FLOW.CustomerService.calls_not_indexed (
    calls_not_indexed_id INT IDENTITY(1,1) NOT NULL,
    [Date] DATE NULL,
    related_account VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    handle_time INT NULL,
    department_id INT NULL,
    agent_id INT NULL,
    CONSTRAINT calls_not_indexed_pk PRIMARY KEY (calls_not_indexed_id)
);
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| calls_not_indexed_id | int | Technical surrogate primary key. |
| Date | date | Calendar date when the call occurred. |
| related_account | varchar(100) | Customer account related to the call (if available). |
| handle_time | int | Call handling time (business-defined unit, typically seconds). |
| department_id | int | Department associated with the call. |
| agent_id | int | Agent who handled the call (if available). |

---

## 6. Business Rules & Assumptions

- Each record represents one call interaction that could not be indexed.
- Agent and department attribution may be incomplete or missing.
- Calls in this table are **not guaranteed to be represented** in:
  - `vonage_status`
  - `agent_productivity`
  - `outbounds`
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- High likelihood of missing or NULL values.
- No case_number linkage available.
- No validation enforcing consistency with Vonage totals.
- Date values are treated as calendar dates; no timezone handling is applied.
- This table should not be used as a sole source for productivity metrics.

---

## 8. Downstream Dependencies

### Direct Consumers
- Data quality and reconciliation analysis
- Operational troubleshooting
- Ad‑hoc investigations

### Common Join Keys
- `agent_id`
- `department_id`
- `Date`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw auxiliary table.
- Preserve all records for traceability and reconciliation.
- Clearly document its non-core nature in Snowflake.

⚠️ **Important considerations**
- Do not merge this data into core productivity tables without business validation. Calls not indexed shall be treated as an anomaly.
- Treat as informational rather than metric-defining.
- Clustering is optional and likely unnecessary given expected volumes.

---

## 10. Known Gaps / Technical Debt

- No linkage to cases or Vonage call identifiers
- No classification of call type or outcome
- No audit or ingestion metadata
- Ambiguous business definition of “not indexed”
