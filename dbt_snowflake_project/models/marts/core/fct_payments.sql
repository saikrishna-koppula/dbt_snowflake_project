{{ config(materialized='view', alias='v_fct_payments') }}

select
    pay.payment_id,
    pay.invoice_id,
    inv.invoice_date,
    pay.payment_date,
    cast(pay.paid_amount as numeric) as paid_amount
from {{ ref('stg_payments') }} pay
left join {{ ref('stg_invoices') }} inv on pay.invoice_id = inv.invoice_id
