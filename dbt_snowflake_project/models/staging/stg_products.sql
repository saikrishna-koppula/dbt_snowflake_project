{{ config(
    materialized='view',
    alias='v_stg_products'
) }}

with source as (
    select * from {{ source('src', 'products') }}
),

typed as (
    select
        cast(product_id as string) as product_id,
        cast(product_name as string) as product_name,
        cast(category as string) as category,
        cast(unit_price as float) as unit_price
    from source
)

select * from typed
