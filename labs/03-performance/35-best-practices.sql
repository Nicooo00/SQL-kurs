-- Lesson 35 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

--------------------SQL BEST PRACTICES---------------------
/*
Zlota zasada: Zawsze sprawdzaj plan wykonywania zeby
potwierdzic poprawy wydajnosci gdy optymalizujemy zapytanie.
Porownuj tez wyniki (w tym duplikaty i NULL), SET STATISTICS IO/TIME i reprezentatywne dane.
Ponizsze pary to eksperymenty; etykieta nie jest obietnica szybszego planu.

Jesli nie ma poprawy wybierz ta z opcji gdzie czytelnosc jest
lepsza.
*/

-- =========================================================
-- #1: Select only what you need
-- =========================================================

-- Wariant do porownania
SELECT*
FROM Sales.Customers

-- Alternatywa (sprawdz semantyke i plan)
SELECT CustomerID,FirstName,LastName
FROM Sales.Customers

-- =========================================================
-- #2: Avoid unnecessary DISTINCT & ORDER BY
-- Usuniecie DISTINCT lub ORDER BY zmienia wynik / gwarancje kolejnosci; tylko gdy nie sa wymagane.
-- =========================================================

-- Wariant do porownania
SELECT DISTINCT
	FirstName
FROM Sales.Customers
ORDER BY FirstName

-- Alternatywa (sprawdz semantyke i plan)
SELECT FirstName
FROM Sales.Customers

-- =========================================================
-- #3: For Exploration Purpose, Litit Rows!
-- =========================================================

-- Wariant do porownania
SELECT
	OrderID,
	Sales
FROM Sales.Orders

-- Alternatywa (sprawdz semantyke i plan)
SELECT TOP 10
	OrderId,
	Sales
FROM Sales.Orders

-- =========================================================================
-- #4: Evaluate indexes for frequently used WHERE predicates
-- Sama czestotliwosc nie wystarcza: sprawdz selektywnosc, istniejace indeksy i koszt zapisu.
-- =========================================================================

SELECT*
FROM Sales.Orders WHERE OrderStatus = 'Delivered'

CREATE NONCLUSTERED INDEX idx_Sales_Orders_OS
ON Sales.Orders (OrderStatus)

-- =========================================================
-- #5: Avoid applying functions to columns in WHERE clauses
-- =========================================================

-- Wariant do porownania
SELECT*
FROM Sales.Orders
WHERE LOWER(OrderStatus) = 'delivered' -- to moze zablokowac dzialanie indexu

-- Alternatywa (sprawdz semantyke i plan)
SELECT
	o.*,
	LOWER(OrderStatus) [lowercase status]
FROM Sales.Orders o
WHERE OrderStatus = 'Delivered'

-- Wariant do porownania
SELECT*
FROM Sales.Customers
WHERE SUBSTRING(FirstName,1,1) = 'A'

-- Alternatywa (sprawdz semantyke i plan)
SELECT *
FROM Sales.Customers
WHERE Firstname LIKE 'A%'

-- Wariant do porownania
SELECT*
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025

-- Alternatywa (sprawdz semantyke i plan)
SELECT*
FROM Sales.Orders
WHERE OrderDate >= '20250101' AND OrderDate < '20260101'

-- =========================================================
-- #6: Leading wildcards usually prevent a normal B-tree seek
-- Zmiana %Gold% na Gold% zmienia znaczenie: contains vs starts with. Index scan nadal jest mozliwy.
-- =========================================================

-- Wariant do porownania
SELECT*
FROM Sales.Customers
WHERE LastName LIKE '%Gold%' -- zwykle nie pozwala na seek po tym prefiksie

-- Alternatywa (sprawdz semantyke i plan)
SELECT*
FROM Sales.Customers
WHERE LastName LIKE 'Gold%' -- moze pozwolic na seek; sprawdz plan

-- =========================================================
-- #7: Use IN instead of Multiple OR
-- =========================================================

-- Wariant do porownania
SELECT*
FROM Sales.Orders
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3 -- IN bywa czytelniejsze; optymalizator czesto tworzy ten sam plan

-- Alternatywa (sprawdz semantyke i plan)
SELECT*
FROM Sales.Orders
WHERE CustomerID IN (1,2,3)

-- =================================================================
-- #8: Choose JOIN type by required rows, then measure
-- INNER/LEFT/RIGHT/FULL zwracaja rozne zbiory. Nie zamieniaj ich tylko dla szybkosci.
-- =================================================================

