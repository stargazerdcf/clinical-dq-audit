-- ============================================================
-- Clinical Data Quality Audit
-- Dataset: Diabetes 130-US Hospitals (1999-2008)
-- Author: Donna Chandler-Ferguson
-- Date: April 2026
-- Purpose: Demonstrate data quality analysis techniques
--          on a real clinical dataset as a portfolio project
-- ============================================================


-- ============================================================
-- SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS clinical_dq_project;
USE clinical_dq_project;


-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE IF NOT EXISTS diabetic_data (
    encounter_id INT,
    patient_nbr INT,
    race VARCHAR(50),
    gender VARCHAR(50),
    age VARCHAR(50),
    weight VARCHAR(50),
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    time_in_hospital INT,
    payer_code VARCHAR(50),
    medical_specialty VARCHAR(100),
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    diag_1 VARCHAR(50),
    diag_2 VARCHAR(50),
    diag_3 VARCHAR(50),
    number_diagnoses INT,
    max_glu_serum VARCHAR(50),
    A1Cresult VARCHAR(50),
    metformin VARCHAR(50),
    repaglinide VARCHAR(50),
    nateglinide VARCHAR(50),
    chlorpropamide VARCHAR(50),
    glimepiride VARCHAR(50),
    acetohexamide VARCHAR(50),
    glipizide VARCHAR(50),
    glyburide VARCHAR(50),
    tolbutamide VARCHAR(50),
    pioglitazone VARCHAR(50),
    rosiglitazone VARCHAR(50),
    acarbose VARCHAR(50),
    miglitol VARCHAR(50),
    troglitazone VARCHAR(50),
    tolazamide VARCHAR(50),
    examide VARCHAR(50),
    citoglipton VARCHAR(50),
    insulin VARCHAR(50),
    glyburide_metformin VARCHAR(50),
    glipizide_metformin VARCHAR(50),
    glimepiride_pioglitazone VARCHAR(50),
    metformin_rosiglitazone VARCHAR(50),
    metformin_pioglitazone VARCHAR(50),
    change_med VARCHAR(50),
    diabetesMed VARCHAR(50),
    readmitted VARCHAR(50)
);


-- ============================================================
-- DATA LOAD
-- Note: Copy diabetic_data.csv to MySQL secure_file_priv
-- folder before running. Run SHOW VARIABLES LIKE
-- 'secure_file_priv' to find the correct path.
-- ============================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/diabetic_data.csv'
INTO TABLE diabetic_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- PHASE 1: DATA PROFILING
-- Understand the overall shape and structure of the dataset
-- ============================================================

-- 1.1 Record counts and hospital stay statistics
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT patient_nbr) AS unique_patients,
    COUNT(DISTINCT encounter_id) AS unique_encounters,
    MIN(time_in_hospital) AS min_days,
    MAX(time_in_hospital) AS max_days,
    ROUND(AVG(time_in_hospital), 2) AS avg_days
FROM diabetic_data;
-- FINDING: 101,766 records, 71,518 unique patients
-- 30,248 repeat encounters indicating high readmission rate
-- Average hospital stay 4.40 days, range 1-14 days

-- 1.2 Gender distribution
SELECT 
    gender,
    COUNT(*) AS count
FROM diabetic_data
GROUP BY gender
ORDER BY count DESC;
-- FINDING: Female 54,708 | Male 47,055 | Unknown/Invalid 3
-- 3 invalid gender records flagged for review

-- 1.3 Race distribution
SELECT 
    race,
    COUNT(*) AS count
FROM diabetic_data
GROUP BY race
ORDER BY count DESC;
-- FINDING: Dataset is 74.8% Caucasian
-- Hispanic 2%, Asian 0.6% -- significant demographic skew
-- 2,273 records with unknown race (2.23%)


-- ============================================================
-- PHASE 2: DATA VALIDATION
-- Check for missing, invalid, and outlier values
-- ============================================================

-- 2.1 Missing value scan -- checking for ? placeholder values
-- Note: This dataset uses ? instead of NULL for missing data
SELECT
    SUM(CASE WHEN race = '?' THEN 1 ELSE 0 END) AS missing_race,
    SUM(CASE WHEN gender = '?' THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN age = '?' THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN weight = '?' THEN 1 ELSE 0 END) AS missing_weight,
    SUM(CASE WHEN payer_code = '?' THEN 1 ELSE 0 END) AS missing_payer,
    SUM(CASE WHEN medical_specialty = '?' THEN 1 ELSE 0 END) AS missing_specialty,
    SUM(CASE WHEN diag_1 = '?' THEN 1 ELSE 0 END) AS missing_diag1,
    SUM(CASE WHEN diag_2 = '?' THEN 1 ELSE 0 END) AS missing_diag2,
    SUM(CASE WHEN diag_3 = '?' THEN 1 ELSE 0 END) AS missing_diag3
FROM diabetic_data;
-- FINDING: Weight 96.86% missing -- not fit for analysis
-- Medical specialty 49.08% missing
-- Payer code 39.56% missing
-- Age, diag_1 highly complete -- reliable for analysis

