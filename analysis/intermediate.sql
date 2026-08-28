-- How is monthly revenue trending month-over-month?
WITH monthly_revenue AS (
    SELECT
		EXTRACT(YEAR FROM order_time) AS order_year,
		EXTRACT(MONTH FROM order_time) AS month_number,
        TO_CHAR(order_time, 'Month') AS order_month,
        SUM(total) AS revenue
    FROM orders
    GROUP BY 1,2,3
)
SELECT
    order_year, order_month, revenue,
    LAG(revenue) OVER (ORDER BY order_year, month_number) AS prev_month_revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY order_year, month_number))
        / NULLIF(LAG(revenue) OVER (ORDER BY order_year, month_number), 0), 2
    ) AS percentage_change
FROM monthly_revenue
ORDER BY order_year, month_number;

-- Which product categories are most profitable after accounting for cost?
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    SUM(oi.quantity * p.cost) AS total_cost,
    SUM(oi.quantity * (oi.unit_price - p.cost)) AS gross_profit,
    ROUND(
        100.0 * SUM(oi.quantity * (oi.unit_price - p.cost))
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0), 2
    ) AS margin_percentage
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY gross_profit DESC;

-- Who are the top 3 spending customers within each country?
WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.name,
        c.country,
        SUM(o.total) AS total_spent,
        RANK() OVER (PARTITION BY c.country ORDER BY SUM(o.total) DESC) AS spend_rank
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.name, c.country
)
SELECT *
FROM customer_spend
WHERE spend_rank <= 3
ORDER BY country, spend_rank;

-- What is the approximate session-to-order conversion rate for each traffic source?
-- (Approximated by matching a customer's same-day session and order, since orders has no session_id FK.)
SELECT
    s.source,
    COUNT(DISTINCT s.session_id)  AS total_sessions,
    COUNT(DISTINCT o.order_id)    AS total_orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
        / NULLIF(COUNT(DISTINCT s.session_id), 0), 2
    ) AS conversion_rate_pct
FROM sessions s
LEFT JOIN orders o
    ON o.customer_id = s.customer_id
   AND DATE(o.order_time) = DATE(s.start_time)
GROUP BY s.source
ORDER BY conversion_rate_pct DESC;

-- Which products have the highest share of negative reviews (rating <= 2)?
SELECT
    p.product_id,
    p.name,
    p.category,
    COUNT(*) FILTER (WHERE r.rating <= 2) AS negative_reviews,
    COUNT(*)                              AS total_reviews,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE r.rating <= 2) / COUNT(*), 2
    ) AS negative_pct
FROM reviews r
JOIN products p ON p.product_id = r.product_id
GROUP BY p.product_id, p.name, p.category
HAVING COUNT(*) >= 5
ORDER BY negative_pct DESC;

-- How does applying a discount affect average order value?
SELECT
    CASE WHEN discount_percentage > 0 THEN 'Discounted' ELSE 'Full Price' END AS order_type,
    COUNT(*)                AS num_orders,
    ROUND(AVG(total), 2)    AS avg_order_value,
    ROUND(AVG(subtotal), 2) AS avg_subtotal
FROM orders
GROUP BY order_type;