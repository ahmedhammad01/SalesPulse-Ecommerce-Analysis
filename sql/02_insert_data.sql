-- Connect to database (Optional)
-- \c ecommerce_db;

-- Note: Adjust the path below to match your actual file location if different.
-- Ensure the SQL Server service account has read permissions on these files.

-- 1. Suppliers
BULK INSERT "suppliers"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\suppliers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 2. Customers
BULK INSERT "customers"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 3. Products
BULK INSERT "products"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\products.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 4. Orders
BULK INSERT "orders"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\orders.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 5. Order Items
BULK INSERT "order_items"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\order_items.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 6. Refunds
BULK INSERT "refunds"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\order_item_refunds.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 7. Website Sessions
BULK INSERT "website_sessions"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\website_sessions.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 8. Website Pageviews
BULK INSERT "website_pageviews"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\website_pageviews.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 9. Geographical Data
BULK INSERT "geographical_data"
FROM 'd:\DATA ANALYST\SalesPulse Ecommerce Data Analysis\data\geographical_data.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
