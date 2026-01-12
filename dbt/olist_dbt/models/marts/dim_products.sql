-- dim_products
-- Grain: 1 row per product_id
-- Joins PT category to EN translation.

with products as (
    select *
    from {{ ref('stg_products') }}
),

cat as (
    select *
    from {{ ref('stg_product_category_name_translation') }}
)

select
    md5(p.product_id) as product_key,

    p.product_id,
    p.product_category_name,
    c.product_category_name_english as product_category_name_en,

    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,

    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

from products p
left join cat c
  on p.product_category_name = c.product_category_name
where p.product_id is not null