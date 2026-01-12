-- stg_sellers
-- Purpose:
--   - Read raw.sellers via source()
--   - Standardize location fields (trim, empty -> NULL)
-- Grain:
--   - 1 row per seller_id

with src as (
    select * from {{ source('raw', 'sellers') }}
),

cleaned as (
    select
        nullif(seller_id, '') as seller_id,
        nullif(seller_zip_code_prefix, '') as seller_zip_code_prefix,
        nullif(trim(seller_city), '') as seller_city,
        nullif(trim(seller_state), '') as seller_state
    from src
)

select * from cleaned