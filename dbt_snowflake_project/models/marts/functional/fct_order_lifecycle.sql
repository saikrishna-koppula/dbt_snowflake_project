{{ config(
    materialized = 'table',
    alias = 'fct_order_lifecycle'
) }}

with po as (
    select * from {{ ref('stg_purchase_orders') }}
),
ship as (
    select * from {{ ref('stg_shipments') }}
),
inv as (
    select * from {{ ref('stg_invoices') }}
),
pay as (
    select * from {{ ref('fct_payments') }}
),
product_expected as (
    select * from {{ ref('eph_product_order_amount') }}
)

select
    po.po_id,
    po.order_date,
    po.supplier_id,
    po.product_id,
    ship.shipment_id,
    ship.shipment_date,
    inv.invoice_id,
    inv.invoice_date,
    inv.due_date,
    pay.payment_id,
    pay.payment_date,
    po.quantity,
    po.unit_price,
    po.total_amount,
    product_expected.expected_amount,
    pay.paid_amount
from po
left join ship on po.po_id = ship.po_id
left join inv on po.po_id = inv.po_id
left join pay on inv.invoice_id = pay.invoice_id
left join product_expected 
    on po.po_id = product_expected.po_id
   and po.product_id = product_expected.product_id
