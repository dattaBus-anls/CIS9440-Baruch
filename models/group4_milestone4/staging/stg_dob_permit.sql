
-- Stage DOB Permit Issuance data for Group 4

WITH source_data AS (
    SELECT *
    FROM {{ source('raw', 'dob_permit_raw') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(permit_si_no), '') AS permit_si_no,

        NULLIF(TRIM(job__), '') AS job_number,
        NULLIF(TRIM(job_doc___), '') AS job_doc_number,
        NULLIF(TRIM(permit_sequence__), '') AS permit_sequence,
        NULLIF(TRIM(bin__), '') AS bin_number,

        NULLIF(UPPER(TRIM(borough)), '') AS borough,

        CASE
            WHEN REGEXP_CONTAINS(TRIM(zip_code), r'^\d{5}$')
                THEN TRIM(zip_code)
            WHEN REGEXP_CONTAINS(TRIM(zip_code), r'^\d{5}-\d{4}$')
                THEN SUBSTR(TRIM(zip_code), 1, 5)
            ELSE NULL
        END AS zip_code,

        CASE
            WHEN REGEXP_CONTAINS(TRIM(bbl), r'^\d{10}$')
                THEN TRIM(bbl)
            ELSE NULL
        END AS bbl,

        NULLIF(UPPER(TRIM(job_type)), '') AS job_type,
        NULLIF(UPPER(TRIM(permit_type)), '') AS permit_type,
        NULLIF(UPPER(TRIM(permit_subtype)), '') AS permit_subtype,

        NULLIF(UPPER(TRIM(filing_status)), '') AS filing_status,
        NULLIF(UPPER(TRIM(permit_status)), '') AS permit_status,

        NULLIF(TRIM(bldg_type), '') AS bldg_type,

        CASE
            WHEN UPPER(TRIM(residential)) = 'YES' THEN TRUE
            WHEN UPPER(TRIM(residential)) = 'NO' THEN FALSE
            ELSE NULL
        END AS residential,

        NULLIF(UPPER(TRIM(owner_s_business_type)), '')
            AS owner_business_type,

        CASE
            WHEN UPPER(TRIM(non_profit)) = 'Y' THEN TRUE
            WHEN UPPER(TRIM(non_profit)) = 'N' THEN FALSE
            ELSE NULL
        END AS non_profit,

        SAFE.PARSE_DATE('%m/%d/%Y', NULLIF(TRIM(filing_date), ''))
            AS filing_date,

        SAFE.PARSE_DATE('%m/%d/%Y', NULLIF(TRIM(issuance_date), ''))
            AS issuance_date,

        SAFE.PARSE_DATE('%m/%d/%Y', NULLIF(TRIM(expiration_date), ''))
            AS expiration_date

    FROM source_data
)

SELECT *
FROM cleaned
