-- stg_product_category_name_translation
-- Purpose:
--   - Read raw.product_category_name_translation via source()
--   - Standardize empty strings -> NULL
-- Grain:
--   - 1 row per product_category_name (mapping table)

with src as (
    select * from {{ source('raw', 'product_category_name_translation') }}
),

cleaned as (
    select
        nullif(product_category_name, '') as product_category_name,
        nullif(product_category_name_english, '') as product_category_name_english
    from src
)

select * from cleaned