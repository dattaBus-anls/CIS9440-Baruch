
-- Create DOB permit fact table for Group 4

WITH permits AS (

    SELECT *
    FROM {{ ref('stg_dob_permit') }}

),

final AS (

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY p.permit_si_no
        ) AS dob_permit_key,

        p.permit_si_no,

        l.location_key,
        pt.permit_type_key,
        ps.permit_status_key,
        prop.property_type_key,
        ot.owner_type_key,

        fd.date_key AS filing_date_key,
        id.date_key AS issuance_date_key,
        ed.date_key AS expiration_date_key,

        p.job_number,
        p.job_doc_number,
        p.permit_sequence,
        p.bin_number,
        p.bbl,

        DATE_DIFF(
            p.expiration_date,
            p.issuance_date,
            DAY
        ) AS permit_duration_days,

        1 AS permit_count

    FROM permits p

    LEFT JOIN {{ ref('dim_location_milestone4') }} l
        ON COALESCE(p.borough, 'UNSPECIFIED') = l.borough
        AND p.zip_code IS NOT DISTINCT FROM l.zip_code

    LEFT JOIN {{ ref('dim_permit_type_milestone4') }} pt
        ON p.job_type IS NOT DISTINCT FROM pt.job_type
        AND p.permit_type IS NOT DISTINCT FROM pt.permit_type
        AND p.permit_subtype IS NOT DISTINCT FROM pt.permit_subtype

    LEFT JOIN {{ ref('dim_permit_status_milestone4') }} ps
        ON p.filing_status IS NOT DISTINCT FROM ps.filing_status
        AND p.permit_status IS NOT DISTINCT FROM ps.permit_status

    LEFT JOIN {{ ref('dim_property_type_milestone4') }} prop
        ON p.bldg_type IS NOT DISTINCT FROM prop.bldg_type
        AND p.residential IS NOT DISTINCT FROM prop.residential

    LEFT JOIN {{ ref('dim_owner_type_milestone4') }} ot
        ON p.owner_business_type IS NOT DISTINCT FROM ot.owner_business_type
        AND p.non_profit IS NOT DISTINCT FROM ot.non_profit

    LEFT JOIN {{ ref('dim_date_milestone4') }} fd
        ON p.filing_date = fd.full_date

    LEFT JOIN {{ ref('dim_date_milestone4') }} id
        ON p.issuance_date = id.full_date

    LEFT JOIN {{ ref('dim_date_milestone4') }} ed
        ON p.expiration_date = ed.full_date

)

SELECT *
FROM final
