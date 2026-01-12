-- dim_customers
-- Grain: 1 row per customer_id
-- Note: Starting as SCD1-style dimension. (SCD2 can be added later if needed.)

with customers as (
    select *
    from {{ ref('stg_customers') }}
)

select
    -- surrogate key (stable within project)
    md5(customer_id) as customer_key,

    -- natural keys
    customer_id,
    customer_unique_id,

    -- attributes
    customer_zip_code_prefix,
    customer_city,
    customer_state

from customers
where customer_id is not null