CREATE DATABASE IF NOT EXISTS `Findout`;
USE `Findout`;

DROP TABLE IF EXISTS `sale2`;
DROP TABLE IF EXISTS `product2`;

CREATE TABLE `product2` (
  `id` INT NOT NULL PRIMARY KEY,
  `product_name` VARCHAR(255) NOT NULL,
  `category` VARCHAR(100) NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `cost` DECIMAL(10,2) NOT NULL,
  `stock` INT NOT NULL,
  `discount` DECIMAL(5,2) DEFAULT 0);

CREATE TABLE `sale2` (
  `sale_id` INT NOT NULL PRIMARY KEY,
  `id` INT NOT NULL, 
  `customer_id` INT,
  `sale_date` DATETIME,
  `channel` VARCHAR(50), 
  `transaction` VARCHAR(50), 
  `currency` CHAR(3),
  `quantity` INT,
  `total_price` DECIMAL(12,2),
  `region` VARCHAR(100),
  `notes` TEXT);


INSERT INTO `product2` (`id`,`product_name`,`category`,`unit_price`,`cost`,`stock`,`discount`)
VALUES
(1, 'Nimbus Smartwatch', 'electronics', 199.99, 120.00, 80, 10.0),
(2, 'Aurora Wireless Headphones', 'electronics', 129.99, 60.00, 150, 5.0),
(3, 'Paper Notebook', 'stationery', 4.50, 1.00, 500, 0.0),
(4, 'Desk Lamp', 'furniture', 45.00, 20.00, 40, 0.0),
(5, 'Gaming Monitor', 'electronics', 349.99, 200.00, 30, 15.0),
(6, 'Duplicate Product', 'other', 9.99, 3.00, 10, 0.0);
 

INSERT INTO `sale2` (`sale_id`,`id`,`customer_id`,`sale_date`,`channel`,`transaction`,`currency`,`quantity`,`total_price`,`region`,`notes`)
VALUES
(10, 1, 101, '2025-07-22 11:00:00', 'online', 'completed', 'USD', 2, 399.98, 'North America', 'First order'),
(11, 2, 102, '2025-08-01 09:30:00', 'in_store', 'completed', 'USD', 1, 129.99, 'Europe', 'Promo'),
(12, 3, 103, '2025-10-10 10:00:00', 'online', 'completed', 'EUR', 10, 45.00, 'Europe', 'Bulk purchase'),
(13, 4, 104, '2025-10-10 16:00:00', 'wholesale', 'completed', 'USD', 250, 87497.50, 'APAC', 'Large order'),
(14, 5, 105, '2025-10-11 12:00:00', 'online', 'pending', 'USD', 1, 129.99, 'Europe', 'Pending payment'),
(15, 6, 106, '2025-09-01 08:00:00', 'in_store', 'completed', 'USD', 3, 13.50, 'North America', 'product id missing'),
(16, 7, 107, '2025-10-11 13:00:00', 'in_store', 'completed', 'EUR', 1, 199.99, 'Europe', 'Returned item');


-- 1) Table sample: view products
SELECT * FROM `product2`;

-- 2) Row Count (full qualification with schema)
SELECT COUNT(*) AS row_count FROM `Findout`.`product2`;

-- 3) Checking for duplicate IDs (show only duplicates)
SELECT id, COUNT(*) AS duplicate_value_count
FROM `product2`
GROUP BY id
HAVING COUNT(*) > 1;

-- 4) Distinct values for selected columns (avoid SELECT DISTINCT *)
--    Example: distinct product names and categories, and count of distinct categories
SELECT DISTINCT product_name, category FROM product2;
SELECT COUNT(DISTINCT category) AS distinct_categories FROM products;

-- 5) Getting familiar with INFORMATION_SCHEMA and column types for products table
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Findout' AND TABLE_NAME = 'product2';

-- 6) Inspecting data for NULL values (actual SQL NULLs) and for string 'null' in notes
SELECT COUNT(*) AS Null_ProductIDs FROM product2 WHERE id IS NULL;
SELECT COUNT(*) AS Null_ReferenceIds_In_Sale FROM sale2 WHERE id IS NULL;
SELECT COUNT(*) AS Notes_with_literal_null FROM sale2 WHERE LOWER(IFNULL(notes,'')) LIKE '%null%';

-- 7) Analyze transaction status and currency used (completed USD transactions)
SELECT `transaction`, `currency`, COUNT(*) AS trans_count
FROM sale2
WHERE `transaction` = 'completed' AND `currency` = 'USD'
GROUP BY `transaction`, `currency`;

