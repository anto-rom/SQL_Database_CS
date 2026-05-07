# TABLE: CustomerService.incoming_tickets

## 1. Purpose
Stores incoming ticket volume data for Customer Service.
Each record represents an **incoming ticket event**, optionally enriched with case, agent, reason and language information.

This table is the **authoritative source for incoming volume metrics** and is used to:
- Measure ticket inflow by department and date
- Support workload, capacity and trend analysis
- Serve as denominator in quality and reopen rate metrics

It is a key dependency of:
- `CustomerService.MONTHLY_einstein`
- Volume and demand dashboards
- Capacity planning and forecasting models

---

## 2. Grain (CRITICAL)
One row per:
- Incoming ticket
- Date

Each row represents **one incoming ticket** recorded in Salesforce.

⚠️ **Why grain matters**
- Volume metrics assume *1 row = 1 ticket*
- Monthly aggregations rely on `SUM(ticket_total)`
- Any duplication or aggregation mismatch will directly distort:
  - Incoming ticket counts
  - Ratios such as Reopened vs Incoming

This table must preserve **event-level or minimally atomic ticket granularity**.

---

## 3. Functional Source (Salesforce)

### Salesforce Report
- **Report ID:** `00OR6000007axtZMAQ`
- **Report Name:** Incoming Tickets

### Functional Definition
This Salesforce report contains incoming ticket data with:
- Ticket creation events
- Department attribution
- Optional agent assignment
- Case reason and language

No aggregation is applied at source.

---

## 4. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.incoming_tickets (
    incoming_tickets_id INT IDENTITY(1,1) NOT NULL,
    department_id INT NOT NULL,
    ticket_total INT NULL,
    [Date] DATE NULL,
    agent_id INT NULL,
    case_number INT NULL,
    case_reason VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [language] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT incoming_tickets_pkey PRIMARY KEY (incoming_tickets_id),
    CONSTRAINT incoming_tickets_department_fk
        FOREIGN KEY (department_id)
        REFERENCES APP_FLOW.CustomerService.department(department_id)
);

CREATE NONCLUSTERED INDEX IX_incoming_tickets_Date_Department
    ON APP_FLOW.CustomerService.incoming_tickets ([Date], department_id)
    INCLUDE (ticket_total);
``
```
## 5. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| incoming_tickets_id | int | Technical surrogate primary key. |
| department_id | int | Department receiving the incoming ticket. |
| ticket_total | int | Number of tickets represented by the row (typically 1). |
| Date | date | Ticket creation date. |
| agent_id | int | Agent assigned to the ticket at creation time (if available). |
| case_number | int | Salesforce case number (if applicable). |
| case_reason | varchar(100) | High-level reason assigned to the incoming ticket. |
| language | varchar(30) | Language associated with the ticket. |

---

## 6. Business Rules & Assumptions

- Each incoming ticket is represented by one record.
- `ticket_total` is expected to be **1** in most cases, but is stored explicitly to support flexible aggregation.
- Agent attribution may be missing at ticket creation.
- Case reason and language reflect initial classification.
- No aggregation logic is applied within this table.

---

## 7. Data Quality Considerations

- `case_number` and `agent_id` may be NULL.
- No uniqueness constraint exists on `case_number`.
- Free-text `case_reason` values are not normalized.
- Language values may vary in format and casing.
- Date is treated as a calendar date; no timezone logic is applied.

---

## 8. Downstream Dependencies

### Direct Consumers
- `CustomerService.MONTHLY_einstein`
- Volume and demand dashboards
- Capacity and forecasting models

### Common Join Keys
- `department_id`
- `Date`
- `case_number`

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a raw ticket-level fact table.
- Preserve `ticket_total` even if equal to 1.
- Aggregate only in semantic or reporting layers.

⚠️ **Technical considerations**
- Replace `IDENTITY` with a Snowflake sequence if required.
- Replace indexes with clustering on `Date` and `department_id` if needed.
- Ensure consistency of date logic with the `date` dimension.

---

## 10. Known Gaps / Technical Debt

- No explicit uniqueness constraint on tickets
- No historical tracking of reclassification (reason/language changes)
- Case reason taxonomy not normalized
- No audit or ingestion metadata
