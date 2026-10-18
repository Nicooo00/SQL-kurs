-- Lesson 22 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

---------SQL Value Window Functions----------

-------LEAD() & LAG()-------
/*
LEAD() - Dostaje dostep do wartosci z nastepnego wiersza w obrebie okna.
LAG() -  Dostaje dostep do wartosci z poprzedniego wiersza w obrebie okna.

SYNTAX:

LEAD(expr,offset,default)
LAG(expr,offset,default)

LEAD(Sales,2,10) OVER(PARTITION BY ProductID ORDER BY OrderDate)

- Expr jest wygagane, moze to byc kazdy typ danych
- 2 to nasz offset, mowi on ile ma pojsc do przodu/tylu i zwrocic wartosc (optional)
default: 1
-10 to nasza default value jesli nie mozna dostac dostepu do nastepnych/poprzednich wierszy (optional)
default: NULL
- ORDER BY jest wymagany!
*/

---USE CASE: Month-Over-Month ANALYSIS---

/*task: Analyze the month-over-month (MoM) peformance by finding the percentage change
in sales between the current and previous month */

/*
Year-over-Year (YoY) - analiza ogolnego trendu wzrostu lub spadku wydajnosci biznesu na przestrzeni czasu.
Month-over-Month (Mom) - analiza krotkotrwalych trendow i odkrywanie wzorow w sezonowosci.
*/

SELECT
	miesiace,
	SumOfSales,
	ROUND(100.0 * (SumOfSales - PreviousSales) / NULLIF(PreviousSales, 0), 2) AS [MoM percentage change]
FROM (
	SELECT
		miesiace,
		SumOfSales,
		LAG(SumOfSales) OVER(ORDER BY miesiace) AS PreviousSales
	FROM (
		SELECT
			DATETRUNC(month, OrderDate) AS miesiace,
			SUM(Sales) AS SumOfSales
		FROM Sales.Orders
		GROUP BY DATETRUNC(month, OrderDate)
	) AS monthly
) AS changes
ORDER BY miesiace;
-- Sortujemy po dacie z rokiem, nie po nazwie miesiaca.
-- Pierwszy miesiac i zerowy poprzedni wynik daja NULL, nie sztuczne 0%.
-- To porownanie z poprzednim dostepnym miesiacem. Przy lukach potrzebny jest kalendarz.

SELECT
	DATETRUNC(month,OrderDate) AS miesiace,
	SUM(Sales) AS SumOfSales
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate);

--USE CASE: Customer Retention Analysis---
/*
Mierzy zachowanie i lojalnosc klientow by pomoc biznesowi budowac
silne relacje z klinentami.
*/

/*task: Analyze customer loyalty by ranking customers based on tyhe averaged number of
days between orders */

SELECT
	CustomerID,
	AVG(CAST(ileDni AS decimal(18,2))) [srednia],
	RANK() OVER(ORDER BY
		CASE
			WHEN AVG(CAST(ileDni AS decimal(18,2))) IS NULL THEN 1 ELSE 0
		END ASC,
		AVG(CAST(ileDni AS decimal(18,2))))
FROM(
SELECT
	CustomerID,
	OrderDate,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC) [nastepneZamowienie],
	DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC)) [ileDni]
FROM Sales.Orders
)t
GROUP BY CustomerID


-----------

SELECT
	RANK() OVER(ORDER BY AVG(CAST(ileDni AS decimal(18,2)))) [ranking],
	CustomerID,
	AVG(CAST(ileDni AS decimal(18,2))) [srednia]
FROM(
	SELECT
		CustomerID,
		OrderDate,
		DATEDIFF(day,LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate),OrderDate) [ileDni]
	FROM Sales.Orders
)t
GROUP BY CustomerID
HAVING AVG(CAST(ileDni AS decimal(18,2))) IS NOT NULL

---lub---

SELECT
    ROW_NUMBER() OVER(
        ORDER BY
            CASE WHEN AVG(CAST(ileDni AS decimal(18,2))) IS NULL THEN 1 ELSE 0 END ASC,
            AVG(CAST(ileDni AS decimal(18,2))) ASC
    ) [ranking],
    CustomerID,
    AVG(CAST(ileDni AS decimal(18,2))) [srednia]
FROM (
    SELECT
        CustomerID,
        OrderDate,
        DATEDIFF(day, LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) [ileDni]
    FROM Sales.Orders
) t
GROUP BY CustomerID
ORDER BY
    CASE WHEN AVG(CAST(ileDni AS decimal(18,2))) IS NULL THEN 1 ELSE 0 END ASC,
    AVG(CAST(ileDni AS decimal(18,2))) ASC;



------FIRST_VALUE() & LAST_VALUE()------
/*
FIRST_VALUE() - ma dostep do wartosci z pierwszego wiersza w oknie
LAST_VALUE() - ma dostep do ostatniego wiersza w oknie
*/

/*task: Find the lowest and highest sales for each product*/


SELECT
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) [najwiekszaWartosc],
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC ROWS BETWEEN CURRENT ROW AND
	UNBOUNDED FOLLOWING) [najmniejszaWartosc]
FROM Sales.Orders

/*task: Find the difference is sales between the current and the lowest sales*/

SELECT
	ProductID,
	Sales,
	OrderDate,
	ABS(Sales - MIN(Sales) OVER(PARTITION BY ProductID)) [LsDiff]
FROM Sales.Orders
