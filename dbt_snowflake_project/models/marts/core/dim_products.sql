{{ config(materialized='table', alias='dim_products') }}

select
    product_id,
    product_name,
    category,
    cast(unit_price as numeric) as unit_price
from {{ ref('stg_products') }}
