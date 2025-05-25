{{ config(
    materialized='view',
    alias='v_stg_payments'
) }}

with source as (
    select * from {{ source('src', 'payments') }}
),

typed as (
    select
        cast(payment_id as string) as payment_id,
        cast(invoice_id as string) as invoice_id,
        cast(payment_date as date) as payment_date,
        cast(paid_amount as float) as paid_amount
    from source
)

select * from typed
