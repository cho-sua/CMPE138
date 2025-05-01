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

-- Optimized Query 2 (from Query 5) List all hostpitals, their general information, and current patient diagnoses
SELECT DISTINCT x.hospital_name, x.hospital_ownership, x.address, x.city, x.hospital_overall_rating, x.county_name,x.phone_number, y.hospital_referral_region_description as region, y.drg_definition
FROM `bigquery-public-data.cms_medicare.hospital_general_info` x
JOIN `bigquery-public-data.cms_medicare.inpatient_charges_2014` y
ON x.provider_id =y.provider_id
WHERE y.drg_definition IS NOT NULL
LIMIT 100