-- 8) Join two tables, make a report about the sale on certain dates and what channel was used.

SELECT DISTINCT p.product_name, p.category, s.sale_date, s.channel
FROM product2 p
JOIN sale2 s ON p.id = s.id
WHERE s.sale_date BETWEEN '2025-07-21 10:20:00' AND '2025-10-10 09:15:00'
  AND (s.channel = 'online' OR s.channel = 'in_store')
ORDER BY s.sale_date;

-- 9) Numeric summary for unit_price and quantities per customer
SELECT customer_id,
       AVG(unit_price) AS avg_unit_price,
       MAX(quantity) AS max_quantity_sold,
       SUM(total_price) AS sum_total_price
FROM sale2
LEFT JOIN product2 USING (id) 
GROUP BY customer_id
ORDER BY max_quantity_sold DESC;

-- 10) Join tables, report the maximum quantity sold >= 200 and the region.
SELECT p.product_name, p.category,
       s.customer_id, MAX(s.quantity) AS max_quantity_sold,
       s.region, s.notes
FROM product2 p
JOIN sale2 s ON p.id = s.id
GROUP BY p.product_name, p.category, s.customer_id, s.region, s.notes
HAVING MAX(s.quantity) >= 200;

-- 11) Report the number of electronics in the category column
SELECT COUNT(*) AS Number_of_Electronics
FROM product2
WHERE category = 'electronics';

-- 12) Select products where related sale used EUR and discount <= 5
SELECT *
FROM product2
WHERE id IN (
  SELECT id
  FROM sale2
  WHERE currency = 'EUR' AND discount <= 5
);

-- 12b) Select rows from sale where Total_Price <= max(total_price) among wholesale channel
SELECT *
FROM sale2
WHERE total_price <= (
  SELECT MAX(total_price) FROM sale2 WHERE channel = 'wholesale'
)
ORDER BY total_price DESC;

-- 13) Extracting products that were sold in a particular period
SELECT DISTINCT p.*
FROM product2 p
WHERE p.id IN (
  SELECT s.id FROM sale2 s
  WHERE s.sale_date BETWEEN '2025-10-10 09:15:00' AND '2025-10-11 14:30:00'
);

-- 14) Conditional labeling by product_name using CASE;
SELECT p.*,
  CASE
    WHEN p.product_name = 'Nimbus Smartwatch' AND p.cost > 80 AND p.stock > 70 THEN 'Expensive'
    WHEN p.product_name = 'Nimbus Smartwatch' THEN 'Affordable'
    WHEN p.product_name = 'Aurora Wireless Headphones' AND (p.unit_price > 100 AND p.cost > 50) THEN 'Very expensive'
    WHEN p.product_name = 'Aurora Wireless Headphones' THEN 'Best Price'
    ELSE 'Other'
  END AS Expensive_Articles
FROM product2 p
WHERE p.product_name IN ('Aurora Wireless Headphones', 'Nimbus Smartwatch');

-- 15) Create a procedure: select electronics with unit_price > 100 and stock < 100

DROP PROCEDURE IF EXISTS `summary1`;
DELIMITER $$
CREATE PROCEDURE `summary1`()
BEGIN
  SELECT * FROM product2
  WHERE category = 'electronics' AND unit_price > 100 AND stock < 100;
END$$
DELIMITER ;

-- Call example:
CALL summary1();

-- 16) Combine two tables and create a procedure to return completed transactions with product category

DROP PROCEDURE IF EXISTS `summary2`;
DELIMITER $$
CREATE PROCEDURE `summary2`()
BEGIN
  SELECT a.category, b.sale_date, b.transaction, b.channel, b.customer_id
  FROM product2 a
  JOIN sale2 b ON a.id = b.id
  WHERE b.transaction = 'completed';
END$$
DELIMITER ;

-- Call example:
CALL summary2();

-- 17) Use Common Table Expressions (CTEs) to query joined data and filtered products
WITH cust_info AS (
  SELECT p.product_name, p.category, s.sale_date, p.cost
  FROM product2 p
  JOIN sale2 s ON p.id = s.id
)
SELECT * FROM cust_info;

WITH cte AS (
  SELECT * FROM product2
  WHERE category = 'electronics' AND cost > 100
)
SELECT * FROM cte;

-- 18) Rank the number of electronics in the category column using window functions
SELECT p.*,
       ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY p.id DESC) AS Quantity_Count
FROM product2 p
JOIN sale2 s ON p.id = s.id
WHERE p.category = 'electronics';


