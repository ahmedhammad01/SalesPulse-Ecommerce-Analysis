/*
===============================================================================
EDA: High Value Customer Analysis
===============================================================================
Purpose:    Segment customers to identify VIPs and opportunities for retention.
Key Metrics:
            - Top Spenders
            - Frequent Buyers
            - Customer Segmentation (VIP, Regular, Low Value)
===============================================================================
*/

-- 1. Top 10 Customers by Total Spend (Lifetime Value)
SELECT TOP 10
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC;

-- 2. Customer Segmentation (RFM-like approach based on Spend)
-- Logic: 
--      VIP: Spent > $5000
--      Regular: Spent between $1000 and $5000
--      New/Low Value: Spent < $1000
WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(total_amount) as total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN total_spent > 5000 THEN 'VIP'
        WHEN total_spent BETWEEN 1000 AND 5000 THEN 'Regular'
        ELSE 'Low Value'
    END as customer_segment,
    COUNT(customer_id) as customer_count,
    SUM(total_spent) as total_revenue_from_segment
FROM CustomerSpend
GROUP BY 
    CASE 
        WHEN total_spent > 5000 THEN 'VIP'
        WHEN total_spent BETWEEN 1000 AND 5000 THEN 'Regular'
        ELSE 'Low Value'
    END
ORDER BY total_revenue_from_segment DESC;
