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

### Data Completeness
| Issue | Field | Impact |
|---|---|---|
| 96.86% missing | Weight | Not fit for analysis |
| 49.08% missing | Medical Specialty | Use with caution |
| 39.56% missing | Payer Code | Use with caution |
| 2.23% missing | Race | Flag for equity analysis |
| 3 records | Gender | Invalid values flagged |

### Data Validity
| Issue | Field | Impact |
|---|---|---|
| 97 records | Medications | High outliers (>60) flagged |
| 1 patient | Patient ID 88785891 | 40 encounters — high utilization outlier |

### Data Integrity
| Issue | Finding | Impact |
|---|---|---|
| Repeat encounters | 30,248 of 101,766 encounters are return visits | Patient vs encounter level analysis requires careful handling |
| Age-stay correlation | Average hospital stay increases consistently with age | Confirms expected clinical pattern — supports dataset integrity |

### Representativeness Bias — Critical Finding
| Issue | Finding | Impact |
|---|---|---|
| Demographic skew | 74.8% Caucasian representation | Inconsistent with known diabetes epidemiology |
| Underrepresented populations | Hispanic 2.0%, Asian 0.6% | Disproportionately low given higher diabetes prevalence in these groups |
| Unknown race | 2,273 records (2.23%) | May further mask minority representation |

**Analyst Note:** Demographic analysis reveals significant racial skew inconsistent 
with known diabetes epidemiology, where minority populations — particularly 
African American and Hispanic patients — have disproportionately higher rates 
of diabetes than Caucasians. This dataset is flagged for representativeness bias. 
Any predictive models, clinical analyses, or policy recommendations derived from 
this dataset should be interpreted with caution regarding applicability to minority 
diabetic populations. This finding is particularly relevant in the context of 
healthcare equity initiatives and AI fairness requirements.

## Skills Demonstrated
- MySQL database creation and data loading
- Clinical data profiling and exploration
- Missing value detection including non-standard placeholders (?)
- Outlier identification and contextual clinical assessment
- SQL view creation for data cleaning best practices
- Data quality scorecard reporting

- ## Analytical Observations
This project demonstrates data quality analysis beyond technical validation 
into clinical and ethical dimensions. The representativeness bias finding 
reflects awareness of emerging healthcare data quality standards around 
demographic completeness, health equity, and AI fairness — increasingly 
critical considerations for organizations using clinical data for 
decision-making and predictive modeling.

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
