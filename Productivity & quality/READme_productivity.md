README: CustomerService.agent_productivity_new_daily
## Purpose
This view consolidates daily productivity metrics for agents, combining Vonage and non-Vonage models into a unified structure. It serves as the foundation for performance tracking, SLA compliance, and operational reporting.

## Key Features

Unified Model: Handles both Vonage and non-Vonage departments.
Daily Targets: Targets are sourced from CustomerService.agent_target based on department_id and months_of_service ranges.
Fallback Logic: If hire_date is missing, months_of_service defaults to 0.
Safe Arithmetic: Uses wide DECIMAL types to prevent overflow (Error 8115).
Outbound Actions: Counts distinct outbound_id from CustomerService.outbounds.
Achieved Percentage: Returns ratio in [0,1] (not multiplied by 100).
Transferred Cases: Included in productivity for both models.


## Data Sources

CustomerService.vonage_status → Vonage time metrics.
CustomerService.agent_productivity → Resolved cases.
CustomerService.agent_transfer → Transferred cases.
CustomerService.outbounds → Outbound actions.
CustomerService.agent_target → Daily targets by department and tenure.
CustomerService.agent & CustomerService.department → Agent and department details.


## Logic Overview

Keys CTE: Collects distinct (Date, agent_id) across all fact tables.
Vonage CTE: Aggregates productive, non-productive, and total time per agent/day.
Resolved & Transferred CTEs: Counts cases resolved and transferred per agent/day.
Outbounds CTE: Counts distinct outbound actions per agent/day.
Target Calculation:

Determines months_of_service via DATEDIFF.
Selects applicable target range from agent_target.


## Model Adjustments:

For non-Vonage: fixed target.
For Vonage: target adjusted by ratio_productive (productive/total_time).


## Achieved %:

Ratio of productivity to adjusted target.
Applies quality rule: if Vonage productive time < 7200s, returns NULL.




## Output Columns

Date: Reporting date.
Agent Info: agent_id, agent_name.
Department Info: department_id, department_name.
item_target_day: Daily target from agent_target.
Vonage Metrics: productive, non_productive, total_time.
Case Totals: resolved_total, transfer_total.
Outbound Total: Distinct outbound actions.
is_non_vonage_dept: Flag for non-Vonage departments.
ratio_productive: Productive time ratio.
target_model: Adjusted target for the model.
prod_total_model: Productivity total for the model.
achieved_pct: Achievement ratio (0–1, can exceed 1 if overachieved).


## Business Rules

Non-Vonage departments: IDs (2,3,12,13,14,15,16,18,21).
Vonage productivity requires logged time; otherwise, productivity = 0.
Achieved % is NULL if Vonage productive time < 7200s (quality rule).
