/*
===============================================================================
EDA: Geographical Insights
===============================================================================
Purpose:    Analyze sales performance across different regions.
Key Metrics:
            - Total Sales by Region
            - Order volume by Region
===============================================================================
*/

-- 1. Sales Performance by Region
SELECT 
    region_name,
    total_sales,
    number_of_orders,
    (total_sales / NULLIF(number_of_orders, 0)) as avg_order_value_per_region
FROM geographical_data
ORDER BY total_sales DESC;

-- 2. Regional Market Share
SELECT 
    region_name,
    total_sales,
    (total_sales * 100.0 / (SELECT SUM(total_sales) FROM geographical_data)) as market_share_pct
FROM geographical_data
ORDER BY market_share_pct DESC;
