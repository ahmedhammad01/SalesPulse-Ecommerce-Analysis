/*
===============================================================================
EDA: Top Selling Products Analysis
===============================================================================
Purpose:    Identify best-performing products to optimize inventory and marketing.
Key Metrics:
            - Top Products by Revenue
            - Top Products by Volume (Quantity Sold)
            - Worst Performing Products
===============================================================================
*/

-- 1. Top 10 Best-Selling Products by Revenue
SELECT TOP 10
    p.product_name,
    p.category,
    SUM(oi.total_price) as total_revenue,
    SUM(oi.quantity) as total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC;

-- 2. Top 10 Best-Selling Products by Volume (Units Sold)
SELECT TOP 10
    p.product_name,
    p.category,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.total_price) as total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_quantity_sold DESC;

-- 3. Revenue by Product Category
-- Purpose: Understand which categories drive the most value.
SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id) as orders_containing_category,
    SUM(oi.total_price) as total_category_revenue,
    (SUM(oi.total_price) * 100.0 / (SELECT SUM(total_price) FROM order_items)) as pct_of_total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_category_revenue DESC;
