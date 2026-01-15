-- FILE: 03_delivery_delay_vs_review_score.sql
-- PURPOSE:
--   Compare average review score for late vs on-time deliveries.
--   Uses fct_orders which already contains aggregated review metrics.
--
-- HOW TO RUN (recommended):
--   dbt show --select analysis:03_delivery_delay_vs_review_score
--
-- EXPECTED RESULT:
--   - 2 rows: 'Late' and 'On time' (depending on data completeness)
--   - avg_review_score should typically be lower for 'Late'
--   - order_count > 0
--
-- NOTE:
--   This analysis requires delivered_customer_date and estimated_delivery_date to be present.

select
  delivery_status,
  avg_review_score,
  order_count
from (
    select
        case
            when o.order_delivered_customer_date is null
              or o.order_estimated_delivery_date is null
            then 'Unknown'
            when o.order_delivered_customer_date > o.order_estimated_delivery_date
            then 'Late'
            else 'On time'
        end as delivery_status,
        avg(o.avg_review_score) as avg_review_score,
        count(*) as order_count
    from {{ ref('fct_orders') }} o
    where o.order_status = 'delivered'
      and o.order_delivered_customer_date is not null
      and o.order_estimated_delivery_date is not null
    group by 1
) s
order by
  case s.delivery_status
    when 'On time' then 1
    when 'Late' then 2
    else 3
  end