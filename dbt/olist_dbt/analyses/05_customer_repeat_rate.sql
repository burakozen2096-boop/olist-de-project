select
    case
        when order_count = 1 then 'Single-order'
        else 'Repeat'
    end as customer_type,
    count(*) as customer_count
from (
    select
        customer_key,
        count(*) as order_count
    from {{ ref('fct_orders') }}
    group by customer_key
) t
group by 1
order by customer_type