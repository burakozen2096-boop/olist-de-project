-- stg_order_items
-- Purpose:
--   - Read raw.order_items via source()
--   - Standardize empty strings -> NULL
--   - Cast numeric fields (price, freight_value) to numeric
--   - Cast shipping_limit_date to timestamp
-- Grain:
--   - 1 row per (order_id, order_item_id)

with src as (
    select * from {{ source('raw', 'order_items') }}
),

cleaned as (
    select
        -- Keys
        nullif(order_id, '') as order_id,
        nullif(order_item_id, '')::int as order_item_id,
        nullif(product_id, '') as product_id,
        nullif(seller_id, '') as seller_id,

        -- Dates
        nullif(shipping_limit_date, '')::timestamp as shipping_limit_date,

        -- Numerics (raw is text)
        nullif(price, '')::numeric as price,
        nullif(freight_value, '')::numeric as freight_value

    from src
)

select * from cleaned
