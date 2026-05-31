/* =====================================================
   Bright Motors Car Sales Analysis
   Author: Rinae Netshilinganedza
   Role:  Data Analyst
===================================================== */


/* ==============================
   1. CREATE DATABASE
================================= */

CREATE DATABASE bright_motors;
USE bright_motors;


/* ==============================
   2. CREATE TABLE
================================= */

CREATE TABLE car_sales (
    sale_id INT,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    region VARCHAR(50),
    fuel_type VARCHAR(20),
    mileage INT,
    selling_price VARCHAR(20),
    cost_price VARCHAR(20),
    units_sold INT,
    sale_date DATE
);


/* ==============================
   3. DATA CLEANING
================================= */

-- Add numeric columns
ALTER TABLE car_sales
ADD selling_price_num FLOAT,
ADD cost_price_num FLOAT;

-- Convert text prices to numeric
UPDATE car_sales
SET selling_price_num = REPLACE(selling_price, ',', ''),
    cost_price_num = REPLACE(cost_price, ',', '');

-- Remove rows with missing important values
DELETE FROM car_sales
WHERE make IS NULL
   OR model IS NULL;


/* ==============================
   4. CREATE CALCULATED FIELDS
================================= */

-- Total Revenue Column
ALTER TABLE car_sales
ADD total_revenue FLOAT;

UPDATE car_sales
SET total_revenue =
selling_price_num * units_sold;


-- Profit Margin Column
ALTER TABLE car_sales
ADD profit_margin FLOAT;

UPDATE car_sales
SET profit_margin =
((selling_price_num - cost_price_num)
/ selling_price_num) * 100;


-- Performance Tier Column
ALTER TABLE car_sales
ADD performance_tier VARCHAR(20);

UPDATE car_sales
SET performance_tier =
CASE
    WHEN profit_margin > 20 THEN 'High Margin'
    WHEN profit_margin BETWEEN 10 AND 20 THEN 'Medium Margin'
    ELSE 'Low Margin'
END;


/* ==============================
   5. DATA VALIDATION
================================= */

SELECT * FROM car_sales LIMIT 10;

SELECT COUNT(*) AS total_records
FROM car_sales;


/* ==============================
   6. BUSINESS ANALYSIS QUERIES
================================= */

-- Revenue by Make
SELECT make,
SUM(total_revenue) AS total_revenue
FROM car_sales
GROUP BY make
ORDER BY total_revenue DESC;


-- Top Selling Models
SELECT make, model,
SUM(units_sold) AS total_units_sold
FROM car_sales
GROUP BY make, model
ORDER BY total_units_sold DESC;


-- Regional Performance
SELECT region,
SUM(units_sold) AS total_sales,
SUM(total_revenue) AS total_revenue
FROM car_sales
GROUP BY region
ORDER BY total_revenue DESC;


-- Fuel Type Distribution
SELECT fuel_type,
COUNT(*) AS sales_count
FROM car_sales
GROUP BY fuel_type;


-- Average Selling Price Trend
SELECT YEAR(sale_date) AS sales_year,
AVG(selling_price_num) AS average_price
FROM car_sales
GROUP BY YEAR(sale_date)
ORDER BY sales_year;


-- Mileage vs Price Relationship
SELECT mileage,
AVG(selling_price_num) AS average_price
FROM car_sales
GROUP BY mileage
ORDER BY mileage;


-- Profitability Analysis
SELECT performance_tier,
COUNT(*) AS vehicle_count
FROM car_sales
GROUP BY performance_tier;


/* ==============================
   7. FINAL DATA EXPORT
================================= */

-- Use this query to export cleaned data
SELECT *
FROM car_sales;
