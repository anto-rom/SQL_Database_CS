## Table: `CustomerService.repeat_rca`

### 1. Description
This table stores **Root Cause Analysis (RCA) information for repeat customer service cases**.  
It is used to analyse **repeat drivers**, identify **systemic vs agent‑controlled causes**, and support **Repeat Rate reporting** within Customer Service.

### 2. Grain
- One row per **case** with repeat activity.

### 3. Primary Key
- `repeat_rca_id` – Auto-incremented surrogate key (`IDENTITY(1,1)`).

### 4. Columns

| Column Name   | Data Type | Nullable | Description |
|--------------|----------|----------|-------------|
| `repeat_rca_id` | `int` | No | Primary key of the table |
| `Date` | `date` | Yes | Date when the repeat RCA was recorded |
| `case_number` | `int` | Yes | Unique identifier of the customer service case |
| `agent_id` | `int` | Yes | Identifier of the agent associated with the case |
| `3_repeats` | `int` | Yes | Number of repeat interactions for the same case |
| `repeat_rca` | `varchar` | Yes | Root cause classification of the repeat |

### 5. Business Rules
- RCA values reflect **manual classification** of repeat causes.
- The `3_repeats` field represents the **count of repeat contacts** for the same case.
- Records may contain `NULL` values when information is not available.
- Historical records are not overwritten.

### 6. Relationships
- `agent_id` → `CustomerService.agents.agent_id`
- `case_number` → Customer Service case fact tables

### 7. Usage
This table is used in:
- Repeat Rate analytics
- RCA distribution and trend analysis
- Team Leader and Manager performance reviews
- Power BI dashboards and drill‑through analysis

### 8. Refresh
- **Frequency**: Daily
- **Latency**: D+1

### 9.Notes
- RCA categories are **not modified after ingestion** to preserve auditability.
- The table is designed for **diagnostic analysis**, not SLA measurement.


## 10. Physical Table Definition
```sql
CREATE TABLE APP_FLOW.CustomerService.repeat_rca (
	repeat_rca_id int IDENTITY(1,1) NOT NULL,
	[Date] date NULL,
	agent_id int NULL,
	[3_repeats] int NULL,
	repeat_rca varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	case_number int NULL,
	CONSTRAINT repeat_rca_pkey PRIMARY KEY (repeat_rca_id)
);
```
