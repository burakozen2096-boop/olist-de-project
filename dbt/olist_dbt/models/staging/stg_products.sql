-- stg_products
-- Purpose:
--   - Read raw.products via source()
--   - Fix known source typos (*_lenght -> *_length)
--   - Cast numeric columns to int/numeric
-- Grain:
--   - 1 row per product_id

with src as (
    select * from {{ source('raw', 'products') }}
),

cleaned as (
    select
        -- Key
        nullif(product_id, '') as product_id,

        -- Category name (kept as text; translation join later)
        nullif(product_category_name, '') as product_category_name,

        -- Source typo fix: lenght -> length
        nullif(product_name_lenght, '')::int as product_name_length,
        nullif(product_description_lenght, '')::int as product_description_length,

        -- Quantities / measures
        nullif(product_photos_qty, '')::int as product_photos_qty,
        nullif(product_weight_g, '')::numeric as product_weight_g,
        nullif(product_length_cm, '')::numeric as product_length_cm,
        nullif(product_height_cm, '')::numeric as product_height_cm,
        nullif(product_width_cm, '')::numeric as product_width_cm

    from src
)

select * from cleaned
