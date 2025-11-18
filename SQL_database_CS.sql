-- DROP SCHEMA CustomerService;

CREATE SCHEMA CustomerService;
-- APP_FLOW.CustomerService.ASA_AHT definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.ASA_AHT;

CREATE TABLE APP_FLOW.CustomerService.ASA_AHT ( [Date] date NULL, department_id int NULL, aba int NULL, total_call_duration int NULL, aht int NULL, agent_id int NULL, interaction_type nvarchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, [language] nvarchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, agent_talk_time int NULL, total_ring_duration int NULL);


-- APP_FLOW.CustomerService.IVR_abandoned definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.IVR_abandoned;

CREATE TABLE APP_FLOW.CustomerService.IVR_abandoned ( [Date] date NOT NULL, department_id int NOT NULL, inbound int NULL, sla decimal(5,4) NULL, aba decimal(5,4) NULL, asa numeric(38,0) NULL, aht numeric(6,0) NULL, CONSTRAINT PK_call_performance PRIMARY KEY ([Date],department_id));
 CREATE NONCLUSTERED INDEX IX_call_performance_dept_date ON APP_FLOW.CustomerService.IVR_abandoned (  department_id ASC  , Date ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
ALTER TABLE APP_FLOW.CustomerService.IVR_abandoned WITH NOCHECK ADD CONSTRAINT CK_call_perf_sla_0_1 CHECK (([sla] IS NULL OR [sla]>=(0) AND [sla]<=(1)));
ALTER TABLE APP_FLOW.CustomerService.IVR_abandoned WITH NOCHECK ADD CONSTRAINT CK_call_perf_aba_0_1 CHECK (([aba] IS NULL OR [aba]>=(0) AND [aba]<=(1)));
ALTER TABLE APP_FLOW.CustomerService.IVR_abandoned WITH NOCHECK ADD CONSTRAINT CK_call_perf_inbound_nonneg CHECK (([inbound] IS NULL OR [inbound]>=(0)));


-- APP_FLOW.CustomerService.RCA_analysis definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.RCA_analysis;

CREATE TABLE APP_FLOW.CustomerService.RCA_analysis ( RCA_id int IDENTITY(1,1) NOT NULL, case_number int NULL, survey_name nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, Premium bit NULL, department_id int NULL, issue_resolved bit NULL, RCA nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, [Date] date NULL, CONSTRAINT PK__RCA_anal__5FBB2C391BB47082 PRIMARY KEY (RCA_id));


-- APP_FLOW.CustomerService.SLA_ABA definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.SLA_ABA;

CREATE TABLE APP_FLOW.CustomerService.SLA_ABA ( [Date] date NULL, department_id int NULL, sla bit NULL, aba bit NULL, agent_id int NULL, end_reason nvarchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, last_state nvarchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, interaction_type nvarchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, [language] nvarchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL);


-- APP_FLOW.CustomerService.TL_discretion definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.TL_discretion;

CREATE TABLE APP_FLOW.CustomerService.TL_discretion ( TL_discretion_id int IDENTITY(1,1) NOT NULL, agent_id int NOT NULL, discretion_score float NULL, record_date date NOT NULL, CONSTRAINT PK__TL_discr__49A1F1F89E99D10E PRIMARY KEY (TL_discretion_id));


-- APP_FLOW.CustomerService.VoC definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.VoC;

CREATE TABLE APP_FLOW.CustomerService.VoC ( VoC_ID numeric(18,0) IDENTITY(1,1) NOT NULL, [Date] date NULL, case_number bigint NULL, survey_name nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, Premium bit NULL, account_name nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, case_origin nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, case_reason nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, case_subreason nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, agent_id int NULL, country nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, NPS_type nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, survey_resolution numeric(5,2) NULL, NPS numeric(5,2) NULL, NPS_Reason nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, NES numeric(5,2) NULL, CSAT_Service numeric(5,2) NULL, CSAT_Product numeric(5,2) NULL, customer_comment varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, [chain] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, department_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, customer_comment_detractor varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, Week_number AS (datepart(week,dateadd(day,(-3),[Date]))), [Year] AS (datepart(year,dateadd(day,(-3),[Date]))), Month_number AS (datepart(month,[Date])), Month_name AS (datename(month,[Date])), team_hierarchy varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, CONSTRAINT PK__VoC__B2E3BB204D3E6DAD PRIMARY KEY (VoC_ID), CONSTRAINT UQ_VoC_ID UNIQUE (VoC_ID));


-- APP_FLOW.CustomerService.case_reason definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.case_reason;

CREATE TABLE APP_FLOW.CustomerService.case_reason ( case_reason_id int IDENTITY(1,1) NOT NULL, department_id int NULL, case_number int NULL, age int NULL, [Date] date NULL, case_reason varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, case_subreason varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, CONSTRAINT case_reason_pk PRIMARY KEY (case_reason_id));


-- APP_FLOW.CustomerService.contact_rate definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.contact_rate;

CREATE TABLE APP_FLOW.CustomerService.contact_rate ( contact_rate_id int IDENTITY(1,1) NOT NULL, department_id int NOT NULL, total_number decimal(18,2) NOT NULL, [Date] date NULL, CONSTRAINT contact_rate_pkey PRIMARY KEY (contact_rate_id));


-- APP_FLOW.CustomerService.[date] definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.[date];

CREATE TABLE APP_FLOW.CustomerService.[date] ( date_id int IDENTITY(1,1) NOT NULL, [Date] date NULL, [Month] varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, Month_number int NULL, Week_number int NULL, Week_Year int NULL, CONSTRAINT PK_date PRIMARY KEY (date_id));
 CREATE NONCLUSTERED INDEX IX_date_Date ON APP_FLOW.CustomerService.date (  Date ASC  )  
	 INCLUDE ( Week_number ) 
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- APP_FLOW.CustomerService.department definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.department;

CREATE TABLE APP_FLOW.CustomerService.department ( department_id int IDENTITY(1,1) NOT NULL, department_name varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, vertical varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, department_group varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, team_hierarchy varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, CONSTRAINT department_pkey PRIMARY KEY (department_id));


-- APP_FLOW.CustomerService.einstein_cases definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.einstein_cases;

CREATE TABLE APP_FLOW.CustomerService.einstein_cases ( einstein_cases_id int IDENTITY(1,1) NOT NULL, [Date] date NULL, case_number int NULL, agent_id int NULL, case_reason nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, support_email_id int NULL, subreason nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, reopened bit NULL, resolution_reason nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, CONSTRAINT PK__einstein__95186CE8545800AB PRIMARY KEY (einstein_cases_id));


-- APP_FLOW.CustomerService.[language] definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.[language];

CREATE TABLE APP_FLOW.CustomerService.[language] ( language_id int IDENTITY(1,1) NOT NULL, language_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, CONSTRAINT language_pkey PRIMARY KEY (language_id));


-- APP_FLOW.CustomerService.outbounds definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.outbounds;

CREATE TABLE APP_FLOW.CustomerService.outbounds ( outbound_id int IDENTITY(1,1) NOT NULL, agent_id int NULL, [Date] date NULL, department_id int NULL, case_number int NULL, CONSTRAINT outbounds_pk PRIMARY KEY (outbound_id));


-- APP_FLOW.CustomerService.priority definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.priority;

CREATE TABLE APP_FLOW.CustomerService.priority ( priority_id int NOT NULL, priority_name varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, CONSTRAINT PK__priority__EE325785E0F5675C PRIMARY KEY (priority_id));


-- APP_FLOW.CustomerService.quality_evaluations definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.quality_evaluations;

CREATE TABLE APP_FLOW.CustomerService.quality_evaluations ( quality_evaluations_id int IDENTITY(1,1) NOT NULL, department_id int NOT NULL, agent_id int NOT NULL, [Date] date NULL, quality_total decimal(18,2) NULL, case_number bigint NULL, evaluator int NULL, case_type varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, CONSTRAINT quality_evaluations_pkey PRIMARY KEY (quality_evaluations_id));


-- APP_FLOW.CustomerService.repeat_cases definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.repeat_cases;

CREATE TABLE APP_FLOW.CustomerService.repeat_cases ( repeat_cases_id int IDENTITY(1,1) NOT NULL, case_number int NULL, department_id int NULL, agent_id int NULL, nb_repeats int NULL, [Date] date NULL, CONSTRAINT repeat_cases_pkey PRIMARY KEY (repeat_cases_id));


-- APP_FLOW.CustomerService.repeat_rate definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.repeat_rate;

CREATE TABLE APP_FLOW.CustomerService.repeat_rate ( repeat_rate_id int IDENTITY(1,1) NOT NULL, department_id int NOT NULL, agent_id int NOT NULL, [Date] date NULL, [3_repeats] int NULL, all_touchpoints int NULL, [Month] AS (format([Date],'MMMM')), CONSTRAINT repeat_rate_pkey PRIMARY KEY (repeat_rate_id));


-- APP_FLOW.CustomerService.shifts definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.shifts;

CREATE TABLE APP_FLOW.CustomerService.shifts ( agent_id int NULL, [Date] date NULL, shift_time numeric(18,0) NULL);


-- APP_FLOW.CustomerService.shrinkage definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.shrinkage;

CREATE TABLE APP_FLOW.CustomerService.shrinkage ( shrinkage_id int IDENTITY(1,1) NOT NULL, [Date] date NULL, agent_id int NULL, event varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, shrinkage_time numeric(18,0) NULL, CONSTRAINT PK__shrinkag__90619FA31094DF7E PRIMARY KEY (shrinkage_id));


-- APP_FLOW.CustomerService.support_email definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.support_email;

CREATE TABLE APP_FLOW.CustomerService.support_email ( support_email_id int NOT NULL, email_address text COLLATE SQL_Latin1_General_CP1_CI_AS NULL, department_id int NULL, CONSTRAINT PK__support___124642061368D92B PRIMARY KEY (support_email_id));


-- APP_FLOW.CustomerService.surveys_sent definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.surveys_sent;

CREATE TABLE APP_FLOW.CustomerService.surveys_sent ( surveys_sent_id int IDENTITY(1,1) NOT NULL, [Date] date NULL, department_id int NULL, case_number int NULL, account_name varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, managed_account bit NULL, CONSTRAINT surveys_sent_pk PRIMARY KEY (surveys_sent_id));


-- APP_FLOW.CustomerService.ticket_sla definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.ticket_sla;

CREATE TABLE APP_FLOW.CustomerService.ticket_sla ( ticket_sla_id int IDENTITY(1,1) NOT NULL, SLA_difference decimal(10,2) NULL, Date_open date NULL, case_number int NULL, department_id int NULL, priority nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, Date_replied date NULL, in_SLA bit NULL, CONSTRAINT PK__ticket_s__3C803FB4F76BE481 PRIMARY KEY (ticket_sla_id));


-- APP_FLOW.CustomerService.tl definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.tl;

CREATE TABLE APP_FLOW.CustomerService.tl ( tl_id int IDENTITY(1,1) NOT NULL, first_name varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, last_name varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, CONSTRAINT tl_pkey PRIMARY KEY (tl_id));


-- APP_FLOW.CustomerService.agent definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.agent;

CREATE TABLE APP_FLOW.CustomerService.agent ( agent_id int NOT NULL, first_name varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, last_name varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, tl_id int NOT NULL, department_id int NOT NULL, start_date date NULL, item_target AS (case when [start_date] IS NULL then NULL else case when case when [start_date]>CONVERT([date],getdate()) then (0) else datediff(month,[start_date],getdate())-case when dateadd(month,datediff(month,[start_date],getdate()),[start_date])>CONVERT([date],getdate()) then (1) else (0) end end<=(4) then (8) when case when [start_date]>CONVERT([date],getdate()) then (0) else datediff(month,[start_date],getdate())-case when dateadd(month,datediff(month,[start_date],getdate()),[start_date])>CONVERT([date],getdate()) then (1) else (0) end end<=(15) then (15) else (20) end end), CONSTRAINT PK_agent PRIMARY KEY (agent_id), CONSTRAINT agent_unique UNIQUE (agent_id), CONSTRAINT agent_department_fk FOREIGN KEY (department_id) REFERENCES APP_FLOW.CustomerService.department(department_id), CONSTRAINT agent_tl_fk FOREIGN KEY (tl_id) REFERENCES APP_FLOW.CustomerService.tl(tl_id));


-- APP_FLOW.CustomerService.agent_productivity definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.agent_productivity;

CREATE TABLE APP_FLOW.CustomerService.agent_productivity ( agent_prod_id int IDENTITY(1,1) NOT NULL, [Date] date NOT NULL, agent_id int NOT NULL, case_number int NOT NULL, department_id int NOT NULL, age int NULL, CONSTRAINT PK__agent_pr__963B65ACBB683AB7 PRIMARY KEY (agent_prod_id), CONSTRAINT agent_productivity_agent_FK FOREIGN KEY (agent_id) REFERENCES APP_FLOW.CustomerService.agent(agent_id));


-- APP_FLOW.CustomerService.agent_transfer definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.agent_transfer;

CREATE TABLE APP_FLOW.CustomerService.agent_transfer ( agent_transfer_id int IDENTITY(1,1) NOT NULL, [Date] date NOT NULL, agent_id int NOT NULL, case_number int NOT NULL, department_id int NOT NULL, new_department int NOT NULL, CONSTRAINT PK__agent_tr__1B6280868771AF0F PRIMARY KEY (agent_transfer_id), CONSTRAINT agent_transfer_agent_FK FOREIGN KEY (agent_id) REFERENCES APP_FLOW.CustomerService.agent(agent_id));
 CREATE NONCLUSTERED INDEX IX_agent_transfer_Date_NewDepartment ON APP_FLOW.CustomerService.agent_transfer (  Date ASC  , new_department ASC  )  
	 INCLUDE ( department_id ) 
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- APP_FLOW.CustomerService.incoming_tickets definition

-- Drop table

-- DROP TABLE APP_FLOW.CustomerService.incoming_tickets;

CREATE TABLE APP_FLOW.CustomerService.incoming_tickets ( incoming_tickets_id int IDENTITY(1,1) NOT NULL, department_id int NOT NULL, ticket_total int NULL, [Date] date NULL, CONSTRAINT incoming_tickets_pkey PRIMARY KEY (incoming_tickets_id), CONSTRAINT incoming_tickets_department_fk FOREIGN KEY (department_id) REFERENCES APP_FLOW.CustomerService.department(department_id));
 CREATE NONCLUSTERED INDEX IX_incoming_tickets_Date_Department ON APP_FLOW.CustomerService.incoming_tickets (  Date ASC  , department_id ASC  )  
	 INCLUDE ( ticket_total ) 
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- CustomerService.AGENTS_Monthly_Outbounds source

-- CustomerService.AGENTS_Monthly_Outbounds source

ALTER VIEW CustomerService.AGENTS_Monthly_Outbounds AS
SELECT 
    d.Month_number,
    a.agent_id,
    a.first_name + ' ' + a.last_name AS Agent_Name,
    dp.department_id,
    dp.department_name,
    SUM(o.total_outbounds) AS outbounds
FROM CustomerService.outbounds o
JOIN CustomerService.date d ON o.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = o.department_id
JOIN CustomerService.agent a ON a.agent_id = o.agent_id
GROUP BY 
    d.Month_number, 
    dp.department_id, 
    dp.department_name, 
    a.first_name + ' ' + a.last_name, 
    a.agent_id;


-- CustomerService.AGENTS_Monthly_Productivity source

ALTER VIEW CustomerService.AGENTS_Monthly_Productivity AS
SELECT 
    a.agent_id AS id,
    d2.department_name,
    a.first_name + ' ' + a.last_name AS Agent_Name,
    tl.first_name + ' ' + tl.last_name AS TL_Name,
    CAST(COUNT(*) AS DECIMAL(18,2)) / NULLIF(COUNT(DISTINCT p.Date), 0) AS prod_per_day, -- promedio de casos por día trabajado
    COUNT(*) AS productivity_total, -- total de casos del mes
    d.Month_number AS Month
FROM CustomerService.agent_productivity p
JOIN CustomerService.agent a ON a.agent_id = p.agent_id
JOIN CustomerService.date d ON d.Date = p.Date
JOIN CustomerService.tl tl ON tl.tl_id = a.tl_id
JOIN CustomerService.department d2 ON p.department_id = d2.department_id
GROUP BY 
    a.agent_id, 
    a.first_name + ' ' + a.last_name, 
    tl.first_name + ' ' + tl.last_name,
    d2.department_name,
    d.Month_number;


-- CustomerService.AGENTS_daily_Outbounds source

ALTER VIEW CustomerService.AGENTS_daily_Outbounds AS
SELECT 
    d.Week_Year as Year,
    d.Month_number,
    d.Week_number,
    d.Date,
    a.agent_id,
    a.first_name + ' ' + a.last_name AS Agent_Name,
    dp.department_id,
    dp.department_name,
    SUM(o.total_outbounds) AS outbounds
FROM CustomerService.outbounds o
JOIN CustomerService.date d ON o.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = o.department_id
JOIN CustomerService.agent a ON a.agent_id = o.agent_id
WHERE d.Date > '2025-09-30'
GROUP BY 
    d.Month_number, 
    d.Week_Year,
    d.Week_number,
    d.Date,
    dp.department_id, 
    dp.department_name, 
    a.first_name + ' ' + a.last_name, 
    a.agent_id;


-- CustomerService.AGENT_KPIS source

-- CustomerService.AGENT_KPIS source

ALTER VIEW CustomerService.AGENT_KPIS AS
WITH AnchorMonths AS (
    SELECT agent_id, MonthKey FROM (
        SELECT o.agent_id, YEAR(o.[Date])*100 + MONTH(o.[Date]) AS MonthKey FROM CustomerService.outbounds o
        UNION
        SELECT p.agent_id, YEAR(p.[Date])*100 + MONTH(p.[Date]) FROM CustomerService.productivity p
        UNION
        SELECT asa.agent_id, YEAR(asa.[Date])*100 + MONTH(asa.[Date]) FROM APP_FLOW.CustomerService.ASA_AHT_payments asa
        UNION
        SELECT vc.agent_id, YEAR(vc.[Date])*100 + MONTH(vc.[Date]) FROM CustomerService.VoC vc
        UNION
        SELECT qe.agent_id, YEAR(qe.[Date])*100 + MONTH(qe.[Date]) FROM CustomerService.quality_evaluations qe
    ) AM
),
DimMonth AS (
    SELECT
        YEAR(d.[Date])*100 + MONTH(d.[Date]) AS MonthKey,
        MAX(d.Month_number) AS Month_number
    FROM CustomerService.[Date] d
    GROUP BY YEAR(d.[Date])*100 + MONTH(d.[Date])
),
OutboundsAgg AS (
    SELECT
        o.agent_id,
        YEAR(o.[Date])*100 + MONTH(o.[Date]) AS MonthKey,
        SUM(o.total_outbounds) AS outbounds
    FROM CustomerService.outbounds o
    GROUP BY o.agent_id, YEAR(o.[Date])*100 + MONTH(o.[Date])
),
ProdAgg AS (
    SELECT
        p.agent_id,
        YEAR(p.[Date])*100 + MONTH(p.[Date]) AS MonthKey,
        AVG(TRY_CONVERT(decimal(10,4), p.productivity_total)) AS productivity_avg
    FROM CustomerService.productivity p
    GROUP BY p.agent_id, YEAR(p.[Date])*100 + MONTH(p.[Date])
),
CallsAgg AS (
    SELECT
        asa.agent_id,
        asa.department_id,
        YEAR(asa.[Date])*100 + MONTH(asa.[Date]) AS MonthKey,
        COUNT_BIG(*) AS total_calls,
        SUM(CASE WHEN sla.aba = 1 THEN 1 ELSE 0 END) AS sla_hits,
        SUM(CASE WHEN sla.aba = 1 AND sla.interaction_type = 'VIP' THEN 1 ELSE 0 END) AS sla_vip_hits,
        SUM(CASE WHEN sla.interaction_type = 'VIP' THEN 1 ELSE 0 END) AS vip_total,
CAST(
  100.0 *
  SUM(CASE WHEN sla.aba = 1 AND sla.interaction_type = 'VIP' AND asa.department_id = 37 THEN 1 ELSE 0 END)
  / NULLIF(SUM(CASE WHEN sla.interaction_type = 'VIP' AND asa.department_id = 37 THEN 1 ELSE 0 END), 0)
AS decimal(6,2)) AS sla_vip_percentage,
        0 AS abandoned_calls,
        CAST(
            ISNULL(AVG(TRY_CONVERT(float, asa.agent_talk_time)), 0.0)
            + ISNULL(AVG(TRY_CONVERT(float, asa.total_call_duration - asa.agent_talk_time)), 0.0)
            + 120.0
        AS int) AS aht_seconds,
        CAST(ISNULL(AVG(TRY_CONVERT(float, asa.total_ring_duration)), 0.0) AS int) AS asa_seconds
    FROM APP_FLOW.CustomerService.ASA_AHT_payments asa
    INNER JOIN APP_FLOW.CustomerService.SLA_payments sla
        ON asa.agent_id = sla.agent_id AND asa.[Date] = sla.[Date]
    GROUP BY asa.agent_id, asa.department_id, YEAR(asa.[Date])*100 + MONTH(asa.[Date])
),
VoCAgg AS (
    SELECT
        vc.agent_id,
        YEAR(vc.[Date])*100 + MONTH(vc.[Date]) AS MonthKey,
        SUM(CASE WHEN vc.survey_resolution = 1 THEN 1 ELSE 0 END) AS resolved,
        SUM(CASE WHEN vc.survey_resolution = 0 THEN 1 ELSE 0 END) AS not_resolved,
        SUM(CASE WHEN vc.NPS IN (9, 10) THEN 1 ELSE 0 END) AS nps_promoter,
        SUM(CASE WHEN vc.NPS BETWEEN 0 AND 6 THEN 1 ELSE 0 END) AS nps_detractor,
        COUNT(vc.NPS) AS nps_total,
        SUM(CASE WHEN vc.CSAT_Service IN (4, 5) THEN 1 ELSE 0 END) AS csat_positive,
        SUM(CASE WHEN vc.CSAT_Service IN (1, 2) THEN 1 ELSE 0 END) AS csat_negative,
        COUNT(vc.CSAT_Service) AS csat_total,
        SUM(CASE WHEN vc.NES IN (4, 5) THEN 1 ELSE 0 END) AS nes_positive,
        SUM(CASE WHEN vc.NES IN (1, 2) THEN 1 ELSE 0 END) AS nes_negative,
        COUNT(vc.NES) AS nes_total,
        SUM(CASE WHEN vc.CSAT_Product IN (1, 2) THEN 1 ELSE 0 END) AS product_negative,
        COUNT(vc.CSAT_Product) AS product_total,
        SUM(CASE WHEN vc.CSAT_Product IN (4, 5) THEN 1 ELSE 0 END) AS csat_product_positive
    FROM CustomerService.VoC vc
    GROUP BY vc.agent_id, YEAR(vc.[Date])*100 + MONTH(vc.[Date])
),
QualityAgg AS (
    SELECT
        qe.agent_id,
        YEAR(qe.[Date])*100 + MONTH(qe.[Date]) AS MonthKey,
        AVG(CASE WHEN qe.case_type = 'Call' THEN TRY_CONVERT(decimal(10,4), qe.quality_total) END) AS avg_quality_call,
        AVG(CASE WHEN qe.case_type = 'E-mail' THEN TRY_CONVERT(decimal(10,4), qe.quality_total) END) AS avg_quality_email,
        AVG(TRY_CONVERT(decimal(10,4), qe.quality_total)) AS avg_quality_total
    FROM CustomerService.quality_evaluations qe
    GROUP BY qe.agent_id, YEAR(qe.[Date])*100 + MONTH(qe.[Date])
),
RepeatAgg AS (
    SELECT
        rr.agent_id,
        YEAR(rr.[Date])*100 + MONTH(rr.[Date]) AS MonthKey,
        SUM(rr.[3_repeats]) AS repeats,
        SUM(rr.all_touchpoints) AS touchpoints
    FROM CustomerService.repeat_rate rr
    GROUP BY rr.agent_id, YEAR(rr.[Date])*100 + MONTH(rr.[Date])
)
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    CONCAT(tl.first_name, ' ', tl.last_name) AS team_leader,
    d.department_name AS department_name,
    dm.Month_number,
    am.MonthKey,
    ob.outbounds,
    prod.productivity_avg,
    ca.total_calls,
    CAST(100.0 * ca.sla_hits / NULLIF(ca.total_calls, 0) AS decimal(6,2)) AS sla_percentage,
    CAST(
        100.0 *
        SUM(CASE WHEN ca.department_id = 37 THEN ca.sla_vip_hits ELSE 0 END)
        / NULLIF(SUM(CASE WHEN ca.department_id = 37 THEN ca.vip_total ELSE 0 END), 0)
    AS decimal(6,2)) AS sla_vip_percentage,
    CAST(100.0 * ca.abandoned_calls / NULLIF(ca.total_calls, 0) AS decimal(6,2)) AS abandoned_percentage,
    ca.aht_seconds,
    ca.asa_seconds,
    voc.resolved,
    voc.not_resolved,
    CAST(100.0 * voc.resolved / NULLIF(voc.resolved + voc.not_resolved, 0) AS decimal(6,2)) AS Resolution_total,
    voc.nps_promoter,
    voc.nps_detractor,
    voc.nps_total,
    CAST(100.0 * (voc.nps_promoter - voc.nps_detractor) / NULLIF(voc.nps_total, 0) AS decimal(6,2)) AS NPS,
    voc.csat_positive,
    voc.csat_negative,
    voc.csat_total,
    CAST(100.0 * voc.csat_positive / NULLIF(voc.csat_total, 0) AS decimal(6,2)) AS CSAT_Service,
    voc.nes_positive,
    voc.nes_negative,
    voc.nes_total,
    CAST(100.0 * voc.nes_positive / NULLIF(voc.nes_total, 0) AS decimal(6,2)) AS NES,
    voc.product_negative,
    voc.product_total,
    CAST(100.0 * voc.csat_product_positive / NULLIF(voc.product_total, 0) AS decimal(6,2)) AS CSAT_Product,
    ra.repeats,
    ra.touchpoints,
    CAST(100.0 * ra.repeats / NULLIF(ra.touchpoints, 0) AS decimal(6,2)) AS RR,
    qa.avg_quality_call,
    qa.avg_quality_email,
    qa.avg_quality_total
FROM AnchorMonths am
JOIN CustomerService.agent a ON a.agent_id = am.agent_id
JOIN CustomerService.TL tl ON a.tl_id = tl.tl_id
JOIN CustomerService.department d ON a.department_id = d.department_id
LEFT JOIN DimMonth dm ON dm.MonthKey = am.MonthKey
LEFT JOIN OutboundsAgg ob ON ob.agent_id = am.agent_id AND ob.MonthKey = am.MonthKey
LEFT JOIN ProdAgg prod ON prod.agent_id = am.agent_id AND prod.MonthKey = am.MonthKey
LEFT JOIN CallsAgg ca ON ca.agent_id = am.agent_id AND ca.MonthKey = am.MonthKey
LEFT JOIN VoCAgg voc ON voc.agent_id = am.agent_id AND voc.MonthKey = am.MonthKey
LEFT JOIN QualityAgg qa ON qa.agent_id = am.agent_id AND qa.MonthKey = am.MonthKey
LEFT JOIN RepeatAgg ra ON ra.agent_id = am.agent_id AND ra.MonthKey = am.MonthKey
where a.tl_id <> 0
GROUP BY
    a.first_name,
    a.last_name,
    tl.first_name,
    tl.last_name,
    d.department_name,
    dm.Month_number,
    am.MonthKey,
    ob.outbounds,
    prod.productivity_avg,
    ca.total_calls,
    ca.sla_hits,
    ca.vip_total,
    ca.abandoned_calls,
    ca.aht_seconds,
    ca.asa_seconds,
    voc.resolved,
    voc.not_resolved,
    voc.nps_promoter,
    voc.nps_detractor,
    voc.nps_total,
    voc.csat_positive,
    voc.csat_negative,
    voc.csat_total,
    voc.nes_positive,
    voc.nes_negative,
    voc.nes_total,
    voc.product_negative,
    voc.product_total,
    voc.csat_product_positive,
    ra.repeats,
  ra.touchpoints,
    qa.avg_quality_call,
    qa.avg_quality_email,
    qa.avg_quality_total;


-- CustomerService.AGENT_MONTHLY_VoC source

ALTER VIEW CustomerService.AGENT_MONTHLY_VoC AS
SELECT 
    d2.Month_number,
    d2.Week_Year,
    d2.Date,
    d2.Week_number,
    a.agent_id,
    a.first_name + ' ' + a.last_name AS agent_name,
    CONCAT(tl.first_name, ' ', tl.last_name) AS Team_Leader,
    d.department_id,
    d.department_name,
    SUM(CASE WHEN v.survey_resolution = 1 THEN 1 ELSE 0 END) AS Resolved,
    COUNT(v.survey_resolution) AS Not_resolved,
    ROUND(SUM(CASE WHEN v.survey_resolution = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.survey_resolution), 0), 2) AS Resolution_total,
    SUM(CASE WHEN v.NPS IN (9, 10) THEN 1 ELSE 0 END) AS nps_promoter,
    SUM(CASE WHEN v.NPS BETWEEN 0 AND 6 THEN 1 ELSE 0 END) AS nps_detractor,
    COUNT(v.NPS) AS nps_total,
    ROUND((SUM(CASE WHEN v.NPS IN (9, 10) THEN 1 ELSE 0 END) - SUM(CASE WHEN v.NPS BETWEEN 0 AND 6 THEN 1 ELSE 0 END)) * 100.0 / NULLIF(COUNT(v.NPS), 0), 2) AS NPS,
    SUM(CASE WHEN v.CSAT_Service IN (4, 5) THEN 1 ELSE 0 END) AS csat_positive,
    SUM(CASE WHEN v.CSAT_Service IN (1, 2) THEN 1 ELSE 0 END) AS csat_negative,
    COUNT(v.CSAT_Service) AS csat_total,
    ROUND(SUM(CASE WHEN v.CSAT_Service IN (4, 5) THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.CSAT_Service), 0), 2) AS CSAT_Service,
    SUM(CASE WHEN v.NES IN (4, 5) THEN 1 ELSE 0 END) AS nes_positive,
    SUM(CASE WHEN v.NES IN (1, 2) THEN 1 ELSE 0 END) AS nes_negative,
    COUNT(v.NES) AS nes_total,
    ROUND(SUM(CASE WHEN v.NES IN (4, 5) THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.NES), 0), 2) AS NES,
    SUM(CASE WHEN v.CSAT_Product IN (1, 2) THEN 1 ELSE 0 END) AS Product_negative,
    COUNT(v.CSAT_Product) AS product_total,
    ROUND(SUM(CASE WHEN v.CSAT_Product IN (4, 5) THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.CSAT_Product), 0), 2) AS CSAT_Product
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
JOIN CustomerService.date d2 ON d2.Date = v.Date
JOIN CustomerService.agent a ON a.agent_id = v.agent_id
JOIN CustomerService.tl tl ON a.tl_id = tl.tl_id
WHERE d2.Week_Year = 2025
GROUP BY 
    d2.Month_number, 
    d2.Week_Year, 
    d2.Week_number,
    d2.Date,    
    d.department_id, 
    d.department_name, 
    a.agent_id,
    a.first_name, 
    a.last_name,
    tl.first_name,
    tl.last_name;


