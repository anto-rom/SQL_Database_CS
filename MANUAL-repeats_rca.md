# Table: `CustomerService.repeats_rca`

## Overview
This table stores **[brief business purpose of the table]**.  
It is used for **[reporting / SLA tracking / quality / surveys / operational analysis]** within Customer Service.

## Source
- **System**: `APP_FLOW`
- **Domain**: `CustomerService`
- **Data Origin**: [e.g. Salesforce / Internal process / Survey tool]

## Grain
- **One row per**: [ticket / agent / survey / date / case]

## Primary Key
- `<primary_key_column>` – Surrogate key generated using `IDENTITY(1,1)`.

## Columns

| Column Name | Data Type | Nullable | Description |
|------------|----------|----------|-------------|
| `<column_1>` | `int` | No | Description of the column |
| `<column_2>` | `date` | Yes | Description of the column |
| `<column_3>` | `decimal(10,2)` | Yes | Description of the column |
| `<column_4>` | `float` | Yes | Description of the column |
| `<column_5>` | `varchar(n)` | Yes | Description of the column |

## Business Logic
- **[Rule 1]**: Explanation of how the metric or value is calculated.
- **[Rule 2]**: Any transformation or assumption applied.
- **[Rule 3]**: Edge cases or exceptions, if applicable.

## Relationships
- `<foreign_key_column>` → `<schema>.<related_table>.<related_column>`
- Used to join with **[dimension / fact table name]** for reporting.

## Usage
This table is mainly used for:
- SLA monitoring
- Quality and performance analysis
- Team Leader / Manager scorecards
- Power BI dashboards and drill-through analysis

## Refresh & Latency
- **Refresh frequency**: [Daily / Near-real-time / On demand]
- **Expected latency**: [e.g. D+1]

## Data Quality Notes
- Nullable fields may contain `NULL` when the information is not available.
- Duplicate prevention relies on the primary key.
- No hard deletes; historical data is preserved.

## Security & Access
- Contains **no PII** / **limited PII** / **PII** (specify).
- Access restricted to Customer Service analytics users.

## Example
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
