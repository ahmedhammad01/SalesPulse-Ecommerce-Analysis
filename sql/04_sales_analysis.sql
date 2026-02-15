/*
===============================================================================
EDA: Sales Trend Analysis
===============================================================================
Purpose:    Analyze sales performance over time to identify trends and seasonality.
Key Metrics:
            - Total Revenue
            - Total Orders
            - Average Order Value (AOV)
            - Monthly Sales Growth
===============================================================================
*/

-- 1. Sales Overview (Total Revenue, Orders, AOV)
SELECT 
    COUNT(order_id) as total_orders,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as average_order_value
FROM orders;

-- 2. Monthly Sales Trend
-- Purpose: Identify seasonality and peak sales months.
SELECT 
    FORMAT(order_date, 'yyyy-MM') as month,
    COUNT(order_id) as total_orders,
    SUM(total_amount) as total_revenue
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month;

-- 3. Daily Sales Trend (Recent activity)
-- Purpose: Monitor daily performance fluctuations.
SELECT 
    order_date,
    COUNT(order_id) as daily_orders,
    SUM(total_amount) as daily_revenue
FROM orders
GROUP BY order_date
ORDER BY order_date DESC;
