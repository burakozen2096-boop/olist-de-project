-- FILE: 02_top_categories_by_revenue.sql
-- PURPOSE:
--   Identify top product categories by gross_item_value (price + freight) using marts join.
--   Demonstrates correct joins: fct_order_items -> dim_products.
--
-- HOW TO RUN (recommended):
--   dbt show --select 02_top_categories_by_revenue
--
-- EXPECTED RESULT:
--   - 10 rows
--   - total_revenue should be numeric and descending
--   - category should be mostly non-null (some may be null if category translation missing)
select
    coalesce(p.product_category_name_en, p.product_category_name, 'unknown') as category,
    sum(oi.gross_item_value) as total_revenue
from {{ ref('fct_order_items') }} oi
join {{ ref('dim_products') }} p
  on oi.product_key = p.product_key
group by 1
order by total_revenue desc