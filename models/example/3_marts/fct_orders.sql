with orders as (
    select * from {{ ref('int_orders_customers') }}
),

final as (
    select
        order_id,
        order_date,
        order_status,
        order_priority,
        order_total,
        customer_id,
        customer_name,
        market_segment,
        account_balance,

        -- business-friendly labels (useful for Looker/dashboards)
        case
            when order_status = 'F' then 'Fulfilled'
            when order_status = 'O' then 'Open'
            when order_status = 'P' then 'Pending'
            else 'Unknown'
        end as order_status_label,

        case
            when order_total >= 200000 then 'High Value'
            when order_total >= 100000 then 'Mid Value'
            else 'Standard'
        end as order_value_tier,

        -- date parts useful for finance reporting
        date_trunc('month', order_date) as order_month,
        date_trunc('quarter', order_date) as order_quarter,
        year(order_date) as order_year

    from orders
)

select * from final