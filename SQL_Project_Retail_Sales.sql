-- SQL Retail Sales Analysis
-- Basic to Advanced

-- 1) DATABASE & TABLE CREATION
CREATE DATABASE Retail_Sales_Project_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
-- 2) DATA EXPLORATION & CLEANING
-- Determine the total number of records in the dataset 
SELECT 
	COUNT (*)
FROM retail_sales;
-- Identify unique product categories in the dataset
SELECT DISTINCT category 
FROM retail_sales;

-- Find out how many unique customers are in the dataset
SELECT
	COUNT(DISTINCT customer_id)
FROM retail_sales;

--Check for any null values in the dateset
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL 
	OR sale_time IS NULL 
	OR customer_id IS NULL 
	OR gender IS NULL 
	OR age IS NULL 
	OR category IS NULL 
	OR quantity IS NULL 
	OR price_per_unit IS NULL 
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Delete records with missing data that cannot be recovered
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL 
	OR sale_time IS NULL 
	OR customer_id IS NULL 
	OR gender IS NULL 
	OR age IS NULL 
	OR category IS NULL 
	OR quantity IS NULL 
	OR price_per_unit IS NULL 
	OR cogs IS NULL
	OR total_sale IS NULL;

-- 3) DATA ANALYSIS & FINDINGS
-- Retrieve all columns for sales made on '2022-11-05' 
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more than 4 in the month of Nov-2022 
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity >= 4;

-- Calculate the total sales (total_sale) for each category
SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- Find the average age of customers who purchased items from the 'Beauty' category
SELECT
	ROUND(AVG (age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Find all transactions where the total_sale is greater than 1000
SELECT * 
FROM retail_sales
WHERE total_sale >1000;

-- Find the total number of transactions (transaction_id) made by each gender
-- in each category
SELECT
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category,
		 gender
ORDER BY 1;

-- Calculate the average sale for each month. Find best selling month in each year
SELECT
	year,
	month,
	avg_sale
FROM
(SELECT
	EXTRACT(YEAR from sale_date) AS year,
	EXTRACT(month FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank= 1;

-- Find the top 5 Customers based on the highest total sales
SELECT
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- Create each shift and number of orders (Example Morning<12, Afternoon
-- between 12 & 17, Evening >17)
WITH hourly_sale
AS (
SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT (*) as total_orders
FROM hourly_sale
GROUP BY shift;