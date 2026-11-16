
-- Create DOB permit status dimension for Group 4

WITH unique_permit_statuses AS (

    SELECT DISTINCT
        filing_status,
        permit_status

    FROM {{ ref('stg_dob_permit') }}

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            filing_status,
            permit_status
    ) AS permit_status_key,

    filing_status,
    permit_status

FROM unique_permit_statuses
