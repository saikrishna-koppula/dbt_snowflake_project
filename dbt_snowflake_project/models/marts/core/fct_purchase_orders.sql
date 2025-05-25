{{ config(materialized='view', alias='v_fct_purchase_orders') }}

select
    po.po_id,
    po.order_date,
    po.supplier_id,
    s.supplier_name,
    po.product_id,
    p.product_name,
    p.category,
    cast(po.quantity as integer) as quantity,
    cast(po.unit_price as numeric) as unit_price,
    cast(po.total_amount as numeric) as total_amount
from {{ ref('stg_purchase_orders') }} po
left join {{ ref('stg_suppliers') }} s on po.supplier_id = s.supplier_id
left join {{ ref('stg_products') }} p on po.product_id = p.product_id
