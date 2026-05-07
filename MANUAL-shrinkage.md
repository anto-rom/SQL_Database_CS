## Table: `CustomerService.shrinkage`

### 1. Description
This table stores **agent shrinkage records** at a daily level.  
Shrinkage represents **non‑productive time** such as meetings, training, sick leave, technical issues, or other off‑queue activities reported by Team Leaders.

### 2. Grain
- One row per **agent, date, and shrinkage event**.

### 3. Primary Key
- `shrinkage_id` – Auto-incremented surrogate key (`IDENTITY(1,1)`).

### 4. Physical Table Description

```sql
CREATE TABLE APP_FLOW.CustomerService.shrinkage (
	shrinkage_id int IDENTITY(1,1) NOT NULL,
	[Date] date NULL,
	agent_id int NULL,
	event varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	shrinkage_time numeric(18,0) NULL,
	CONSTRAINT PK__shrinkag__90619FA31094DF7E PRIMARY KEY (shrinkage_id)
);
```

### 5. Columns

| Column Name | Data Type | Nullable | Description |
|------------|----------|----------|-------------|
| `shrinkage_id` | `int` | No | Primary key of the table |
| `Date` | `date` | Yes | Date when the shrinkage occurred |
| `agent_id` | `int` | Yes | Internal identifier of the agent |
| `event` | `varchar(20)` | Yes | Type of shrinkage event (e.g. Sick Leave, Training, Meeting) |
| `shrinkage_time` | `numeric(18,0)` | Yes | Duration of the shrinkage event, expressed in time units |

### 6. Business Rules
- Shrinkage data is **manually entered by Team Leaders** on a daily basis.
- Each record represents a **single shrinkage event** for an agent on a given date.
- Multiple shrinkage events may exist for the same agent and date.
- No automatic validation or standardisation of event names is enforced at ingestion time.

### 7. Data Source
- **Primary input**: Excel file where Team Leaders log daily shrinkage.
- **Intermediate layer**: Consolidated Excel workbook.
- **Ingestion**: VBA macro exports the data into a SQL insert file (`shrinkage_insert.sql`) consumed by the database. [1](https://fintraxgroupholdings.sharepoint.com/teams/CSCITeam-Qualitystatsshared/Shared%20Documents/DATA%20BASE/DB%20documents%20%26%20Training/shrinkage.txt)

### 8. Relationships
- `agent_id` → `CustomerService.agents.agent_id`
- `Date` → Calendar / Date dimension

### 9. Usage
This table is used in:
- Agent productivity and capacity analysis
- Shrinkage rate calculations
- Staffing and workforce planning dashboards
- Operational performance reporting in Power BI

### 10. Refresh
- **Frequency**: Manual / daily
- **Trigger**: Team Leader data submission and macro execution

### 11. Notes
- Shrinkage values are stored **as provided**, without transformation or aggregation.
- Event naming consistency depends on user input and should be standardised at reporting layer if needed.
- Historical records are preserved for auditability and trend analysis.
