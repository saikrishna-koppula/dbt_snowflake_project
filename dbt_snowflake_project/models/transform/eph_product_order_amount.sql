{{ config(materialized='ephemeral') }}

select
    p.product_id,
    p.product_name,
    po.po_id,
    po.quantity * po.unit_price as expected_amount
from {{ ref('stg_products') }} p
join {{ ref('stg_purchase_orders') }} po
    on p.product_id = po.product_id
