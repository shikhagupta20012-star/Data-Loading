CREATE DATABASE sales_etl;
USE sales_etl;

CREATE TABLE orders_data (
Order_ID VARCHAR(10),
Customer_ID VARCHAR(10),
Sales_Amount VARCHAR(50),
Order_Date VARCHAR(20)
);

INSERT INTO orders_data VALUES
('O101','C001','4500','12-01-2024'),
('O102','C002',NULL,'15-01-2024'),
('O103','C003','3200','2024/01/18'),
('O101','C001','4500','12-01-2024'),
('O104','C004','Three Thousand','20-01-2024'),
('O105','C005','5100','25-01-2024');

SELECT * FROM orders_data;

### Question 1 – Find Duplicate Records

SELECT Order_ID, COUNT(*)
FROM orders_data
GROUP BY Order_ID
HAVING COUNT(*) > 1;


### Question 2 – Find Missing Values

SELECT *
FROM orders_data
WHERE Sales_Amount IS NULL;


### Question 3 – Detect Invalid Sales Amount (Non-Numeric)


SELECT *
FROM orders_data
WHERE Sales_Amount NOT REGEXP '^[0-9]+$'
AND Sales_Amount IS NOT NULL;


### Question 4 – Detect Different Date Formats

SELECT *
FROM orders_data
WHERE Order_Date LIKE '%/%';


### Question 5 – Remove Duplicate Record

DELETE FROM orders_data
WHERE Order_ID='O101'
LIMIT 1;

SELECT * FROM orders_data;


### Question 6 – Handle Missing Sales Amount

# First calculate average:

SELECT AVG(Sales_Amount)
FROM orders_data
WHERE Sales_Amount REGEXP '^[0-9]+$';

# Update NULL value:

UPDATE orders_data
SET Sales_Amount = 4500
WHERE Sales_Amount IS NULL;


### Question 7 – Fix Text Sales Amount


UPDATE orders_data
SET Sales_Amount = 3000
WHERE Sales_Amount = 'Three Thousand';


### Question 8 – Convert Date Format

# Convert / format to standard.

UPDATE orders_data
SET Order_Date = STR_TO_DATE(Order_Date,'%d-%m-%Y')
WHERE Order_Date LIKE '%-%';


### Question 9 – Create Clean Table for Loading

CREATE TABLE clean_orders (
Order_ID VARCHAR(10) PRIMARY KEY,
Customer_ID VARCHAR(10),
Sales_Amount DECIMAL(10,2),
Order_Date DATE
);


### Question 10 – Load Clean Data

INSERT INTO clean_orders
SELECT
Order_ID,
Customer_ID,
CAST(Sales_Amount AS DECIMAL(10,2)),
Order_Date
FROM orders_data;

SELECT * FROM clean_orders;
