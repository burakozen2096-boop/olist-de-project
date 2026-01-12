-- stg_customers
-- Purpose:
--   - Read raw.customers via dbt source()
--   - Standardize text fields (trim, empty -> NULL)
-- Grain:
--   - 1 row per customer_id

with src as (
    -- Pull from raw layer (declared in models/raw/_sources.yml)
    select * from {{ source('raw', 'customers') }}
),

cleaned as (
    select
        -- Business keys: normalize empty strings to NULL
        nullif(customer_id, '') as customer_id,
        nullif(customer_unique_id, '') as customer_unique_id,

        -- Zip prefix kept as text in staging too (often used as join/group key)
        nullif(customer_zip_code_prefix, '') as customer_zip_code_prefix,

        -- City/state: trim whitespace, convert empty to NULL
        nullif(trim(customer_city), '') as customer_city,
        nullif(trim(customer_state), '') as customer_state
    from src
)

select * from cleaned
