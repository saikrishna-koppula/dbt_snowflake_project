{{ config(materialized='view', alias='v_fct_pending_payments') }}

with lifecycle as (
    select * from {{ ref('fct_order_lifecycle') }}
)

select
    PO_ID,
    ORDER_DATE,
    SUPPLIER_ID,
    PRODUCT_ID,
    SHIPMENT_ID,
    SHIPMENT_DATE,
    INVOICE_ID,
    INVOICE_DATE,
    DUE_DATE,
    PAYMENT_ID,
    PAYMENT_DATE,
    QUANTITY,
    UNIT_PRICE,
    TOTAL_AMOUNT,
    EXPECTED_AMOUNT,
    PAID_AMOUNT,
    (EXPECTED_AMOUNT - coalesce(PAID_AMOUNT, 0)) as amount_pending
from lifecycle
where PAID_AMOUNT is null or PAID_AMOUNT < EXPECTED_AMOUNT
