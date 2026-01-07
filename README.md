# CustomerService Data Warehouse (SQL Server)
This repository contains the database script SQL_database_CS.sql to create the analytical schema for CustomerService (SQL Server/T‑SQL), including all tables and over 30 views for operational and customer experience metrics.

Scope: Payments, Partners, Hospitality / customer support. Key metrics: ASA, AHT, SLA, ABA (Abandonment), agent productivity, RR (Repeat Rate), VoC (NPS/CSAT/NES), transfers, and quality.

📂 Repository Structure
.
├── SQL_database_CS.sql   # T‑SQL script: schema, tables, indexes, constraints, and views
└── README.md             # This document
└── data&macros           # Excel macros to convert SF reports into SQL Server

🗃️ ## Schema & Objects

Schema: CustomerService (and APP_FLOW.CustomerService for paid sources/ingestion)
Main tables (summary):

department · department catalog (with team_hierarchy and vertical)
agent · agent catalog, TL, and calculated item_target based on seniority
date · extended calendar with Week_number, Week_Year (Thursday–Wednesday week), Month_number
Operational: agent_productivity, agent_transfer, outbounds, incoming_tickets, quality_evaluations, repeat_rate, repeat_cases, resolution_sla, ticket_sla, einstein_cases, surveys_sent, TL_discretion, shrinkage, shifts
VoC/Surveys: VoC (with NPS, CSAT, NES, comments, and calculated calendar columns)
Telephony: SLA_ABA, ASA_AHT (source), IVR_abandoned (with checks and index by dept+date)

The script also creates indexes for high-usage views: IX_incoming_tickets_Date_Department, IX_agent_transfer_Date_NewDepartment, IX_date_Date, etc., and several constraints (PK, UNIQUE, FK, CHECK) for integrity.

Key Relationships (simplified)
 department(1) ──< agent ──< agent_productivity
      │                 │            └─< agent_transfer (dept changes)
      │                 └─< quality_evaluations
      │                 └─< repeat_rate / repeat_cases / repeat_rca
      └─< incoming_tickets / outbounds / ticket_sla / resolution_sla

 date ──< (all tables with Date column)

 VoC ──(join)── department (by name) and agent (by id)
 SLA_ABA + ASA_AHT ──(agg)── telephony metrics (ASA/AHT/SLA/ABA)

The database is organized under the CustomerService schema, with tables and views covering the following core areas:
1. Agent & Team Management

agent: Stores agent profiles, including names, department, team leader, and start date.
tl: Team leader profiles.
agent_target: Defines daily productivity targets by department and agent seniority.
shifts: Tracks agent shift times.
shrinkage: Records shrinkage events (non-productive time).

2. Case & Ticket Tracking

incoming_tickets: Logs incoming support tickets by department, date, agent, and language.
agent_productivity: Tracks cases resolved by agents, including age and department.
agent_transfer: Records case transfers between departments.
billables: Tracks billable cases, time spent, and revenue.

3. Customer Feedback & Surveys

VoC: Voice of Customer survey results, including NPS, CSAT, NES, comments, and resolution status.
surveys_sent: Records surveys sent to customers.
quality_evaluations: Stores quality scores for calls and emails.

4. Performance Metrics

ASA_AHT: Tracks call metrics (Average Speed of Answer, Average Handle Time).
SLA_ABA: Service Level Agreement and Abandonment metrics.
IVR_abandoned: IVR call abandonment statistics.
repeat_cases / repeat_rate / repeats / repeat_rca: Tracks repeat cases and root cause analysis.

5. Operational Data

department: Department metadata, vertical, group, and hierarchy.
date: Calendar table with week, month, and year attributes.
priority: Ticket priority definitions.
inventory: Tracks inventory-related cases.

6. Additional Tables

outbounds: Outbound actions by agents.
resolution_sla: SLA compliance for case resolutions.
spam: Spam case tracking.
support_email: Support email addresses by department.

Views
The database includes numerous views for reporting and analytics, such as:

AGENTS_Monthly_Outbounds: Monthly outbound actions per agent.
AGENTS_Monthly_Productivity: Monthly productivity metrics per agent.
AGENT_KPIS: Key performance indicators per agent.
DAILY_IncomingVSresolved: Daily comparison of incoming tickets vs. resolved cases.
MONTHLY_Call_performance: Monthly call performance metrics.
MONTHLY_VoC_SUMMARY: Monthly summary of customer feedback.

Key Features

Comprehensive agent and case tracking for operational transparency.
Integrated survey and feedback analysis (NPS, CSAT, NES).
Repeat case and root cause analytics for continuous improvement.
Flexible reporting views for daily, weekly, and monthly performance.
Support for multiple departments and verticals.

Usage

Data Extraction: Use SQL queries or reporting tools (e.g., Power BI, DBeaver) to extract and analyze data.
ETL Integration: Data can be loaded from CRM platforms (e.g., Salesforce) and transformed via Excel macros before loading into Azure SQL.
Reporting: Views are optimized for KPI dashboards, agent scorecards, and operational analysis.

Getting Started

Connect to the Database: Ensure VPN access (e.g., FortiClient) and use provided credentials for Azure SQL Server.
Review Schema: Familiarize yourself with table definitions and relationships.
Use Views for Reporting: Leverage pre-built views for common analytics needs.
Maintain Data Integrity: All agent and case changes should be made in SQL, not just in Excel, to avoid reporting errors.

Author & Maintenance

Author: Antonio Romero [antonio.romero@weareplanet.com]
Contact: For technical issues or schema updates, contact the Continuous Improvement Senior Lead.

Additional Resources

Internal documentation and training materials are available for onboarding and advanced usage.
For technical support or access issues, refer to the agent support hotline or internal Confluence pages.
