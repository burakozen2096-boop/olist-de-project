-- dim_geography
-- Grain: 1 row per zip_code_prefix
-- Purpose:
--   - Provide a conformed geography dimension for customers/sellers joins.

with geo as (
    select *
    from {{ ref('int_geolocation_zip_prefix') }}
)

select
    md5(geolocation_zip_code_prefix) as geography_key,
    geolocation_zip_code_prefix as zip_code_prefix,
    geolocation_city as city,
    geolocation_state as state,
    geolocation_lat as lat,
    geolocation_lng as lng
from geo
where geolocation_zip_code_prefix is not null