-- CustomerService.AGENT_Monthly_RR source

-- =============================================
-- Vista convertida: AGENT_Monthly_RR
-- =============================================
ALTER VIEW CustomerService.AGENT_Monthly_RR AS
SELECT 
    dt.Month_number,
    a.agent_id,
    a.first_name + ' ' + a.last_name AS Agent_Name,
    tl.first_name + ' ' + tl.last_name AS TL_Name,
    dt.Week_Year,
    SUM(rr.[3_repeats]) AS repeats,
    SUM(rr.all_touchpoints) AS touchpoints,
    rr.department_id,
    d.department_name AS name,
    CAST(SUM(rr.[3_repeats]) * 100.0 / NULLIF(SUM(rr.all_touchpoints), 0) AS DECIMAL(5,2)) AS rr
FROM CustomerService.repeat_rate rr
JOIN CustomerService.department d ON d.department_id = rr.department_id
JOIN CustomerService.date dt ON dt.Date = rr.Date
JOIN CustomerService.agent a ON a.agent_id = rr.agent_id
JOIN CustomerService.tl tl ON a.tl_id = tl.tl_id
GROUP BY 
    dt.Month_number, 
    rr.department_id, 
    d.department_name, 
    dt.Week_Year, 
    a.agent_id, 
    a.first_name, 
    a.last_name, 
    tl.first_name, 
    tl.last_name;


