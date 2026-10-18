-- Lesson 23 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

--------------SQL Subqueries-------------
/*
Kategorie podzapytan on Dependency:
- Non-Correlated Subquery,
- Correlated Subquery,

Kategorie podzapytan on Result Types:
- Scalar,
- Row,
- Table,

Kategorie podzapytan on Location|Clauses
- SELECT,
- FROM,
- JOIN,
- WHERE,
*/

SELECT
AVG(CAST(Sales AS decimal(18,2)))
FROM Sales.Orders -- Scalar query (jedna kolumna, jeden wiersz)

SELECT
	OrderID
FROM Sales.Orders -- podzapytanie kolumnowe (jedna kolumna, wiele wierszy); row subquery zwraca jeden wiersz.

SELECT
	OrderID,
	OrderDate
FROM Sales.Orders -- Table query (wiele kolumn, wiele wierszy)


--------Subquery in FROM clause------
/*
FROM Subquery - uzywamy jako tymczasowas tabele dla Main Query
SYNTAX:

SELECT column1,column2,...
FROM (SELECT column FROM table WHERE condition) AS alias
*/

/*task: Find the products that have higher than the average price of
all products*/

SELECT*
	FROM(
	SELECT
		ProductID,
		Price,
		AVG(CAST(Price AS decimal(18,2))) OVER() [srednia]
	FROM Sales.Products
)t
WHERE Price > srednia

/*task: Rank customers based on their total amount of sales*/

SELECT
	t.*, -- trzeba dac alias po tabeli z ktorej wydobywamy czyli w tym przydapdku t
	RANK() OVER(ORDER BY suma DESC) [ranking]
FROM(
SELECT
	CustomerID,
	SUM(Sales) [suma]
FROM Sales.Orders as o
GROUP BY CustomerID
)t

--------Subquery in SELECT clause--------
/*
Uzywamy SELECT podzapytan aby zaagregowac dane obok siebie
z danymi z glownego zapytania, co pozwala na bezposrednie
porownanie.

SYNTAX:

SELECT
	Column1,
	(SELECT column FROM table1 WHERE condition) AS alias
FROM table1

ZASADA: inner zapytanie musi byc podzapytaniem skalarnym.
*/

/*task: Show the product IDs, names, prices and total number
of orders*/

SELECT
	p.*,
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products as p;


--------JOIN Subquery-------
/*
Uzywa sie tego by przygotowac dane (filtrujac lub agregujac)
przed joinowania go z innymi tabelami.
*/

/*task: Show all customer details and fing the total orders of
each customer*/

