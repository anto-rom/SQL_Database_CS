📘 Customer Support SQL Schema - README
Overview
This SQL script defines the CustomerService schema for a customer support data warehouse. It includes table definitions, constraints, indexes, and views that support performance tracking, agent productivity, customer feedback analysis, and operational metrics.

📂 Schema: CustomerService
✅ Tables
The schema includes multiple tables grouped by function:
1. Agent & Team Management

agent: Agent details, including department and team lead.
tl: Team lead information.
TL_discretion: Monthly discretion scores per agent.

2. Operational Metrics

ASA_AHT: Call durations and agent talk times.
SLA_ABA: SLA and abandonment flags per interaction.
IVR_abandoned: Daily call performance metrics.
shifts: Agent shift durations.
shrinkage: Time lost due to shrinkage events.

3. Productivity & Tickets

agent_productivity: Daily case handling per agent.
agent_transfer: Case transfers between departments.
incoming_tickets: Daily ticket volume per department.
tickets_sla: SLA performance per ticket.

4. Customer Feedback

VoC: Voice of Customer survey results.
surveys_sent: Surveys sent per case/account.
RCA_analysis: Root cause analysis linked to VoC.
case_reason: Case reasons and subreasons.

5. Quality & Evaluations

quality_evaluations: Quality scores per case.
repeat_cases: Repeated cases per agent.
repeat_rate: Repeat rate metrics.

6. Support Channels

support_email: Email addresses linked to departments.
einstein_cases: AI-classified cases with resolution status.

7. Reference Tables

department: Department metadata.
date: Calendar table with week/month/year breakdown.
language: Supported languages.
priority: Ticket priority levels.
contact_rate: Contact rate per department.


📊 Views
The script defines daily, weekly, and monthly views for reporting and analysis:
Agent-Level Views

AGENT_KPIS: Monthly KPIs per agent.
AGENTS_Monthly_Productivity, AGENTS_Monthly_Outbounds
AGENT_Monthly_RR, AGENT_Monthly_call_performance
AGENT_monthly_evaluations, AGENT_MONTHLY_VoC

Department-Level Views

MONTHLY_Incoming, MONTHLY_Outbounds, MONTHLY_Productivity
MONTHLY_Call_performance, MONTHLY_Tickets_SLA
MONTHLY_RCA_Analysis, MONTHLY_case_reasons
MONTHLY_Evaluations, MONTHLY_Contact_Rate
MONTHLY_VoC, MONTHLY_VoC_SUMMARY, MONTHLY_VoC_Reasons

Weekly Views

WEEKLY_Incoming, WEEKLY_Outbounds, WEEKLY_Productivity
WEEKLY_Call_performance, WEEKLY_Tickets_SLA
WEEKLY_Evaluations, WEEKLY_Contact_Rate, WEEKLY_RR
WEEKLY_VoC, WEEKLY_einstein

Daily Views

DAILY_Incoming, DAILY_Outbounds, DAILY_RR
DAILY_Call_performance, DAILY_Productivity
DAILY_repeat_cases, DAILY_IncomingVSresolved
agent_productivity_daily_check

Specialized Views

VoC_PMS, VoC_PMS_Negative: Feedback related to Property Management System.
VoC_Partners_L2: Feedback from Partners and L2 teams.
VoC_Payments, VoC_Payments_Negative: Feedback from Payments departments.


🔐 Constraints & Indexes

Primary keys and foreign keys are defined for referential integrity.
Check constraints ensure valid SLA and ABA values.
Indexes are created for performance optimization on key tables.


🧠 Notes

The schema supports agent-level performance tracking, customer satisfaction analysis, and operational efficiency.
Views are designed to align with weekly (Thu–Wed) and monthly reporting cycles.
Calculated fields include SLA percentages, AHT/ASA in seconds, NPS, CSAT, NES, and repeat rates.