-- CustomerService.AGENT_Monthly_call_performance source

-- CustomerService.AGENT_Monthly_call_performance source

-- CustomerService.AGENT_Monthly_call_performance source

ALTER VIEW CustomerService.AGENT_Monthly_call_performance AS
WITH sla_agg AS (
    SELECT
        s.[Date],
        s.[agent_id],
        s.[department_id], -- << añadir la columna
        SUM(CASE WHEN s.sla = 1 THEN 1 ELSE 0 END)  AS sla_hits,
        SUM(CASE WHEN s.aba = 1 THEN 1 ELSE 0 END)  AS aba_hits,
        COUNT(*)                                    AS total_calls 
    FROM CustomerService.SLA_ABA AS s
    WHERE s.interaction_type = 'Inbound Call'
    GROUP BY s.[Date], s.[agent_id], s.[department_id]
),
asa_agg AS (
    SELECT
        a.[Date],
        a.[agent_id],
        SUM(CAST(a.agent_talk_time     AS DECIMAL(18,2))) AS sum_talk_sec,
        SUM(CAST(a.total_ring_duration AS DECIMAL(18,2))) AS sum_queue_sec,
        COUNT(*)                                         AS cnt_calls
    FROM CustomerService.ASA_AHT AS a
    GROUP BY a.[Date], a.[agent_id]
)
SELECT
    YEAR(s.[Date])  AS [Year],
    MONTH(s.[Date]) AS [Month_number],
    dep.[department_name],
    ag.[agent_id],
    CONCAT(ag.[first_name], ' ', ag.[last_name]) AS agent_name,
    SUM(s.total_calls) AS [inbounds],
    CAST(ROUND(100.0 * SUM(s.sla_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS DECIMAL(5,2)) AS sla_percentage,
    CAST(ROUND(100.0 * SUM(s.aba_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS DECIMAL(5,2)) AS abandoned_percentage,
    CAST(ROUND( SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0), 2) AS DECIMAL(18,2)) AS asa_seconds,
    CAST(ROUND(
          (SUM(COALESCE(a.sum_talk_sec, 0))  / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + (SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + 120
    , 2) AS DECIMAL(18,2)) AS aht_seconds
FROM sla_agg s
LEFT JOIN asa_agg a
  ON a.[Date] = s.[Date]
 AND a.[agent_id] = s.[agent_id]
JOIN CustomerService.[department] dep
  ON dep.[department_id] = s.[department_id]
JOIN CustomerService.[agent] ag
  ON ag.[agent_id] = s.[agent_id]
GROUP BY
    YEAR(s.[Date]),
    MONTH(s.[Date]),
    dep.[department_name],
    ag.[agent_id],
    ag.[first_name],
    ag.[last_name];


-- CustomerService.AGENT_monthly_evaluations source

-- CustomerService.AGENT_monthly_evaluations source

ALTER   VIEW CustomerService.AGENT_monthly_evaluations AS
SELECT 
    qe.Date,
    qe.case_number,
	qe.agent_id,
    d2.department_name,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    d.[Week_Year],
    d.Month_number,
    ROUND(AVG(CASE WHEN qe.case_type = 'Call' 
                   THEN TRY_CAST(qe.quality_total AS decimal(10,4)) END), 2) AS avg_quality_call,
    ROUND(AVG(CASE WHEN qe.case_type = 'E-mail' 
                   THEN TRY_CAST(qe.quality_total AS decimal(10,4)) END), 2) AS avg_quality_email,
    ROUND(AVG(TRY_CAST(qe.quality_total AS decimal(10,4))), 2) AS avg_quality_total
FROM CustomerService.quality_evaluations AS qe
JOIN CustomerService.[agent] AS a 
  ON a.agent_id = qe.agent_id
JOIN CustomerService.[date] AS d 
  ON d.[Date] = qe.[Date]
JOIN CustomerService.department AS d2 
  ON qe.department_id = d2.department_id
GROUP BY 
    qe.Date,
	qe.agent_id, 
	qe.case_number,
	d2.department_name,
    CONCAT(a.first_name, ' ', a.last_name), 
    d.[Week_Year],
    d.Month_number;


-- CustomerService.DAILY_IncomingVSresolved source

ALTER VIEW CustomerService.DAILY_IncomingVSresolved AS
WITH incoming_summary AS (
    SELECT 
        Date,
        department_id,
        SUM(ticket_total) AS Total_incoming
    FROM CustomerService.incoming_tickets
    GROUP BY Date, department_id
),
cases_summary AS (
    SELECT 
        ap.Date,
        a.department_id,
        COUNT(DISTINCT ap.case_number) AS total_cases
    FROM CustomerService.agent_productivity ap
    JOIN CustomerService.agent a ON ap.agent_id = a.agent_id
    GROUP BY ap.Date, a.department_id
)
SELECT
    d.Date,
    d.Week_number,
    dp.department_id,
    dp.department_name,
    ISNULL(i.Total_incoming, 0) AS Total_incoming,
    ISNULL(c.total_cases, 0) AS total_cases
FROM CustomerService.date d
JOIN CustomerService.department dp ON 1 = 1
LEFT JOIN incoming_summary i ON i.Date = d.Date AND i.department_id = dp.department_id
LEFT JOIN cases_summary c ON c.Date = d.Date AND c.department_id = dp.department_id;


-- CustomerService.DAILY_Incoming_Total source

ALTER   VIEW CustomerService.DAILY_Incoming_Total
AS
WITH incoming AS (
    SELECT
        it.[Date]                         AS [Date],
        it.department_id                  AS department_id,
        SUM(COALESCE(it.ticket_total, 0)) AS incoming_from_customers,
        CAST(0 AS int)                    AS incoming_from_transfers
    FROM CustomerService.incoming_tickets AS it
    WHERE it.[Date] IS NOT NULL
    GROUP BY it.[Date], it.department_id
),
transfers_in AS (
    SELECT
        at.[Date]                         AS [Date],
        at.new_department                 AS department_id,  -- receptor
        CAST(0 AS int)                    AS incoming_from_customers,
        COUNT(*)                          AS incoming_from_transfers
    FROM CustomerService.agent_transfer AS at
    WHERE at.[Date] IS NOT NULL
      AND at.new_department IS NOT NULL
      AND at.department_id IS NOT NULL
      AND at.new_department <> at.department_id  -- excluir auto-transferencias
    GROUP BY at.[Date], at.new_department
),
unioned AS (
    SELECT * FROM incoming
    UNION ALL
    SELECT * FROM transfers_in
),
aggregated AS (
    SELECT
        u.[Date],
        u.department_id,
        SUM(u.incoming_from_customers) AS incoming_from_customers,
        SUM(u.incoming_from_transfers) AS incoming_from_transfers,
        SUM(u.incoming_from_customers) + SUM(u.incoming_from_transfers) AS total_incoming
    FROM unioned AS u
    GROUP BY u.[Date], u.department_id
)
SELECT
    a.[Date],
    a.department_id,
    d.[Week_number],
    a.incoming_from_customers,
    a.incoming_from_transfers,
    a.total_incoming
FROM aggregated AS a
LEFT JOIN CustomerService.[date] AS d
    ON d.[Date] = a.[Date];


-- CustomerService.DAILY_Outbounds source

ALTER VIEW CustomerService.DAILY_Outbounds AS
SELECT 
    d.Date,
    a.agent_id,
    a.first_name + ' ' + a.last_name AS Agent_Name,
    dp.department_id,
    dp.department_name,
    SUM(o.total_outbounds) AS outbounds
FROM CustomerService.outbounds o
JOIN CustomerService.date d ON o.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = o.department_id
JOIN CustomerService.agent a ON a.agent_id = o.agent_id
GROUP BY 
    d.Date, 
    dp.department_id, 
    dp.department_name, 
    a.first_name + ' ' + a.last_name, 
    a.agent_id;


-- CustomerService.DAILY_RR source

-- CustomerService.DAILY_RR source

ALTER   VIEW [CustomerService].[DAILY_RR] AS
SELECT 
    d.[department_id],
	d.[department_name],
    d.[vertical],
    a.[agent_id],
    CONCAT(a.first_name,' ',a.last_name COLLATE SQL_Latin1_General_CP1_CI_AS) AS agent_name,
    SUM(rr.[3_repeats])           AS [repeats],
    SUM(rr.[all_touchpoints])     AS [touchpoints],
    CAST(
        ROUND(SUM(rr.[3_repeats]) * 100.0 / NULLIF(SUM(rr.[all_touchpoints]), 0), 2)
        AS DECIMAL(5,2)
    ) AS [RR],
    d2.[Month_number],
    d2.[Month],
    d2.[Week_number],
    d2.[Date]
FROM [CustomerService].[repeat_rate]   AS rr
JOIN [CustomerService].[department]    AS d  ON d.[department_id] = rr.[department_id]
JOIN [CustomerService].[date]          AS d2 ON d2.[Date]         = rr.[Date]
JOIN [CustomerService].[agent]		   AS a ON a.[agent_id] = rr.[agent_id]	
GROUP BY 
    d2.[Month_number], d.[vertical], d2.[Month], d2.[Week_number], a.[agent_id],
    d.[department_name], d.[department_id], d2.[Date],
   a.[first_name], a.[last_name];


-- CustomerService.DAILY_Ticket_SLA source

ALTER VIEW CustomerService.DAILY_Ticket_SLA AS
SELECT 
    d.Date,
    dp.department_name AS department,
    CAST(AVG(CAST(sla.in_SLA AS FLOAT)) AS DECIMAL(10,4)) AS avg_in_SLA
FROM CustomerService.ticket_sla sla
JOIN CustomerService.date d 
    ON sla.Date_open = d.Date
JOIN CustomerService.department dp 
    ON dp.department_id = sla.department_id
GROUP BY 
    d.Date, 
    dp.department_name;


-- CustomerService.DAILY_call_performance source

-- CustomerService.DAILY_call_performance source

ALTER VIEW CustomerService.DAILY_call_performance AS
WITH sla_agg AS (
    SELECT
        s.[Date],
        s.agent_id,
        s.department_id,
        SUM(CASE WHEN s.sla = 1 THEN 1 ELSE 0 END) AS sla_hits,
        SUM(CASE WHEN s.aba = 1 THEN 1 ELSE 0 END) AS aba_hits,
        COUNT(*) AS total_calls
    FROM CustomerService.SLA_ABA AS s
    WHERE s.interaction_type = 'Inbound Call'
      AND s.[Date] >= '2025-10-01'
    GROUP BY s.[Date], s.agent_id, s.department_id
),
asa_agg AS (
    SELECT
        a.[Date],
        a.agent_id,
        a.department_id,
        SUM(CAST(a.agent_talk_time AS FLOAT)) AS sum_talk_sec,
        SUM(CAST(a.total_ring_duration AS FLOAT)) AS sum_queue_sec,
        COUNT(*) AS cnt_calls
    FROM CustomerService.ASA_AHT AS a
    WHERE a.[Date] >= '2025-10-01'
    GROUP BY a.[Date], a.agent_id, a.department_id
)
SELECT
    s.[Date] AS call_date,
    d.Week_number,
    d.Week_Year,
    d.[Month],
    CASE 
        WHEN s.department_id IN (37, 9, 10) THEN 'VIP'
        ELSE 'No_VIP'
    END AS client_type,
    CONCAT(
        ag.first_name COLLATE Latin1_General_100_CI_AS,
        ' ',
        ag.last_name
    ) AS agent_name,
    CONCAT(
        tl.first_name COLLATE Latin1_General_100_CI_AS,
        ' ',
        tl.last_name
    ) AS team_lead_name,
    s.department_id,
    a.agent_id,
    dep.department_name,
    dep.vertical,
    SUM(s.total_calls) AS inbounds,
    ROUND(100.0 * SUM(s.sla_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS sla_percentage,
    ROUND(100.0 * SUM(s.aba_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS abandoned_percentage,
    ROUND(SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0), 2) AS asa_seconds,
    ROUND(
          (SUM(COALESCE(a.sum_talk_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + (SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + 120
    , 2) AS aht_seconds
FROM sla_agg s
LEFT JOIN asa_agg a
  ON a.[Date] = s.[Date]
 AND a.agent_id = s.agent_id
 AND a.department_id = s.department_id
JOIN CustomerService.department dep
  ON dep.department_id = s.department_id
JOIN CustomerService.[date] d
  ON d.[Date] = s.[Date]
LEFT JOIN CustomerService.agent ag
  ON ag.agent_id = s.agent_id
LEFT JOIN CustomerService.tl tl
  ON tl.tl_id = ag.tl_id
GROUP BY
    s.[Date],
    d.Week_number,
    a.agent_id,
    d.Week_Year,
    d.[Month],
    CASE 
        WHEN s.department_id IN (37, 9, 10) THEN 'VIP'
        ELSE 'No_VIP'
    END,
    CONCAT(
        ag.first_name COLLATE Latin1_General_100_CI_AS,
        ' ',
        ag.last_name
    ),
    CONCAT(
        tl.first_name COLLATE Latin1_General_100_CI_AS,
        ' ',
        tl.last_name
    ),
    s.department_id,
    dep.department_name,
    dep.vertical;


-- CustomerService.DAILY_productivity source

ALTER VIEW CustomerService.DAILY_productivity
AS
WITH cases AS (
    SELECT
        ap.agent_id,
        ap.department_id,
        ap.[Date],
        COUNT(DISTINCT ap.case_number) AS total_cases,
        MAX(ap.age) AS age
    FROM CustomerService.agent_productivity ap
    GROUP BY ap.agent_id, ap.department_id, ap.[Date]
),
transfers AS (
    SELECT
        at.agent_id,
        at.department_id,
        at.[Date],
        COUNT(DISTINCT at.case_number) AS total_transfers
    FROM CustomerService.agent_transfer at
    GROUP BY at.agent_id, at.department_id, at.[Date]
),
outbounds AS (
    SELECT
        o.agent_id,
        o.department_id,
        o.[Date],
        COUNT(o.outbound_id) AS total_outbounds
    FROM CustomerService.outbounds o
    GROUP BY o.agent_id, o.department_id, o.[Date]
),
merged AS (
    SELECT
        COALESCE(c.agent_id, t.agent_id) AS agent_id,
        COALESCE(c.department_id, t.department_id) AS department_id,
        COALESCE(c.[Date], t.[Date]) AS [Date],
        ISNULL(c.total_cases, 0) AS total_cases,
        ISNULL(t.total_transfers, 0) AS total_transfers,
        c.age AS age
    FROM cases c
    FULL OUTER JOIN transfers t
        ON t.agent_id = c.agent_id
        AND t.department_id = c.department_id
        AND t.[Date] = c.[Date]
),
merged2 AS (
    SELECT
        m.agent_id,
        m.department_id,
        m.[Date],
        m.total_cases,
        m.total_transfers,
        m.age,
        ISNULL(o.total_outbounds, 0) AS total_outbounds
    FROM merged m
    LEFT JOIN outbounds o
        ON o.agent_id = m.agent_id
        AND o.department_id = m.department_id
        AND o.[Date] = m.[Date]
)
SELECT
    d.Week_Year,
    dp.department_id,  -- ✅ Nueva columna añadida
    a.agent_id,
    d.Week_number,
    m.[Date],
    CONCAT(
        a.first_name COLLATE DATABASE_DEFAULT,
        N' ',
        a.last_name COLLATE DATABASE_DEFAULT
    ) AS agent_name,
    dp.department_name,
    CONCAT(
        tl.first_name COLLATE DATABASE_DEFAULT,
        N' ',
        tl.last_name COLLATE DATABASE_DEFAULT
    ) AS tl_name,
    m.total_cases,
    m.total_transfers,
    m.total_outbounds,
    (m.total_cases + m.total_transfers) AS [total],
    CASE
        WHEN m.age > 2 THEN m.total_cases * 1.5
        ELSE m.total_cases * 1
    END AS scale_cases,
    m.total_transfers * 0.5 AS scale_transfers,
    (
        CASE
            WHEN m.age > 2 THEN m.total_cases * 1.5
            ELSE m.total_cases * 1
        END
        + m.total_transfers * 0.5
        + m.total_outbounds * 0.75
    ) AS scale_total
FROM merged2 m
JOIN CustomerService.[date] d
    ON d.[Date] = m.[Date]
JOIN CustomerService.agent a
    ON a.agent_id = m.agent_id
LEFT JOIN CustomerService.tl tl
    ON tl.tl_id = a.tl_id
JOIN CustomerService.department dp
    ON dp.department_id = m.department_id;


-- CustomerService.DAILY_repeat_cases source

-- CustomerService.DAILY_repeat_cases source

-- CustomerService.DAILY_repeat_cases source

-- =============================================
-- Vista convertida: DAILY_repeat_cases
-- =============================================
ALTER VIEW CustomerService.DAILY_repeat_cases AS
SELECT 
    rc.repeat_cases_id,
    rc.Date,
    rc.case_number,
    rc.department_id,
    a.agent_id,
    CONCAT(a.first_name, ' ', a.last_name COLLATE SQL_Latin1_General_CP1_CI_AS) AS agent_name,
    d.department_name AS Department_Name,
    rc.nb_repeats
FROM CustomerService.repeat_cases rc
JOIN CustomerService.agent a ON rc.agent_id = a.agent_id
JOIN CustomerService.department d ON d.department_id = rc.department_id;


-- CustomerService.Daily_Incoming source

-- CustomerService.Daily_Incoming source

-- CustomerService.Daily_Incoming source

-- CustomerService.Daily_Incoming source

-- CustomerService.Daily_Incoming source

ALTER VIEW CustomerService.DAILY_incoming AS
SELECT 
    d.Week_year,
    d.Week_number,
	d.Month_number,
    d.Date,
    SUM(it.ticket_total) AS total_incoming,
    dp.department_id,
    dp.department_name AS name
FROM CustomerService.incoming_tickets it
JOIN CustomerService.date d ON it.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = it.department_id
GROUP BY 
    d.Date,
    d.Month, 
    d.Week_number,
    d.Month_number, 
    dp.department_id,
    dp.department_name,
	d.Week_year;


-- CustomerService.MONTHLY_Call_performance source

-- CustomerService.MONTHLY_Call_performance source

-- CustomerService.MONTHLY_Call_performance source

ALTER   VIEW CustomerService.MONTHLY_call_performance AS
WITH sla_agg AS (
    SELECT
        s.[Date],
        s.[department_id],
        SUM(CASE WHEN s.sla = 1 THEN 1 ELSE 0 END)  AS sla_hits,
        SUM(CASE WHEN s.aba = 1 THEN 1 ELSE 0 END)  AS aba_hits,
        COUNT(*)                                    AS total_calls 
    FROM CustomerService.SLA_ABA AS s
    WHERE s.interaction_type = 'Inbound Call'
    GROUP BY s.[Date], s.[department_id]
),
asa_agg AS (
    SELECT
        a.[Date],
        a.[department_id],
        SUM(CAST(a.agent_talk_time      AS FLOAT)) AS sum_talk_sec,
        SUM(CAST(a.total_ring_duration  AS FLOAT)) AS sum_queue_sec,
        COUNT(*)                                   AS cnt_calls
    FROM CustomerService.ASA_AHT AS a
    GROUP BY a.[Date], a.[department_id]
)
SELECT
    -- Month calendar----
    YEAR(d.[Date])  AS [Year],
    MONTH(d.[Date]) AS [Month_number],
    dep.[department_id],
    dep.[department_name],
    SUM(s.total_calls) AS [inbounds],
    ROUND(100.0 * SUM(s.sla_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS sla_percentage,
    ROUND(100.0 * SUM(s.aba_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS abandoned_percentage,
    ROUND( SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0), 2) AS asa_seconds,
    ROUND(
          (SUM(COALESCE(a.sum_talk_sec, 0))  / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + (SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + 120
    , 2) AS aht_seconds,
    FORMAT(
        DATEADD(SECOND,
            ROUND( SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0), 0),
        0),
        'HH:mm:ss'
    ) AS asa_formatted,
    FORMAT(
        DATEADD(SECOND,
            ROUND(
                  (SUM(COALESCE(a.sum_talk_sec, 0))  / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
                + (SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
                + 120, 0
            ),
        0),
        'HH:mm:ss'
    ) AS aht_formatted
FROM sla_agg s
LEFT JOIN asa_agg a
  ON a.[Date] = s.[Date]
 AND a.[department_id] = s.[department_id]
JOIN CustomerService.[date] d
  ON d.[Date] = s.[Date]  -- Calendar
JOIN CustomerService.[department] dep
  ON dep.[department_id] = s.[department_id]
GROUP BY
    YEAR(d.[Date]),
    MONTH(d.[Date]),
    dep.[department_id],
    dep.[department_name];


-- CustomerService.MONTHLY_Contact_Rate source

ALTER VIEW CustomerService.MONTHLY_Contact_Rate AS
SELECT 
    d.Month_number,
    AVG(cr.total_number) AS contact_rate,
    dp.department_name AS name
FROM CustomerService.contact_rate cr
JOIN CustomerService.date d ON cr.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = cr.department_id
GROUP BY 
    d.Month_number, 
    dp.department_name;


-- CustomerService.MONTHLY_Evaluations source

ALTER VIEW CustomerService.MONTHLY_Evaluations AS
SELECT 
    d.Month_number,
    AVG(q.quality_total) AS score,
    dp.department_name AS name
FROM CustomerService.quality_evaluations q
JOIN CustomerService.date d ON q.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = q.department_id
GROUP BY 
    d.Month_number, 
    dp.department_name;


-- CustomerService.MONTHLY_Incoming source

-- CustomerService.MONTHLY_Incoming source

-- =============================================
-- Vista convertida: MONTHLY_Incoming
-- =============================================
ALTER VIEW CustomerService.MONTHLY_Incoming AS
SELECT 
    d.Week_Year as Year,
	d.Month,
    d.Month_number,
    dp.team_hierarchy,
    dp.department_name AS department_name,
    SUM(it.ticket_total) AS total_incoming
FROM CustomerService.incoming_tickets it
JOIN CustomerService.date d ON it.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = it.department_id
GROUP BY 
	d.Week_Year,
    d.Month, 
    d.Month_number, 
    dp.team_hierarchy,
    dp.department_name;


-- CustomerService.MONTHLY_Outbounds source

-- CustomerService.MONTHLY_Outbounds source

-- =============================================
-- Vista convertida: MONTHLY_Outbounds
-- =============================================
ALTER VIEW CustomerService.MONTHLY_Outbounds AS
SELECT 
    d.Week_Year,
	d.Month_number,
    dp.department_id,
    dp.department_name,
    SUM(o.total_outbounds) AS outbounds
FROM CustomerService.outbounds o
JOIN CustomerService.date d ON o.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = o.department_id
GROUP BY 
    d.Week_Year,
	d.Month_number, 
    dp.department_id, 
    dp.department_name;


-- CustomerService.MONTHLY_Productivity source

ALTER VIEW CustomerService.MONTHLY_Productivity AS
SELECT 
    d.Month_number,
    dp.department_name,
    COUNT(*) AS total_cases
FROM CustomerService.agent_productivity p
JOIN CustomerService.date d ON p.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = p.department_id
GROUP BY 
    d.Month_number, 
    dp.department_name;


-- CustomerService.MONTHLY_RCA_Analysis source

ALTER VIEW CustomerService.MONTHLY_RCA_Analysis AS
SELECT 
    d2.Date,
	d2.Month_number,
    d2.Week_Year,
    d.department_id,
    d.department_name,
    v.case_number,
    rca.RCA,
    v.NPS_type,
    v.survey_resolution,
    v.case_origin,
    v.NPS_reason
FROM CustomerService.RCA_analysis rca
JOIN CustomerService.department d ON d.department_id = rca.department_id
JOIN CustomerService.date d2 ON d2.Date = rca.Date
JOIN CustomerService.VoC v ON v.Date = rca.Date
GROUP BY 
    rca.RCA, 
    d2.Date,
    d2.Month_number, 
    v.NPS_type,
    v.case_origin,
    v.case_number,
    d.department_id,
    d.department_name, 
    v.NPS_reason,
    v.survey_resolution,
    d2.Week_Year;


-- CustomerService.MONTHLY_RR source

-- =============================================
-- Vista convertida: MONTHLY_RR
-- =============================================
ALTER VIEW CustomerService.MONTHLY_RR AS
SELECT 
    dt.Month_number,
    dt.Week_Year,
    SUM(rr.[3_repeats]) AS repeats,
    SUM(rr.all_touchpoints) AS touchpoints,
    rr.department_id,
    d.department_name AS name,
    CAST(SUM(rr.[3_repeats]) * 100.0 / NULLIF(SUM(rr.all_touchpoints), 0) AS DECIMAL(5,2)) AS rr
FROM CustomerService.repeat_rate rr
JOIN CustomerService.department d ON d.department_id = rr.department_id
JOIN CustomerService.date dt ON dt.Date = rr.Date
GROUP BY 
    dt.Month_number, 
    rr.department_id, 
    d.department_name, 
    dt.Week_Year;


-- CustomerService.MONTHLY_Tickets_SLA source

-- =============================================
-- Vista convertida: MONTHLY_Tickets_SLA
-- =============================================
ALTER VIEW CustomerService.MONTHLY_Tickets_SLA AS

SELECT 
    d.Month_number,
    dp.department_name AS department,
    CAST(AVG(CAST(sla.in_SLA AS FLOAT)) AS DECIMAL(10,4)) AS avg_in_SLA
FROM CustomerService.ticket_sla sla
JOIN CustomerService.date d 
    ON sla.Date_open = d.Date
JOIN CustomerService.department dp 
    ON dp.department_id = sla.department_id
GROUP BY 
    d.Month_number, 
    dp.department_name;


-- CustomerService.MONTHLY_Transfers source

-- CustomerService.MONTHLY_Transfers source

-- =============================================
-- Vista convertida: MONTHLY_Transfers
-- =============================================
ALTER VIEW CustomerService.MONTHLY_Transfers AS
SELECT 
    d.Month_number,
    COUNT(t.agent_transfer_id) AS total_transfers,
    dp_from.department_name AS from_department,
    dp_to.department_name AS to_department
FROM CustomerService.agent_transfer t
JOIN CustomerService.department dp_from ON dp_from.department_id = t.department_id
JOIN CustomerService.department dp_to ON dp_to.department_id = t.new_department
JOIN CustomerService.date d ON d.Date = t.Date
WHERE d.Week_Year = 2025
GROUP BY 
    d.Month_number, 
    dp_from.department_name, 
    dp_to.department_name;


-- CustomerService.MONTHLY_VoC source

ALTER VIEW CustomerService.MONTHLY_VoC AS
SELECT 
    d2.Month_number,
    d2.Week_Year,
    d2.Date,
    d2.Week_number,
    v.case_number,
    a.agent_id,
	CONCAT(a.first_name,' ',a.last_name COLLATE SQL_Latin1_General_CP1_CI_AS) AS agent_name,
	d.vertical,
    d.department_name,
    v.case_origin,
    v.NPS_Reason,
    v.NPS_type,
    COUNT(*) as No_surveys,
    SUM(CASE WHEN v.survey_resolution = 1 THEN 1 ELSE 0 END) AS Resolved,
    COUNT(v.survey_resolution) AS Not_resolved,
    ROUND(SUM(CASE WHEN v.survey_resolution = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.survey_resolution), 0), 2) AS Resolution_total,
    SUM(CASE WHEN v.NPS IN (9, 10) THEN 1 ELSE 0 END) AS nps_promoter,
    SUM(CASE WHEN v.NPS BETWEEN 0 AND 6 THEN 1 ELSE 0 END) AS nps_detractor,
    COUNT(v.NPS) AS nps_total,
    ROUND((SUM(CASE WHEN v.NPS IN (9, 10) THEN 1 ELSE 0 END) - SUM(CASE WHEN v.NPS BETWEEN 0 AND 6 THEN 1 ELSE 0 END)) * 100.0 / NULLIF(COUNT(v.NPS), 0), 2) AS NPS,
    SUM(CASE WHEN v.CSAT_Service IN (4, 5) THEN 1 ELSE 0 END) AS csat_positive,
    SUM(CASE WHEN v.CSAT_Service IN (1, 2) THEN 1 ELSE 0 END) AS csat_negative,
    COUNT(v.CSAT_Service) AS csat_total,
    ROUND(SUM(CASE WHEN v.CSAT_Service IN (4, 5) THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.CSAT_Service), 0), 2) AS CSAT_Service,
    SUM(CASE WHEN v.NES IN (4, 5) THEN 1 ELSE 0 END) AS nes_positive,
    SUM(CASE WHEN v.NES IN (1, 2) THEN 1 ELSE 0 END) AS nes_negative,
    COUNT(v.NES) AS nes_total,
    ROUND(SUM(CASE WHEN v.NES IN (4, 5) THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.NES), 0), 2) AS NES,
    SUM(CASE WHEN v.CSAT_Product IN (1, 2) THEN 1 ELSE 0 END) AS Product_negative,
    COUNT(v.CSAT_Product) AS product_total,
    ROUND(SUM(CASE WHEN v.CSAT_Product IN (4, 5) THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(v.CSAT_Product), 0), 2) AS CSAT_Product
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
JOIN CustomerService.date d2 ON d2.Date = v.Date
JOIN CustomerService.agent a ON a.agent_id = v.agent_id
GROUP BY 
    d2.Month_number, 
    d2.Week_Year, 
    d2.Week_number,
    v.case_number,
    d.vertical,
    d.department_name,
    a.agent_id,
    a.first_name,
    a.last_name,
    v.NPS_Reason,
    v.NPS_Type,
    v.case_origin,
    d2.Date;


-- CustomerService.MONTHLY_VoC_Reasons source

ALTER VIEW CustomerService.MONTHLY_VoC_Reasons AS
SELECT 
    d2.Month_number,
    v.Year,
    d.department_name,
    v.NPS_type,
    v.NPS_Reason,
    COUNT(v.NPS_Reason) AS count
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name= v.department_name
JOIN CustomerService.date d2 ON d2.Date = v.Date
JOIN CustomerService.agent a ON a.agent_id = v.agent_id
GROUP BY 
    d2.Month_number, 
    v.NPS_Reason, 
    v.NPS_type, 
    v.Year, 
    d.department_name;


-- CustomerService.MONTHLY_VoC_SUMMARY source

ALTER VIEW CustomerService.MONTHLY_VoC_SUMMARY AS
WITH voc_base AS (
    SELECT 
        d2.Date,
        d2.Month_number,
        d2.Week_Year,
        d.team_hierarchy,
        d.department_id,
        d.department_name,
        COUNT(*) AS No_surveys,
        SUM(CASE WHEN v.survey_resolution = 1 THEN 1 ELSE 0 END) AS Resolved,
        SUM(CASE WHEN v.survey_resolution = 0 THEN 1 ELSE 0 END) AS Not_resolved,
        COUNT(v.survey_resolution) AS Resolution_total,
        SUM(CASE WHEN v.NPS IN (9, 10) THEN 1 ELSE 0 END) AS nps_promoter,
        SUM(CASE WHEN v.NPS BETWEEN 0 AND 6 THEN 1 ELSE 0 END) AS nps_detractor,
        COUNT(v.NPS) AS nps_total,
        SUM(CASE WHEN v.CSAT_Service IN (4, 5) THEN 1 ELSE 0 END) AS csat_positive,
        SUM(CASE WHEN v.CSAT_Service IN (1, 2) THEN 1 ELSE 0 END) AS csat_negative,
        COUNT(v.CSAT_Service) AS csat_total,
        SUM(CASE WHEN v.NES IN (4, 5) THEN 1 ELSE 0 END) AS nes_positive,
        SUM(CASE WHEN v.NES IN (1, 2) THEN 1 ELSE 0 END) AS nes_negative,
        COUNT(v.NES) AS nes_total,
        SUM(CASE WHEN v.CSAT_Product IN (1, 2) THEN 1 ELSE 0 END) AS product_negative,
        COUNT(v.CSAT_Product) AS product_total
    FROM CustomerService.VoC v
    JOIN CustomerService.department d ON d.department_name = v.department_name
    JOIN CustomerService.date d2 ON d2.Date = v.Date
    GROUP BY d2.Date, d2.Month_number, d2.Week_Year, d.team_hierarchy, d.department_id, d.department_name
),
surveys_sent_monthly AS (
    SELECT 
        d.Month_number,
        d.Week_Year,
        dp.department_id,
        dp.department_name,
        COUNT(*) AS surveys_sent_total
    FROM APP_FLOW.CustomerService.surveys_sent ss
    JOIN CustomerService.department dp ON dp.department_id = ss.department_id
    JOIN CustomerService.date d ON d.Date = ss.Date
    GROUP BY d.Month_number, d.Week_Year, dp.department_id, dp.department_name
)
SELECT 
    vb.Date,
    vb.Month_number,
    vb.Week_Year,
    vb.team_hierarchy,
    vb.department_id,
    vb.department_name,
    vb.No_surveys,
    vb.Resolved,
    vb.Not_resolved,
    vb.Resolution_total,
    ROUND(vb.Resolved * 100.0 / NULLIF(vb.Resolution_total, 0), 2) AS Resolution_total_pct,
    vb.nps_promoter,
    vb.nps_detractor,
    vb.nps_total,
    ROUND((vb.nps_promoter - vb.nps_detractor) * 100.0 / NULLIF(vb.nps_total, 0), 2) AS NPS,
    vb.csat_positive,
    vb.csat_negative,
    vb.csat_total,
    ROUND(vb.csat_positive * 100.0 / NULLIF(vb.csat_total, 0), 2) AS CSAT_Service,
    vb.nes_positive,
    vb.nes_negative,
    vb.nes_total,
    ROUND(vb.nes_positive * 100.0 / NULLIF(vb.nes_total, 0), 2) AS NES,
    vb.product_negative,
    vb.product_total,
    ROUND((vb.product_total - vb.product_negative) * 100.0 / NULLIF(vb.product_total, 0), 2) AS CSAT_Product,
    ISNULL(ssm.surveys_sent_total, 0) AS surveys_sent_total
FROM voc_base vb
LEFT JOIN surveys_sent_monthly ssm 
    ON ssm.Month_number = vb.Month_number 
    AND ssm.Week_Year = vb.Week_Year 
    AND ssm.department_id = vb.department_id;


-- CustomerService.MONTHLY_case_reasons source

-- =============================================
-- Vista convertida: MONTHLY_case_reasons
-- =============================================
ALTER VIEW CustomerService.MONTHLY_case_reasons AS
SELECT 
    d.Month_number,
    d.Month,
    d.Week_Year,
    dp.team_hierarchy,
    dp.department_name,
    cs.case_reason,
    cs.case_subreason,
    COUNT(cs.case_subreason) AS count
FROM CustomerService.case_reason cs
JOIN CustomerService.date d ON cs.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = cs.department_id
GROUP BY 
    d.Month_number, 
    d.Month,
    dp.team_hierarchy,
    dp.department_name, 
    cs.case_reason, 
    d.Week_Year,
    cs.case_subreason;


-- CustomerService.MONTHLY_einstein source

-- CustomerService.MONTHLY_einstein source

ALTER VIEW CustomerService.MONTHLY_einstein AS
SELECT 
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
        d.Month_number,
        dp.department_id,
        SUM(it.ticket_total) AS sum
    FROM CustomerService.incoming_tickets it
    JOIN CustomerService.date d ON it.Date = d.Date
    JOIN CustomerService.department dp ON dp.department_id = it.department_id
    GROUP BY d.Month_number, dp.department_id
) it_monthly ON d.Month_number = it_monthly.Month_number AND dp.department_id = it_monthly.department_id
GROUP BY 
    d.Month_number, 
    dp.department_name,
    CAST(se.email_address AS VARCHAR(MAX));


-- CustomerService.MONTHLY_surveys_sent source

-- CustomerService.MONTHLY_surveys_sent source

-- CustomerService.MONTHLY_surveys_sent source

ALTER VIEW CustomerService.MONTHLY_surveys_sent AS
SELECT 
    d.Month_number,
    d.Week_Year as Year,
    d.Week_number,
    ss.department_id,
    dp.department_name,
    COUNT (ss.surveys_sent_id) AS No_surveys,
    ss.Date
FROM CustomerService.surveys_sent as ss
JOIN CustomerService.date d ON d.Date = SS.Date
JOIN CustomerService.department dp ON dp.department_id = ss.department_id
GROUP BY 
    d.Month_number, 
    d.Week_Year,
    d.Week_number,
    ss.department_id, 
    dp.department_name,
	ss.Date;


-- CustomerService.VoC_PMS source

-- =============================================
-- Vista convertida: VoC_PMS
-- =============================================
ALTER VIEW CustomerService.VoC_PMS AS
SELECT 
    v.Date,
    v.case_number,
    v.subject,
    v.NPS,
    v.CSAT_Service,
    v.NES,
    v.customer_comment,
    d.department_name
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
WHERE v.subject LIKE '%Property Management System%'
AND v.customer_comment IS NOT NULL;


-- CustomerService.VoC_PMS_Negative source

-- =============================================
-- Vista convertida: VoC_PMS_Negative
-- =============================================
ALTER VIEW CustomerService.VoC_PMS_Negative AS
SELECT 
    v.Date,
    v.case_number,
    v.subject,
    v.NPS,
    v.CSAT_Service,
    v.NES,
    v.customer_comment,
    d.department_name
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
WHERE v.subject LIKE '%Property Management System%'
AND v.customer_comment IS NOT NULL
AND (
    v.NPS BETWEEN 0 AND 6
    OR v.CSAT_Service BETWEEN 1 AND 2
    OR v.NES BETWEEN 1 AND 2
);


-- CustomerService.VoC_Partners_L2 source

-- CustomerService.VoC_Partners_L2 source

-- CustomerService.VoC_Partners_L2 source

ALTER VIEW CustomerService.VoC_Partners_L2 AS
SELECT 
    v.Date,
    v.case_number,
    v.survey_resolution,
    v.NPS,
    v.CSAT_Service,
    v.NES,
    v.customer_comment,
    d.department_name
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
WHERE v.team_hierarchy like 'Partners' or v.team_hierarchy like 'L2';


-- CustomerService.VoC_Payments source

-- CustomerService.VoC_Payments source

-- CustomerService.VoC_Payments source

-- =============================================
-- Vista convertida: VoC_Payments
-- =============================================
ALTER VIEW CustomerService.VoC_Payments AS
SELECT 
    v.Date,
    v.case_number,
    v.survey_resolution,
    v.NPS,
    v.CSAT_Service,
    v.NES,
    v.customer_comment,
    d.department_name
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
WHERE d.department_id IN (1, 2, 3);


-- CustomerService.VoC_Payments_Negative source

-- CustomerService.VoC_Payments_Negative source

-- =============================================
-- Vista convertida: VoC_Payments_Negative
-- =============================================
ALTER VIEW CustomerService.VoC_Payments_Negative AS
SELECT 
    v.Date,
    v.case_number,
    v.NPS,
    v.CSAT_Service,
    v.NES,
    v.customer_comment,
    d.department_name
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
WHERE (
    v.NPS BETWEEN 0 AND 6
);


-- CustomerService.WEEKLY_Contact_Rate source

-- =============================================
-- Vista convertida: WEEKLY_Contact_Rate
-- =============================================
ALTER VIEW CustomerService.WEEKLY_Contact_Rate AS
SELECT 
    d.Week_number,
    AVG(cr.total_number) AS contact_rate,
    dp.department_name AS name
FROM CustomerService.contact_rate cr
JOIN CustomerService.date d ON cr.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = cr.department_id
GROUP BY 
    d.Week_number, 
    dp.department_name;


-- CustomerService.WEEKLY_Evaluations source

-- =============================================
-- Vista convertida: WEEKLY_Evaluations
-- =============================================
ALTER VIEW CustomerService.WEEKLY_Evaluations AS
SELECT 
    d.Week_number,
    AVG(q.quality_total) AS score,
    dp.department_name AS name
FROM CustomerService.quality_evaluations q
JOIN CustomerService.date d ON q.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = q.department_id
GROUP BY 
    d.Week_number, 
    dp.department_name;


-- CustomerService.WEEKLY_Incoming source

ALTER VIEW CustomerService.WEEKLY_Incoming AS
SELECT 
	d.Date,
	d.Week_Year,
    d.Week_number,
    SUM(it.ticket_total) AS sum,
    dp.department_id,
    dp.department_name AS name
FROM CustomerService.incoming_tickets it
JOIN CustomerService.date d ON it.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = it.department_id
GROUP BY
	d.Date,
    d.Week_number,
    d.Week_Year,
    dp.department_id,
    dp.department_name;


-- CustomerService.WEEKLY_Incomingmock source

ALTER VIEW CustomerService.WEEKLY_Incomingmock AS
SELECT
    d.Date,
    d.Week_Year,
    d.Week_number,
    dp.department_id,
    dp.department_name AS name,
    ISNULL(inc.incoming_count, 0) AS incoming,
    ISNULL(tr.transferred_count, 0) AS transferred,
    ISNULL(inc.incoming_count, 0) + ISNULL(tr.transferred_count, 0) AS total
FROM CustomerService.date d
CROSS JOIN CustomerService.department dp
LEFT JOIN (
    -- Incoming tickets
    SELECT
        it.Date,
        it.department_id,
        COUNT(*) AS incoming_count
    FROM CustomerService.incoming_tickets it
    GROUP BY it.Date, it.department_id
) inc ON inc.Date = d.Date AND inc.department_id = dp.department_id
LEFT JOIN (
    -- Transferred tickets (distinct case_number)
    SELECT
        at.Date,
        at.new_department AS department_id,
        COUNT(DISTINCT at.case_number) AS transferred_count
    FROM CustomerService.agent_transfer at
    GROUP BY at.Date, at.new_department
) tr ON tr.Date = d.Date AND tr.department_id = dp.department_id
WHERE d.Date IS NOT NULL;


-- CustomerService.WEEKLY_Outbounds source

ALTER VIEW CustomerService.WEEKLY_Outbounds AS
SELECT 
    d.Week_number,
    dp.department_id,
    dp.department_name,
    SUM(o.total_outbounds) AS outbounds,
    dp.department_name AS name
FROM CustomerService.outbounds o
JOIN CustomerService.date d ON o.Date = d.Date
JOIN CustomerService.department dp ON dp.department_id = o.department_id
GROUP BY 
    d.Week_number, 
    dp.department_id, 
    dp.department_name;


-- CustomerService.WEEKLY_Productivity source

-- CustomerService.WEEKLY_Productivity source

-- CustomerService.WEEKLY_Productivity source

-- CustomerService.WEEKLY_Productivity source

ALTER VIEW [CustomerService].[WEEKLY_Productivity]
AS
WITH base AS (
    SELECT
        d.[Week_Year],
        d.[Week_number],
        dp.[department_name],
        CAST(ap.[case_number] AS DECIMAL(18,4)) AS case_number
    FROM [CustomerService].[agent_productivity] AS ap
    JOIN [CustomerService].[date] AS d
        ON ap.[Date] = d.[Date]
    JOIN [CustomerService].[department] AS dp
        ON dp.[department_id] = ap.[department_id]
)
SELECT
    [Week_Year],
    [Week_number],
    [department_name],
    CAST(AVG(case_number) AS DECIMAL(18,2)) AS productivity_avg,
    CAST(SUM(case_number) AS DECIMAL(18,2)) AS productivity_total
FROM base
GROUP BY
    [Week_Year],
    [Week_number],
    [department_name];


-- CustomerService.WEEKLY_RR source

-- CustomerService.WEEKLY_RR source

-- CustomerService.WEEKLY_RR source

-- =============================================
-- Vista convertida: WEEKLY_RR
-- =============================================
ALTER VIEW CustomerService.WEEKLY_RR AS
SELECT 
    dt.Week_number,
    dt.Date,
    SUM(rr.[3_repeats]) AS repeats,
    SUM(rr.all_touchpoints) AS touchpoints,
    d.vertical,
    rr.department_id,
    d.department_name AS name,
    CAST(SUM(rr.[3_repeats]) * 100.0 / NULLIF(SUM(rr.all_touchpoints), 0) AS DECIMAL(5,2)) AS rr
FROM CustomerService.repeat_rate rr
JOIN CustomerService.department d ON d.department_id = rr.department_id
JOIN CustomerService.date dt ON dt.Date = rr.Date
GROUP BY 
    dt.Week_number, 
    dt.Date,
    rr.department_id, 
    d.vertical,
    d.department_name;


-- CustomerService.WEEKLY_Ticket_SLA source

-- CustomerService.WEEKLY_Ticket_SLA source

ALTER VIEW CustomerService.WEEKLY_Ticket_SLA AS
SELECT 
	d.Date,
    d.Week_number,
    dp.department_id,
    dp.department_name AS department,
    CAST(AVG(CAST(sla.in_SLA AS FLOAT)) AS DECIMAL(10,4)) AS avg_in_SLA
FROM CustomerService.ticket_sla sla
JOIN CustomerService.date d 
    ON sla.Date_open = d.Date
JOIN CustomerService.department dp 
    ON dp.department_id = sla.department_id
GROUP BY 
    d.Week_number,
    d.Date,
    dp.department_id,
    dp.department_name;


-- CustomerService.WEEKLY_VoC source

-- CustomerService.WEEKLY_VoC source

ALTER VIEW CustomerService.WEEKLY_VoC AS
SELECT 
    d2.Month_number,
    d2.Week_Year,
    d2.Date,
    d2.Week_number,
    d.vertical,
    d.department_id,
    d.department_name,
    COUNT(CASE WHEN v.survey_resolution = 1 THEN 1 END) AS Resolved,
    COUNT(v.survey_resolution) AS Not_resolved,
    ROUND(COUNT(CASE WHEN v.survey_resolution = 1 THEN 1 END) * 100.0 / NULLIF(COUNT(v.survey_resolution), 0), 2) AS Resolution_total,
    COUNT(CASE WHEN v.NPS IN (9, 10) THEN 1 END) AS nps_promoter,
    COUNT(CASE WHEN v.NPS BETWEEN 0 AND 6 THEN 1 END) AS nps_detractor,
    COUNT(v.NPS) AS nps_total,
    ROUND((COUNT(CASE WHEN v.NPS IN (9, 10) THEN 1 END) - COUNT(CASE WHEN v.NPS BETWEEN 0 AND 6 THEN 1 END)) * 100.0 / NULLIF(COUNT(v.NPS), 0), 2) AS NPS,
    COUNT(CASE WHEN v.CSAT_Service IN (4, 5) THEN 1 END) AS csat_positive,
    COUNT(CASE WHEN v.CSAT_Service IN (1, 2) THEN 1 END) AS csat_negative,
    COUNT(v.CSAT_Service) AS csat_total,
    ROUND(COUNT(CASE WHEN v.CSAT_Service IN (4, 5) THEN 1 END) * 100.0 / NULLIF(COUNT(v.CSAT_Service), 0), 2) AS CSAT_Service,
    COUNT(CASE WHEN v.NES IN (4, 5) THEN 1 END) AS nes_positive,
    COUNT(CASE WHEN v.NES IN (1, 2) THEN 1 END) AS nes_negative,
    COUNT(v.NES) AS nes_total,
    ROUND(COUNT(CASE WHEN v.NES IN (4, 5) THEN 1 END) * 100.0 / NULLIF(COUNT(v.NES), 0), 2) AS NES,
    COUNT(CASE WHEN v.CSAT_Product IN (1, 2) THEN 1 END) AS Product_negative,
    COUNT(v.CSAT_Product) AS product_total,
    ROUND(COUNT(CASE WHEN v.CSAT_Product IN (4, 5) THEN 1 END) * 100.0 / NULLIF(COUNT(v.CSAT_Product), 0), 2) AS CSAT_Product
FROM CustomerService.VoC v
JOIN CustomerService.department d ON d.department_name = v.department_name
JOIN CustomerService.date d2 ON d2.Date = v.Date
JOIN CustomerService.agent a ON a.agent_id = v.agent_id
GROUP BY 
    d2.Month_number, 
    d2.Week_number, 
    d2.Week_Year, 
    d2.Date,
    d.department_id,
    d.vertical,
    d.department_name;


-- CustomerService.WEEKLY_call_performance source

ALTER   VIEW CustomerService.WEEKLY_call_performance AS
WITH sla_agg AS (
    SELECT
        s.[Date],
        s.[department_id],
        SUM(CASE WHEN s.sla = 1 THEN 1 ELSE 0 END)  AS sla_hits,
        SUM(CASE WHEN s.aba = 1 THEN 1 ELSE 0 END)  AS aba_hits,
        COUNT(*)                                    AS total_calls   -- inbound por día+depto
    FROM CustomerService.SLA_ABA AS s
    WHERE s.interaction_type = 'Inbound Call'
    GROUP BY s.[Date], s.[department_id]
),
asa_agg AS (
    SELECT
        a.[Date],
        a.[department_id],
        SUM(CAST(a.agent_talk_time      AS FLOAT)) AS sum_talk_sec,
        SUM(CAST(a.total_ring_duration  AS FLOAT)) AS sum_queue_sec,
        COUNT(*)                                   AS cnt_calls
    FROM CustomerService.ASA_AHT AS a
    GROUP BY a.[Date], a.[department_id]
)
SELECT
    d.[Week_Year],
    d.[Week_number],
    dep.[department_id],
    dep.[department_name],
    SUM(s.total_calls) AS [inbounds],
    ROUND(100.0 * SUM(s.sla_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS sla_percentage,
    ROUND(100.0 * SUM(s.aba_hits) / NULLIF(SUM(s.total_calls), 0), 2) AS abandoned_percentage,
    ROUND( SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0), 2) AS asa_seconds,
    ROUND(
          (SUM(COALESCE(a.sum_talk_sec, 0))  / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + (SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
        + 120
    , 2) AS aht_seconds,
    FORMAT(
        DATEADD(SECOND,
            ROUND( SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0), 0),
        0),
        'HH:mm:ss'
    ) AS asa_formatted,
    FORMAT(
        DATEADD(SECOND,
            ROUND(
                  (SUM(COALESCE(a.sum_talk_sec, 0))  / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
                + (SUM(COALESCE(a.sum_queue_sec, 0)) / NULLIF(SUM(COALESCE(a.cnt_calls, 0)), 0))
                + 120, 0
            ),
        0),
        'HH:mm:ss'
    ) AS aht_formatted,
    d.[Date]
FROM sla_agg s
LEFT JOIN asa_agg a
  ON a.[Date] = s.[Date]
 AND a.[department_id] = s.[department_id]
JOIN CustomerService.[date] d
  ON d.[Date] = s.[Date]  -- calendario con semana Jue–Mié
JOIN CustomerService.[department] dep
  ON dep.[department_id] = s.[department_id]
GROUP BY
	d.[Date],
    d.[Week_Year],
    d.[Week_number],
    dep.[department_id],
    dep.[department_name];


-- CustomerService.WEEKLY_einstein source

ALTER VIEW CustomerService.WEEKLY_einstein AS
SELECT 
    d.Week_number,
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
    MAX(it_weekly.sum) AS incoming_tickets,
    ROUND(
        CAST(SUM(CASE WHEN ec.reopened = 1 THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(MAX(it_weekly.sum), 0), 
        2
    ) AS Reopened_vs_Incoming
FROM CustomerService.einstein_cases ec
JOIN CustomerService.date d ON ec.Date = d.Date
JOIN CustomerService.support_email se ON ec.support_email_id = se.support_email_id
JOIN CustomerService.department dp ON dp.department_id = se.department_id
LEFT JOIN (
    SELECT 
        d.Week_number,
        dp.department_id,
        SUM(it.ticket_total) AS sum
    FROM CustomerService.incoming_tickets it
    JOIN CustomerService.date d ON it.Date = d.Date
    JOIN CustomerService.department dp ON dp.department_id = it.department_id
    GROUP BY d.Week_number, dp.department_id
) it_weekly ON d.Week_number = it_weekly.Week_number AND dp.department_id = it_weekly.department_id
GROUP BY 
    d.Week_number, 
    dp.department_name,
    CAST(se.email_address AS VARCHAR(MAX));


-- CustomerService.agent_productivity_daily_check source

ALTER VIEW CustomerService.agent_productivity_daily_check AS
SELECT
    s.Date AS work_date,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    a.item_target AS daily_target,
    MAX(s.shift_time) AS shift_time,
    COALESCE(MAX(sh.shrinkage_time), 0) AS shrinkage_time,
    (MAX(s.shift_time) - COALESCE(MAX(sh.shrinkage_time), 0)) AS effective_time,
    MAX(ap.productivity_total) AS productivity_total,
    ROUND(
        a.item_target * 1.0 * (MAX(s.shift_time) - COALESCE(MAX(sh.shrinkage_time), 0)) / MAX(s.shift_time),
        2
    ) AS adjusted_target,
    ROUND(
        MAX(ap.productivity_total) * 1.0 /
        NULLIF(
            a.item_target * 1.0 * (MAX(s.shift_time) - COALESCE(MAX(sh.shrinkage_time), 0)) / MAX(s.shift_time),
            0
        ) * 100,
        2
    ) AS target_achievement_pct,
    MAX(ap.age) AS age
FROM
    CustomerService.agent a
    INNER JOIN CustomerService.shifts s ON a.agent_id = s.agent_id
    LEFT JOIN CustomerService.shrinkage sh ON a.agent_id = sh.agent_id AND s.Date = sh.Date
    INNER JOIN (
        SELECT agent_id, Date, COUNT(*) AS productivity_total, MAX(age) AS age
        FROM CustomerService.agent_productivity
        GROUP BY agent_id, Date
    ) ap ON a.agent_id = ap.agent_id AND s.Date = ap.Date
WHERE
    a.department_id = '1' AND a.tl_id <> '0'
GROUP BY s.Date, a.agent_id, a.first_name, a.last_name, a.item_target;


-- CustomerService.discretion_scores source

-- CustomerService.discretion_scores source

ALTER VIEW CustomerService.discretion_scores AS
	SELECT 
	d.Month_number,
	CONCAT(a.first_name, ' ', a.last_name) as agent_name,
	CONCAT(tl.first_name, ' ',tl.last_name) as tl_name,
	dis.discretion_score
	FROM CustomerService.TL_discretion as dis
	JOIN CustomerService.agent a ON a.agent_id = dis.agent_id
	JOIN CustomerService.tl tl ON tl.tl_id = dis.tl_id
	JOIN CustomerService.date d ON d.Month_number = dis.Month_number;
