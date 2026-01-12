-- dim_date
-- Grain: 1 row per day
-- Purpose:
--   - Provide a canonical date dimension for BI and time-based analysis.
--   - Built from min/max order_purchase_timestamp in stg_orders.

with bounds as (
    select
        min(order_purchase_timestamp::date) as min_date,
        max(order_purchase_timestamp::date) as max_date
    from {{ ref('stg_orders') }}
    where order_purchase_timestamp is not null
),

dates as (
    select
        generate_series(min_date, max_date, interval '1 day')::date as date_day
    from bounds
)

select
    -- common BI-friendly surrogate key (YYYYMMDD)
    (extract(year  from date_day)::int * 10000
     + extract(month from date_day)::int * 100
     + extract(day   from date_day)::int) as date_key,

    date_day,

    extract(year from date_day)::int  as year,
    extract(quarter from date_day)::int as quarter,
    extract(month from date_day)::int as month,
    extract(day from date_day)::int   as day,

    -- ISO day of week: 1=Mon ... 7=Sun
    extract(isodow from date_day)::int as iso_day_of_week,

    btrim(to_char(date_day, 'Day')) as day_name,
    btrim(to_char(date_day, 'Month')) as month_name,
    to_char(date_day, 'Mon') as month_name_short,

    
    (extract(isodow from date_day)::int in (6, 7)) as is_weekend,

    date_trunc('week', date_day)::date  as week_start_date,
    date_trunc('month', date_day)::date as month_start_date

from dates
order by date_day