
-- Create shared date dimension for DOB permits and NYC 311 complaints

WITH all_dates AS (

    SELECT filing_date AS full_date
    FROM {{ ref('stg_dob_permit') }}

    UNION DISTINCT

    SELECT issuance_date AS full_date
    FROM {{ ref('stg_dob_permit') }}

    UNION DISTINCT

    SELECT expiration_date AS full_date
    FROM {{ ref('stg_dob_permit') }}

    UNION DISTINCT

    SELECT created_date AS full_date
    FROM {{ ref('stg_311_complaint') }}

    UNION DISTINCT

    SELECT closed_date AS full_date
    FROM {{ ref('stg_311_complaint') }}

),

unique_dates AS (

    SELECT DISTINCT full_date
    FROM all_dates
    WHERE full_date IS NOT NULL

)

SELECT
    CAST(FORMAT_DATE('%Y%m%d', full_date) AS INT64) AS date_key,
    full_date,
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    EXTRACT(MONTH FROM full_date) AS month,
    FORMAT_DATE('%B', full_date) AS month_name,
    EXTRACT(DAYOFWEEK FROM full_date) AS day_of_week,
    EXTRACT(DAY FROM full_date) AS day_of_month,
    FORMAT_DATE('%A', full_date) AS day_name,
    EXTRACT(DAYOFWEEK FROM full_date) IN (1, 7) AS is_weekend,
    EXTRACT(YEAR FROM full_date) AS fiscal_year

FROM unique_dates
