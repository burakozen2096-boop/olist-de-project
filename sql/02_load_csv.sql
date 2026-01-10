COPY raw.orders
FROM '/data/raw/olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

COPY raw.customers
FROM '/data/raw/olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

COPY raw.order_items
FROM '/data/raw/olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');
