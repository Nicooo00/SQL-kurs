----------SQL CTE's (common table expressions)-----------

/*
Common Table Expression - Tymczasowy, nazwany set wynikow (tabela wirtualna),
ktora moze byc uzywana kilka razy w twoim query by uproscic i zorganizowac
skomplikowane zapytania.

Typy CTE's:
- Non-Recursive CTE dzieli sie na:
--- standalone CTE,
--- Nested CTE,

- Recursive CTE dzieli sie na:
--- 
--- 

Non-Recursive CTE - jest wykonywane tylko raz bez zadnych powtorzen

Recursive CTE - zapytanie odwolujace sie same do siebie, ktore
przetwarza dane w petli az nie zostanie spelniony okreslony warunek
*/



------------Standalone CTE------------
/*
Zdefiniowane i uzywane niezaleznie.
Dziala niezaleznie poniewaz jest zawarte same w sobie
i nie polega na innych CTE i zapytaniach.

Syntax:

WITH CTE-Name AS
(
SELECT... 
FROM...            --ten srodek tego nawiasu to CTE query
WHERE...
)

SELECT ...
FROM CTE-Name      -- main query (tu jest CTE usage)
WHERE ...

ZASADA CTE: Nie mozna uzyc ORDER BY bezposrednio w CTE,
ale mozna w Main Query potem

*/

----------Multiple Standalone CTE's---------
/*
Syntax:

WITH CTE-Name AS
(
SELECT... 
FROM...           
WHERE...
)
, CTE-Name2 AS     -- tylko pierwsze zapytanie bedzie uzywalo klauzuli WITH
(
SELECT...
FROM ...
WHERE...
)                  -- mozemy miec tyle CTE ile chcemy

SELECT...
FROM CTE-Name    
JOIN CTE-Name2
WHERE...
*/

/*task:  1.Find the total Sales Per Customer (standalone CTE)
2.Find the last order date for each customer (standalone CTE)


*/


WITH [CTE_Sum_Of_Sales] AS
(
SELECT
	o.CustomerID,
	SUM(Sales) [sumaSprzedazy]
FROM Sales.Orders as o
GROUP BY o.CustomerID
), [CTE_Last_Order] AS
(
SELECT
	CustomerID,
	MAX(OrderDate) [Last_Order]
FROM Sales.Orders
GROUP BY CustomerID
)
--Main Query--
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	ctes.sumaSprzedazy,
	ctel.Last_Order
FROM Sales.Customers as c
LEFT JOIN CTE_Sum_Of_Sales as ctes ON
c.CustomerID = ctes.CustomerID
LEFT JOIN CTE_Last_Order as ctel ON
c.CustomerID = ctel.CustomerID



------------NESTED CTE-----------
/*
CTE w srodku innego CTE. Nested CTE uzywa wynikow innego CTE,
dlatego nie moze dzialac niezaleznie.

Syntax:

WITH CTE-Name1 AS      -- standalone CTE(moze samo dzialac)
(
SELECT...
FROM...
WHERE...
),
CTE-Name2 AS          -- Nested CTE(nie moze samo dzialac)
(
SELECT...
FROM CTE-Name1
WHERE...
)

SELECT...             -- Main Query 
FROM CTE-Name2        -- mozemy tez brac dane z CTE-Name1
WHERE...
*/

/*task: Step 3: Rank Customers based on total sales per customer
task: Step 4: Segment customers based on their total sales*/

WITH [CTE_Sum_Of_Sales] AS                            
(
SELECT
	o.CustomerID,
	SUM(Sales) [sumaSprzedazy]
FROM Sales.Orders as o
GROUP BY o.CustomerID
), [CTE_Last_Order] AS
(
SELECT
	CustomerID,
	MAX(OrderDate) [Last_Order]
FROM Sales.Orders
GROUP BY CustomerID
), [CTE_Ranking] AS
(
SELECT
	CustomerID,
	RANK() OVER(ORDER BY sumaSprzedazy DESC) [ranking]
FROM CTE_Sum_Of_Sales
), [CTE_Customer_Segments] AS
(
SELECT
	c.CustomerID,
	sumaSprzedazy,
	CASE
		WHEN sumaSprzedazy > 100 THEN 'Good'
		WHEN sumaSprzedazy < 100 AND sumaSprzedazy > 50 THEN 'Ok'
		ELSE 'Bad'
	END [segmenty]
FROM Sales.Customers as c
LEFT JOIN CTE_Sum_Of_Sales as sos ON
sos.CustomerID = c.CustomerID
)
--Main Query--
SELECT
	cter.ranking,
	c.CustomerID,
	c.FirstName,
	c.LastName,
	ctes.sumaSprzedazy,
	ctel.Last_Order,
	ctese.segmenty
