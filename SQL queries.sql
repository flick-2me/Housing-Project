-- ====================================================================================
-- HOUSING MARKET DATA: SQL EXPLORATION & TRANSFORMATIONS
-- ====================================================================================

-- 1. Create Table Schema (Example for Google BigQuery / PostgreSQL)
CREATE TABLE IF NOT EXISTS Housing_Data (
    house_id VARCHAR(50),
    date DATE,
    year_build INT,
    purchase_price NUMERIC,
    Offer_Price NUMERIC,
    sqm NUMERIC,
    region VARCHAR(100),
    city VARCHAR(100),
    zip_code VARCHAR(20),
    sales_type VARCHAR(50),
    house_type VARCHAR(50),
    nom_interest_rate NUMERIC,
    dk_ann_infl_rate NUMERIC
);

-- 2. Inspect the first 10 rows to understand the structure
SELECT * FROM Housing_Data 
LIMIT 10;

-- 3. Identify Missing Data in critical columns
SELECT
    COUNT(*) as total_rows,
    SUM(CASE WHEN purchase_price IS NULL THEN 1 ELSE 0 END) as missing_price,
    SUM(CASE WHEN sqm IS NULL OR sqm = 0 THEN 1 ELSE 0 END) as missing_sqm
FROM Housing_Data;

-- 4. Overall Market Summary Statistics
SELECT
    COUNT(house_id) as total_sales,
    ROUND(AVG(purchase_price), 2) as avg_purchase_price,
    MIN(purchase_price) as min_price,
    MAX(purchase_price) as max_price
FROM Housing_Data;

-- 5. Sales Volume and Revenue by Region
SELECT
    region,
    COUNT(house_id) as total_units_sold,
    SUM(purchase_price) as total_regional_revenue
FROM Housing_Data
GROUP BY region
ORDER BY total_regional_revenue DESC;

-- 6. Average Price per Square Meter by House Type
SELECT
    house_type,
    ROUND(AVG(purchase_price / NULLIF(sqm, 0)), 2) as avg_price_per_sqm
FROM Housing_Data
WHERE sqm > 0
GROUP BY house_type
ORDER BY avg_price_per_sqm DESC;

-- 7. Yearly Sales Trend
SELECT
    EXTRACT(YEAR FROM date) as sales_year,
    COUNT(house_id) as properties_sold,
    SUM(purchase_price) as total_revenue
FROM Housing_Data
GROUP BY sales_year
ORDER BY sales_year DESC;

-- 8. Negotiation Margins: Average Discount by Region
SELECT
    region,
    ROUND(AVG(Offer_Price - purchase_price), 2) as avg_discount_amount
FROM Housing_Data
WHERE Offer_Price > purchase_price
GROUP BY region
ORDER BY avg_discount_amount DESC;

-- 9. Top 10 Most Expensive Properties
SELECT
    house_id,
    region,
    city,
    house_type,
    purchase_price
FROM Housing_Data
ORDER BY purchase_price DESC
LIMIT 10;

-- 10. CTE: Find properties sold for more than their regional average
WITH RegionalAvg AS (
    SELECT region, AVG(purchase_price) as regional_avg_price
    FROM Housing_Data
    GROUP BY region
)
SELECT
    h.house_id,
    h.region,
    h.house_type,
    h.purchase_price,
    ROUND(r.regional_avg_price, 2) as regional_avg,
    ROUND(h.purchase_price - r.regional_avg_price, 2) as price_above_avg
FROM Housing_Data h
JOIN RegionalAvg r ON h.region = r.region
WHERE h.purchase_price > r.regional_avg_price
ORDER BY price_above_avg DESC
LIMIT 20;
