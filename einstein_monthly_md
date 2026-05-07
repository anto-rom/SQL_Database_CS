# VIEW: CustomerService.MONTHLY_einstein

## 1. Purpose
Provides a monthly aggregation of Einstein case outcomes (reopened vs not reopened) by **department** and **support email/channel**.
This view is used for management reporting of:
- Total cases processed under Einstein scope
- Reopen volumes and reopen rate (%)
- Comparison of reopened cases vs total incoming tickets (monthly)

This is a **semantic/reporting layer** view built on top of case-level and ticket-level facts.

---

## 2. Grain (CRITICAL)
One row per:
- `Week_Year`
- `Month_number`
- `Department`
- `Email address` (support channel)

**Why grain is critical**
- All metrics (counts and percentages) assume the grouping dimensions above define a *unique monthly bucket*.
- Any mismatch in join keys (especially across years) can duplicate or misattribute `incoming_tickets`, which will corrupt:
  - `incoming_tickets`
  - `Reopened_vs_Incoming`

> ⚠️ Important: The current join to the monthly incoming subquery is done using only `(Month_number, department_id)`.  
> If the dataset spans multiple years, month numbers repeat (e.g., Jan 2025 and Jan 2026), which can cause incorrect matches unless `Week_Year` (or a Year field) is also included in the join condition.

---

## 3. Functional Source (Business / Reporting Layer)

This view does **not** come from a Salesforce report directly.
It is derived from:
- Einstein case outcomes (case-level) from `CustomerService.einstein_cases`
- Support channel mapping from `CustomerService.support_email` and `CustomerService.department`
- Calendar attributes from `CustomerService.date`
- Incoming ticket volumes from `CustomerService.incoming_tickets` aggregated monthly

Primary purpose is operational quality reporting around reopenings.

---

## 4. Physical View Definition


```sql
ALTER VIEW CustomerService.MONTHLY_einstein AS
SELECT 
    d.Week_Year,
    d.Month_number,
    dp.department_name AS department,
    CAST(se.email_address AS VARCHAR(MAX)) AS email_address,
    COUNT(ec.case_number) AS total_cases,
    SUM(CASE WHEN ec.reopened = 1 THEN 1 ELSE 0 END) AS Reopened,
    SUM(CASE WHEN ec.reopened = 0 THEN 1 ELSE 0 END) AS Not_Reopened,
    ROUND(
        CAST(SUM(CASE WHEN ec.reopened = 0 THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(COUNT(ec.case_number), 0), 
        2
    ) AS Not_Reopened_Percentage,
    ROUND(
        CAST(SUM(CASE WHEN ec.reopened = 1 THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(COUNT(ec.case_number), 0), 
        2
    ) AS Reopened_Percentage,
    MAX(it_monthly.sum) AS incoming_tickets,
    ROUND(
        CAST(SUM(CASE WHEN ec.reopened = 1 THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(MAX(it_monthly.sum), 0), 
        2
    ) AS Reopened_vs_Incoming
FROM CustomerService.einstein_cases ec
JOIN CustomerService.date d ON ec.Date = d.Date
JOIN CustomerService.support_email se ON ec.support_email_id = se.support_email_id
JOIN CustomerService.department dp ON dp.department_id = se.department_id
LEFT JOIN (
    SELECT 
        d.Week_Year,
        d.Month_number,
        dp.department_id,
        SUM(it.ticket_total) AS sum
    FROM CustomerService.incoming_tickets it
    JOIN CustomerService.date d ON it.Date = d.Date
    JOIN CustomerService.department dp ON dp.department_id = it.department_id
    GROUP BY d.Month_number, dp.department_id, d.Week_Year
) it_monthly 
    ON d.Month_number = it_monthly.Month_number 
   AND dp.department_id = it_monthly.department_id
GROUP BY 
    d.Week_Year,
    d.Month_number, 
    dp.department_name,
    CAST(se.email_address AS VARCHAR(MAX));

  ```
  ## 5. Output Column Definitions

