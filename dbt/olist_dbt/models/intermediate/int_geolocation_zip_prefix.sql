-- int_geolocation_zip_prefix
-- Grain: 1 row per geolocation_zip_code_prefix
-- Purpose:
--   - Geolocation source has multiple rows per zip prefix.
--   - Aggregate to a single representative row for dimensional joins.

with geo as (
    select *
    from {{ ref('stg_geolocation') }}
    where geolocation_zip_code_prefix is not null
),

-- average lat/lng per zip prefix (stable enough for demo/BI mapping)
agg_latlng as (
    select
        geolocation_zip_code_prefix,
        avg(geolocation_lat) as avg_lat,
        avg(geolocation_lng) as avg_lng
    from geo
    where geolocation_lat is not null
      and geolocation_lng is not null
    group by 1
),

-- choose the most frequent city/state per zip prefix
ranked_city_state as (
    select
        geolocation_zip_code_prefix,
        geolocation_city,
        geolocation_state,
        count(*) as cnt,
        row_number() over (
            partition by geolocation_zip_code_prefix
            order by count(*) desc, geolocation_city asc, geolocation_state asc
        ) as rn
    from geo
    where geolocation_city is not null
      and geolocation_state is not null
    group by 1, 2, 3
),

top_city_state as (
    select
        geolocation_zip_code_prefix,
        geolocation_city,
        geolocation_state
    from ranked_city_state
    where rn = 1
)

select
    a.geolocation_zip_code_prefix,
    a.avg_lat as geolocation_lat,
    a.avg_lng as geolocation_lng,
    t.geolocation_city,
    t.geolocation_state
from agg_latlng a
left join top_city_state t
  on a.geolocation_zip_code_prefix = t.geolocation_zip_code_prefix