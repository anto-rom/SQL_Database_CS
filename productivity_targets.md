# TABLE: CustomerService.agent_target

## 1. Purpose
Stores daily productivity targets per department and agent seniority.
This table defines the **business-owned productivity objectives** used to calculate expected output and achievement ratios for Customer Service agents.

It is a **reference/configuration table**, not an operational fact table, and is used to:
- Determine daily productivity targets
- Adjust targets based on agent seniority
- Support performance and achievement calculations

It is a key dependency of:
- `CustomerService.agent_productivity_new_daily`

---

## 2. Grain
One row per:
- Department
- Seniority level

Each row defines the **daily item target** applicable to agents within a department and a given seniority range.

---

## 3. Functional Source (Business Defined)

⚠️ **Important:**  
This table does **not** originate from any Salesforce report.

### Source Type
- Business-defined targets
- Manually maintained or loaded from business rules

### Functional Definition
Targets are defined by the business based on:
- Department
- Agent seniority (experience level)
- Minimum and maximum months of service

These targets represent **expected daily productivity** and are subject to review and change.

---

## 4. Physical Table Definition
```sql
CREATE TABLE APP_FLOW.CustomerService.agent_target (
    department_id INT NOT NULL,
    seniority VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    min_months INT NOT NULL,
    max_months INT NULL,
    item_target_day DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_agent_target PRIMARY KEY (department_id, seniority)
);
```
## 5. Column Definitions

| Column name      | Type | Description |
|------------------|------|-------------|
| department_id     | int | Department to which the target applies. |
| seniority         | varchar(20) | Business-defined seniority category for the agent. |
| min_months        | int | Minimum number of months of service for this seniority level. |
| max_months        | int | Maximum number of months of service for this seniority level (NULL = open-ended). |
| item_target_day   | decimal(5,2) | Daily productivity target defined by the business. |

---

## 6. Business Rules & Assumptions

- Targets are defined and maintained by the business.
- Each agent is mapped to a seniority level based on months of service.
- Seniority ranges must not overlap within the same department.
- Targets apply per **full FTE day** before any ratio or FTE adjustments.
- No historical versioning is implemented in this table.

---

## 7. Data Quality Considerations

- No enforcement exists to prevent overlapping `min_months` / `max_months` ranges.
- No foreign key constraint to a department reference table.
- Seniority values are free text and not normalized.
- Changes overwrite previous values without history.

---

## 8. Downstream Dependencies

### Direct Consumers
- `CustomerService.agent_productivity_new_daily`
- Productivity, target and achievement KPIs
- Management and Team Leader scorecards

### Typical Join Logic
- Match agent department
- Match months of service between `min_months` and `max_months`
- Select the most specific applicable target

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Migrate as a reference/configuration table.
- Preserve exact values as defined by the business.
- Consider adding effective date logic if targets change over time.

⚠️ **Important business note**
- Targets **may change every year**.
- Snowflake implementation should support:
  - Easy updates
  - Optional versioning (effective_from / effective_to)

---

## 10. Known Gaps / Technical Debt

- No historical tracking of target changes
- No reference table for seniority values
- No validation preventing overlapping ranges
- No audit or approval metadata (who changed what and when)
