{{ config(
    materialized='view',
    alias='v_stg_invoices'
) }}

with source as (
    select * from {{ source('src', 'invoices') }}
),

typed as (
    select
        cast(invoice_id as string) as invoice_id,
        cast(po_id as string) as po_id,
        cast(invoice_date as date) as invoice_date,
        cast(due_date as date) as due_date,
        cast(amount_due as float) as amount_due
    from source
)

select * from typed
