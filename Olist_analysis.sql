CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

CREATE TABLE category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12,2),
    freight_value NUMERIC(12,2),
    total_item_value NUMERIC(12,2),

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);

CREATE TABLE payments (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC(12,2),

    PRIMARY KEY (order_id, payment_sequential),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

CREATE TABLE reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);
Select*from categrory_transl;
select count(*) from order_items;
ALTER TABLE orders
ADD COLUMN delivery_days NUMERIC,
ADD COLUMN delivery_delay_days NUMERIC,
ADD COLUMN is_late BOOLEAN,
ADD COLUMN order_month VARCHAR(20);
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'orders'
ORDER BY ordinal_position;
SELECT COUNT(*) FROM category_translation;
SELECT * FROM payments;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM reviews;
ALTER TABLE reviews
DROP CONSTRAINT reviews_pkey;
ALTER TABLE reviews
ADD COLUMN review_record_id BIGSERIAL PRIMARY KEY;
---- now the query will start...
--  Business performance
--Q1. revenue trend
SELECT 
    order_id,
    SUM(payment_value) AS revenue
FROM payments
GROUP BY order_id;
--Q1. Monthly revenue trend
select DATE_TRUNC('month',o.order_purchase_timestamp) as Month,
sum(p.payment_value) as Revenue 
from orders as o
join payments as p
on o.order_id = p.order_id
Group by Month
ORDER BY Month;
-- Previous month revenue
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(p.payment_value) AS revenue
    FROM orders AS o
    JOIN payments AS p
        ON o.order_id = p.order_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER(ORDER BY month) AS previous_month_revenue
FROM monthly_revenue
ORDER BY month;
---Percentage growth by month
WITH Monthly_orders as (
SELECT DATE_TRUNC('month',order_purchase_timestamp) AS Month,
COUNT(order_id) AS Orders 
FROM Orders
GROUP BY Month
)
SELECT Month , orders ,LAG(orders) OVER(ORDER BY Month) as previous_month_order,
ROUND( ((orders -LAG(orders) OVER(ORDER BY Month))
/NULLIF(LAG(orders) OVER (ORDER BY month), 0)
        ) * 100,
        2)AS Growth_percentage
FROM Monthly_orders 
order by Month;
--- Average order vaule according to months
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(p.payment_value) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        SUM(p.payment_value) / COUNT(DISTINCT o.order_id),
        2
    ) AS aov
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;
---contribute revenue by product category
WITH category_revenue AS (
    SELECT
        t.product_category_name_english AS category,
        SUM(oi.price) AS revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN  category_translation t
        ON p.product_category_name = t.product_category_name
    GROUP BY category
)
SELECT
    category,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM category_revenue
ORDER BY revenue_rank;
--- top customers according to revenue
with revenue as (
select C. customer_unique_id  , sum(o_i.price) as Revenue from orders o
join customers  C
on o.customer_id = C.customer_id
join order_items o_i
on o_i.order_id = o.order_id
group by  C. customer_unique_id 
)
select customer_unique_id ,Revenue , rank() over(order by Revenue DESC) as ranking
from revenue 
order by Revenue DESC
limit 3;
--
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY customer_type
ORDER BY customer_count DESC;
--How many customers purchased only once,
--and how many customers came back and purchased multiple times?
WITH customer_months AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id,
       purchase_month
),

customer_activity AS (
    SELECT
        customer_unique_id,
        COUNT(*) AS active_months
    FROM customer_months
    GROUP BY customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE active_months > 1) AS retained_customers,
    ROUND(
        COUNT(*) FILTER (WHERE active_months > 1) * 100.0
        / COUNT(*),
        2
    ) AS retention_percentage
FROM customer_activity;
-- Customer life time value
WITH customer_data AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS total_revenue,
        MIN(o.order_purchase_timestamp) AS first_order,
        MAX(o.order_purchase_timestamp) AS last_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_orders,
    total_revenue AS customer_lifetime_value,
    ROUND(total_revenue / total_orders, 2) AS average_order_value,
    first_order,
    last_order
FROM customer_data
ORDER BY customer_lifetime_value DESC
LIMIT 20;
-- customer with segemnt of high , low and medium
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),
customer_segments AS (
    SELECT
        customer_unique_id,
        revenue,
        NTILE(3) OVER (ORDER BY revenue DESC) AS segment
    FROM customer_revenue
)
SELECT
    CASE
        WHEN segment = 1 THEN 'High Value'
        WHEN segment = 2 THEN 'Medium Value'
        WHEN segment = 3 THEN 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
	ROUND(SUM(revenue), 2) AS total_revenue
FROM customer_segments
GROUP BY segment
ORDER BY segment;
-- top 10 product based on revenue
WITH category_revenue AS (
    SELECT
        tc.product_category_name_english AS category,
        SUM(oi.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN category_translation tc
        ON tc.product_category_name = p.product_category_name
    GROUP BY category
)
SELECT
    category,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS ranking
FROM category_revenue
ORDER BY ranking 
limit 10;
--Product Category Sales Performance
SELECT
    tc.product_category_name_english AS category,
    COUNT(*) AS units_sold,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN category_translation tc
    ON p.product_category_name = tc.product_category_name
GROUP BY tc.product_category_name_english
ORDER BY units_sold DESC;
--Top Sellers by Revenue
WITH seller_revenue AS (
    SELECT
        s.seller_id ,
        SUM(oi.price) AS revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    GROUP BY s.seller_id
)
SELECT
    seller_id, 
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS ranking
FROM seller_revenue
ORDER BY ranking 
limit 10;
--average delivery time
SELECT
    ROUND( AVG(EXTRACT(DAY FROM(order_delivered_customer_date - order_purchase_timestamp)
            ) ),2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
-- late delivery rate
SELECT
  ROUND(COUNT(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date
      )* 100.0 / COUNT(*),2) AS late_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
--Payment Method Analysis
SELECT payment_type,COUNT(*) AS transactions,SUM(payment_value) AS total_payment,
    ROUND(AVG(payment_value), 2) AS average_payment
FROM payments
GROUP BY payment_type
ORDER BY total_payment DESC;
-- State wise sells
SELECT c.customer_state,SUM(oi.price) AS revenue,COUNT(DISTINCT o.order_id) AS orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;