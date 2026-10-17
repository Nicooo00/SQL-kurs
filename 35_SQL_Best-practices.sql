--------------------SQL BEST PRACTICES---------------------
/*
Zlota zasada: Zawsze sprawdzaj plan wykonywania zeby 
potwierdzic poprawy wydajnosci gdy optymalizujemy zapytanie.

Jesli nie ma poprawy wybierz ta z opcji gdzie czytelnosc jest
lepsza.
*/

-- =========================================================
-- #1: Select only what you need
-- =========================================================

-- Bad practice
SELECT*
FROM Sales.Customers

-- Good Practice
SELECT CustomerID,FirstName,LastName
FROM Sales.Customers

-- =========================================================
-- #2: Avoid unnecessary DISTINCT & ORDER BY
-- =========================================================

-- Bad practice
SELECT DISTINCT
	FirstName
FROM Sales.Customers
ORDER BY FirstName

--Good Practice
SELECT FirstName
FROM Sales.Customers

-- =========================================================
-- #3: For Exploration Purpose, Litit Rows!
-- =========================================================

-- Bad practice
SELECT
	OrderID,
	Sales
FROM Sales.Orders

--Good Practice
SELECT TOP 10
	OrderId,
	Sales
FROM Sales.Orders

-- =========================================================================
-- #4: Create nonclustered Index on frequently used Columns in WHERE clause
-- =========================================================================

SELECT*
FROM Sales.Orders WHERE OrderStatus = 'Delivered'

CREATE NONCLUSTERED INDEX idx_Sales_Orders_OS
ON Sales.Orders (OrderStatus)

-- =========================================================
-- #5: Avoid applying functions to columns in WHERE clauses
-- =========================================================

-- Bad practice
SELECT*
FROM Sales.Orders
WHERE LOWER(OrderStatus) = 'delivered' -- to moze zablokowac dzialanie indexu 

-- Good practice
SELECT
	o.*,
	LOWER(OrderStatus) [lowercase status]
FROM Sales.Orders o
WHERE OrderStatus = 'Delivered'

--Bad Practice
SELECT*
FROM Sales.Customers
WHERE SUBSTRING(FirstName,1,1) = 'A'

--Good Practice
SELECT *
FROM Sales.Customers
WHERE Firstname LIKE 'A%'

--Bad practice
SELECT*
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025

--Good practice
SELECT*
FROM Sales.Orders
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31'

-- =========================================================
-- #6: Avoid leading wildcards as they prevent index usage
-- =========================================================

--Bad practice
SELECT*
FROM Sales.Customers
WHERE LastName LIKE '%Gold%' -- to blokuje dzialanie indexu

--Good practice
SELECT*
FROM Sales.Customers
WHERE LastName LIKE 'Gold%' -- to nie blokuje dzialania indexu

-- =========================================================
-- #7: Use IN instead of Multiple OR
-- =========================================================

--Bad practice
SELECT*
FROM Sales.Orders
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3 -- OR jest fatalny dla wydajnosci

--Good practice
SELECT*
FROM Sales.Orders
WHERE CustomerID IN (1,2,3)

-- =================================================================
-- #8: Understand The Speed of Joins & Use INNER JOIN when possible
-- =================================================================

--Best Performance
SELECT c.FirstName, o.OrderID FROM Sales.Customers c INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Slightly Slower Performance 
SELECT c.FirstName, o.OrderID FROM Sales.Customers c RIGHT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
SELECT c.FirstName, o.OrderID FROM Sales.Customers c LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

--Worst Performance 
SELECT c.FirstName, o.OrderID FROM Sales.Customers c FULL OUTER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- =============================================================================
-- #9: Use Explicit Join (ANSI Join) Instead of Implicit Join (non-ANSI Join)
-- =============================================================================

--Bad practice
SELECT
	o.OrderID,
	c.FirstName
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID

--Good Practice
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
-- #11: Filter Before Joining (Big Tables)
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
-- #12: Aggregate Before Joining (Big Tables)
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

--Best Practice
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

--Bad Practice
--Correlated Subquery
SELECT
	c.CustomerID,
	c.FirstName,
	(SELECT COUNT(o.OrderID)
	FROM Sales.Orders o 
	WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM Sales.Customers c

-- =================================================================
-- #13: Use Union Instead of OR in Joins
-- =================================================================

--Bad practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID
OR c.CustomerID = o.SalesPersonID -- OR to perfomance killer

--Good practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID

UNION

SELECT o.OrderID,c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.SalesPersonID

-- =================================================================
-- #14: Check for Nestep Loops and Use SQL HINTS
-- =================================================================

-- jesli tabela jest duza i SQL wybiera nestested loops to zle
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID

--wtedy wymuszamy inny join SQL hintem
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID
OPTION(HASH JOIN)

-- ======================================================================
-- #15: Use UNION ALL instead of using UNION if duplicates are acceptable
-- ======================================================================

-- Bad practice
SELECT CustomerID FROM Sales.Orders
UNION -- SQL musi sprawdzic czy sa duplikaty nawet jesli ich nie ma
SELECT CustomerID FROM Sales.OrdersArchive

-- Best Practice
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchive

-- ===========================================================================================
-- #16: Use UNION ALL instead + Distinct instead using UNION if duplicates are not acceptable
-- ===========================================================================================

-- Bad practice
SELECT CustomerID FROM Sales.Orders
UNION 
SELECT CustomerID FROM Sales.OrdersArchive

--Best practice
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

CREATE CLUSTERED COLUMNSTORE INDEX idx_Orders_Columnstore 
ON Sales.Orders


-- ================================================================
-- #18: Pre-Aggregate Data and store it in new Table for Reporting
-- ================================================================

SELECT MONTH(OrderDate) OrderYear, SUM(Sales) AS TotalSales
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- ========================
-- #19: test JOIN vs Exists
-- ========================

-- JOIN (best if performance equals to EXISTS)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

-- EXISTS (best practice for large tables)
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

--Good practice
SELECT
	EmployeeID,
	FirstName,
	CASE
		WHEN Salary > AVG(Salary) OVER () THEN 'Above Average'
		WHEN Salary < AVG(Salary) OVER () THEN 'Below Average'
		ELSE 'Average'
	END AS Status
FROM Sales.Employees

-- ===================================================
-- #21: Avoid VARCHAR() and TEXT if possible
-- ===================================================

--Bad practice
CREATE TABLE CustomerInfoBad(
	CustomerID INT,
	FirstName VARCHAR(MAX),
	LastName TEXT,
	Country VARCHAR(255),
	TotalPurchases FLOAT,
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
	TotalPurchases FLOAT,
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
-- #24: Ensure all your tables have a Clustered Primary Key 
-- =========================================================
-- ===========================================================================
-- #25: Create a non-clustered index for foreign keys that are used frequently
-- ===========================================================================


-- ======================================
-- #26: Avoid Over Indexing
-- ======================================
-- ======================================
-- #27: Drop unused indexes
-- ======================================
-- ======================================
-- #28: Update Statistics (Weekly)
-- ======================================
-- ==========================================
-- #29: Reorganize & Rebuild Indexes (Weekly)
-- ==========================================
-- ==========================================================
-- #30: Partition Large Tables (Facts) to improve performance
-- ==========================================================