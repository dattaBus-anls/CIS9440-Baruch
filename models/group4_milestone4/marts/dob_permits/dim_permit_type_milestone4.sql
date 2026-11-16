
-- Create DOB permit type dimension for Group 4

WITH unique_permit_types AS (

    SELECT DISTINCT
        job_type,
        permit_type,
        permit_subtype

    FROM {{ ref('stg_dob_permit') }}

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            job_type,
            permit_type,
            permit_subtype
    ) AS permit_type_key,

    job_type,
    permit_type,
    permit_subtype

FROM unique_permit_types
