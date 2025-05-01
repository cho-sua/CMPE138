
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

SELECT DISTINCT x.hospital_name, x.hospital_ownership, x.address, x.city, x.hospital_overall_rating, x.county_name,x.phone_number
FROM `bigquery-public-data.cms_medicare.hospital_general_info` x
JOIN `bigquery-public-data.cms_medicare.inpatient_charges_2014` y
ON x.provider_id =y.provider_id
LIMIT 20