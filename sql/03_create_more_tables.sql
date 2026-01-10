CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.order_payments;
CREATE TABLE raw.order_payments (
  order_id text,
  payment_sequential text,
  payment_type text,
  payment_installments text,
  payment_value text
);

DROP TABLE IF EXISTS raw.order_reviews;
CREATE TABLE raw.order_reviews (
  review_id text,
  order_id text,
  review_score text,
  review_comment_title text,
  review_comment_message text,
  review_creation_date text,
  review_answer_timestamp text
);

DROP TABLE IF EXISTS raw.products;
CREATE TABLE raw.products (
  product_id text,
  product_category_name text,
  product_name_lenght text,
  product_description_lenght text,
  product_photos_qty text,
  product_weight_g text,
  product_length_cm text,
  product_height_cm text,
  product_width_cm text
);

DROP TABLE IF EXISTS raw.sellers;
CREATE TABLE raw.sellers (
  seller_id text,
  seller_zip_code_prefix text,
  seller_city text,
  seller_state text
);

DROP TABLE IF EXISTS raw.geolocation;
CREATE TABLE raw.geolocation (
  geolocation_zip_code_prefix text,
  geolocation_lat text,
  geolocation_lng text,
  geolocation_city text,
  geolocation_state text
);

DROP TABLE IF EXISTS raw.product_category_name_translation;
CREATE TABLE raw.product_category_name_translation (
  product_category_name text,
  product_category_name_english text
);
