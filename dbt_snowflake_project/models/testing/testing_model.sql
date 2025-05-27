-- models/staging/stg_test_model.sql
{{ config(materialized='table') }}

SELECT
    'test_value' AS sample_column,
    current_timestamp() AS loaded_at
