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
	CONCAT(ISNULL(ROUND((CAST(SumOfSales AS FLOAT) - CAST(LAG(SumOfSales,1,0) OVER(ORDER BY miesiace)AS FLOAT))
	/ CAST(LAG(SumOfSales) OVER(ORDER BY miesiace) AS FLOAT) * 100,2),0),'%') [(MoM) percentage change]
FROM(
SELECT
	DATENAME(MONTH,OrderDate) [miesiace],
	SUM(Sales) [SumOfSales]
FROM Sales.Orders
GROUP BY DATENAME(MONTH,OrderDate)
)t;

SELECT
	DATENAME(MONTH,OrderDate) [miesiace],
	SUM(Sales) [SumOfSales]
FROM Sales.Orders
GROUP BY DATENAME(MONTH,OrderDate);

--USE CASE: Customer Retention Analysis---
/*
Mierzy zachowanie i lojalnosc klientow by pomoc biznesowi budowac 
silne relacje z klinentami.
*/

/*task: Analyze customer loyalty by ranking customers based on tyhe averaged number of
days between orders */

SELECT
	CustomerID,
	AVG(ileDni) [srednia],
	RANK() OVER(ORDER BY
		CASE
			WHEN AVG(ileDni) IS NULL THEN 1 ELSE 0 
		END ASC,
		AVG(ileDni))
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
	RANK() OVER(ORDER BY AVG(ileDni)) [ranking],
	CustomerID,
	AVG(ileDni) [srednia]
FROM(
	SELECT
		CustomerID,
		OrderDate,
		DATEDIFF(day,LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate),OrderDate) [ileDni]
	FROM Sales.Orders
)t
GROUP BY CustomerID
HAVING AVG(ileDni) IS NOT NULL

---lub---

SELECT 
    ROW_NUMBER() OVER(
        ORDER BY 
            CASE WHEN AVG(ileDni) IS NULL THEN 1 ELSE 0 END ASC, 
            AVG(ileDni) ASC
    ) [ranking],
    CustomerID,
    AVG(ileDni) [srednia]
FROM (
    SELECT 
        CustomerID,
        OrderDate,
        DATEDIFF(day, LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) [ileDni]
    FROM Sales.Orders
) t
GROUP BY CustomerID
ORDER BY 
    CASE WHEN AVG(ileDni) IS NULL THEN 1 ELSE 0 END ASC, 
    AVG(ileDni) ASC;



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

















