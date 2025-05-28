import pandas as pd
import numpy as np
from faker import Faker
from uuid import uuid4
import random
from datetime import datetime, timedelta
import os

# Setup
fake = Faker()
Faker.seed(42)
np.random.seed(42)
random.seed(42)

# Output path
output_dir = "supply_chain_data"
os.makedirs(output_dir, exist_ok=True)

# Time range
end_date = datetime.today()
start_date = end_date - timedelta(days=730)

def random_date(start, end, n):
    return [fake.date_between(start_date=start, end_date=end) for _ in range(n)]

# Beverage brands and product types
brands = ["Keurig", "Dr Pepper", "7UP", "Snapple", "Bai", "Canada Dry", "Mott's", "Core", "Clamato", "Squirt"]
product_types = [
    "Coffee Pods", "Root Beer", "Soda", "Sparkling Water", "Juice", "Iced Tea", "Cold Brew", "Tonic Water", "Flavored Water"
]

# 1. Suppliers
supplier_count = 30
suppliers = pd.DataFrame({
    "supplier_id": [str(uuid4()) for _ in range(supplier_count)],
    "supplier_name": [f"{random.choice(brands)} Bottlers Inc." for _ in range(supplier_count)],
    "contact_email": [fake.company_email() for _ in range(supplier_count)],
    "phone": [fake.phone_number() for _ in range(supplier_count)],
    "address": [fake.address().replace("\n", ", ") for _ in range(supplier_count)],
})
suppliers.to_csv(f"{output_dir}/suppliers.csv", index=False)

# 2. Products
product_count = 100
products = pd.DataFrame({
    "product_id": [str(uuid4()) for _ in range(product_count)],
    "product_name": [f"{random.choice(brands)} {random.choice(product_types)}" for _ in range(product_count)],
    "category": [random.choice(['Beverage', 'Energy Drink', 'Diet Soda', 'Coffee']) for _ in range(product_count)],
    "unit_price": np.round(np.random.uniform(0.5, 5.0, product_count), 2)
})
products.to_csv(f"{output_dir}/products.csv", index=False)

# 3. Purchase Orders
po_count = 5000
purchase_orders = pd.DataFrame({
    "po_id": [str(uuid4()) for _ in range(po_count)],
    "supplier_id": np.random.choice(suppliers['supplier_id'], po_count),
    "order_date": random_date(start_date, end_date, po_count),
})
purchase_orders['product_id'] = np.random.choice(products['product_id'], po_count)
purchase_orders['quantity'] = np.random.randint(100, 10000, po_count)
purchase_orders = purchase_orders.merge(products[['product_id', 'unit_price']], on='product_id', how='left')
purchase_orders['total_amount'] = np.round(purchase_orders['quantity'] * purchase_orders['unit_price'], 2)
purchase_orders.to_csv(f"{output_dir}/purchase_orders.csv", index=False)

# 4. Shipments (95% of POs shipped)
shipment_count = int(po_count * 0.95)
shipment_df = purchase_orders.sample(n=shipment_count).copy()
shipment_df['shipment_id'] = [str(uuid4()) for _ in range(shipment_count)]
shipment_df['shipment_date'] = pd.to_datetime(shipment_df['order_date']) + pd.to_timedelta(np.random.randint(1, 15, shipment_count), unit='D')
shipment_df = shipment_df[['shipment_id', 'po_id', 'shipment_date', 'quantity']]
shipment_df.to_csv(f"{output_dir}/shipments.csv", index=False)

# 5. Invoices (all POs invoiced)
invoice_df = purchase_orders.copy().sample(frac=1.0).reset_index(drop=True)
invoice_df['invoice_id'] = [str(uuid4()) for _ in range(len(invoice_df))]
invoice_df['invoice_date'] = pd.to_datetime(invoice_df['order_date']) + pd.to_timedelta(np.random.randint(2, 10, len(invoice_df)), unit='D')
invoice_df['due_date'] = invoice_df['invoice_date'] + pd.to_timedelta(30, unit='D')
invoice_df.rename(columns={'total_amount': 'amount_due'}, inplace=True)
invoice_df = invoice_df[['invoice_id', 'po_id', 'invoice_date', 'due_date', 'amount_due']]
invoice_df.to_csv(f"{output_dir}/invoices.csv", index=False)

# 6. Payments (90% of invoices paid)
payment_count = int(len(invoice_df) * 0.9)
payments_df = invoice_df.sample(n=payment_count).copy()
payments_df['payment_id'] = [str(uuid4()) for _ in range(payment_count)]
payments_df['payment_date'] = pd.to_datetime(payments_df['invoice_date']) + pd.to_timedelta(np.random.randint(1, 30, payment_count), unit='D')
payments_df['paid_amount'] = np.round(payments_df['amount_due'] * np.random.uniform(0.9, 1.0, payment_count), 2)
payments_df = payments_df[['payment_id', 'invoice_id', 'payment_date', 'paid_amount']]
payments_df.to_csv(f"{output_dir}/payments.csv", index=False)

print(f"✅ Beverage data generation complete. Files saved in: {output_dir}")