FROM Sales.Customers as c
LEFT JOIN CTE_Sum_Of_Sales as ctes ON
c.CustomerID = ctes.CustomerID
LEFT JOIN CTE_Last_Order as ctel ON
c.CustomerID = ctel.CustomerID
LEFT JOIN CTE_Ranking as cter ON
c.CustomerID = cter.CustomerID
LEFT JOIN CTE_Customer_Segments as ctese ON
c.CustomerID = ctese.CustomerID
ORDER BY 
	CASE
		WHEN cter.ranking IS NULL THEN 1 ELSE 0
	END,
	ranking ASC


--------------BEST PRACTICES-------------
/*
Przemysl i refaktoruj swoje CTE zanim napiszesz nowy.
Pomysl czy mozesz np. polaczyc stare CTE zanim napiszesz nowy.

Nie uzywaj wiecej niz 5 CTEs w jednym zapytaniu; inaczej twoj kod
bedzie ciezki do zrozumienia i utrzymania. (moze lepiej bedzie
rozdzielic jedno zapytanie na dwa na przyklad)
*/


------------Recursive CTE-----------
/*
Recursive CTE - zapytanie odwolujace sie same do siebie, ktore
przetwarza dane w petli az nie zostanie spelniony okreslony warunek

SYNTAX:

WITH CTE-Name AS
(
SELECT                  -- anchor query (wykona sie tylko raz, taki pierwszy step)
FROM
WHERE

UNION ALL/UNION 

SELECT                 --  recursive query (bedzie sie wykonywac az do break condition
					   --  lub do konca danych)
FROM CTE-Name
WHERE [break condition]
)
SELECT...              -- main query
FROM CTE-Name
WHERE...
*/

/*task: Generate a Sequence of Numbers from 1 to 20*/

WITH Series AS
(
--Anchor Query
SELECT
	1 AS MyNumber
UNION ALL
-- Recursive Query
SELECT
MyNumber + 1       -- tak sie da
FROM Series
WHERE MyNumber < 1000
)
-- Main Query
SELECT*
FROM Series
OPTION (MAXRECURSION 5000)  -- tak ograniczamy liczbe maksymalnych iteracji petli
-- domyslny limit to 100 ale mozemy ustawic go na wyzszy

/*task: Show the employee hierarchy by displaying each
employees level within the organization */

WITH CTE_Emp_Hierarchy AS
(
--Anchor Query
SELECT
	EmployeeID,
	FirstName,
	ManagerID,
	1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL

UNION ALL
--Recursive Query

SELECT
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	Level + 1
FROM Sales.Employees as e
INNER JOIN CTE_Emp_Hierarchy ceh
ON e.ManagerID = ceh.EmployeeID
)
SELECT*
FROM CTE_Emp_Hierarchy
ORDER BY 
	Level,
	ManagerID

/*To reprezentuje hierarchiczna strukture w firmie, gdzie Frank jest szefem.
pod nim jest bezposrednio Kevin i Mary. Pod Kevinem jest Michel, a pod Mary jest Carol.
Dziala to w taki sposob poniewaz z kazda iteracja ta tabela z ktore joinujemy zmienia sie
(jest inna) widac to w kursie u barry. na poczatkuje joinujemy z "jedynka", do cte dochodzi Kevin i Mary
Teraz joinujemy z 2,3 a wiec chodza osoby z ManagerID 2 i 3, a wiec Michael i Carol, po czym
nie ma wiecej danych i jest exit z petli.
NOTE: JOIN w Recursive CTE patrzy tylko na to co wygenerowal POPRZEDNI krok, dlatego nie dodaje wszystkiego od nowa
za kazdym razem.
*/