| Output column | Type (logical) | Description |
|--------------|-----------------|-------------|
| Week_Year | string/int | Week-year label from the date dimension used for reporting time-bucketing. |
| Month_number | int | Month number (1–12) from the date dimension. |
| department | string | Department name derived from support email → department mapping. |
| email_address | string | Support email address representing the channel / queue. |
| total_cases | int | Total number of Einstein-scoped cases in the month for the grouping. |
| Reopened | int | Number of cases flagged as reopened (`reopened = 1`). |
| Not_Reopened | int | Number of cases not reopened (`reopened = 0`). |
| Not_Reopened_Percentage | decimal(?,2) | Not reopened rate = Not_Reopened / total_cases (rounded to 2 decimals). |
| Reopened_Percentage | decimal(?,2) | Reopened rate = Reopened / total_cases (rounded to 2 decimals). |
| incoming_tickets | int | Monthly incoming ticket volume for the department (from aggregated `incoming_tickets`). |
| Reopened_vs_Incoming | decimal(?,2) | Reopened / incoming_tickets (rounded to 2 decimals). |

---

## 6. Business Rules & Assumptions

- `einstein_cases` is assumed to be **one row per case** (case-level grain).
- `reopened` is treated as boolean:
  - `1` → reopened
  - `0` → not reopened
- The view counts `case_number` directly; therefore:
  - duplicates in `einstein_cases` will inflate totals and distort rates.
- Incoming tickets are aggregated by month and department from `incoming_tickets`.
- `incoming_tickets` uses `MAX(it_monthly.sum)` in the outer query:
  - assumes there is **at most one** matching monthly incoming value per (month, department).
  - if more than one match exists, `MAX` will hide duplicates but can still be incorrect.

---

## 7. Data Quality Considerations (Important)

### 7.1 Year/Month join risk (high impact)
The incoming tickets monthly subquery groups by `Week_Year` but the LEFT JOIN does not include `Week_Year`.
If the dataset spans multiple years, month numbers repeat and may match the wrong year.

**Recommended fix**
Add `Week_Year` (or a `Year` field) to the join:
- `ON d.Month_number = it_monthly.Month_number AND dp.department_id = it_monthly.department_id AND d.Week_Year = it_monthly.Week_Year`

### 7.2 Null handling
- Division uses `NULLIF` to avoid divide-by-zero, returning NULL percentages when denominators are 0.
- If `incoming_tickets` is NULL (no match), `Reopened_vs_Incoming` becomes NULL.

### 7.3 Case uniqueness
If `einstein_cases` contains duplicates per `case_number`, the reopen metrics will be incorrect.

---

## 8. Downstream Dependencies

### Direct Consumers
- Monthly quality dashboards (Einstein reopen reporting)
- Department performance packs / scorecards

### Input Dependencies
- `CustomerService.einstein_cases`
- `CustomerService.date`
- `CustomerService.support_email`
- `CustomerService.department`
- `CustomerService.incoming_tickets`

---

## 9. Migration Notes (Azure → Snowflake)

✅ Recommended approach
- Rebuild this as a Snowflake view or dbt model in the **semantic layer**.
- Ensure **year-safe joins** for monthly incoming tickets (include `Week_Year` or a true `Year` key).
- Replace SQL Server-specific casting/rounding with Snowflake equivalents where needed (logic stays the same).

⚠️ Technical considerations
- Validate that `date` dimension fields (`Week_Year`, `Month_number`) exist and have identical logic in Snowflake.
- Confirm that incoming tickets aggregation logic matches the business definition of “incoming tickets per month”.

---

## 10. Known Gaps / Technical Debt

- Join to incoming tickets is not year-safe (risk of misattribution across years).
- Uses `VARCHAR(MAX)` / `NVARCHAR(MAX)` patterns upstream; consider standardizing lengths for Snowflake.
- Uses `MAX(it_monthly.sum)` as a safeguard instead of enforcing a unique join; may hide data issues.
- No explicit testing layer (e.g., uniqueness checks on `einstein_cases.case_number`).

## 11. Validation Checks Post‑Migration (Azure → Snowflake)

To ensure correctness and consistency after migration, the following validation checks are recommended.

### 11.1 Case‑level consistency
**Objective:** Ensure that the case grain is preserved.

- Validate that `einstein_cases` contains **one row per `case_number`**.
```sql
SELECT case_number, COUNT(*)
FROM CustomerService.einstein_cases
GROUP BY case_number
HAVING COUNT(*) > 1;
