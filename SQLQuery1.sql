--use MyDatabase
--select
--coffee_name as product_name,
--sum(quantity)as quantity,

--Top-Selling Products on a Single Day
SELECT  coffee_name AS product_name,
 SUM(quantity) AS total_quantity,
  SUM(total) AS total_price,
  Time_of_Day as shift,
  date
FROM coffeshop
GROUP BY  date, coffee_name,
time_of_day
order by total_price desc;
--Top-Selling Products in a Day
SELECT  coffee_name AS product_name,
 SUM(quantity) AS total_quantity,
  SUM(total) AS total_price,
  Time_of_Day as shift,
  date
FROM coffeshop
where date='2024-10-02'
GROUP BY  date, coffee_name,
time_of_day
order by total_price desc;
--Top-Selling Products by Shift
SELECT
  coffee_name AS product_name,
  SUM(quantity) AS total_quantity,
 SUM(total) AS total_price,
 Time_of_Day as shift
FROM coffeshop
WHERE coffee_name IN ('latte', 'hot chocolate', 'americano')
GROUP BY coffee_name,Time_of_Day
order by total_price  desc 

--Best-Selling Month

 WITH monthly_sales AS (
  SELECT
    coffee_name,
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(total) AS total_sales
  FROM coffeshop
  GROUP BY
    coffee_name,
    YEAR(Date),
    MONTH(Date)
)

SELECT
  coffee_name,
  year,
  month,
  total_sales,
  LAG(total_sales) OVER (
    PARTITION BY coffee_name
    ORDER BY year, month
  ) AS prev_month_sales,
  total_sales - LAG(total_sales) OVER (
    PARTITION BY coffee_name
    ORDER BY year, month
  ) AS diff_from_prev_month
FROM monthly_sales
where coffee_name = 'latte' ;

-- Highest Growth Month


WITH monthly_sales AS (
  SELECT
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(total) AS total_sales
  FROM coffeshop
  GROUP BY YEAR(Date), MONTH(Date)
)

SELECT TOP 1
  year,
  month,
  total_sales
FROM monthly_sales
ORDER BY total_sales DESC;

--- ÇáÇßËÑ äãæ

WITH monthly_sales AS (
  SELECT
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(total) AS total_sales
  FROM coffeshop
  where coffee_name='latte'
  GROUP BY YEAR(Date), MONTH(Date)
),
lagged_sales AS (
  SELECT
    year,
    month,
    total_sales,
    LAG(total_sales) OVER (
      ORDER BY year, month
    ) AS prev_month_sales,
    total_sales - LAG(total_sales) OVER (
      ORDER BY year, month
    ) AS growth_value
  FROM monthly_sales
)

SELECT TOP 1
  year,
  month,
  total_sales,
  growth_value
FROM lagged_sales
WHERE prev_month_sales IS NOT NULL
ORDER BY growth_value DESC;

-- another way
WITH monthly_sales AS (
    SELECT
        YEAR(Date) AS year,
        MONTH(Date) AS month,
        SUM(CASE 
                WHEN coffee_name = 'Latte' THEN total 
                ELSE 0 
            END) AS total_sales
    FROM coffeshop
    GROUP BY YEAR(Date), MONTH(Date)
),
lagged_sales AS (
    SELECT
        year,
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY year, month) AS prev_month_sales,
   total_sales - LAG(total_sales) OVER (ORDER BY year, month)  AS growth_value
   FROM monthly_sales
)
SELECT TOP 1
    year,
    month,
    total_sales,
    growth_value
FROM lagged_sales
WHERE prev_month_sales IS NOT NULL
ORDER BY growth_value DESC;



