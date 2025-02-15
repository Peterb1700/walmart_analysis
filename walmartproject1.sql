SELECT * from walmart;


--Exploratory Data Analaysis--

SELECT COUNT(*)
FROM walmart;

--returns 9969 total records in this dataset--

SELECT COUNT(DISTINCT payment_method)
FROM walmart;

--ouput shows us that there are 3 distinct payment methods--

SELECT payment_method,
		COUNT(*)
FROM walmart 
GROUP BY 1;

--credit card has 4256 transactions , ewallet has 3881 transactions, cash has 1832 transactions--

SELECT COUNT(DISTINCT branch)
FROM walmart;

--output shows 100 distinct branches in this dataset--

SELECT MAX(quantity) FROM walmart;

--max quantity is 10--

SELECT MIN(quantity) FROM walmart;

--min quantity is 1--

SELECT DISTINCT(category)
FROM walmart;

--output shows us that categories are fashion, electronics, health and beauty, food/beverages, sports/travel, home/lifestyle

SELECT COUNT(DISTINCT city)
FROM walmart;

--there are 98 different cities--


--find distinct payment methods and number of quantity sold--

SELECT 
payment_method,
COUNT(*) as no_payments,
SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY 1 

--credit card has 4256;9567, ewallet has 3881;8932, cash has 1832;4984--

--highest rated category in each branch, rating, category--
--avg rating--subquery and window function--

SELECT * FROM

(SELECT branch,
category,
AVG(rating) as avg_rating,
RANK() OVER( PARTITION BY branch ORDER BY AVG(rating) DESC)
FROM walmart
GROUP BY 1,2
)
WHERE rank = 1 


--busiest day for each branch based on number of transactions--cte 

WITH date_cte AS(
SELECT 
	branch,
	TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
	COUNT(*) as no_transactions,
	RANK() OVER(PARTITION BY branch ORDER BY(COUNT(*)) DESC) as rank
FROM walmart
GROUP BY 1,2
ORDER BY 1, 3 DESC
)

SELECT * 
FROM date_cte 
WHERE rank = 1 


--quantity of items sold per payment method--

SELECT payment_method,
SUM(quantity) as total_qty_sold
FROM walmart
GROUP BY 1

--avg, minimum, maximum rating of each category per city--

SELECT city,
category,
MAX(rating) as max_rating,
MIN(rating) as min_rating,
AVG(rating) as avg_rating
FROM walmart
GROUP BY 1, 2
ORDER BY 1

--total revenue and profit for each category--

SELECT 
category,
SUM(total) as total_revenue,
SUM(total * profit_margin) as profit
FROM walmart
GROUP BY 1 

--most common payment method for each branch, cte and window function--

WITH payment_method_cte AS

(SELECT 
branch,
payment_method,
RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as preferred_payment_method
FROM walmart
GROUP BY 1,2
)
SELECT * FROM
payment_method_cte 
WHERE preferred_payment_method = 1 

--create morning,afternoon,night categories to better segment sales --

ALTER TABLE walmart
ADD COLUMN time_of_day VARCHAR(15)

--added time of day column--

UPDATE walmart 
SET time_of_day=
CASE 
	WHEN EXTRACT(HOUR FROM (time::time)) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END;

--used case statement and added segmented column based on time_of_day with morning, afternoon, evening--

--END OF SQL--