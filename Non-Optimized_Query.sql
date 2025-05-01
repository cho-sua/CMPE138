-- Query 1 Discover all Floridian physicians and suppliers
SELECT
  npi AS doctor_ID,
  nppes_provider_first_name,
  nppes_provider_last_org_name,
  nppes_provider_city,
  nppes_provider_state
FROM
  `bigquery-public-data.cms_medicare.physicians_and_other_supplier_2012`
WHERE
  LOWER(nppes_provider_state) = 'fl'
LIMIT 1000;

-- Query 2 Discover all physicians / suppliers who have an average medicare 
-- payment less than half the submitted charge amount AND the average charge amount is > $1000

SELECT
  npi,
  nppes_provider_first_name,
  nppes_provider_last_org_name,
  average_submitted_chrg_amt,
  average_medicare_payment_amt
FROM
  `bigquery-public-data.cms_medicare.physicians_and_other_supplier_2012`
WHERE
  average_medicare_payment_amt < 0.5 * average_submitted_chrg_amt
  AND average_submitted_chrg_amt > 1000
ORDER BY
  average_submitted_chrg_amt DESC
LIMIT 100;

-- Query 3 - Query the amount of physicians/suppliers in Californian cities with a minimum of 200
--
SELECT
  nppes_provider_city,
  COUNT(DISTINCT npi) AS num_providers
FROM
  `bigquery-public-data.cms_medicare.physicians_and_other_supplier_2012`
WHERE
  LOWER(nppes_provider_state) = 'ca'
GROUP BY
  nppes_provider_city
HAVING
  COUNT(DISTINCT npi) > 200
ORDER BY
  num_providers DESC;

-- Query 4 - Find 10 of the providers / suppliers in Florida
SELECT DISTINCT provider_id, provider_name, provider_street_address, average_covered_charges, average_total_payments, average_medicare_payments
FROM `bigquery-public-data.cms_medicare.inpatient_charges_2014`
WHERE provider_state = "FL"
LIMIT 10

-- Query 5 - Find 10 hospitals and their provider perscribed drugs.
SELECT y.hospital_name, x.drg_definition, x.hospital_referral_region_description AS hospital_region
FROM `bigquery-public-data.cms_medicare.inpatient_charges_2014` x
JOIN `bigquery-public-data.cms_medicare.hospital_general_info` y
ON x.provider_id = y.provider_id
LIMIT 10

-- Query 6 -- Discover 20 hospitals, gathering their general information and available providers.
SELECT DISTINCT hospital_name, hospital_ownership, address, city, hospital_overall_rating, county_name, phone_number
FROM `bigquery-public-data.cms_medicare.hospital_general_info`
WHERE provider_id IN(
  SELECT provider_id
  FROM `bigquery-public-data.cms_medicare.inpatient_charges_2014`
)
LIMIT 20


-- Query 7 -- Find the average care given across all health care agencies.
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
WHERE
  percent_of_patients_with_cancer IS NOT NULL OR
  percent_of_patients_with_depression IS NOT NULL OR
  percent_of_patients_with_heart_failure IS NOT NULL OR
  percent_of_patients_with_diabetes IS NOT NULL OR
  percent_of_patients_with_hypertension IS NOT NULL OR
  percent_of_patients_with_osteoporosis IS NOT NULL OR
  percent_of_patients_with_stroke IS NOT NULL;

-- Query 8 -- Breakdown of care given by sex / race

SELECT 
  SUM(male_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_male,
  SUM(female_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_female,
  SUM(nondual_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_nonbinary,
  SUM(white_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_white,
  SUM(black_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_black,
  SUM(asian_pacific_islander_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_asian,
  SUM(hispanic_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_hispanic,
  SUM(american_indian_or_alaska_native_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_native,
  SUM(other_or_unknown_benefciaries) / NULLIF(SUM(distinct_beneficiaries_non_lupa), 0) * 100 AS percent_other,
FROM
  `bigquery-public-data.cms_medicare.home_health_agencies_2014`;