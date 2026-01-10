COPY raw.order_payments
FROM '/data/raw/olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

COPY raw.order_reviews
FROM '/data/raw/olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

COPY raw.products
FROM '/data/raw/olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

COPY raw.sellers
FROM '/data/raw/olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

COPY raw.geolocation
FROM '/data/raw/olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

COPY raw.product_category_name_translation
FROM '/data/raw/product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');
