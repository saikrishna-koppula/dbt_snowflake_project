{{ config(
    materialized = 'incremental',
    unique_key = 'payment_id',
    alias = 'fct_payments',
    on_schema_change = 'append_new_columns'
) }}

with payments as (
    select
        cast(payment_id as string) as payment_id,
        cast(invoice_id as string) as invoice_id,
        try_to_date(payment_date) as payment_date,
        cast(paid_amount as number(10,2)) as paid_amount
    from {{ ref('stg_payments') }}
    {% if is_incremental() %}
      where try_to_date(payment_date) > (select max(payment_date) from {{ this }})
    {% endif %}
),

invoices as (
    select
        invoice_id,
        try_to_date(invoice_date) as invoice_date
    from {{ ref('stg_invoices') }}
)

select
    pay.payment_id,
    pay.invoice_id,
    inv.invoice_date,
    pay.payment_date,
    pay.paid_amount
from payments pay
left join invoices inv
    on pay.invoice_id = inv.invoice_id
