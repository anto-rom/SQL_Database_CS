# SQL_Database_CS
DB for Customer Support operations

## Customer Support Reporting Structure Overview
Our reporting infrastructure for Customer Support—covering Hospitality, Payments, and Partners—is built on a SQL Server database designed to support daily operational insights and performance tracking.
Data Source and ETL Process

The primary data source is Salesforce (SF).
We apply a daily ETL (Extract, Transform, Load) process to clean, enrich, and structure the data before it enters the reporting database.
Data manipulation and cleansing are performed using Excel and VBA macros, which allow for flexible handling of exceptions, data corrections, and formatting.

## Database Structure

The SQL Server database contains a set of reporting tables and views tailored to Customer Support metrics.
These structures are designed to:

Normalize and standardize incoming data.
Support segmentation by department (Hospitality, Payments, Partners).
Enable historical tracking and trend analysis.
Facilitate integration with Excel-based dashboards and reports.

## Key Features

Daily data refresh ensures reports reflect the most recent activity.
Custom logic in VBA macros handles data validation, mapping, and transformation before loading into SQL.
The structure supports KPI reporting, including metrics like ticket volume, resolution time, and agent performance.

🧱 1. Schema Overview

Schema Name: CustomerService
All tables and views are created under this schema, often prefixed with APP_FLOW.CustomerService or CustomerService.


📊 2. Core Tables
These tables store raw and processed data used for reporting:
Agent & Team Structure

agent: Stores agent details, linked to departments and team leaders (tl).
tl: Team leader information.
department: Department metadata including hierarchy and vertical.

Date Dimension

date: Calendar table with fields like Month, Week_number, Week_Year, etc.

Operational Metrics

ASA_AHT_payments: Call metrics including talk time, ring duration, AHT, ASA.
SLA_payments: SLA and ABA flags per interaction.
IVR_abandoned: IVR performance metrics.
incoming_tickets: Daily ticket volume per department.
outbounds: Outbound call counts.
productivity: Agent productivity scores.
quality_evaluations: Quality scores per case.
repeat_cases / repeat_rate: Repeat contact metrics.
tickets_sla: SLA compliance for tickets.

Voice of Customer (VoC)

VoC: Survey results including NPS, CSAT, NES, comments.
surveys_sent: Metadata on surveys sent.
RCA_analysis: Root cause analysis linked to VoC and case data.

Reference Tables

language: Supported languages.
case_reason: Case categorization.


📈 3. Views for Reporting
Views are grouped by granularity and focus area:
Agent-Level KPIs

AGENT_KPIS: Monthly KPIs combining productivity, call metrics, VoC, quality, and repeat rates.
AGENTS_Monthly_Productivity, AGENTS_Monthly_Outbounds: Monthly agent-level aggregations.
AGENT_monthly_evaluations, AGENT_Monthly_RR, AGENT_Monthly_call_performance: Specialized agent views.

Department-Level Aggregates

MONTHLY_* views: Aggregated by department and month (e.g., MONTHLY_Call_performance, MONTHLY_Contact_Rate, MONTHLY_Evaluations, MONTHLY_Incoming, etc.).
WEEKLY_* views: Similar structure but grouped by week.

Daily Views

DAILY_Productivity, DAILY_RR, DAILY_call_performance, DAILY_repeat_cases: Daily breakdowns for operational monitoring.

Specialized VoC Views

VoC_PMS, VoC_PMS_Negative, VoC_Partners_L2, VoC_Payments, VoC_Payments_Negative: Filtered views for specific segments or feedback types.


🔗 Relationships & Constraints

Primary Keys: Defined for all tables, often using identity columns.
Foreign Keys:

agent links to department and tl.
incoming_tickets, transfers, quality_evaluations, etc., link to department.


Check Constraints: Used in IVR_abandoned to validate SLA and ABA values (e.g., between 0 and 1).


🧮 Calculated Columns & Expressions

Many views include calculated KPIs:

SLA %, ABA %, AHT (in seconds), ASA (in seconds)
NPS, CSAT, NES scores
Repeat Rate (RR)
Aggregations using SUM, AVG, COUNT, ROUND, FORMAT




🛠️ ETL & Data Handling

Data is extracted from Salesforce (SF).
Cleaned and transformed using Excel and VBA macros before loading into SQL Server.
Daily refresh ensures up-to-date reporting.
