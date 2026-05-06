# TABLE: CustomerService.agent_transfer

## 1. Purpose
Stores case-level transfer events performed by Customer Service agents.
Each record represents a single case transfer between departments executed by an agent on a specific date.

This table captures **internal workload not reflected as case resolutions** and is a key input for:
- Productivity calculations
- Transfer volume analysis
- Downstream performance and achievement metrics

It is a core dependency of:
- `CustomerService.agent_productivity_new_daily`

---

## 2. Grain
One row per:
- Case transfer event
- Agent
- Transfer date

Each row represents **one transfer action** performed by one agent for one case on a given calendar day.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR600000BkWzYMAV`
- **Report Name:** Agent Transfers

### Functional Definition
This Salesforce report contains case transfer events with the following characteristics:
- One row per transfer event
- Agent who performed the transfer
- Origin department and target department
- Case language
- Case origin

The report is extracted without aggregation and persisted in SQL for analytical reuse.

No aggregation is applied at source.

---

## 4. Physical Table Definition
```sql
CREATE TABLE APP_FLOW.CustomerService.agent_transfer (
	agent_transfer_id int IDENTITY(1,1) NOT NULL,
	[Date] date NOT NULL,
	agent_id int NOT NULL,
	case_number int NOT NULL,
	department_id int NOT NULL,
	new_department int NOT NULL,
	[language] varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	case_origin varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__agent_tr__1B6280868771AF0F PRIMARY KEY (agent_transfer_id),
	CONSTRAINT agent_transfer_agent_FK FOREIGN KEY (agent_id) REFERENCES APP_FLOW.CustomerService.agent(agent_id)
);
 CREATE NONCLUSTERED INDEX IX_agent_transfer_Date_NewDepartment ON APP_FLOW.CustomerService.agent_transfer (  Date ASC  , new_department ASC  )  
	 INCLUDE ( department_id ) 
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
```


## 5. Column Definitions

| Column name        | Type          | Description |
|--------------------|---------------|-------------|
| agent_transfer_id  | int           | Technical surrogate primary key. |
| Date               | date          | Calendar date when the transfer was performed. |
| agent_id           | int           | Identifier of the agent who performed the transfer. |
| case_number        | int           | Salesforce case number associated with the transfer. |
| department_id      | int           | Department owning the case before the transfer. |
| new_department     | int           | Department owning the case after the transfer. |
| language           | varchar(30)   | Language associated with the case (if available). |
| case_origin        | varchar(30)   | Origin of the case (e.g. channel or source system). |

---

## 6. Business Rules & Assumptions

- Each transfer action generates exactly one record in this table.
- Multiple transfers for the same case on the same day are possible and valid.
- Transfers do not represent case resolutions and must be treated separately in productivity calculations.
- `department_id` represents the **origin department**, while `new_department` represents the **destination department**.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `agent_id` must exist in `CustomerService.agent`.
- No uniqueness constraint is enforced on `case_number`.
- Multiple rows per case and day are expected.
- `language` and `case_origin` may be NULL depending on Salesforce data availability.
- Date values are treated as calendar dates; no timezone normalization is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- `CustomerService.agent_productivity_new_daily`
- Productivity and workload analysis dashboards
- Operational transfer volume reporting

### Common Join Keys
- `(agent_id, Date)`
- `case_number`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate this table as a raw event-level fact table.
- Preserve one row per transfer event.
- Avoid collapsing transfers into daily aggregates upstream.

⚠️ **Technical considerations**
- Replace `IDENTITY` with a Snowflake-compatible sequence if required.
- Foreign key constraints should be enforced logically, not physically.
- Consider clustering by `Date` and optionally `new_department`.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on transfer events
- No sequencing of multiple transfers within the same day
- Limited standardization of `language` values
- No audit columns (e.g. insert timestamp, source system)