SELECT
c.*,
o.TotalOrders
FROM Sales.Customers as c
LEFT JOIN (
	SELECT
		CustomerID,
		COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID


--------WHERE Subquery-------
/*
Uzywa sie dla bardziej skomplikowanej logiki filtrowania danych
i sprawia ze zapytanie jest bardziej elastyczne i dynamiczne.

COMPARISON OPERATORS: uzywamy aby porownac dwie wartosci
<,>,=,!=,>=,<=

LOGICAL OPERATORS:
IN ANY ALL EXISTS

SYNTAX comparison operators:

SELECT column1, column2,...
FROM table1
WHERE column = (SELECT column FROM table2 WHERE condition)      musi to byc skalar

*/

/*task: Find the products that have a price higher than the averaged
price of all products*/

SELECT
p.*,
(SELECT AVG(CAST(Price AS decimal(18,2))) [srednia] FROM Sales.Products) [srednia]
FROM Sales.Products as p
WHERE Price > (SELECT AVG(CAST(Price AS decimal(18,2))) [srednia] FROM Sales.Products)



SELECT
AVG(CAST(Price AS decimal(18,2))) [srednia]
FROM Sales.Products

---------IN Opertaror---------
/*
Sprawdza czy wartosc pasuje do jakielkolwiek wartosci
z listy.

SYNTAX:

SELECT column1, column2,...
FROM table1
WHERE column IN (SELECT column FROM table2 WHERE condition)    NIE musi to byc skalar!
*/

/*task: Show the details of orders made by customers in Germany*/

SELECT*
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany')

-- w analogicznym przykladzie gdzie chcemy zwrocic wszystkich ale nie Niemcow,
-- mozemy uzyc != albo NOT IN


----------ANY & ALL Subqueries---------
/*
ANY - stosuje podany operator porownania (np. >) do wartosci z listy.
Warunek ma byc prawdziwy dla przynajmniej jednej wartosci.

ALL - porownanie ma byc prawdziwe dla kazdej wartosci; dla pustej listy wynik to TRUE.
ANY dla pustej listy daje FALSE. NULL moze wprowadzic UNKNOWN.

SYNTAX:

SELECT column1, column2,...
FROM table1
WHERE column < ANY (SELECT column FROM table2 WHERE condition)
*/

/*task: Find female employees whose salaries are greater than the
salaries of any male employees */

SELECT
	EmployeeID,
	CONCAT(TRIM(FirstName),' ', TRIM(LastName)) [imie i nazwisko],
	Salary
FROM Sales.Employees
WHERE
	Gender = 'F'
	AND Salary > ANY
(SELECT
	Salary
FROM Sales.Employees
WHERE Gender = 'M')

/*task: Find female employees whose salaries are greaten than the
salaries of all male employees */

SELECT
	FirstName,
	ISNULL(LastName,'Kowalska') [Nazwisko],
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL
(SELECT Salary FROM Sales.Employees WHERE Gender = 'M')



----------Dependencies of Subqueries----------

/*

Non-Correlated Subquery - podzapytanie ktore moze dzialac niezaleznie od Main Query
(mozna wykonac bez Main Query)
Liczba fizycznych wykonan zalezy od planu; brak korelacji nie gwarantuje jednego wykonania ani szybkosci.
For static comparisons.

Correlated Subquery - podzapytanie krote polega na wartosciach z Main Query
(nie mozna wykonac bez Main Query)
Logicznie zalezy od biezacego wiersza, ale optymalizator moze je przeksztalcic np. w JOIN.
Wydajnosc zalezy od planu i indeksow, nie samej korelacji.
For row-by-row comparisons or Dynamic Filtering

*/

/*task: Show all customer details and find the orders for each customer*/

SELECT
	c.*,
	ISNULL(licznik,0) [licznik]
FROM Sales.Customers as c
LEFT JOIN (SELECT CustomerID,COUNT(*) as [licznik] FROM Sales.Orders GROUP BY CustomerID) as o
ON c.CustomerID = o.CustomerID


SELECT
*,
(SELECT COUNT(*) [count] FROM Sales.Orders as o WHERE o.CustomerID = c.CustomerID) [totalSales]
-- tu jak damy zamiast c.CustomerID np. 1 albo 2 to count zliczy nam ile zamowien ma dany klient
FROM Sales.Customers as c



------------EXISTS-----------
/*
Sprawdza czy podzapytanie zwraca jakies wiersze.

SYNTAX:

SELECT column1, column2,...

FROM Table2

WHERE EXISTS (SELECT 1
			  FROM Table1)
			  WHERE Table.ID = Table2.ID)


*/

/*task: Show the order datails for customers in Germany*/

SELECT
	OrderID,
	CustomerID,
	OrderDate
FROM Sales.Orders as o
WHERE EXISTS(SELECT 1 FROM Sales.Customers as c WHERE o.CustomerID = c.CustomerID AND c.Country = 'Germany')

-- NOT EXISTS zwroci zamowienia bez pasujacego klienta z Niemiec,
-- takze bez dopasowanego klienta; to nie zawsze to samo co Country <> 'Germany'.
-- Uwaga na NOT IN: NULL w podzapytaniu moze zmienic wynik na UNKNOWN.
