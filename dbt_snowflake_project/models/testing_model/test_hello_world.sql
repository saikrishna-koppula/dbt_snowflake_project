{{ config(
    materialized = 'view'
) }}

SELECT
    'Hello, dbt Cloud!' AS message,
    CURRENT_TIMESTAMP AS generated_at