-- INNER: tylko pasujace pary
SELECT c.FirstName, o.OrderID FROM Sales.Customers c INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- OUTER: zachowuje tez niedopasowane wiersze wybranej strony
SELECT c.FirstName, o.OrderID FROM Sales.Customers c RIGHT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
SELECT c.FirstName, o.OrderID FROM Sales.Customers c LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- FULL: zachowuje niedopasowane wiersze obu stron
SELECT c.FirstName, o.OrderID FROM Sales.Customers c FULL OUTER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- =============================================================================
-- #9: Use Explicit Join (ANSI Join) Instead of Implicit Join (non-ANSI Join)
-- =============================================================================

-- Wariant do porownania
SELECT
	o.OrderID,
	c.FirstName
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID

-- Alternatywa (sprawdz semantyke i plan)
SELECT
	o.OrderID,
	c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- =========================================================
-- #10: Make sure to Index the columns used in the ON clause
-- =========================================================

SELECT
	c.FirstName,
	o.OrderID
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

CREATE NONCLUSTERED INDEX idx_Orders_CID
ON Sales.Orders (CustomerID) -- zrob index na tabeli gdzie nie mamy indexu

-- =================================================================
-- #11: Compare equivalent filters for INNER JOIN
-- Te trzy warianty moga miec ten sam plan: SQL Server potrafi przesuwac filtry.
-- Przy OUTER JOIN przeniesienie filtra miedzy WHERE i ON moze zmienic wynik.
-- =================================================================

--Filter After Join (WHERE)
SELECT
	c.FirstName,
	o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = O.CustomerID
WHERE o.OrderStatus = 'Delivered'

--Filter During Join (ON)
SELECT
	c.FirstName,
	o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = O.CustomerID
AND o.OrderStatus = 'Delivered'

--Filter Before Join (SUBQUERY)
SELECT
	c.FirstName,
	o.OrderID
FROM Sales.Customers c
INNER JOIN (SELECT OrderID, CustomerID FROM Sales.Orders WHERE ORDERSTATUS = 'Delivered') o
ON c.CustomerID = o.CustomerID

-- =================================================================
-- #12: Compare aggregation strategies
-- Preagregacja moze ograniczyc liczbe wierszy, ale nie gwarantuje szybszego planu.
-- Tu INNER pomija klientow bez zamowien, a scalar COUNT ponizej zwraca ich z 0.
-- =================================================================

--Grouping and Joining
SELECT
	c.CustomerID,
	c.FirstName,
	COUNT(o.OrderID) AS OrderCount
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID,c.FirstName

-- Alternatywa (sprawdz semantyke i plan)
--Pre-aggregated Subquery
SELECT
	c.CustomerID,
	c.FirstName,
	o.OrderCount
FROM Sales.Customers c
INNER JOIN
(
	SELECT
		CustomerID,
		COUNT(OrderID) AS OrderCount
	FROM Sales.Orders
	GROUP BY CustomerID
) o
ON c.CustomerID = o.CustomerID

-- Wariant do porownania
--Correlated Subquery
SELECT
	c.CustomerID,
	c.FirstName,
	(SELECT COUNT(o.OrderID)
	FROM Sales.Orders o
	WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM Sales.Customers c

-- =================================================================
-- #13: Compare OR with UNION only after checking semantics
-- UNION usuwa duplikaty projekcji, a OR zachowuje wielokrotnosc pasujacych par.
-- Tutaj warunki krajow sa rozlaczne, a OrderID i CustomerID unikalne, wiec projekcja nie traci par.
-- =================================================================

-- Wariant do porownania
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON (c.CustomerID = o.CustomerID AND c.Country = 'Germany')
OR (c.CustomerID = o.CustomerID AND c.Country = 'USA') -- koszt zalezy od planu

-- Alternatywa (sprawdz semantyke i plan)
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID AND c.Country = 'Germany'

UNION

SELECT o.OrderID,c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID AND c.Country = 'USA'

-- =================================================================
-- #14: Diagnose Nested Loops before considering hints
-- =================================================================

-- Nested Loops moga byc optymalne nawet dla duzej tabeli przy malym wyniku zewnetrznym i dobrym indeksie.
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- Tylko eksperyment: wymuszenie HASH JOIN moze pogorszyc wynik; porownaj odczyty, CPU i czas.
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OPTION(HASH JOIN)

-- ======================================================================
-- #15: Use UNION ALL instead of using UNION if duplicates are acceptable
-- ======================================================================

-- Wariant do porownania
SELECT CustomerID FROM Sales.Orders
UNION -- SQL musi sprawdzic czy sa duplikaty nawet jesli ich nie ma
SELECT CustomerID FROM Sales.OrdersArchive

-- Alternatywa (sprawdz semantyke i plan)
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchive

-- ===========================================================================================
-- #16: UNION vs DISTINCT over UNION ALL
-- Te formy sa logicznie rownowazne dla tej projekcji i moga miec ten sam plan. Brak gwarancji przyspieszenia.
-- ===========================================================================================

-- Wariant do porownania
SELECT CustomerID FROM Sales.Orders
UNION
SELECT CustomerID FROM Sales.OrdersArchive

-- Alternatywa (sprawdz semantyke i plan)
SELECT DISTINCT CustomerID
FROM (
	SELECT CustomerID FROM Sales.Orders
	UNION ALL
	SELECT CustomerID FROM Sales.OrdersArchive
)CombinedData

-- ===========================================================================================
-- #17: Use Columnstore Index for Aggregations on Large Table
-- ===========================================================================================

SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM Sales.Orders
GROUP BY CustomerID

-- Orders ma juz clustered PK. CCI pokazujemy na kopii bez usuwania klucza tabeli zrodlowej.
SELECT * INTO Sales.OrdersColumnstoreDemo FROM Sales.Orders;
CREATE CLUSTERED COLUMNSTORE INDEX idx_Orders_Columnstore
ON Sales.OrdersColumnstoreDemo


-- ================================================================
-- #18: Pre-Aggregate Data and store it in new Table for Reporting
-- ================================================================

SELECT DATETRUNC(month,OrderDate) OrderMonth, SUM(Sales) AS TotalSales
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate)

