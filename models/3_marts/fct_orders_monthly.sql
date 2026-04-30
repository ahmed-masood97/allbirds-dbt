with orders as (
    select * from {{ ref('fct_orders') }}
),

monthly_summary as (
    select
        order_month,
        order_year,
        market_segment,
        order_status_label,
        order_value_tier,

        -- volume metrics
        count(distinct order_id)                                    as total_orders,
        count(distinct customer_id)                                 as unique_customers,

        -- revenue metrics
        sum(order_total)                                            as total_revenue,
        avg(order_total)                                            as avg_order_value,
        min(order_total)                                            as min_order_value,
        max(order_total)                                            as max_order_value,

        -- mix metrics
        count(case when order_value_tier = 'High Value' then 1 end) as high_value_orders,
        count(case when order_value_tier = 'Mid Value' then 1 end)  as mid_value_orders,
        count(case when order_value_tier = 'Standard' then 1 end)   as standard_orders

    from orders
    group by 1, 2, 3, 4, 5
)

select * from monthly_summary