
-- Create NYC 311 complaint status dimension for Group 4

WITH unique_complaint_statuses AS (

    SELECT DISTINCT
        complaint_status

    FROM {{ ref('stg_311_complaint') }}

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY complaint_status
    ) AS complaint_status_key,

    complaint_status

FROM unique_complaint_statuses
