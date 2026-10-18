---------------CASE WHEN Statement----------------
/*
Sprawdza liste warunkow i zwraca wartosc gdy pierwszy z tych warunkow
jest spelniony.

CASE -- start logiki
	WHEN condition1 THEN result1 -- najwazniejsze warunki powinny byc na gorze

	WHEN condition2 THEN result2

	...

	ELSE result -- w SQL else odpowiada za default value (wykona sie jesli inne conditions beda false)
	-- jesli niezdefiniujemy else a inne warunki beda falszywe to dostaniem NULL

END -- koniec logiki

Glownym celem CASE WHEN statementow jest transformacja danych,
tworzenie nowych kolumn bazujacych na posiadnych juz danych.

Zasada: typ danych wynikow musi byc taki sam we wszystkich warunkach (po then i else).


*/

---USE CASE: Categorizing Data---
/*
Grupowanie danych w rozne kategorie po pewnych warunkach.
*/

USE SalesDB

/*task: Generate a repot showing the total sales for each category:
-High: if the sales are higher than 50,
-Medium: if the sales are between 20 and 50
-Low: if the sales equal or lower than 20 
Sort the result from lowest to highest */

SELECT
	SUM(Sales) as [suma sprzedazy],
	CASE
		WHEN o.Sales > 50 THEN 'High'
		WHEN o.Sales > 20 THEN 'Medium'
		ELSE 'Low'
	END as [kategorie sprzedazy]
FROM Sales.Orders as o
GROUP BY 
	CASE
			WHEN o.Sales > 50 THEN 'High'
			WHEN o.Sales > 20 THEN 'Medium'
			ELSE 'Low'
	END
ORDER BY SUM(Sales) ASC;

-- rozwiazanie barra (ponizej)

SELECT
Category,
SUM(Sales) AS TotalSales
FROM (
SELECT
	OrderID,
	Sales,
		CASE
			WHEN o.Sales > 50 THEN 'High'
			WHEN o.Sales > 20 THEN 'Medium'
			ELSE 'Low'
		END as Category
	FROM Sales.Orders as o
)t
GROUP BY Category
ORDER BY TotalSales DESC;

--NOTE: Wychodzi na to ze latwiej jest cos zgrupowac w jednym zapytaniu, a faktycznie wyswietlic
-- dopiero w innym (subqueries). Jest to wygodne bo aliasy sa duzo bardziej przydatne wtedy.


---------USE CASE: Mapping---------
/*
Tranformacja wartosci z jednej formy na druga.
*/

/*Retrieve employee details with gender displayed as full text*/

SELECT
	EmployeeID,
	CONCAT(TRIM(FirstName),' ',TRIM(ISNULL(LastName,'Kowalska'))) as [imie i nazwisko],
	CASE
		WHEN Gender = 'M' THEN 'Male'
		WHEN Gender = 'F' THEN 'Female'
		ELSE NULL
	END as [Plec]
FROM Sales.Employees as e

/*Retrieve customer details with abbreviated country code*/

SELECT
	id,
	[imie i nazwisko],
	flag
FROM(
SELECT
	CustomerID as id,
	CONCAT(TRIM(FirstName),' ',TRIM(LastName)) as [imie i nazwisko],
	CASE
		WHEN LEN(COUNTRY) > 3 THEN 0
		ELSE 1
	END as flag
FROM Sales.Customers
)t
WHERE flag = 1; -- w tym rozwiazaniu zalozylem ze skrocona nazwa ma 3 znaki i mniej
-- tak zrozumialem te zadanie. rownie dobrze moznaby uzyc left(3) albo tak jak barra
-- mapowac dane (jego rozwiazanie podam ponizej)

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'n/a'
	END CountryAbrr,

	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'n/a'
	END CountryAbrr2 -- tutaj pokazana forma skrocona case when statement, jesli jestemy pewni ze
	--logika bedzie dotyczyc jednej kolumny to mozemy w taki sposob to zapisac

FROM Sales.Customers;

SELECT DISTINCT Country
FROM Sales.Customers;

------USE CASE: Handling NULLS------
/*
Zmienianie NULL na specyficzna wartosc.
*/

/*task: Find the average scores of customers and treat Nulls as 0
And additionaly provide details such as CustomerID & LastName */

SELECT
	CustomerID,
	nazwisko,
	AVG(Score2) OVER() AvgCustomer -- kolejny raz uzyte window functions ktore beda pozniej
FROM(
	SELECT
		CustomerID,
		ISNULL(LastName,'n/a') as nazwisko,
		CASE
			WHEN Score IS NULL THEN 0
			ELSE Score
		END as Score2
	FROM Sales.Customers as c
)t;

------USE CASE: Conditional Aggregations-----
/*
Uzywanie funkcji grupujacych na podzbiorach danych by spelnic pewne warunki.
*/

/*task: Count how many times each customer has made an order with sales greater than 30*/

/*sposob: bedziemy sumowac binarne indykatory(1,0) by pokazac ile razy nasz
warunek jest prawdziwy dla danego klienta.*/

SELECT
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) as flag,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID	
