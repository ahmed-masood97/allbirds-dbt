{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

with orders as (
    select * from {{ ref('int_orders_customers') }}
),

final as (
    select
        order_id,
        order_date,
        order_status,
        order_total,
        order_priority,
        customer_id,
        customer_name,
        market_segment,

        case
            when order_status = 'F' then 'Fulfilled'
            when order_status = 'O' then 'Open'
            when order_status = 'P' then 'Pending'
            else 'Unknown'
        end as order_status_label,

        date_trunc('month', order_date) as order_month,
        date_trunc('quarter', order_date) as order_quarter,
        year(order_date) as order_year

    from orders

    {% if is_incremental() %}
        where order_date > (select max(order_date) from {{ this }})
    {% endif %}
)

select * from final