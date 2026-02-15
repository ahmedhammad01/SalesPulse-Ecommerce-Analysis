/*
===============================================================================
Drop All Tables Script
===============================================================================
Purpose:    Drop all existing tables to allow fresh data import
Note:       Run this BEFORE running 01_create_tables.sql
===============================================================================
*/

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS "website_pageviews";
DROP TABLE IF EXISTS "website_sessions";
DROP TABLE IF EXISTS "refunds";
DROP TABLE IF EXISTS "order_items";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "products";
DROP TABLE IF EXISTS "suppliers";
DROP TABLE IF EXISTS "customers";

SELECT 'All tables dropped successfully' as Status;
