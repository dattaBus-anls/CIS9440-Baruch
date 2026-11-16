
-- Stage NYC 311 Construction and Plumbing complaints

WITH source_data AS (
    SELECT *
    FROM {{ source('raw', 'nyc311_construction_raw') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(unique_key), '') AS unique_key,

        -- Convert timestamps to dates using NYC local time
        DATE(created_date, 'America/New_York') AS created_date,

        -- Only Closed complaints receive a closure date
        CASE
            WHEN UPPER(TRIM(status)) = 'CLOSED'
                THEN DATE(closed_date, 'America/New_York')
            ELSE NULL
        END AS closed_date,

        NULLIF(UPPER(TRIM(complaint_type)), '')
            AS complaint_type,

        NULLIF(TRIM(descriptor), '') AS descriptor,

        NULLIF(UPPER(TRIM(status)), '')
            AS complaint_status,

        NULLIF(TRIM(resolution_description), '')
            AS resolution_description,

        NULLIF(UPPER(TRIM(borough)), '') AS borough,

        CASE
            WHEN REGEXP_CONTAINS(TRIM(incident_zip), r'^\d{5}$')
                THEN TRIM(incident_zip)
            WHEN REGEXP_CONTAINS(TRIM(incident_zip), r'^\d{5}-\d{4}$')
                THEN SUBSTR(TRIM(incident_zip), 1, 5)
            ELSE NULL
        END AS zip_code,

        CASE
            WHEN REGEXP_CONTAINS(TRIM(bbl), r'^\d{10}$')
                THEN TRIM(bbl)
            ELSE NULL
        END AS bbl,

        latitude,
        longitude

    FROM source_data
)

SELECT *
FROM cleaned
