# STORE BACKGROUND
-- A retail store chain tracks daily sales transactions, including order details, customer info, product categories, order iterms and order status.
-- The business wants to optimize operations, improve customer experience, and increase profitability using data driven decision.
# Problem statement:
-- Because of this, they're missing changes to earn more, losing customers, and making poor business decisions.

# Problem:
-- The store doesn't have a clear idea about:
-- 1. Which product sell the most
-- 2. Customer preference
-- 3. Which items bring in the most profit and 
-- 4. Where things are going wrong in delivery or operations.

# Solutions:
-- They need proper reports and simple insights to understand their sales, customets, and product performance better.

# Why this need to be resolved ?
-- Without poor insights:
-- 1. It'll miss sales opportunities
-- 2. Poor inventory and stafiing decisions
-- 3. Increased operational costs
-- 4. Low customer satisfaction
-- 5. Inaccurate business forecasts
-- Solving this will help increase revenue, improve service quality, optimize operations.

#Business Problems
-- 1. What are the top 5 most selling products by quantity? 
-- 2. Which products are most frequently canceled? 
-- 3. What time of the day has the highest number of purchases? 
-- 4. Who are the top 5 highest spending customers? 
-- 5. Which product categories generate the highest revenue? 
-- 6. What is the return/cancellation rate per product category? 
-- 7. What is the most preferred payment mode? 
-- 8. How does age group affect purchasing behavior? 
-- 9. What’s the monthly sales trend? 
-- 10. Are certain genders buying more specific product categories? 

-- create database yt_project
-- use yt_project
-- 	
CREATE TABLE sales_store (
 transaction_id VARCHAR (15),
 customer_id VARCHAR (15),
 customer_name VARCHAR (30),
 customer_age INT,
 gender VARCHAR (15),
 product_id VARCHAR (15),
 product_name VARCHAR (15),
 product_category VARCHAR (15),
 quantiy INT,
 prce FLOAT,
 payment_mode VARCHAR (15),
 purchase_date DATE,
 time_of_purchase TIME,
 status VARCHAR (15)
 );
SELECT * FROM sales_store;



SELECT COUNT(*) AS total_rows,
       MIN(purchase_date) AS earliest,
       MAX(purchase_date) AS latest,
       SUM(purchase_date = '0000-00-00') AS zero_dates
FROM sales_store;

-- Data clearning
CREATE TABLE sales AS SELECT * FROM sales_store;
SELECT * FROM SALES

-- 1. To check for duplicates.
-- method-1: check the duplicate transaction_id
SELECT transaction_id
FROM sales
GROUP BY transaction_id
HAVING COUNT(transaction_id) >1;
-- method-2: It'll give the number of times each transaction_id is duplicated.
SELECT transaction_id,count(*)
FROM sales
GROUP BY transaction_id
HAVING COUNT(transaction_id) >1;
-- method-3: using window fucntion
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS ROW_NUM
    FROM sales
-- method-3: using CTE
WITH CTE as (
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS ROW_NUM
    FROM sales
)
SELECT * FROM CTE
WHERE Row_Num >1
-- method-4: Reverification
WITH CTE as (
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS ROW_NUM
    FROM sales
)
SELECT * FROM CTE
WHERE transaction_id in ('TXN240646','TXN342128','TXN855235','TXN981773')
-- DELETE THE DUPLICATES:
-- WITH CTE as (
-- SELECT *,
-- 	ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS ROW_NUM
--     FROM sales
--     )
-- DELETE FROM CTE
-- WHERE ROW_NUM=2
-- Error Code: 1288. The target table CTE of the DELETE is not updatable

select count(*) from sales

CREATE TABLE sales_clean AS SELECT DISTINCT * FROM sales;
DROP TABLE sales;
RENAME TABLE sales_clean TO sales;

-- step-2:  correction of headers:
ALTER TABLE sales
	RENAME COLUMN quantiy to quantity,
    RENAME COLUMN prce to price;

select * from sales

-- Step-3: Check datatypes

DESCRIBE sales;

-- Step-4: check null count
SELECT
    COUNT(*)                          AS total_rows,
    SUM(transaction_id    IS NULL)    AS transaction_id,
    SUM(customer_id       IS NULL)    AS customer_id,
    SUM(customer_name     IS NULL)    AS customer_name,
    SUM(customer_age      IS NULL)    AS customer_age,
    SUM(gender            IS NULL)    AS gender,
    SUM(product_id        IS NULL)    AS product_id,
    SUM(product_name      IS NULL)    AS product_name,
    SUM(product_category  IS NULL)    AS product_category,
    SUM(quantity          IS NULL)    AS quantity,
    SUM(price             IS NULL)    AS price,
    SUM(payment_mode      IS NULL)    AS payment_mode,
    SUM(purchase_date     IS NULL)    AS purchase_date,
    SUM(time_of_purchase  IS NULL)    AS time_of_purchase,
    SUM(status            IS NULL)    AS status
FROM sales;


-- treating null value:
SELECT * 
FROM sales 
WHERE 
	transaction_id    IS NULL
    OR 
    customer_id       IS NULL
    OR
    customer_name     IS NULL
    OR
    customer_age      IS NULL
    OR
    gender            IS NULL
    OR 
    product_id        IS NULL
    OR
    product_name      IS NULL
    OR
    product_category  IS NULL
    OR
    quantity          IS NULL
    OR
    price             IS NULL
    OR
    payment_mode      IS NULL
    OR
    purchase_date     IS NULL
    OR
    time_of_purchase  IS NULL
    OR
    status            IS NULL
-- De
DELETE from sales where transaction_id is null

SET SQL_SAFE_UPDATES = 0;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM sales where customer_name='Ehsaan Ram'
UPDATE sales
	SET customer_id='CUST9494'
    WHERE transaction_id ='TXN977900'
    
