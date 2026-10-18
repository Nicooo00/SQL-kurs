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

GO

DROP VIEW dbo.V_Monthly_Summary

--NOTE: W postgresie mozna uzyc komendy CREATE OR REPLACE jak chcemy zupdatowac view

/*
Jesli chcemy zmienic view to mozemy zrobic drop view, create view od nowa,
a jesli nie to uzyjemy T-SQL.
Transact-SQL to rozszerzenie SQL ktore dodaje programistyczna funkcjonalnosc.
*/
---------------------------------------------------------------------------------------------

----USE CASE 2: Hide complexity-----
/*
Widoki moga byc uzywane by ukryc zlozonosc tabel w bazie danych i oferuja
uzytkownikom bardziej przyjazne i prostsze do zrozumienia obiekty.
*/

/*task: Provide a view that combines details from orders, products,customers
and employees*/

CREATE VIEW Sales.V_Order_Details AS
(
SELECT
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	CONCAT(ISNULL(c.FirstName,''),' ',ISNULL(c.LastName,'')) [customerName],
	c.Country [kraj],
	CONCAT(ISNULL(e.FirstName,''),' ',ISNULL(e.LastName,'')) [employeeName],
	e.Department,
	o.Sales,
	o.Quantity
FROM Sales.Orders as o
LEFT JOIN Sales.Products as p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Customers as c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Employees as e
ON o.SalesPersonID = e.EmployeeID
)
----------------------------------------------------------------------------------

SELECT*
FROM Sales.V_Order_Details

------------USE CASE: Data Security-----------
/*
Uzywaj widokow aby wymusic bezpieczenstwo i ochronic dane wrazliwe
przez ukrywanie kolumn i/lub wiersz z tabel.
*/

/*task: Provide a view for the EU Sales Team that combines details from
all tables and excludes data related to the USA*/
--------------------------------------------------------------------------------------
IF OBJECT_ID ('Sales.V_EU_Sales_Data','V') IS NOT NULL
	DROP VIEW Sales.V_EU_Sales_Data
GO


CREATE VIEW Sales.V_EU_Sales_Data AS
(
SELECT
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	CONCAT(ISNULL(c.FirstName,''),' ',ISNULL(c.LastName,'')) [customerName],
	c.Country [kraj],
	CONCAT(ISNULL(e.FirstName,''),' ',ISNULL(e.LastName,'')) [employeeName],
	o.Sales,
	o.Quantity
FROM Sales.Orders as o
LEFT JOIN Sales.Products as p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Customers as c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Employees as e
ON o.SalesPersonID = e.EmployeeID
WHERE c.Country != 'USA'
)

GO

DROP VIEW dbo.V_EU_Sales_Data
---------------------------------------------------------------------------------------

-------USE CASE: Flexibility and Dynamic-------
/*
Widoki daja nam swobode editowania tabel i zmiania ich bez potrzeby
by inne osoby uczyly sie na nowo naszych nowych nazw i struktur tabel.
*/

------USE CASE: Multiple Languages-------
/*
Dzieki widokom mozemy pokazywac nazwy kolumn, tabel w innych jezykach,
dla partnerow miedzynarodowych.
*/

------USE CASE: Virtual Data Marts in DWH-------
/*
Widoki mogą służyć jako hurtownie tematyczne (Data Marts) w systemie hurtowni danych,
ponieważ zapewniają elastyczny i wydajny sposób prezentowania danych.
Chodzi o to aby miec fizyczne dane w jednym miejscu i zbudowac nad nimi
poziom wirtualny (widoki).
*/

