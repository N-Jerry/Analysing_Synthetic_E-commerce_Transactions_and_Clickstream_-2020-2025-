-- How can customers be segmented using RFM (Recency, Frequency, Monetary) analysis?
WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(order_time) AS last_order_date,
        COUNT(order_id)  AS frequency,
        SUM(total)       AS monetary
    FROM orders
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        EXTRACT(DAY FROM (CURRENT_DATE - last_order_date)) AS recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY (CURRENT_DATE - last_order_date) ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency DESC)                       AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary DESC)                        AS monetary_score
    FROM rfm_base
)
SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS rfm_total,
    CASE
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3                        THEN 'Loyal Customers'
        WHEN recency_score <= 2 AND frequency_score <= 2                        THEN 'At Risk'
        ELSE 'Needs Attention'
    END AS segment
FROM rfm_scores
ORDER BY rfm_total DESC;

-- What does the browsing-to-purchase funnel look like across sessions, and where's the biggest drop-off?
-- (Assumes event_type values like 'view', 'add_to_cart', 'purchase' — adjust to match actual data.)
WITH funnel AS (
    SELECT
        session_id,
        MAX(CASE WHEN event_type = 'view'        THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_type = 'add_to_cart'  THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_type = 'purchase'     THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY session_id
)
SELECT
    COUNT(*)             AS total_sessions,
    SUM(viewed)           AS viewed_sessions,
    SUM(added_to_cart)    AS cart_sessions,
    SUM(purchased)        AS purchase_sessions,
    ROUND(100.0 * SUM(added_to_cart) / NULLIF(SUM(viewed), 0), 2)    AS view_to_cart_pct,
    ROUND(100.0 * SUM(purchased) / NULLIF(SUM(added_to_cart), 0), 2) AS cart_to_purchase_pct
FROM funnel;

-- What is the month-over-month retention rate for each customer signup cohort?
WITH cohorts AS (
    SELECT customer_id, DATE_TRUNC('month', signup_date) AS cohort_month
    FROM customers
),
orders_monthly AS (
    SELECT o.customer_id, DATE_TRUNC('month', o.order_time) AS order_month
    FROM orders o
    GROUP BY o.customer_id, DATE_TRUNC('month', o.order_time)
),
cohort_activity AS (
    SELECT
        c.cohort_month,
        (DATE_PART('year', om.order_month) - DATE_PART('year', c.cohort_month)) * 12
          + (DATE_PART('month', om.order_month) - DATE_PART('month', c.cohort_month)) AS month_number,
        COUNT(DISTINCT c.customer_id) AS active_customers
    FROM cohorts c
    JOIN orders_monthly om ON om.customer_id = c.customer_id
    GROUP BY c.cohort_month, month_number
),
cohort_size AS (
    SELECT cohort_month, COUNT(*) AS num_customers
    FROM cohorts
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.month_number,
    ca.active_customers,
    cs.num_customers,
    ROUND(100.0 * ca.active_customers / cs.num_customers, 2) AS retention_pct
FROM cohort_activity ca
JOIN cohort_size cs ON cs.cohort_month = ca.cohort_month
ORDER BY ca.cohort_month, ca.month_number;

-- Which customers are at risk of churning, based on their typical purchase cadence?
WITH order_gaps AS (
    SELECT
        customer_id,
        order_time,
        order_time - LAG(order_time) OVER (PARTITION BY customer_id ORDER BY order_time) AS gap
    FROM orders
),
customer_cadence AS (
    SELECT
        customer_id,
        AVG(gap)        AS avg_gap,
        MAX(order_time) AS last_order
    FROM order_gaps
    WHERE gap IS NOT NULL
    GROUP BY customer_id
)
SELECT
    customer_id,
    last_order,
    avg_gap,
    CURRENT_DATE - last_order::date AS days_since_last_order,
    CASE
        WHEN (CURRENT_DATE - last_order::date) > EXTRACT(DAY FROM avg_gap) * 1.5 THEN 'At Risk'
        ELSE 'Active'
    END AS churn_status
FROM customer_cadence
ORDER BY days_since_last_order DESC;

-- Which pairs of products are most frequently purchased together?
SELECT
    p1.name  AS product_a,
    p2.name  AS product_b,
    COUNT(*) AS times_bought_together
FROM order_items oi1
JOIN order_items oi2
    ON oi1.order_id = oi2.order_id
   AND oi1.product_id < oi2.product_id
JOIN products p1 ON p1.product_id = oi1.product_id
JOIN products p2 ON p2.product_id = oi2.product_id
GROUP BY p1.name, p2.name
ORDER BY times_bought_together DESC
LIMIT 10;

-- What is the cumulative revenue contribution of each customer acquisition source over time?
WITH first_touch AS (
    SELECT
        customer_id,
        source,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_time) AS rn
    FROM sessions
),
customer_source AS (
    SELECT customer_id, source AS acquisition_source
    FROM first_touch
    WHERE rn = 1
),
monthly_source_revenue AS (
    SELECT
        cs.acquisition_source,
        DATE_TRUNC('month', o.order_time) AS month,
        SUM(o.total)                      AS revenue
    FROM orders o
    JOIN customer_source cs ON cs.customer_id = o.customer_id
    GROUP BY cs.acquisition_source, DATE_TRUNC('month', o.order_time)
)
SELECT
    acquisition_source,
    month,
    revenue,
    SUM(revenue) OVER (PARTITION BY acquisition_source ORDER BY month) AS cumulative_revenue
FROM monthly_source_revenue
ORDER BY acquisition_source, month;