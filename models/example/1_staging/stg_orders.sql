with source as (
    select * from {{ source('tpch', 'ORDERS') }}
),

renamed as (
    select
        O_ORDERKEY      as order_id,
        O_CUSTKEY       as customer_id,
        O_ORDERSTATUS   as order_status,
        O_TOTALPRICE    as order_total,
        O_ORDERDATE     as order_date,
        O_ORDERPRIORITY as order_priority,
        O_CLERK         as clerk,
        O_COMMENT       as order_comment
    from source
)

select * from renamed