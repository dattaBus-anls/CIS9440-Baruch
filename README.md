# NYC Construction Permits & 311 Complaints
### End-to-End ELT Pipeline and Dimensional Data Warehouse
**CIS 9440 — Data Warehousing and Analytics | Group 4 | Fall 2026**
**Baruch College — Zicklin School of Business**
---

## Project Overview

This project develops an Extract, Load, and Transform (ELT) pipeline and dimensional data warehouse using two NYC Open Data sources: Department of Buildings (DOB) permit records and NYC 311 construction-related complaints.

The goal is to transform public operational data into structured, analytics-ready tables for examining building permit activity, construction complaints, geographic patterns, and trends over time.

The project implements Kimball dimensional modeling principles with shared dimensions, subject-specific dimensions, and fact tables.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data extraction and loading |
| NYC Open Data / Socrata API | Source data |
| Google Cloud Run | Execute extraction and loading services |
| Google BigQuery | Raw data storage and analytical warehouse |
| dbt | Data transformation, model dependencies, and lineage |
| SQL | Staging and dimensional transformations |
| GitHub | Version control and project collaboration |

## ELT Architecture

```text
NYC Open Data (Socrata API)
             |
             v
     Google Cloud Run
             |
             v
       Google BigQuery
       RAW DATA LAYER
       group4_project
             |
             v
      dbt Transformations
       STAGING LAYER
       group4_staging
             |
             v
       DIMENSIONAL MODEL
       group4_warehouse
             |
       +-----+-----+
       |           |
   8 Dimensions  2 Fact Tables
```

## Data Sources and Extraction

The pipeline uses two NYC Open Data sources:

| Source | BigQuery raw table | Records |
|---|---|---:
| NYC DOB Permits | `dob_permit_raw` | 271,390 |
| NYC 311 Construction Complaints | `nyc311_construction_raw` | 252,632 |
| **Total** | | **524,022** |

The extraction and loading process used Google Cloud Run services to retrieve data through the Socrata API and load it into BigQuery in batches.

Cloud Run services:

- `group4-socrata-dob`
- `group4-socrata-311`

Successful loading activity was confirmed through Cloud Run execution logs on October 27, 2026.

## BigQuery Data Organization

**GCP Project:** `apu-cis9440-baruch`

| Dataset | Layer | Description |
|---|---|---|
| `group4_project` | Raw | Extracted DOB permit and 311 complaint records |
| `group4_staging` | Staging | Prepared and standardized source data |
| `group4_warehouse` | Warehouse | Final dimensional tables |

### Raw Tables

- `dob_permit_raw` — Original DOB permit records.
- `nyc311_construction_raw` — Original construction-related 311 complaints.

### Staging Tables

- `stg_dob_permit` — Prepared DOB permit records.
- `stg_311_complaint` — Prepared 311 complaint records.

### Final Dimensional Warehouse

The warehouse contains eight dimension tables and two fact tables.

**Conformed dimensions**

| Table | Description |
|---|---|
| `dim_date_milestone4` | Date attributes shared across the two analytical subjects |
| `dim_location_milestone4` | Geographic attributes for location-based analysis |

**DOB permit dimensions**

| Table | Description |
|---|---|
| `dim_permit_type_milestone4` | Permit categories |
| `dim_permit_status_milestone4` | Permit status classifications |
| `dim_property_type_milestone4` | Property classifications |
| `dim_owner_type_milestone4` | Owner classifications |

**311 complaint dimensions**

| Table | Description |
|---|---|
| `dim_complaint_type_milestone4` | Complaint categories |
| `dim_complaint_status_milestone4` | Complaint status classifications |

**Fact tables**

| Table | Description |
|---|---|
| `fact_dob_permit_milestone4` | Permit activity records and dimension references |
| `fact_311_complaint_milestone4` | Construction-related complaint records and dimension references |

## dbt Transformation Process

The transformation pipeline follows these stages:

1. Define the raw BigQuery tables as dbt sources.
2. Prepare and standardize the records using staging models.
3. Create shared and subject-specific dimensions.
4. Build the fact tables using upstream dimension models.
5. Materialize the resulting tables in BigQuery.
6. Validate model execution and dimensional relationships.

### dbt Build

```bash
dbt deps
dbt build --select group4_milestone4
```

**Build results:**

- 12 of 12 models completed successfully.
- No reported build errors or warnings.
- 13 of 13 foreign-key relationship checks passed, with zero invalid records.

### dbt Lineage

The complete DAG can be displayed in dbt using:

```text
+fact_dob_permit_milestone4 +fact_311_complaint_milestone4
```

The DAG shows the dependencies from source data through staging and dimensions to the two fact tables.

## Repository Structure

```text
models/
├── assignment_work/                 # Earlier coursework
└── group4_milestone4/
    ├── staging/
    │   ├── sources.yml
    │   ├── stg_dob_permit.sql
    │   └── stg_311_complaint.sql
    └── marts/
        ├── conformed/
        │   ├── dim_date_milestone4.sql
        │   └── dim_location_milestone4.sql
        ├── dob_permits/
        │   ├── dim_permit_type_milestone4.sql
        │   ├── dim_permit_status_milestone4.sql
        │   ├── dim_property_type_milestone4.sql
        │   ├── dim_owner_type_milestone4.sql
        │   └── fact_dob_permit_milestone4.sql
        └── nyc311_complaints/
            ├── dim_complaint_type_milestone4.sql
            ├── dim_complaint_status_milestone4.sql
            └── fact_311_complaint_milestone4.sql

macros/
└── generate_schema_name.sql

dbt_project.yml
packages.yml
package-lock.yml
README.md
```
## Reproducing the dbt Transformations

The dbt SQL models are available in the `beginning-staging-work` branch.

To reproduce the transformation stage:

1. Clone the repository.
2. Check out the project branch.
3. Configure dbt with a BigQuery connection and appropriate credentials.
4. Ensure the required raw tables are available.
5. Install dependencies and execute the models.

```bash
git clone https://github.com/dattaBus-anls/CIS9440-Baruch.git
cd CIS9440-Baruch
git checkout beginning-staging-work
dbt deps
dbt build --select group4_milestone4
```

The extraction services run separately in Google Cloud Run. Reproducing the extraction stage requires the corresponding service code, deployment configuration, and Google Cloud permissions.

## Project Results

| Metric | Result |
|---|---:|
| DOB permit records loaded | 271,390 |
| NYC 311 complaint records loaded | 252,632 |
| Total source records loaded | 524,022 |
| BigQuery datasets | 3 |
| Staging tables | 2 |
| Dimension tables | 8 |
| Fact tables | 2 |
| Successful dbt models | 12/12 |
| Foreign-key validations passed | 13/13 |

The resulting warehouse provides a structured foundation for analyzing NYC construction permits and construction-related complaints.

## Project Information

**Course:** CIS 9440 — Data Warehousing and Analytics  
**Institution:** Baruch College, Zicklin School of Business  
**Group:** Group 4  
**Milestone:** Milestone 4 — Data Transformation & Processing  
**Academic Term:** Fall 2026

**Repository:** https://github.com/dattaBus-anls/CIS9440-Baruch

**Project Branch:** `beginning-staging-work`

---

*Academic data warehousing project developed using NYC Open Data, Google Cloud, BigQuery, and dbt.*
