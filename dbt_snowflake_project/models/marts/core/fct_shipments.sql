{{ config(materialized='view', alias='v_fct_shipments') }}

select
    sh.shipment_id,
    sh.po_id,
    po.order_date,
    sh.shipment_date,
    cast(sh.quantity as integer) as shipped_quantity
from {{ ref('stg_shipments') }} sh
left join {{ ref('stg_purchase_orders') }} po on sh.po_id = po.po_id
