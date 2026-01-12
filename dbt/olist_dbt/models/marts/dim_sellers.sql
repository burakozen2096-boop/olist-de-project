-- dim_sellers
-- Grain: 1 row per seller_id

with sellers as (
    select *
    from {{ ref('stg_sellers') }}
)

select
    md5(seller_id) as seller_key,
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
from sellers
where seller_id is not null