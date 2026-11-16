
-- Create NYC 311 complaint fact table for Group 4

WITH complaints AS (

    SELECT *
    FROM {{ ref('stg_311_complaint') }}

),

final AS (

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY c.unique_key
        ) AS complaint_key,

        c.unique_key,

        l.location_key,
        ct.complaint_type_key,
        cs.complaint_status_key,

        cd.date_key AS created_date_key,
        cld.date_key AS closed_date_key,

        c.bbl,
        c.resolution_description,

        1 AS complaint_count,

        CASE
            WHEN c.complaint_status = 'CLOSED'
                 AND c.closed_date IS NOT NULL
            THEN DATE_DIFF(
                c.closed_date,
                c.created_date,
                DAY
            )
            ELSE NULL
        END AS days_to_close,

        c.latitude,
        c.longitude

    FROM complaints c

    LEFT JOIN {{ ref('dim_location_milestone4') }} l
        ON COALESCE(c.borough, 'UNSPECIFIED') = l.borough
        AND c.zip_code IS NOT DISTINCT FROM l.zip_code

    LEFT JOIN {{ ref('dim_complaint_type_milestone4') }} ct
        ON c.complaint_type IS NOT DISTINCT FROM ct.complaint_type
        AND c.descriptor IS NOT DISTINCT FROM ct.descriptor

    LEFT JOIN {{ ref('dim_complaint_status_milestone4') }} cs
        ON c.complaint_status = cs.complaint_status

    LEFT JOIN {{ ref('dim_date_milestone4') }} cd
        ON c.created_date = cd.full_date

    LEFT JOIN {{ ref('dim_date_milestone4') }} cld
        ON c.closed_date = cld.full_date

)

SELECT *
FROM final
