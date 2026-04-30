with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

joined as (
    select
        o.order_id,
        o.order_date,
        o.order_status,
        o.order_total,
        o.order_priority,
        c.customer_id,
        c.customer_name,
        c.market_segment,
        c.account_balance
    from orders o
    left join customers c on o.customer_id = c.customer_id
)

select * from joined