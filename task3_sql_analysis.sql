
-- Task 3: SQL for Data Analysis

-- Step 1: Create the ecommerce_events table
CREATE TABLE IF NOT EXISTS ecommerce_events (
    event_time DATETIME,
    event_type VARCHAR(50),
    product_id BIGINT,
    category_id BIGINT,
    category_code VARCHAR(100),
    brand VARCHAR(100),
    price DECIMAL(10,2),
    user_id BIGINT,
    user_session VARCHAR(100)
);

-- Step 2: Load data into the table (edit path as per your system)
-- Use the appropriate one among the three below:

-- Option 1: If no secure_file_priv restriction (edit path accordingly)
LOAD DATA INFILE 'E:/archive/2019-Dec.csv'
INTO TABLE ecommerce_events
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Option 2: If secure_file_priv is set (use Uploads directory)
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2019-Dec.csv'
-- INTO TABLE ecommerce_events
-- FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- Option 3: Use LOCAL (ensure MySQL Workbench allows it)
-- LOAD DATA LOCAL INFILE 'E:/archive/2019-Dec.csv'
-- INTO TABLE ecommerce_events
-- FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;


-- Step 3: SQL Queries for Data Analysis

-- a. Basic SELECT with WHERE, ORDER BY, GROUP BY
SELECT event_type, COUNT(*) AS total_events
FROM ecommerce_events
WHERE price > 100
GROUP BY event_type
ORDER BY total_events DESC;

-- b. Aggregate Functions: SUM, AVG
SELECT brand, AVG(price) AS avg_price, SUM(price) AS total_revenue
FROM ecommerce_events
GROUP BY brand
ORDER BY total_revenue DESC;

-- c. JOINS (Assuming another table 'product_info' exists)
-- CREATE TABLE product_info (product_id BIGINT PRIMARY KEY, product_name VARCHAR(100));
-- SELECT ee.product_id, pi.product_name, COUNT(*) AS event_count
-- FROM ecommerce_events ee
-- INNER JOIN product_info pi ON ee.product_id = pi.product_id
-- GROUP BY ee.product_id, pi.product_name;

-- d. Subquery Example
SELECT user_id, price
FROM ecommerce_events
WHERE price > (
    SELECT AVG(price) FROM ecommerce_events
);

-- e. View for frequent users
CREATE VIEW frequent_users AS
SELECT user_id, COUNT(*) AS event_count
FROM ecommerce_events
GROUP BY user_id
HAVING COUNT(*) > 50;

-- f. Index Optimization (optional)
CREATE INDEX idx_event_type ON ecommerce_events(event_type);
CREATE INDEX idx_user_id ON ecommerce_events(user_id);
