{{ config(
    materialized='table',
    alias='stg_shipments'
) }}

with source as (
    select * from {{ source('src', 'shipments') }}
),

typed as (
    select
        cast(shipment_id as string) as shipment_id,
        cast(po_id as string) as po_id,
        cast(shipment_date as date) as shipment_date,
        cast(quantity as integer) as quantity
    from source
)

select * from typed
