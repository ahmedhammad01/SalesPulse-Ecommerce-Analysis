
-- Drop tables if they exist (Order matters due to Foreign Keys)
DROP TABLE IF EXISTS "geographical_data";
DROP TABLE IF EXISTS "website_pageviews";
DROP TABLE IF EXISTS "website_sessions";
DROP TABLE IF EXISTS "refunds";
DROP TABLE IF EXISTS "order_items";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "products";
DROP TABLE IF EXISTS "customers";
DROP TABLE IF EXISTS "suppliers";

-- 1. Suppliers Table
CREATE TABLE "suppliers" (
    "supplier_id" INT, -- Primary key omitted for staging; enforced at transformation layer
    "supplier_name" VARCHAR(255),
    "contact_email" VARCHAR(255),
    "contact_phone" VARCHAR(50)
);

-- 2. Customers Table
CREATE TABLE "customers" (
    "customer_id" INT,
    "first_name" VARCHAR(100),
    "last_name" VARCHAR(100),
    "email" VARCHAR(255),
    "phone" VARCHAR(50),
    "registration_date" DATE,
    "address" VARCHAR(MAX)
);

-- 3. Products Table
CREATE TABLE "products" (
    "product_id" INT, 
    "product_name" VARCHAR(255),
    "category" VARCHAR(100),
    "price" VARCHAR(50), -- Capturing raw currency symbols for ETL processing
    "stock_quantity" INT,
    "supplier_id" INT
);

-- 4. Orders Table
CREATE TABLE "orders" (
    "order_id" INT, 
    "order_date" VARCHAR(50), -- Captured in raw format for normalization
    "customer_id" INT,
    "total_amount" DECIMAL(10, 2),
    "payment_status" VARCHAR(50),
    "shipping_status" VARCHAR(50)
);

-- 5. Order Items Table
CREATE TABLE "order_items" (
    "order_item_id" INT,
    "order_id" INT,
    "product_id" INT,
    "quantity" INT,
    "item_price" DECIMAL(10, 2),
    "total_price" DECIMAL(10, 2)
);

-- 6. Refunds Table
CREATE TABLE "refunds" (
    "refund_id" INT,
    "order_item_id" INT,
    "refund_amount" DECIMAL(10, 2),
    "refund_date" DATE,
    "refund_reason" VARCHAR(255)
);

-- 7. Website Sessions Table
CREATE TABLE "website_sessions" (
    "session_id" INT,
    "customer_id" INT,
    "session_start" DATETIME,
    "session_end" DATETIME,
    "session_duration" INT,
    "device_type" VARCHAR(50)
);

-- 8. Website Pageviews Table
CREATE TABLE "website_pageviews" (
    "pageview_id" INT,
    "session_id" INT,
    "page_url" VARCHAR(255),
    "timestamp" VARCHAR(50), -- Captured in raw datetime format
    "duration" INT
);

-- 9. Geographical Data Table
CREATE TABLE "geographical_data" (
    "region_id" INT,
    "region_name" VARCHAR(100),
    "total_sales" DECIMAL(15, 2),
    "number_of_orders" INT
);
