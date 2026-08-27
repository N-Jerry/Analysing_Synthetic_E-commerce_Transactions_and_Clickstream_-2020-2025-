DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE IF NOT EXISTS customers (
	customer_id INTEGER PRIMARY KEY,
	name TEXT NOT NULL,
	email TEXT NOT NULL UNIQUE,
	country CHAR(2),
	age SMALLINT,
	signup_date DATE,
	receives_promos BOOLEAN
);

CREATE TABLE IF NOT EXISTS products (
	product_id NUMERIC(10, 0) PRIMARY KEY,
	category TEXT NOT NULL,
	name TEXT NOT NULL,
	price NUMERIC(12, 2) NOT NULL,
	cost NUMERIC(12, 2) NOT NULL,
	margin NUMERIC(12, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
	session_id INTEGER PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	start_time TIMESTAMPTZ NOT NULL,
	device TEXT,
	source TEXT,
	country CHAR(2),
	CONSTRAINT fk_sessions_customer
		FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE TABLE IF NOT EXISTS orders (
	order_id INTEGER PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	order_time TIMESTAMPTZ NOT NULL,
	payment_method TEXT,
	discount_percentage NUMERIC(5, 2),
	subtotal NUMERIC(12, 2) NOT NULL,
	total NUMERIC(12, 2) NOT NULL,
	country CHAR(2),
	device TEXT,
	source TEXT,
	CONSTRAINT fk_orders_customer
		FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE TABLE IF NOT EXISTS order_items (
	order_id INTEGER NOT NULL,
	product_id NUMERIC(10, 0) NOT NULL,
	unit_price NUMERIC(12, 2) NOT NULL,
	quantity NUMERIC(10, 2) NOT NULL,
	total_line NUMERIC(12, 2) NOT NULL,
	CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
	CONSTRAINT fk_order_items_order
		FOREIGN KEY (order_id) REFERENCES orders (order_id),
	CONSTRAINT fk_order_items_product
		FOREIGN KEY (product_id) REFERENCES products (product_id)
);

CREATE TABLE IF NOT EXISTS reviews (
	review_id INTEGER PRIMARY KEY,
	order_id INTEGER NOT NULL,
	product_id NUMERIC(10, 0) NOT NULL,
	rating SMALLINT NOT NULL,
	review_text TEXT,
	review_time TIMESTAMPTZ,
	CONSTRAINT fk_reviews_order
		FOREIGN KEY (order_id) REFERENCES orders (order_id),
	CONSTRAINT fk_reviews_product
		FOREIGN KEY (product_id) REFERENCES products (product_id)
);

CREATE TABLE IF NOT EXISTS events (
	event_id INTEGER PRIMARY KEY,
	session_id INTEGER NOT NULL,
	"timestamp" TIMESTAMPTZ NOT NULL,
	event_type TEXT NOT NULL,
	product_id NUMERIC(10, 0),
	quantity NUMERIC(10, 2),
	cart_size INTEGER,
	payment TEXT,
	discount_percentage NUMERIC(5, 2),
	amount NUMERIC(12, 2),
	CONSTRAINT fk_events_session
		FOREIGN KEY (session_id) REFERENCES sessions (session_id),
	CONSTRAINT fk_events_product
		FOREIGN KEY (product_id) REFERENCES products (product_id)
);

