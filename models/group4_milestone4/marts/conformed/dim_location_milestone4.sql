
-- Create shared location dimension for DOB and NYC 311

WITH all_locations AS (

    SELECT
        borough,
        zip_code
    FROM {{ ref('stg_dob_permit') }}

    UNION DISTINCT

    SELECT
        borough,
        zip_code
    FROM {{ ref('stg_311_complaint') }}

),

unique_locations AS (

    SELECT DISTINCT
        COALESCE(borough, 'UNSPECIFIED') AS borough,
        zip_code
    FROM all_locations

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY borough, zip_code
    ) AS location_key,
    borough,
    zip_code

FROM unique_locations
