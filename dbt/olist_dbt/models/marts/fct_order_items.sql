-- fct_order_items
-- Grain: 1 row per (order_id, order_item_id)
-- BI keys:
--   - order_date_key joins dim_date
--   - seller_geography_key joins dim_geography (zip prefix level)

with items as (
    select *
    from {{ ref('stg_order_items') }}
),

orders as (
    select *
    from {{ ref('stg_orders') }}
),

sellers as (
    select *
    from {{ ref('stg_sellers') }}
),

final as (
    select
        i.order_id,
        i.order_item_id,

        -- surrogate keys
        md5(i.product_id) as product_key,
        md5(i.seller_id) as seller_key,
        md5(o.customer_id) as customer_key,

        -- date key (YYYYMMDD)
        (extract(year  from o.order_purchase_timestamp::date)::int * 10000
         + extract(month from o.order_purchase_timestamp::date)::int * 100
         + extract(day   from o.order_purchase_timestamp::date)::int) as order_purchase_date_key,

        -- seller geography key based on zip prefix (may be NULL if zip missing)
        md5(s.seller_zip_code_prefix) as seller_geography_key,

        -- natural ids for debugging
        i.product_id,
        i.seller_id,
        o.customer_id,

        o.order_purchase_timestamp,
        i.shipping_limit_date,

        i.price,
        i.freight_value,
        (i.price + coalesce(i.freight_value, 0)) as gross_item_value

    from items i
    left join orders o
      on i.order_id = o.order_id
    left join sellers s
      on i.seller_id = s.seller_id
)

select * from final
where order_id is not null