-- 2.2 Numerical field range validation
SELECT
    MIN(num_lab_procedures) AS min_lab,
    MAX(num_lab_procedures) AS max_lab,
    ROUND(AVG(num_lab_procedures), 2) AS avg_lab,
    MIN(num_procedures) AS min_proc,
    MAX(num_procedures) AS max_proc,
    ROUND(AVG(num_procedures), 2) AS avg_proc,
    MIN(num_medications) AS min_meds,
    MAX(num_medications) AS max_meds,
    ROUND(AVG(num_medications), 2) AS avg_meds,
    MIN(number_diagnoses) AS min_diag,
    MAX(number_diagnoses) AS max_diag,
    ROUND(AVG(number_diagnoses), 2) AS avg_diag
FROM diabetic_data;
-- FINDING: num_medications max of 81 is an outlier
-- num_diagnoses capped at 16 -- likely a system limitation

-- 2.3 High medication outlier investigation
SELECT 
    num_medications,
    COUNT(*) as record_count
FROM diabetic_data
WHERE num_medications > 50
GROUP BY num_medications
ORDER BY num_medications DESC;
-- FINDING: Smooth distribution above 50 medications
-- 97 records above 60 medications (0.10%) flagged as outliers
-- Distribution pattern suggests data entry errors unlikely

-- 2.4 High utilization patient investigation
SELECT 
    patient_nbr,
    COUNT(*) AS number_of_visits,
    MIN(time_in_hospital) AS shortest_stay,
    MAX(time_in_hospital) AS longest_stay
FROM diabetic_data
GROUP BY patient_nbr
HAVING COUNT(*) > 1
ORDER BY number_of_visits DESC
LIMIT 10;
-- FINDING: Patient 88785891 has 40 encounters
-- Demographic data consistent across all visits
-- Assessed as legitimate high-utilization patient
-- 4 visits/year over 10 years clinically plausible for
-- poorly controlled diabetes in a young adult


-- ============================================================
-- PHASE 3: DATA CLEANING
-- Create a validated view without altering raw data
-- Best practice: never modify or delete original records
-- ============================================================

CREATE OR REPLACE VIEW cleaned_diabetic_data AS
SELECT *,
    CASE 
        WHEN weight = '?' THEN 'Missing'
        ELSE weight 
    END AS weight_clean,
    CASE 
        WHEN race = '?' THEN 'Unknown'
        ELSE race 
    END AS race_clean,
    CASE 
        WHEN medical_specialty = '?' THEN 'Unknown'
        ELSE medical_specialty 
    END AS specialty_clean,
    CASE 
        WHEN payer_code = '?' THEN 'Unknown'
        ELSE payer_code 
    END AS payer_clean,
    CASE 
        WHEN gender = 'Unknown/Invalid' THEN 'Unknown'
        ELSE gender 
    END AS gender_clean,
    CASE 
        WHEN num_medications > 60 THEN 'High'
        WHEN num_medications > 30 THEN 'Moderate'
        ELSE 'Normal'
    END AS medication_volume_flag
FROM diabetic_data;


-- ============================================================
-- PHASE 4: DATA QUALITY SCORECARD
-- Summary of all findings in a single report query
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT patient_nbr) AS unique_patients,
    ROUND(COUNT(*) - COUNT(DISTINCT patient_nbr)) AS repeat_encounters,
    SUM(CASE WHEN race = '?' THEN 1 ELSE 0 END) AS missing_race,
    ROUND(SUM(CASE WHEN race = '?' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2) AS pct_missing_race,
    SUM(CASE WHEN gender = 'Unknown/Invalid' THEN 1 ELSE 0 END) 
        AS invalid_gender,
    SUM(CASE WHEN weight = '?' THEN 1 ELSE 0 END) AS missing_weight,
    ROUND(SUM(CASE WHEN weight = '?' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2) AS pct_missing_weight,
    SUM(CASE WHEN medical_specialty = '?' THEN 1 ELSE 0 END) 
        AS missing_specialty,
    ROUND(SUM(CASE WHEN medical_specialty = '?' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2) AS pct_missing_specialty,
    SUM(CASE WHEN payer_code = '?' THEN 1 ELSE 0 END) AS missing_payer,
    ROUND(SUM(CASE WHEN payer_code = '?' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2) AS pct_missing_payer,
    SUM(CASE WHEN num_medications > 60 THEN 1 ELSE 0 END) 
        AS high_medication_outliers,
    ROUND(SUM(CASE WHEN num_medications > 60 THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2) AS pct_high_meds
FROM diabetic_data;
-- FINAL SCORECARD RESULTS:
-- Total Records: 101,766
-- Unique Patients: 71,518
-- Repeat Encounters: 30,248
-- Missing Race: 2,273 (2.23%)
-- Invalid Gender: 3 (0.003%)
-- Missing Weight: 98,569 (96.86%) -- NOT FIT FOR ANALYSIS
-- Missing Specialty: 49,949 (49.08%)
-- Missing Payer Code: 40,256 (39.56%)
-- High Medication Outliers: 97 (0.10%)