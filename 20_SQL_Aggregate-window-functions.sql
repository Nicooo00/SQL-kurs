-------------------SQL Aggregate functions-----------------

/*
Syntax: AVG(Sales) OVER (PARTITION BY ProductID ORDER BY Sales)
*/

-------------COUNT()------------
/*
Zwraca liczbe wierszy w oknie. Pozwala na kazdy typ danych.
COUNT(*) i COUNT(1) dziala tak samo.
*/

/*task: Find the total number of orders*/

USE SalesDB

SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() as [liczba_wierszy]
FROM Sales.Orders as o

/*task: Find the total orders for each customer*/

SELECT
	CustomerID,
	OrderDate,
	COUNT(*) OVER(PARTITION BY CustomerID) as [window F(X)]
FROM Sales.Orders

/*task: Find the total number of customers, additionally provide all
customers details*/

SELECT
	COUNT(CustomerID) OVER() as [window F(X)],
	ISNULL(TRIM(FirstName), 'unknown') + ' ' + ISNULL(TRIM(LastName),'unknown') as [imie i nazwisko],
	ISNULL(Score,0) as Score
FROM Sales.Customers

/*task: Find the total number of scores for the customers*/

SELECT
	ISNULL(TRIM(FirstName), 'unknown') + ' ' + ISNULL(TRIM(LastName),'unknown') as [imie i nazwisko],
	COUNT(Score) OVER(), 
	COUNT(1) OVER()
FROM Sales.Customers -- w tym zadaniu chodzi o to ze nie mozemy uzyc * bo policzy nam NULL,
-- ktorego nie uznajemy jako score w tabeli
-- its a nice quality check use-case


--USE CASE: Sprawdzamy za pomoca polecenia COUNT() czy mamy duplikaty w naszych danych--

/*task: Check whether the table 'Orders' contains any duplicate rows*/

SELECT
	OrderID,
	COUNT(*) OVER (PARTITION BY	OrderID) CheckPK
FROM Sales.Orders;

SELECT*
FROM(
SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) as [CheckPK]
FROM Sales.OrdersArchive
)t
WHERE CheckPK > 1

-------SUM()-------
/*
Zwraca sume wartosci w obrebie danego okna.
*/

/*task: Find the total sales across all orders and the total sales for each
product. Additionally, provide details such as order ID and order date. */

SELECT
	SUM(Sales) OVER() as [TotalSales],
	SUM(Sales) OVER(PARTITION BY ProductID) as [TotalSalesOfaProduct],
	OrderID,
	OrderDate
FROM Sales.Orders

/*task: Find the percentage contribution of each product's slaes to the total sales */

SELECT
	ProductID,
	Sales,
	SprzedazProduktu,
	ROUND((CAST(SprzedazProduktu AS Float) / CAST(SumaSprzedazy AS Float)) * 100,2) as [Procent (%)],
	SumaSprzedazy
FROM(
SELECT
	ProductID,
	Sales,
	SUM(Sales) OVER(PARTITION BY ProductID) as [SprzedazProduktu],
	SUM(Sales) OVER() as [SumaSprzedazy]
FROM Sales.Orders
)t

-----------AVG()-----------
/*
Zwraca srednia wartosci w danym oknie.
*/

/*task: Find the average sales across all orders and the average sales
for each product. Additionally, provide details such as order Id and order date. */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	AVG(Sales) OVER() as [SredniaALL],
	AVG(Sales) OVER(PARTITION BY ProductID) as [SredniaProduktu]
FROM Sales.Orders

/*task: Find the average scores of customers. 
Additionally, provide details such as Customer ID and Last Name */

SELECT
	CustomerID,
	ISNULL(TRIM(LastName), 'unknown') as [Nazwisko],
	Score,
	AVG(ISNULL(Score,0)) OVER() AvgSales
FROM Sales.Customers

/*task: Find all orders where slaes are higher than the average sales
across all orders */


SELECT
	Sales as [powyzej sreniej]
FROM(
	SELECT
		Sales,
		AVG(Sales) OVER() as [AvgSales]
	FROM Sales.Orders
)t
WHERE Sales > AvgSales


------MIN() and MAX()-------
/*
MIN() zwraca najnizsza wartosc w obrebie okna.
MAX() zwraca najwyzsza wartosc w obrebie okna.
*/

/*task: Find the highest and lowest sales across all orders and the highest and lowest
sales for each product. Additionally, provide details such as order ID and order date. */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	MIN(Sales) OVER() as [MinSales],
	MAX(Sales) OVER() as [MaxSales],
	MIN(Sales) OVER(PARTITION BY ProductID) as [MinProduct],
	MAX(Sales) OVER(PARTITION BY ProductID) as [MaxProduct]
FROM Sales.Orders

/*task: Show the employees with the highest salaries */

SELECT
	FirstName,
	LastName,
	Salary
FROM(
	SELECT
		FirstName,
		LastName,
		Salary,
		MAX(Salary) OVER() as [MaxSalary]
	FROM Sales.Employees
)t
WHERE Salary = MaxSalary
