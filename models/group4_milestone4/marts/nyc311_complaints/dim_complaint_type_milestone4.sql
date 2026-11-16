
-- Create NYC 311 complaint type dimension for Group 4

WITH unique_complaint_types AS (

    SELECT DISTINCT
        complaint_type,
        descriptor

    FROM {{ ref('stg_311_complaint') }}

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            complaint_type,
            descriptor
    ) AS complaint_type_key,

    complaint_type,
    descriptor

FROM unique_complaint_types
