{{ config(
    materialized='table',
    alias='stg_purchase_orders'
) }}

with source as (
    select * from {{ source('src', 'purchase_orders') }}
),

typed as (
    select
        cast(po_id as string) as po_id,
        cast(supplier_id as string) as supplier_id,
        cast(product_id as string) as product_id,
        cast(order_date as date) as order_date,
        cast(quantity as integer) as quantity,
        cast(unit_price as float) as unit_price,
        cast(total_amount as float) as total_amount
    from source
)

select * from typed