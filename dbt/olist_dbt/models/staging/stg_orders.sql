-- stg_orders
-- Purpose:
--   - Read raw.orders via dbt source()
--   - Standardize strings (trim, empty -> NULL)
--   - Cast timestamp-like text columns to timestamp
-- Grain:
--   - 1 row per order_id (order-level)

with src as (
    -- Pull from raw layer (declared in models/raw/_sources.yml)
    select * from {{ source('raw', 'orders') }}
),

cleaned as (
    select
        -- Business keys: keep as-is but normalize empty strings to NULL
        nullif(order_id, '') as order_id,
        nullif(customer_id, '') as customer_id,

        -- Text standardization: trim whitespace, convert empty to NULL
        nullif(trim(order_status), '') as order_status,

        -- Type casting: raw stores everything as text; convert to timestamp in staging
        nullif(order_purchase_timestamp, '')::timestamp as order_purchase_timestamp,
        nullif(order_approved_at, '')::timestamp as order_approved_at,
        nullif(order_delivered_carrier_date, '')::timestamp as order_delivered_carrier_date,
        nullif(order_delivered_customer_date, '')::timestamp as order_delivered_customer_date,
        nullif(order_estimated_delivery_date, '')::timestamp as order_estimated_delivery_date

    from src
)

-- Final select keeps the model readable and makes lineage clear
select * from cleaned
