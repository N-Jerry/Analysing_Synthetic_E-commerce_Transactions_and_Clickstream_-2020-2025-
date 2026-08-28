
-- What is the total revenue and number of orders for each country?
SELECT
    country,
    COUNT(order_id) AS num_orders,
    SUM(total)      AS total_revenue
FROM orders
GROUP BY country
ORDER BY total_revenue DESC;

-- What are the top 5 best-selling products by total quantity sold?
SELECT
    p.product_id,
    p.name,
    p.category,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY total_units_sold DESC
LIMIT 5;

-- How many new customers signed up each month for each year?
SELECT
	EXTRACT(YEAR FROM signup_date) AS signup_year,
	TO_CHAR(signup_date, 'Month') AS signup_month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
/*
We can use this if we want to see both yaer and month in one column
SELECT
    DATE_TRUNC('month', signup_date) AS signup_month,
    COUNT(*)                         AS new_customers
FROM customers
GROUP BY 1
ORDER BY 1;

*/
-- What is the average order value for each payment method?
SELECT
    payment_method,
    COUNT(*)             AS num_orders,
    ROUND(AVG(total), 2) AS avg_order_value
FROM orders
GROUP BY payment_method
ORDER BY avg_order_value DESC;

-- What is the average customer review rating for each product category?
SELECT
    p.category,
    COUNT(r.review_id)      AS num_reviews,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM reviews r
JOIN products p ON p.product_id = r.product_id
GROUP BY p.category
ORDER BY avg_rating DESC;

-- Which device type generates the most orders and revenue?
SELECT
    device,
    COUNT(*)   AS num_orders,
    SUM(total) AS total_revenue
FROM orders
GROUP BY device
ORDER BY total_revenue DESC;