SELECT * FROM sales where customer_name='Damini Raju'
UPDATE sales
	SET customer_id='CUST1401'
    WHERE transaction_id ='TXN985663'
SELECT * FROM sales where customer_id='CUST1003'
UPDATE sales
	SET customer_name='Mahika Saini',customer_age='35',gender='Male'
		WHERE transaction_id = 'TXN432798'
-- STEP 5: Data cleaning
SELECT distinct gender from sales

UPDATE sales
SET gender = 'F'
WHERE gender='Female'

UPDATE sales
SET gender = 'M'
WHERE gender='Male'

SELECT distinct payment_mode from sales

UPDATE sales
SET payment_mode= 'Credit Card'
WHERE payment_mode='CC'

# DATA ANALYSIS: SOLVING BUSINESS PROBLEMS:
-- 1. What are the top 5 most selling products by quantity? 
SELECT product_name, 
	   sum(quantity) as total_qty_sold
	FROM sales
    WHERE status='delivered'
		GROUP BY product_name
        ORDER BY total_qty_sold DESC
        LIMIT 5
    -- Business problem: We didn't know which products are most in demand.
    -- Business Impact: Helps prioritise stock and boost sales through targated promotions.

-- 2. Which products are most frequently canceled? 
SELECT product_name,
	   count(*) as total_cancelled
FROM sales
WHERE status = 'Cancelled'
GROUP BY product_name
ORDER by total_cancelled DESC
LIMIT 5
    -- Business problem: Frequent cancellations affect revenue and customer trust.
    -- Business Impact: Identify poor performing products to imorove quality or remove from catalog.

-- 3. What time of the day has the highest number of purchases? 

	SELECT
		CASE
			WHEN HOUR(time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
            WHEN HOUR(time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
            WHEN HOUR(time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
            WHEN HOUR(time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
		END AS time_of_day,
        COUNT(*) AS total_order
	FROM sales
    GROUP BY time_of_day
    ORDER BY total_order desc
	-- Business problem: Find peak sales time.
    -- Business Impact: Optimize staffing, promotions, and server loads.
    
   --  4. Who are the top 5 highest spending customers? 

SELECT customer_id,
       customer_name,
       SUM(quantity * price) AS total_spent
FROM sales
WHERE status = 'delivered'
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 5;

	-- Business problem: Identify VIP customers.
    -- Business Impact: Personalised offers, loyality rewards and retention.
    
-- 5. Which product categories generate the highest revenue? 


SELECT product_category,
	CONCAT('₹', FORMAT(SUM(quantity * price),2)) AS revenue
    FROM sales
GROUP BY product_category
ORDER BY SUM(quantity * price) DESC
LIMIT 5

	-- Business problem: Identify top-performing product categories.
    -- Business Impact: allowing the business to invest more in high-margin of high-demand categories.

-- 6. What is the return/cancellation rate per product category? 
-- cancellation
SELECT product_category,
FORMAT(COUNT(CASE WHEN status ='cancelled' THEN 1 END) *100.0/count(*),3)+'%' AS cancelled_percent
FROM sales
GROUP BY product_category
ORDER BY cancelled_percent DESC
-- Return
SELECT product_category,
FORMAT(COUNT(CASE WHEN status ='Returned' THEN 1 END) *100.0/count(*),3)+'%' AS retun_percent
FROM sales
GROUP BY product_category
ORDER BY retun_percent DESC


SELECT product_category,
FORMAT(COUNT(CASE WHEN status ='cancelled' THEN 1 END) *100.0/count(*),3)+'%' AS cancelled_percent,
FORMAT(COUNT(CASE WHEN status ='Returned' THEN 1 END) *100.0/count(*),3)+'%' AS retun_percent
FROM sales
GROUP BY product_category
ORDER BY cancelled_percent DESC


	-- Business problem: Monitor dissatisfaction trends per category.
    -- Business Impact: Helps identify and fix product or logistic issue.

-- 7. What is the most preferred payment mode? 

Select payment_mode,
	  COUNT(*) as usage_count
	FROM sales
    GROUP BY payment_mode
    ORDER BY usage_count DESC
    LIMIT 1
-- Business problem: Knbow which payment options customer prefer.
-- Business Impact: Streamline payment processing, prioritize popular modes.

-- 8. How does age group affect purchasing behavior? 

SELECT
    CASE
        WHEN customer_age IS NULL THEN 'UNKNOWN'
        WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
        WHEN customer_age >= 51 THEN '51+'
        ELSE 'UNKNOWN'
    END AS age_group,
    SUM(price * quantity) AS total_purchase
FROM sales
GROUP BY age_group
ORDER BY total_purchase DESC;

-- Business problem: Understand the customer demographic.
-- Business Impact: Targeted marketing and product recommendations by age group.

-- 9. What’s the monthly sales trend? 
-- method-1
SELECT
    DATE_FORMAT(purchase_date, '%b %Y') AS sales_month,
    SUM(quantity * price) AS total_sales
FROM sales
WHERE status = 'delivered'
GROUP BY sales_month, DATE_FORMAT(purchase_date, '%Y-%m')
ORDER BY DATE_FORMAT(purchase_date, '%Y-%m');
    
-- Business problem: Sales fluctuations go unnoticed.
-- Business Impact: Plan inventory and marketing according to seasonal trends.

-- 10. Are certain genders buying more specific product categories? 

SELECT gender,
	   product_category,
       COUNT(product_category) AS total_purchase
	FROM sales
GROUP BY gender, product_category
ORDER BY gender,product_category DESC


-- Business problem: gender based product preference.
-- Business Impact: personalised ads, gender focused campaigns.


