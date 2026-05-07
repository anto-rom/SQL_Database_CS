## Table: `CustomerService.RCA_analysis`

### 1. Description
This table stores **Voice of Customer (VoC) Root Cause Analysis (RCA) results** derived from customer surveys.  
It supports qualitative analysis of **customer feedback**, focusing on **resolution effectiveness**, **recurring issues**, and **service quality drivers**.

### 2. Grain
- One row per **survey response / analysed case**.

### 3. Primary Key
- `RCA_id` – Auto-incremented surrogate key (`IDENTITY(1,1)`).

### 4. Physical table definition

```` sql
CREATE TABLE APP_FLOW.CustomerService.RCA_analysis (
	RCA_id int IDENTITY(1,1) NOT NULL,
	case_number int NULL,
	survey_name nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Premium bit NULL,
	department_id int NULL,
	issue_resolved bit NULL,
	RCA nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] date NULL,
	CONSTRAINT PK__RCA_anal__5FBB2C391BB47082 PRIMARY KEY (RCA_id)
);

````


### 5. Columns

| Column Name | Data Type | Nullable | Description |
|------------|----------|----------|-------------|
| `RCA_id` | `int` | No | Primary key of the table |
| `case_number` | `int` | Yes | Customer Service case identifier |
| `survey_name` | `nvarchar(MAX)` | Yes | Name of the VoC survey |
| `Premium` | `bit` | Yes | Indicates whether the customer is Premium |
| `department_id` | `int` | Yes | Department associated with the case |
| `issue_resolved` | `bit` | Yes | Indicates whether the customer issue was resolved |
| `RCA` | `nvarchar(MAX)` | Yes | Root cause classification derived from VoC analysis |
| `Date` | `date` | Yes | Date when the VoC RCA was recorded |

### Business Rules
- RCA values are **manually assigned by analysts** based on survey feedback.
- Each record represents the **final RCA classification** for a survey response.
- Records may contain `NULL` values when survey attributes are missing.
- Historical data is preserved and not overwritten.

### Relationships
- `case_number` → Customer Service case fact tables
- `department_id` → `CustomerService.departments.department_id`

### Usage
This table is used in:
- VoC RCA distribution and trend analysis
- Customer satisfaction deep‑dive reporting
- Root cause identification for detractor surveys
- Power BI dashboards and drill‑through analysis

### Refresh
- **Frequency**: Manual / analyst‑driven
- **Latency**: Variable, depending on analysis completion

### Notes
- Data is sourced from **Excel‑based VoC analysis files** maintained by analysts.
- An Excel macro exports the analysed results into a SQL insert file consumed by the database. [1](https://fintraxgroupholdings.sharepoint.com/teams/CSCITeam-Qualitystatsshared/Shared%20Documents/DATA%20BASE/DB%20documents%20%26%20Training/VoC_RCA.txt)
- RCA values should not be modified after ingestion to ensure auditability.
