-- stg_order_reviews
-- Purpose:
--   - Read raw.order_reviews via source()
--   - Standardize empty strings -> NULL
--   - Cast score to int and timestamps to timestamp
-- Grain:
--   - 1 row per review_id (Olist data model)

with src as (
    select * from {{ source('raw', 'order_reviews') }}
),

cleaned as (
    select
        nullif(review_id, '') as review_id,
        nullif(order_id, '') as order_id,

        nullif(review_score, '')::int as review_score,
        nullif(trim(review_comment_title), '') as review_comment_title,
        nullif(trim(review_comment_message), '') as review_comment_message,

        nullif(review_creation_date, '')::timestamp as review_creation_date,
        nullif(review_answer_timestamp, '')::timestamp as review_answer_timestamp
    from src
)

select * from cleaned