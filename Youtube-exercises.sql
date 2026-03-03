/*---------------Youtube exercises------------------*/

----------- Select Queries -------------

USE MyDatabase

SELECT *
FROM customers

SELECT *
FROM orders

SELECT 
first_name,
country,
score
FROM customers

SELECT *
FROM customers
WHERE score != 0

SELECT 
	first_name,
	country
FROM customers
WHERE country = 'Germany'

SELECT
first_name
FROM customers
ORDER BY score ASC

SELECT *
FROM customers
ORDER BY 
	country ASC,
	score DESC

SELECT 
	country AS customer_country,
	SUM(score) AS total_score,
	COUNT (id) AS total_customers
FROM customers
GROUP BY country
ORDER BY 
	total_customers DESC,
	total_score DESC

SELECT 
	country,
	AVG(score) AS average_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430
ORDER BY average_score DESC

SELECT * FROM customers

SELECT DISTINCT country
FROM customers

SELECT TOP 2 *
FROM customers
ORDER BY score ASC

SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC



