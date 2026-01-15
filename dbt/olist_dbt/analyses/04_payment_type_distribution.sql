-- FILE: 04_payment_type_distribution.sql
-- PURPOSE:
--   Summarize payment methods by count and total payment value.
--   Uses staging because payment is inherently event-level and already clean/cast there.
--
-- HOW TO RUN (recommended):
--   dbt show --select analysis:04_payment_type_distribution
--
-- EXPECTED RESULT:
--   - Several payment_type values (e.g., credit_card, boleto, voucher, debit_card, not_defined)
--   - total_payment_value numeric, descending
--   - payment_count > 0 for top categories

select
    payment_type,
    count(*) as payment_count,
    sum(payment_value) as total_payment_value
from {{ ref('stg_order_payments') }}
group by 1
order by total_payment_value desc