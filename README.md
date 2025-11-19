###CustomerService Data Warehouse (SQL Server)
This repository contains the database script SQL_database_CS.sql to create the analytical schema for CustomerService (SQL Server/T‑SQL), including all tables and over 30 views for operational and customer experience metrics.

Scope: Payments, Partners, Hospitality / customer support. Key metrics: ASA, AHT, SLA, ABA (Abandonment), agent productivity, RR (Repeat Rate), VoC (NPS/CSAT/NES), transfers, and quality.

📂 Repository Structure
.
├── SQL_database_CS.sql   # T‑SQL script: schema, tables, indexes, constraints, and views
└── README.md             # This document
└── data&macros           # Excel macros to convert SF reports into SQL Server

🗃️ Schema & Objects

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

 📊 Analytical Views (selection & purpose)

Views use DAILY, WEEKLY, MONTHLY, AGENT prefixes for reporting clarity.



Productivity & Activity

DAILY_productivity · mix of cases, transfers, and outbounds per agent and department, with scaling by age
AGENTS_Monthly_Productivity · average productivity per worked day and monthly total per agent
WEEKLY_Productivity · weekly aggregates by department



Telephony (ASA/AHT/SLA/ABA)

DAILY_call_performance, WEEKLY_call_performance, MONTHLY_call_performance · inbound, %SLA, %Abandonment, ASA/AHT in seconds and HH:mm:ss format
AGENT_Monthly_call_performance · metrics by agent and department



Outbounds / Incoming

DAILY_Outbounds, AGENTS_daily_Outbounds, MONTHLY_Outbounds, WEEKLY_Outbounds
DAILY_Incoming_Total · customers vs incoming transfers
DAILY_IncomingVSresolved · incoming vs resolved cases (via agent_productivity)
MONTHLY_Incoming, WEEKLY_Incoming



Repeat Rate (RR)

DAILY_RR, WEEKLY_RR, MONTHLY_RR · %RR = 3_repeats / all_touchpoints * 100
AGENT_Monthly_RR · RR at agent and TL level



Voice of Customer (VoC)

MONTHLY_VoC, WEEKLY_VoC, AGENT_MONTHLY_VoC, MONTHLY_VoC_SUMMARY · NPS, CSAT_Service, NES, CSAT_Product, resolution
Segments: VoC_PMS, VoC_PMS_Negative, VoC_Partners_L2, VoC_Payments, VoC_Payments_Negative
Reasons: MONTHLY_VoC_Reasons



Einstein/Support Email

MONTHLY_einstein, WEEKLY_einstein · reopened vs incoming by email



Ticket SLA & Resolution

DAILY_Ticket_SLA, WEEKLY_Ticket_SLA, MONTHLY_Tickets_SLA
WEEKLY_resolution_sla



RCA & Discretion

MONTHLY_RCA_Analysis · RCA and VoC cross-analysis
Repeat_RCA_view · repeat causes by agent
discretion_scores · monthly discretion score by agent/TL



Comprehensive Agent KPIs

AGENT_KPIS · monthly compendium: outbounds, average productivity, total calls, %SLA, %SLA VIP, %Abandonment, ASA/AHT, resolution, NPS, CSAT/NES, CSAT Product, RR, quality (call/email/total)




🔢 Metric Definitions

ASA (Average Speed of Answer): average total_ring_duration (queue) per call. Returned in seconds; some views also provide HH:mm:ss format.
AHT (Average Handle Time): avg(talk_time) + avg(queue_time) + 120 (includes 120s admin). Result in seconds.
SLA: percentage of calls with sla = 1 over total_calls. (VIP: filter by department_id {37,9,10})
ABA (Abandoned): percentage of calls with aba = 1 over total_calls
RR (Repeat Rate): 3_repeats / all_touchpoints * 100
Productivity: cases per agent/day; in AGENTS_Monthly_Productivity, also prod_per_day = total cases / worked days
VoC:
NPS = %Promoters − %Detractors
CSAT_Service, NES, CSAT_Product = % positive responses over total valid responses
Resolution_total = % surveys with survey_resolution = 1




⚙️ Requirements

SQL Server 2019+ (or Azure SQL) with T‑SQL compatibility: FORMAT, TRY_CONVERT, COUNT_BIG, computed columns, and IDENTITY
Permissions to create schemas, tables, views, indexes, and constraints


The calendar uses Thursday–Wednesday weeks (Week_Year / Week_number). Adjust if your standard differs.

🚀 Installation

Open SQL Server Management Studio (SSMS)
Run the contents of SQL_database_CS.sql in your target database
Verify created objects (example):

SELECT s.name, o.name, o.type_desc
FROM sys.schemas s
JOIN sys.objects o ON o.schema_id = s.schema_id
WHERE s.name IN ('CustomerService','APP_FLOW');

🔒 Quality & Integrity Considerations

Constraints: PK/UNIQUE/FK on agent, department, etc.; CHECKs in IVR_abandoned for sla/aba ranges and non-negative inbound
Collation: The script mixes SQL_Latin1_General_CP1_CI_AS and Latin1_General_100_CI_AS. Keep collation consistent to avoid warnings
Indexes: Nonclustered indexes on high-volume tables (by date/department) to speed up aggregations

🧭 Conventions & Notes

View prefixes: DAILY_, WEEKLY_, MONTHLY_, AGENT_
Month_number and Week_number come from the date table and/or computed columns
department_name is used as a join key in several VoC views; if department names change, consider a department dimension with surrogate key
item_target in agent is a computed column (8/15/20 daily items) based on months since start_date

👤 Author & Context
Designed for Customer Service teams needing daily/weekly/monthly visibility of performance and customer experience.
If you have questions or want to adapt the views to your week model contact Antonio Romero antonio.romero@weareplanet.com

 
