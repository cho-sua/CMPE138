-- Optimized Query 1 (from Query 1)  Find all Floridian physicians and suppliers
SELECT
  npi AS doctor_ID,
  nppes_provider_first_name,
  nppes_provider_last_org_name,
  nppes_provider_city,
  nppes_provider_state
FROM
  `bigquery-public-data.cms_medicare.physicians_and_other_supplier_2012`
WHERE
  nppes_provider_state = 'FL'
LIMIT 1000;

-- Optimized Query 2 (from Query 6) List all hostpitals 
SELECT DISTINCT x.hospital_name, x.hospital_ownership, x.address, x.city, x.hospital_overall_rating, x.county_name,x.phone_number
FROM `bigquery-public-data.cms_medicare.hospital_general_info` x
JOIN `bigquery-public-data.cms_medicare.inpatient_charges_2014` y
ON x.provider_id =y.provider_id
LIMIT 20


-- Query 7 -- Find the average care given across all health care agencies.
-- Removed redundant NULL checks
SELECT 
  AVG(percent_of_patients_with_cancer) AS avg_percent_cancer,
  AVG(percent_of_patients_with_depression) AS avg_percent_depression,
  AVG(percent_of_patients_with_heart_failure) AS avg_percent_heart_failure,
  AVG(percent_of_patients_with_diabetes) AS avg_percent_diabetes,
  AVG(percent_of_patients_with_hypertension) AS avg_percent_hypertension,
  AVG(percent_of_patients_with_osteoporosis) AS avg_percent_osteoporosis,
  AVG(percent_of_patients_with_stroke) AS avg_percent_stroke
FROM
  `bigquery-public-data.cms_medicare.home_health_aagencies_2014`


-- Query 8 -- Breakdown of care given by sex / race
