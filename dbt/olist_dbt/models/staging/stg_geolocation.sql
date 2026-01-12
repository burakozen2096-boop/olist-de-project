-- stg_geolocation
-- Purpose:
--   - Read raw.geolocation via source()
--   - Standardize empty strings -> NULL
--   - Cast latitude/longitude to numeric
-- Note:
--   - Olist geolocation is NOT unique per zip prefix (many rows).
--   - We'll decide later how to aggregate/dedupe for a dimension.
-- Grain:
--   - 1 row per raw record (no natural key)

with src as (
    select * from {{ source('raw', 'geolocation') }}
),

cleaned as (
    select
        nullif(geolocation_zip_code_prefix, '') as geolocation_zip_code_prefix,
        nullif(geolocation_lat, '')::numeric as geolocation_lat,
        nullif(geolocation_lng, '')::numeric as geolocation_lng,
        nullif(trim(geolocation_city), '') as geolocation_city,
        nullif(trim(geolocation_state), '') as geolocation_state
    from src
)

select * from cleaned