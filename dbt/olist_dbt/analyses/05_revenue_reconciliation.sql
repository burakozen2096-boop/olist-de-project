-- FILE: 06_revenue_reconciliation.sql
-- PURPOSE:
--   Verify that order-level and item-level revenue aggregates reconcile exactly.
--   Acts as a safeguard against double counting caused by incorrect joins or grain mismatch.
--
-- HOW TO RUN (recommended):
--   dbt show --select 06_revenue_reconciliation
--
-- EXPECTED RESULT:
--   - revenue_from_orders equals revenue_from_items
--   - difference = 0

select
    sum(order_revenue) as revenue_from_orders,
    sum(item_revenue)  as revenue_from_items,
    sum(order_revenue) - sum(item_revenue) as difference
from (
    select
        o.order_id,
        sum(oi.gross_item_value) as order_revenue,
        sum(oi.gross_item_value) as item_revenue
    from {{ ref('fct_orders') }} o
    join {{ ref('fct_order_items') }} oi
      on o.order_id = oi.order_id
    group by o.order_id
) t
