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

-- Query 5 - List all hostpitals, their general information, and current patient diagnoses
SELECT DISTINCT a.hospital_name, a.hospital_ownership, a.address, a.city, a.hospital_overall_rating, a.county_name, a.phone_number, b.hospital_referral_region_description as region, b.drg_definition, b.average_covered_charges, b.average_medicare_payments, b.average_total_payments, b.total_discharges
FROM `bigquery-public-data.cms_medicare.hospital_general_info` a,`bigquery-public-data.cms_medicare.inpatient_charges_2014` b
WHERE a.provider_id = b.provider_id
LIMIT 100;
