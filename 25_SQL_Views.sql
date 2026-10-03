-----------------SQL Views-----------------
/*
Views to wirtualna tabele oparta na wyniku zapytania, bez przechowywania danych w bazie danych.
Nie mozna do nich nic dopisac bo to tylko widoki ale mozna je zmieniac duzo latwiej niz tabele.
Querying views zawsze jest wolniejsze bo baza danych musi wykonac tez zapytanie z widoku, a nie tylko
z tabeli. Widoki to wirtualny layer a tabale to fizyczny layer.
Widoki to zapisane na stale zapytanie SQL w bazie danych.

SYNTAX:

CREATE VIEW View-Name AS
(
SELECT...
FROM...
WHERE...
)

*/

------USE CASE: Central Query Logic------
/*
Przechowuje centralna, skomplikowana logike zapytania w bazie danych
do dostepu przez wiele zapytan, co ogranicza zlozonosc projektu.
*/

/*task: Find the running total of sales for each month*/

SELECT
	OrderID,
	OrderDate,
	DATENAME(MONTH,OrderDate) [miesiace],
	SUM(Sales) OVER(PARTITION BY DATENAME(MONTH,OrderDate) ORDER BY OrderDate ASC
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) [running total]
FROM Sales.Orders
ORDER BY OrderDate ASC;

--rozw barry

WITH CTE_Monthly_Summary AS
(
SELECT
DATETRUNC(month,OrderDate) OrderMonth,
SUM(Sales) TotalSales,
COUNT(OrderID) TotalOrders,
SUM(Quantity) TotalQuntities
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate)
)
SELECT
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER(ORDER BY OrderMonth) AS [RunningTotal]
FROM CTE_Monthly_Summary;

--------utworzono view w innym zapytniu (patrz nizej)

SELECT*
FROM Sales.V_Monthly_Summary

--NOTE: jesli tworzymy tabele albo widok bez okreslonego schematu,
-- to domyslnie bedzie to dbo.

SELECT
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER(ORDER BY OrderMonth) AS [RunningTotal]
FROM Sales.V_Monthly_Summary;

-------------------------------------------------------------------------------------------

DROP VIEW Sales.V_Monthly_Summary

IF OBJECT_ID ('Sales.V_Monthly_Summary', 'V') IS NOT NULL
	DROP VIEW Sales.V_Monthly_Summary;
GO

CREATE VIEW Sales.V_Monthly_Summary AS
(
	SELECT
	DATETRUNC(month,OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders
	FROM Sales.Orders
	GROUP BY DATETRUNC(month,OrderDate)
)

DROP VIEW dbo.V_Monthly_Summary

--NOTE: W postgresie mozna uzyc komendy CREATE OR REPLACE jak chcemy zupdatowac view

/*
Jesli chcemy zmienic view to mozemy zrobic drop view create view od nowa,
a jesli nie to uzyjemy T-SQL.
Transact-SQL to rozszerzenie SQL ktore dodaje programistyczna funkcjonalnosc.
*/
---------------------------------------------------------------------------------------------




