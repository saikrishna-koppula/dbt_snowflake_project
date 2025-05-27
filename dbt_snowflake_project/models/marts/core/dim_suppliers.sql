{{ config(materialized='table', alias='dim_suppliers') }}

select
    supplier_id,
    supplier_name,
    contact_email,
    phone,
    address
from {{ ref('stg_suppliers') }}