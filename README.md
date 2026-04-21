# Clinical Data Quality Audit
### MySQL | Healthcare Data | Data Quality Analysis

## Project Overview
A complete data quality audit of the Diabetes 130-US Hospitals dataset — 
a real 10-year clinical dataset covering 101,766 patient encounters across 
130 US hospitals from 1999-2008.

This project demonstrates core Data Quality Analyst skills including data 
profiling, validation, cleaning, and scorecard reporting using MySQL.

## Dataset
- **Source**: UCI Machine Learning Repository / Kaggle
- **Records**: 101,766 patient encounters
- **Unique Patients**: 71,518
- **Time Period**: 1999-2008
- **Domain**: Clinical / Diabetes management

## Project Structure
The audit follows a 4-phase methodology:

**Phase 1 — Data Profiling**
Understanding the overall shape and structure of the dataset including 
record counts, unique patient identification, and basic statistical ranges.

**Phase 2 — Data Validation**
Systematic identification of missing values, invalid entries, and 
statistical outliers across all key fields.

**Phase 3 — Data Cleaning**
Creation of a validated view using SQL CASE logic to standardize missing 
value notation and flag outliers — without modifying the original raw data.

**Phase 4 — Quality Scorecard**
A single summary query producing a complete data quality report across 
all key metrics.

## Key Findings
| Issue | Field | Impact |
|---|---|---|
| 96.86% missing | Weight | Not fit for analysis |
| 49.08% missing | Medical Specialty | Use with caution |
| 39.56% missing | Payer Code | Use with caution |
| 2.23% missing | Race | Flag for equity analysis |
| 74.8% Caucasian | Race | Significant demographic skew |
| 3 records | Gender | Invalid values flagged |
| 97 records | Medications | High outliers (>60) flagged |
| 1 patient | Patient ID 88785891 | 40 encounters — high utilization outlier |

## Skills Demonstrated
- MySQL database creation and data loading
- Clinical data profiling and exploration
- Missing value detection including non-standard placeholders (?)
- Outlier identification and contextual clinical assessment
- SQL view creation for data cleaning best practices
- Data quality scorecard reporting

## Background Context
This project was completed as part of a portfolio development effort 
targeting Data Quality Analyst roles in healthcare and clinical data. 
The author brings 20+ years of experience in FDA-regulated preclinical 
research environments including GLP compliance, data review, and 
computerized systems validation.

## Tools Used
- MySQL 9.6
- MySQL Workbench
- Kaggle (dataset source)
