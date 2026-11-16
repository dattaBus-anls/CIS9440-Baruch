
-- Create DOB owner type dimension for Group 4

WITH unique_owner_types AS (

    SELECT DISTINCT
        owner_business_type,
        non_profit

    FROM {{ ref('stg_dob_permit') }}

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            owner_business_type,
            non_profit
    ) AS owner_type_key,

    owner_business_type,
    non_profit

FROM unique_owner_types
