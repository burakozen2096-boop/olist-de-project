-- stg_order_payments
-- Purpose:
--   - Read raw.order_payments via source()
--   - Standardize empty strings -> NULL
--   - Cast numeric fields to int/numeric
-- Grain:
--   - 1 row per (order_id, payment_sequential)

with src as (
    select * from {{ source('raw', 'order_payments') }}
),

cleaned as (
    select
        nullif(order_id, '') as order_id,
        nullif(payment_sequential, '')::int as payment_sequential,
        nullif(trim(payment_type), '') as payment_type,
        nullif(payment_installments, '')::int as payment_installments,
        nullif(payment_value, '')::numeric as payment_value
    from src
)

select * from cleaned