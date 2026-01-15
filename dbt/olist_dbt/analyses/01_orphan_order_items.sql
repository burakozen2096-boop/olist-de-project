-- FILE: 01_orphan_order_items.sql
-- PURPOSE:
--   Sanity check: Ensure fct_order_items rows always have a matching order in fct_orders.
--   This validates referential integrity between facts at order_id level.
--
-- HOW TO RUN (recommended):
--   dbt show --select 01_orphan_order_items
--
-- EXPECTED RESULT:
--   orphan_order_items = 0

select
    count(*) as orphan_order_items
from {{ ref('fct_order_items') }} oi
left join {{ ref('fct_orders') }} o
  on oi.order_id = o.order_id
where o.order_id is null
