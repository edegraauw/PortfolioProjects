-- Walmart Sales Data SQL Project

-- Data Cleaning
SELECT *
FROM `walmartsalesdata.csv`;

-- Add the time_of_day_column
SELECT 
	time,
    (CASE WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
		END) AS time_of_day
FROM `walmartsalesdata.csv`;


ALTER TABLE `walmartsalesdata.csv` ADD COLUMN time_of_day VARCHAR(20);

UPDATE `walmartsalesdata.csv`
SET time_of_day = (
		CASE
			WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
            WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
            ElSE "Evening"
            END);
            
-- Add month_name column
SELECT
	date,
    MONTHNAME(date)
FROM `walmartsalesdata.csv`;

ALTER TABLE `walmartsalesdata.csv` ADD COLUMN month_name VARCHAR(10);

UPDATE `walmartsalesdata.csv`
SET month_name = MONTHNAME(date);

-- -----------------------------------------------------------------------
-- ---------------------- GENERAL QUESTIONS ------------------------------
-- -----------------------------------------------------------------------
-- How many unique cities does the data have? (3: Yangon, Naypyitaw, and Mandalay)
SELECT
	DISTINCT city
FROM `walmartsalesdata.csv`;


-- In which city is each branch? (Yangon - Branch A | Naypyitaw - Branch C | Mandaylay - Branch B)
SELECT
	DISTINCT city,
    branch
FROM `walmartsalesdata.csv`;

-- --------------------------------------------------------------------------
-- ------------------- PRODUCT QUESTIONS ------------------------------------
-- --------------------------------------------------------------------------
-- How many unique product lines does the data have? (6: Health & Beauty | Electronic Accessories| Home & Lifestyle | Sports & Travel | Food and Beverages | Fashion Accessories)
SELECT
	DISTINCT Product_line
FROM `walmartsalesdata.csv`;


-- What is the most selling product line? (Electronic accessories with 971 sales & the least sales come from Health & Beauty with 854)
SELECT
	SUM(quantity) AS qty,
    Product_line
FROM `walmartsalesdata.csv`
GROUP BY Product_line
ORDER BY qty DESC;


-- What is the total revenue by month? (Jan $116,291.86 Feb $97,219.37 | Mar $109,455.50)
SELECT
	month_name AS month,
    SUM(total) AS total_revenue
FROM `walmartsalesdata.csv`
GROUP BY month_name
ORDER BY total_Revenue;


-- What month had the largest COGS? (Jan with a total of cost of $110,754.16)
SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM `walmartsalesdata.csv`
GROUP BY month_name
ORDER BY cogs DESC;


-- What product line had the largest revenue? (Food & Beverages with a total revenue of $56,144.84)
SELECT
	Product_line,
    SUM(total) AS total_revenue
FROM `walmartsalesdata.csv`
GROUP BY Product_line
ORDER BY total_revenue DESC;


-- What city has the largest total revenue? (Naypyitaw has the largest total revenue at $110,568.70)
SELECT
	city,
    branch,
    SUM(total) AS total_revenue
FROM `walmartsalesdata.csv`
GROUP BY city, branch
ORDER BY total_revenue DESC;


-- Which branch sold more products than the average product sold? (Branch A with 1859 over the average)
SELECT
	branch,
    SUM(quantity) AS qnty
FROM `walmartsalesdata.csv`
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM `walmartsalesdata.csv`);


-- What is the most common product line by gender? (Female customers: Fashion Accessories | Male Customers: Health & Beauty)
SELECT
	gender,
    Product_line,
    COUNT(gender) AS total_cnt
FROM `walmartsalesdata.csv`
GROUP BY gender, Product_line
ORDER BY total_cnt DESC;


-- What is the average rating of each product line 0-10? (Food & Beverage: 7.11 | Fashion Accessories: 7.03 | Health & Beauty: 7 | Electronic Accessories: 6.92 | Sports & Travel: 6.92 | Home & Lifestyle: 6.84)
SELECT
	ROUND(AVG(rating), 2) AS avg_rating,
    Product_line
FROM `walmartsalesdata.csv`
GROUP BY Product_Line
ORDER BY avg_rating DESC;

-- ---------------------------------------------------------------------------
-- --------------------------- CUSTOMERS -------------------------------------
-- ---------------------------------------------------------------------------
-- How many unique customer types does the data have? (2: Member | Normal)
SELECT
	DISTINCT `Customer type`
FROM `walmartsalesdata.csv`;


-- How many unique payment methods does the data have? (3: Ewallet | Cash | Credit Card)
SELECT
	DISTINCT payment
FROM  `walmartsalesdata.csv`;



-- What time of day do customers give most raitings per branch? (Evening for all branches. Changed branch = "A" "B" "C" for each branch - A: 7.02 | B: 6.81 | C: 7.07)
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM `walmartsalesdata.csv`
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which of the customer types brings the most revenue? (Member $164,223.44 | Normal $158,743.30)
SELECT
	`Customer type`,
    SUM(total) AS total_revenue
FROM `walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY total_revenue DESC;

-- --------------------------------------------------------------------------