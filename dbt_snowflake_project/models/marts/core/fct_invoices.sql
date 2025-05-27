{{ config(materialized='table', alias='fct_invoices') }}

select
    inv.invoice_id,
    inv.po_id,
    po.order_date,
    inv.invoice_date,
    inv.due_date,
    cast(inv.amount_due as numeric) as amount_due
from {{ ref('stg_invoices') }} inv
left join {{ ref('stg_purchase_orders') }} po on inv.po_id = po.po_id
