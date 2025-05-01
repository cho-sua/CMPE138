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


SELECT DISTINCT provider_id, provider_name, provider_street_address, average_covered_charges, average_total_payments, average_medicare_payments
FROM `bigquery-public-data.cms_medicare.inpatient_charges_2014`
WHERE provider_state = "FL"
LIMIT 10;


SELECT y.hospital_name, x.drg_definition, x.hospital_referral_region_description AS hospital_region
FROM `bigquery-public-data.cms_medicare.inpatient_charges_2014` x
JOIN `bigquery-public-data.cms_medicare.hospital_general_info` y
ON x.provider_id = y.provider_id
LIMIT 10;



SELECT DISTINCT hospital_name, hospital_ownership, address, city, hospital_overall_rating, county_name, phone_number
FROM `bigquery-public-data.cms_medicare.hospital_general_info`
WHERE provider_id IN(
  SELECT provider_id
  FROM `bigquery-public-data.cms_medicare.inpatient_charges_2014`
)
LIMIT 20