-- fct_orders
-- Grain: 1 row per order_id
-- Includes payment and review aggregates.
-- BI keys:
--   - order_date_key joins dim_date
--   - customer_geography_key joins dim_geography (zip prefix level)

with orders as (
    select *
    from {{ ref('stg_orders') }}
),

customers as (
    select *
    from {{ ref('stg_customers') }}
),

payments as (
    select
        order_id,
        sum(coalesce(payment_value, 0)) as total_payment_value,
        max(payment_installments) as max_installments
    from {{ ref('stg_order_payments') }}
    group by 1
),

reviews as (
    select
        order_id,
        avg(review_score)::numeric(10,2) as avg_review_score,
        count(*) as review_count,
        max(review_creation_date) as last_review_creation_date
    from {{ ref('stg_order_reviews') }}
    group by 1
)

select
    o.order_id,

    -- conformed customer key
    md5(o.customer_id) as customer_key,
    o.customer_id,

    -- date dimension key (YYYYMMDD)
    (extract(year  from o.order_purchase_timestamp::date)::int * 10000
     + extract(month from o.order_purchase_timestamp::date)::int * 100
     + extract(day   from o.order_purchase_timestamp::date)::int) as order_purchase_date_key,

    -- customer geography key based on zip prefix (may be NULL if zip missing)
    md5(c.customer_zip_code_prefix) as customer_geography_key,

    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    p.total_payment_value,
    p.max_installments,

    r.avg_review_score,
    r.review_count,
    r.last_review_creation_date

from orders o
left join customers c
  on o.customer_id = c.customer_id
left join payments p
  on o.order_id = p.order_id
left join reviews r
  on o.order_id = r.order_id
where o.order_id is not null