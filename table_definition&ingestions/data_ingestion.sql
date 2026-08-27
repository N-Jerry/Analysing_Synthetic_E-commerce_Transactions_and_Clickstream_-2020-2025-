-- Run this script from the project root directory in psql.
--  psql -U <database_user> -d <databse_name> -f <script_path_to_run
--  For example: psql -U postgres -d "E-commerce_Transactions_Clickstream" -f "table_definition&ingestions/data_ingestion.sql"
-- \copy reads files on the client machine and uses PostgreSQL COPY internally.

\copy customers (customer_id, name, email, country, age, signup_date, marketing_opt_in) FROM 'dataset/customers.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy products (product_id, category, name, price_usd, cost_usd, margin_usd) FROM 'dataset/products.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy sessions (session_id, customer_id, start_time, device, source, country) FROM 'dataset/sessions.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy orders (order_id, customer_id, order_time, payment_method, discount_pct, subtotal_usd, total_usd, country, device, source) FROM 'dataset/orders.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy order_items (order_id, product_id, unit_price_usd, quantity, line_total_usd) FROM 'dataset/order_items.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy reviews (review_id, order_id, product_id, rating, review_text, review_time) FROM 'dataset/reviews.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy events (event_id, session_id, "timestamp", event_type, product_id, qty, cart_size, payment, discount_pct, amount_usd) FROM 'dataset/events.csv' WITH (FORMAT csv, HEADER true, NULL '')
