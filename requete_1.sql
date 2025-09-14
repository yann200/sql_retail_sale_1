-- SQL RETAIL SALES ANALYSES

create database p1_retail_db ;

use p1_retail_db ;

-- CREATE TABLES

drop tables if exists retail_sales_table;

CREATE TABLE retail_sales_table (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);



select * from retail_sales_table;


truncate table retail_sales_table;



-- CHARGER DATA

LOAD DATA LOCAL INFILE 'C:/Users/noume/Downloads/Retail_sales_analysis.csv'
INTO TABLE retail_sales_table
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


select count(*) from retail_sales_table;

-- 
select * 
from retail_sales_table
where transactions_id IS NULL;


-- DATA CLEANING

select *
from retail_sales_table
where 
transactions_id IS NULL
or sale_date is null
or sale_time is null
 or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
;

describe retail_sales_table;

--
delete from retail_sales_table
where 
transactions_id IS NULL
or sale_date is null
or sale_time is null
 or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
;

-- DATA EXPLORATION
-- how many sales we have
select count(*) as total_sale from retail_sales_table;


-- unique customers
select count(distinct customer_id) as total_sale from  retail_sales_table;

-- category we have

select distinct category from retail_sales_table;

-- data analysis & business key problems

-- Q1 retrieve all columns from sales made on '2022-11-05'
select *
from retail_sales_table
where sale_date = '2022-11-05';

-- Q2 retrieve all transactions where the category is 'clothing , quantity sold more than 4 and the month of Nov-2022'

SELECT *
FROM retail_sales_table
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;

-- Q3 calculate total sales (total_sale) for each category

select category, sum(total_sale)
from retail_sales_table
group by 1;

-- Q4 find the average age of customers who purchased items from the buty category
select round(avg(age), 2)
from retail_sales_table
where category = 'beauty';
-- Q5 transactions where the total_sale is greater than 1000
select * 
from retail_sales_table
where total_sale > 1000;



-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(*)
from retail_sales_table
group by category, gender
order by 1;

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select *
from (
SELECT year,
       month,
       avg_total_sale,
       RANK() OVER (PARTITION BY year ORDER BY avg_total_sale DESC) AS rank_in_year
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_total_sale
    FROM retail_sales_table
    GROUP BY year, month
) AS monthly_sales ) as ranked_sales
where rank_in_year = 1;

-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id, sum(total_sale) as total_sales
from retail_sales_table
group by 1
order by 2 desc
limit 5;


-- Q9  Write a SQL query to find the number of unique customers who purchased items from each category
select category, count(distinct(customer_id))
from retail_sales_table
group by 1;

-- Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) 

WITH hourly_sale
AS
(
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
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
	

