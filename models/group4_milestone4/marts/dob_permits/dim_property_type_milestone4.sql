
-- Create DOB property type dimension for Group 4

WITH unique_property_types AS (

    SELECT DISTINCT
        bldg_type,
        residential

    FROM {{ ref('stg_dob_permit') }}

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            bldg_type,
            residential
    ) AS property_type_key,

    bldg_type,
    residential

FROM unique_property_types
