-- snapshots/products/snapshot_products.sql

{% snapshot snapshot_products %}
{{
    config(
        target_schema='snapshots',
        unique_key='product_id',
        strategy='check',
        check_cols=['product_name', 'category', 'unit_price']
    )
}}

select * from {{ source('src', 'products') }}

{% endsnapshot %}
