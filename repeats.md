# TABLE: CustomerService.repeats

## 1. Purpose
Stores case-level records used to identify and analyse **repeat contacts**.
Each record represents a case that has been classified as a *repeat*, according to the business-defined Repeat Process.

This table is the **authoritative source for Repeat Rate analysis**, used to:
- Measure repeat contact volumes
- Identify drivers of repeated customer contacts
- Support Quality, RCA and Continuous Improvement initiatives

The definition of “repeat” is **not trivial** and follows a documented business process.

---

## 2. Grain (CRITICAL)
One row per:
- Case
- Department involved in the repeat context

Each row represents **one case considered as a repeat for a specific department**.

⚠️ **Why grain matters**
- A single case can generate **multiple rows** if it appears under different departments.
- Metrics assume **case-level uniqueness per department**, not global uniqueness.
- Any misunderstanding of the grain will:
  - Inflate repeat volumes
  - Corrupt repeat rate calculations
  - Break joins with incoming or productivity data

This table **must not be aggregated further without understanding this grain**.

---

## 3. Functional Source (Salesforce + Business Logic)

### Salesforce Report
- **Report ID:** `00OR600000C3F3nMAF`
- **Report Type:** Joined Report
  - Cases with Email
  - Cases with Calls

### Functional Definition
The Salesforce report:
- Combines multiple interaction channels (email + calls)
- Produces a joined structure where case attributes may appear in different blocks
- Does not directly match a flat relational structure

The **business logic defining what constitutes a repeat** is documented here:

🔗 **Repeat Process (Confluence)**  
https://confluence.weareplanet.com/display/CIO/Repeat+Process

This Confluence page is the **functional source of truth**.

---

## 4. Ingestion & Transformation Process (IMPORTANT)

This table is **not automatically ingested**.

### Current process
1. Salesforce joined report is **downloaded manually every day** as Excel.
2. A custom VBA macro:
   - Normalises the joined report into a flat structure
   - Resolves duplicated headers and continuation rows
   - Applies business rules to select the relevant block (email vs calls)
   - Cleans free-text fields
   - Normalises premium flags
   - Sets the reference `Date` (typically previous day)
3. The macro exports a `.sql` file.
4. The SQL file is executed to load data into `CustomerService.repeats`.

This process is implemented in:
- **Excel VBA macro (3 modules)**  
  🔗 https://fintraxgroupholdings.sharepoint.com/:t:/r/teams/CSCITeam-Qualitystatsshared/Shared%20Documents/DATA%20BASE/DB%20documents%20%26%20Training/Repeats%20macro%203%20modules.txt?csf=1&web=1&e=K9haKv

---

## 5. Physical Table Definition

```sql
CREATE TABLE APP_FLOW.CustomerService.repeats (
    repeats_id INT IDENTITY(1,1) NOT NULL,
    case_number INT NULL,
    agent_id INT NULL,
    department_id INT NULL,
    account_name VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    age INT NULL,
    premium BIGINT NULL,
    [language] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    subreason VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Date] DATE NULL,
    subject VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    account_country VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT repeats_id PRIMARY KEY (repeats_id)
);
```

## 6. Column Definitions

| Column name | Type | Description |
|------------|------|-------------|
| repeats_id | int | Technical surrogate primary key. |
| case_number | int | Salesforce case number classified as repeat. |
| agent_id | int | Agent associated with the case (if available). |
| department_id | int | Department associated with the repeat classification. |
| account_name | varchar(100) | Customer account name. |
| age | int | Case age at time of extraction (in days). |
| premium | bigint | Normalised premium flag (1 = premium, 0 = non‑premium). |
| language | varchar(30) | Language associated with the case. |
| subreason | varchar(50) | Case subreason used for repeat analysis. |
| Date | date | Reference date for the repeat record (load date). |
| subject | varchar(MAX) | Case subject or short description. |
| account_country | varchar(100) | Country associated with the customer account. |

---

## 7. Business Rules & Assumptions

- Repeat classification follows the **Repeat Process** defined in Confluence.
- Joined report structure requires manual flattening.
- Email and call interactions are treated as part of the same repeat logic.
- Premium flag is normalised during Excel processing.
- The table does **not** store repeat sequences or timing, only classification.

---

## 8. Data Quality Considerations

- Manual process introduces operational risk.
- Case may appear multiple times across departments.
- No database constraint enforces uniqueness.
- Free-text fields are not standardised.
- Date reflects extraction/load logic, not case creation.

---

## 9. Migration Notes (Azure → Snowflake)

✅ **Recommended approach**
- Treat this table as a **semantic / business-derived dataset**.
- Preserve current logic during migration.
- Clearly document manual steps until automation is implemented.

⚠️ **High‑risk area**
- Rebuilding this logic requires:
  - Full understanding of the Confluence process
  - Re-implementation of joined report handling
- Strongly recommended to redesign as:
  - Event-based model
  - Or automated pipeline using raw case interaction data

---

## 10. Known Gaps / Technical Debt

- Manual ingestion process (Excel + VBA)
- No explicit flag for **newly boarded customers**
- Premium logic embedded in macro, not in data model
- No repeat sequence or time-window modelling
- No audit or lineage metadata
