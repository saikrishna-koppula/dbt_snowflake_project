{{ config(
    materialized='view',
    alias='v_stg_suppliers'
) }}

with source as (
    select * from {{ source('src', 'suppliers') }}
),

renamed_and_typed as (
    select
        cast(supplier_id as varchar) as supplier_id,
        cast(supplier_name as varchar) as supplier_name,
        cast(contact_email as varchar) as contact_email,
        cast(phone as varchar) as phone,
        cast(address as varchar) as address
    from source
)

select * from renamed_and_typed
