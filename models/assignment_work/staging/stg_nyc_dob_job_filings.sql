-- Clean and standardize DOB NOW job filing data
-- Preserve source records because repeated filing numbers may contain different information

WITH source AS (
    SELECT *
    FROM {{ source('raw', 'source_nyc_dob_job_apps') }}
),

cleaned AS (
    SELECT
        * EXCEPT (
            filing_status,
            borough,
            council_district,
            zip,
            filing_date,
            current_status_date,
            first_permit_date,
            approved_date,
            signoff_date
        ),

        TRIM(filing_status) AS filing_status,

        -- Standardize location fields
        TRIM(borough) AS borough,
        TRIM(council_district) AS council_district,

        CASE
            WHEN REGEXP_CONTAINS(TRIM(zip), r'^\d{5}$')
                THEN TRIM(zip)
            WHEN REGEXP_CONTAINS(TRIM(zip), r'^\d{9}$')
                THEN TRIM(zip)
            WHEN REGEXP_CONTAINS(TRIM(zip), r'^\d{5}-\d{4}$')
                THEN TRIM(zip)
            ELSE NULL
        END AS zip,

        -- Convert date fields
        SAFE_CAST(filing_date AS TIMESTAMP) AS filing_date,
        SAFE_CAST(current_status_date AS TIMESTAMP) AS current_status_date,
        SAFE_CAST(first_permit_date AS TIMESTAMP) AS first_permit_date,
        SAFE_CAST(approved_date AS TIMESTAMP) AS approved_date,
        SAFE_CAST(signoff_date AS TIMESTAMP) AS signoff_date,

        CURRENT_TIMESTAMP() AS _stg_loaded_at

    FROM source

    -- Keep records with a valid filing number
    WHERE job_filing_number IS NOT NULL
)

SELECT *
FROM cleaned