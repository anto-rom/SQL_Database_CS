# TABLE: CustomerService.VoC

## 1. Purpose
Stores Voice of the Customer (VoC) survey responses associated with Customer Service cases.
Each record represents a single customer survey response, including satisfaction, effort and loyalty metrics.

This table is the **authoritative source for Quality and Customer Experience KPIs**, such as:
- NPS
- NES
- CSAT (Service and Product)
- Detractor analysis and customer comments

It supports Quality dashboards, VoC reporting and management scorecards.

---

## 2. Grain
One row per:
- Survey response
- Case (when applicable)
- Date

Each row represents **one VoC survey completed by a customer**, optionally linked to a Salesforce case and an agent.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR6000009TMpbMAG`
- **Report Name:** Voice of the Customer (VoC)

### Functional Definition
This Salesforce report contains customer survey responses with the following characteristics:
- One row per completed survey
- Survey metadata (survey name, NPS type, resolution survey flag)
- Customer satisfaction and loyalty metrics
- Case and agent context when available
- Free‑text customer feedback

No aggregation is applied at source.

---

## 4. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.VoC (
    VoC_ID NUMERIC(18,0) IDENTITY(1,1) NOT NULL,
    [Date] DATE NULL,
    case_number BIGINT NULL,
    survey_name NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    Premium BIT NULL,
    account_name NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    case_origin NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    case_reason NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    case_subreason NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    agent_id INT NULL,
    country NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    NPS_type NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    survey_resolution BIT NULL,
    NPS NUMERIC(5,2) NULL,
    NPS_Reason NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    NES NUMERIC(5,2) NULL,
    CSAT_Service NUMERIC(5,2) NULL,
    CSAT_Product NUMERIC(5,2) NULL,
    customer_comment VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [chain] VARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    department_name VARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    customer_comment_detractor VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Year] AS (DATEPART(YEAR, DATEADD(DAY, -3, [Date]))),
    Month_number AS (DATEPART(MONTH, [Date])),
    Month_name AS (DATENAME(MONTH, [Date])),
    team_hierarchy VARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT PK__VoC__B2E3BB204D3E6DAD PRIMARY KEY (VoC_ID),
    CONSTRAINT UQ_VoC_ID UNIQUE (VoC_ID)
);
```

## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| VoC_ID | numeric(18,0) | Technical surrogate primary key. |
| Date | date | Survey completion date. |
| case_number | bigint | Salesforce case number associated with the survey (if applicable). |
| survey_name | nvarchar | Name of the survey sent to the customer. |
| Premium | bit | Flag indicating Premium customer. |
| account_name | nvarchar | Customer account name. |
| case_origin | nvarchar | Origin or channel of the case. |
| case_reason | nvarchar | High-level reason of the case. |
| case_subreason | nvarchar | Sub-classification of the case reason. |
| agent_id | int | Agent associated with the case/survey (if available). |
| country | nvarchar | Customer country. |
| NPS_type | nvarchar | Type of NPS survey (e.g. transactional, relational). |
| survey_resolution | bit | Indicates if the survey is resolution-related. |
| NPS | numeric(5,2) | Net Promoter Score value. |
| NPS_Reason | nvarchar | Reason provided for the NPS score. |
| NES | numeric(5,2) | Net Effort Score. |
| CSAT_Service | numeric(5,2) | Customer Satisfaction score for service. |
| CSAT_Product | numeric(5,2) | Customer Satisfaction score for product. |
| customer_comment | varchar | Free-text customer feedback. |
| chain | varchar(255) | Customer chain or group (if applicable). |
| department_name | varchar(255) | Department name related to the case. |
| customer_comment_detractor | varchar | Extracted detractor comment (if applicable). |
| Year | computed | Reporting year (week-shifted logic). |
| Month_number | computed | Calendar month number. |
| Month_name | computed | Calendar month name. |
| team_hierarchy | varchar(255) | Team / hierarchy attribution for reporting. |

---

## 6. Business Rules & Assumptions

- Each completed survey generates exactly one record.
- Surveys may or may not be linked to a case or agent.
- NPS, NES and CSAT values are provided directly by Salesforce.
- Computed date fields are included to support reporting logic.
- Premium logic is provided by Salesforce and not recalculated downstream.

---

## 7. Data Quality Considerations

- `agent_id` and `case_number` may be NULL.
- Free‑text fields are not standardized or normalized.
- Multiple surveys per case may exist.
- Date fields are treated as calendar dates.
- No enforcement of valid NPS ranges at database level.

---

## 8. Downstream Dependencies

### Direct Consumers
- Quality & VoC dashboards
- NPS / CSAT management reporting
- Detractor and customer feedback analysis

### Common Join Keys
- `case_number`
- `agent_id`
- `department_name`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw survey‑level fact table.
- Preserve all text and score fields.
- Re‑implement computed columns (`Year`, `Month_*`) in Snowflake or dbt.

⚠️ **Technical considerations**
- Snowflake does not support persisted computed columns.
- Replace `IDENTITY` with a Snowflake sequence if required.
- NVARCHAR collations should be reviewed but are generally compatible.

---

## 10. Known Gaps / Technical Debt

- No normalization of survey types or score ranges
- Open text fields not structured for text analytics
- No audit / ingestion metadata
- No explicit link to Quality evaluation frameworks
