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

WITH [SumOfSales] AS
(
SELECT
	o.CustomerID,
	SUM(Sales) [sumaSprzedazy]
FROM Sales.Orders as o
GROUP BY o.CustomerID
)
--Main Query--
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	ctes.sumaSprzedazy
FROM Sales.Customers as c
LEFT JOIN SumOfSales as ctes ON
c.CustomerID = ctes.CustomerID

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