-- ========================
-- #19: test JOIN vs Exists
-- ========================

-- JOIN: moze mnozyc wiersze przy wielu dopasowaniach; tutaj CustomerID jest unikalny
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

-- EXISTS: test istnienia, nie mnozy wierszy; nie ma ogolnej przewagi czasowej dla duzych tabel
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE EXISTS (
	SELECT 1
	FROM Sales.Customers c
	WHERE c.CustomerID = o.CustomerID
	AND c.Country = 'USA'
)

-- =========================================
-- #20: Avoid Redundant Logic on Your Query
-- =========================================

-- Alternatywa (sprawdz semantyke i plan)
SELECT
	EmployeeID,
	FirstName,
	CASE
		WHEN Salary > AVG(CAST(Salary AS decimal(18,2))) OVER () THEN 'Above Average'
		WHEN Salary < AVG(CAST(Salary AS decimal(18,2))) OVER () THEN 'Below Average'
		ELSE 'Average'
	END AS Status
FROM Sales.Employees

-- ===================================================
-- #21: Choose data types by meaning and required length
-- VARCHAR jest poprawny dla tekstu; TEXT jest przestarzaly. Dla pieniedzy uzywaj DECIMAL, nie FLOAT.
-- ===================================================

-- Wariant do porownania
CREATE TABLE CustomerInfoBad(
	CustomerID INT,
	FirstName VARCHAR(MAX),
	LastName TEXT,
	Country VARCHAR(255),
	TotalPurchases DECIMAL(18,2),
	Score VARCHAR(255),
	BirthDate VARCHAR(255),
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

CREATE TABLE CustomerInfoGood(
	CustomerID INT PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(50) NOT NULL,    -- 50 not MAX
	LastName VARCHAR(50) NOT NULL,     -- varchar not text
	Country VARCHAR(50) NOT NULL,	  -- 50 not 255
	TotalPurchases DECIMAL(18,2),
	Score INT,                -- int not varchar
	BirthDate DATE,           -- date not varchar
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

CREATE NONCLUSTERED INDEX IX_Good_Customers_EmployeeID
ON CustomerInfoGood(EmployeeID)

-- =========================================================
-- #22: Avoid MAX or large lengths in data types
-- =========================================================
-- =========================================================
-- #23: Use the NOT NULL constraint where applicable
-- =========================================================
-- =========================================================
-- #24: Choose a primary key and clustering key for the workload; they need not be the same
-- =========================================================
-- ===========================================================================
-- #25: Create a non-clustered index for foreign keys that are used frequently
-- ===========================================================================


-- ======================================
-- #26: Avoid Over Indexing
-- ======================================
-- ======================================
-- #27: Review unused indexes over a representative workload; preserve constraint-supporting indexes
-- ======================================
-- ======================================
-- #28: Update statistics when evidence and data changes justify the cost
-- ======================================
-- ==========================================
-- #29: Maintain indexes based on measured need, size, page density and resource cost
-- ==========================================
-- ==========================================================
-- #30: Consider partitioning for manageability and predicate-aligned elimination; measure the benefit
-- ==========================================================
