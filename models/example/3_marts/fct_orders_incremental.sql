{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

with orders as (
    select * from {{ ref('int_orders_customers') }}
)

select
    order_id,
    order_date,
    order_status,
    order_total,
    order_priority,
    customer_id,
    customer_name,
    market_segment

from orders

{% if is_incremental() %}
    where order_date > (select max(order_date) from {{ this }})
{% endif %}