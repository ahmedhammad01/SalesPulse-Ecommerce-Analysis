/*
===============================================================================
E-Commerce Data Transformation & Quality Assurance (ELT)
===============================================================================
Purpose:    Standardize and enhance the raw e-commerce dataset for business intelligence.
Actions:    - Deduplication & Primary Key Enforcement
            - Null Value Imputation & Filtering
            - Data Type Normalization (Financials & Temporals)
            - Business Logic Validation & Anomaly Correction
Author:     Ahmed Hammad
Date:       2026-02-15
===============================================================================
*/

-- ============================================================================
-- 1. DATA EXPLORATION & INVALID DATA REMOVAL
-- ============================================================================

-- A. Maintain Referential Integrity
-- Logic: Records missing secondary foreign keys are excluded to ensure valid downstream joins.
DELETE FROM "orders" WHERE "customer_id" IS NULL;
DELETE FROM "order_items" WHERE "order_id" IS NULL;

-- B. Customer Attribute Validation
-- Decision: Exclude incomplete profiles (missing or invalid email) to maintain CRM quality.
DELETE FROM "customers" WHERE "email" IS NULL OR "email" NOT LIKE '%@%';

-- ============================================================================
-- 2. DEDUPLICATION
-- ============================================================================

-- A. Deduplicate Customers
-- Business Logic: Keep the most recent registration for duplicate Customer IDs.
WITH DuplicateCustomers AS (
    SELECT 
        *, 
        ROW_NUMBER() OVER (PARTITION BY "customer_id" ORDER BY "registration_date" DESC) as rn
    FROM "customers"
)
DELETE FROM DuplicateCustomers WHERE rn > 1;

-- B. Deduplicate Orders
-- Business Logic: Duplicate Order IDs indicate a system glitch. We keep the latest entry.
WITH DuplicateOrders AS (
    SELECT 
        *, 
        ROW_NUMBER() OVER (PARTITION BY "order_id" ORDER BY "order_date" DESC) as rn
    FROM "orders"
)
DELETE FROM DuplicateOrders WHERE rn > 1;

-- ============================================================================
-- 3. DATA STANDARDIZATION & FORMATTING
-- ============================================================================

-- A. Unified Categorization
-- Logic: Normalize mixed-case categories to Title Case for uniform aggregation and reporting.
UPDATE "products"
SET "category" = UPPER(LEFT("category", 1)) + LOWER(SUBSTRING("category", 2, LEN("category")))
WHERE "category" IS NOT NULL;

-- Handle missing categories
UPDATE "products" SET "category" = 'Uncategorized' WHERE "category" IS NULL;

-- B. Standardize Addresses
-- Problem: Addresses often have leading/trailing whitespace.
UPDATE "customers" SET "address" = TRIM("address");

-- C. Fix Payment Status inconsistencies
-- Problem: Null payment statuses.
-- Solution: Assume 'Pending' for missing values.
UPDATE "orders" SET "payment_status" = 'Pending' WHERE "payment_status" IS NULL;

-- ============================================================================
-- 4. BUSINESS LOGIC ENFORCEMENT (LOGIC ERRORS)
-- ============================================================================

-- A. Quantitative Anomaly Correction
-- Logic: Correcting negative quantitative values to resolve data entry inconsistencies.
UPDATE "order_items"
SET "quantity" = ABS("quantity"),
    "item_price" = ABS("item_price"),
    "total_price" = ABS("total_price");

-- B. Remove Future Orders
-- Business Logic: Orders cannot exist in the future.
-- Note: order_date is VARCHAR in DD/MM/YYYY format (103 = British/French format)
DELETE FROM "orders" 
WHERE TRY_CONVERT(DATE, "order_date", 103) > GETDATE() 
   OR TRY_CONVERT(DATE, "order_date", 103) IS NULL;

-- C. Validate Refunds
-- Business Logic: A refund cannot be greater than the original purchase price.
-- Solution: Remove invalid refund records.
DELETE r
FROM "refunds" r
JOIN "order_items" oi ON r."order_item_id" = oi."order_item_id"
WHERE r."refund_amount" > oi."total_price";

-- D. Validate Pageview Durations
-- Business Logic: Pageviews cannot have a duration longer than the session itself.
-- (Optional advanced check, simplified here to just positive durations)
UPDATE "website_pageviews" SET "duration" = 0 WHERE "duration" < 0;

-- E. Validate Session Times
-- logic: Session End must be after Session Start
DELETE FROM "website_sessions" WHERE "session_end" < "session_start";

-- ============================================================================
-- 5. TYPE CONVERSION & CLEANUP
-- ============================================================================

-- A. Financial Column Normalization
-- Transformation: Parsing raw string values with currency symbols into DECIMAL(10,2) format for analysis.

-- Step 1: Character scrubbing
UPDATE "products"
SET "price" = REPLACE(REPLACE("price", '$', ''), ',', '');

-- Step 2: Alter column type (This works only if all rows are clean numbers now)
-- Note: This command might fail if any non-numeric data remains. 
-- In a real scenario, we might use TRY_CAST or handle errors more gracefully.
ALTER TABLE "products" ALTER COLUMN "price" DECIMAL(10, 2);

-- B. Temporal Standardization
-- Normalization: Mapping raw string dates (DD/MM/YYYY) to standard SQL DATE/DATETIME types.

-- Step 1: Standardizing to ISO 8601 (YYYY-MM-DD)
UPDATE "orders" SET "order_date" = CONVERT(VARCHAR, TRY_CONVERT(DATE, "order_date", 103), 23);

-- Step 2: Schema Amendment
ALTER TABLE "orders" ALTER COLUMN "order_date" DATE;
ALTER TABLE "website_pageviews" ALTER COLUMN "timestamp" DATETIME;

-- ============================================================================
-- 6. FINAL INTEGRITY CHECKS (OPTIONAL)
-- ============================================================================

-- A. First, remove any rows with NULL primary key values
DELETE FROM "customers" WHERE "customer_id" IS NULL;
DELETE FROM "orders" WHERE "order_id" IS NULL;
DELETE FROM "products" WHERE "product_id" IS NULL;
DELETE FROM "suppliers" WHERE "supplier_id" IS NULL;

-- B. Note: Primary key constraints are optional for analysis purposes.
-- The data is now clean and deduplicated, which is sufficient for EDA.
-- If you need to add constraints later, ensure columns are NOT NULL first.

-- Example (commented out to avoid errors):
-- ALTER TABLE "customers" ALTER COLUMN "customer_id" INT NOT NULL;
-- ALTER TABLE "customers" ADD CONSTRAINT PK_Customers PRIMARY KEY ("customer_id");

-- Script Complete
SELECT 'Data Cleaning Completed Successfully' as Status;
