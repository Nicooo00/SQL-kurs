-- Lesson 21 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

------------SQL Ranking Functions-------------
/*

Rank Functions Syntax:

Rank() OVER(PARTITION BY ProductID ORDER BY Sales)

- expression inside a rank function must be empty
- PARTITION BY jest opcjonalne
- ORDER BY jest wymagane
- FRAME nie jest dozwolony w ranking functions

*/

--------ROW_NUMBER()-------
/*
Przypisuje unikalny numer do kazdego z wierszy.
Przy remisach numeracja jest dowolna, chyba ze dodamy unikalny tie-breaker, np. OrderID.
ROW_NUMBER w SELECT nie jest trwalym identyfikatorem zapisanym w tabeli.
*/

/*task: Rank the orders based on their sales from
highest to the lowest */

SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC, OrderID) [Ranking]
FROM Sales.Orders

---------RANK()---------
/*
Przypisuje range to kazdego wiersza.
Obsluguje remisy. Moze zostawiac dziury w rankingu.
*/


/*task: Rank the orders based on their sales from
highest to the lowest */

SELECT
	OrderID,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) [Ranking]
FROM Sales.Orders

---------DENSE_RANK()--------
/*
Przypisuje range to kazdego wiersza.
Obsluguje remisy. Nie zostawia dziur w rankingu.
*/

/*task: Rank the orders based on their sales from
highest to the lowest */

SELECT
	OrderID,
	Sales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) [Ranking]
FROM Sales.Orders

---USE CASE: TOP N-Analysis---

/*task: Find the top highest sales for each product*/

SELECT
	ProductID,
	Sales
FROM(
	SELECT
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID
		ORDER BY Sales DESC, OrderID) [pozycja]
	FROM Sales.Orders
)t
WHERE pozycja = 1;

---USE CASE: BOTTOM N-Analysis---

/*task: Find the lowest 2 customers based on their total sales*/


SELECT*
FROM (
	SELECT
		CustomerID,
		SUM(Sales) as faktycznieTrzeba, --- jesli zaznaczmy * to kazda kolumna musi miec swoja nazwe
		ROW_NUMBER() OVER(ORDER BY SUM(Sales), CustomerID) [ranking] -- to dziala bo WF(X) dzialaja z GROUP BY
        --jesli uzywaja tego samego co jest w reszcie selekta i akceptuje to group by
	FROM Sales.Orders
	GROUP BY CustomerID
)t
WHERE ranking <= 2

---USE CASE: Generate Unique IDs---

/*task: Assign unique IDs to the rows of 'Order Archive' table */

SELECT
	ROW_NUMBER() OVER(ORDER BY OrderDate) [unique ids],
	OrderID,
	ProductID,
	Sales
FROM Sales.OrdersArchive

---USE CASE: Identify Duplicates---

/*task: Identify duplicater rows in the table 'OrdersArchive'
and return a cleasn result without any duplicates */

SELECT*
FROM(
SELECT
	ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) [rn],
	OrderID,
	ProductID,
	Sales
FROM Sales.OrdersArchive -- jesli rank jest powyzej jednynki to PK nie jest unikalny
)t
WHERE rn = 1;


----------NTILE()---------
/*
Dzieli dane na podane liczbe mniej wiecej takich samych grup (buckets)
Bucket size = Number of Rows / Number of Buckets
SQL RULE
Wieksze grupy sa pierwsze.
*/

SELECT
	OrderID,
	Sales,
	NTILE(1) OVER(ORDER BY Sales DESC) [one bucket],
	NTILE(2) OVER(ORDER BY Sales DESC) [two bucket],
	NTILE(3) OVER(ORDER BY Sales DESC) [three bucket],
	NTILE(4) OVER(ORDER BY Sales DESC) [four bucket]
FROM Sales.Orders

----USE CASE: Data Segmentation----

/*task: Segment all orders into 3 categories high, medium and low sales*/


SELECT
	Sales,
	rn,
	CASE
		WHEN rn = 1 THEN 'HIGH'
		WHEN rn = 2 THEN 'MEDIUM'
		ELSE 'LOW'
	END [categories]
FROM(
	SELECT
		NTILE(3) OVER(ORDER BY Sales DESC) [rn],
		Sales
	FROM Sales.Orders
)t

----USE CASE: Equalizing Loads----

/*task: In order to export the data, divide the orders into 2 groups*/

SELECT
	NTILE(2) OVER(ORDER BY OrderID) [ntile],
	* -- ta gwiazdke mozna dac na koncu i bedzie to dzialac, ew mozna dac przed ale trzeba wzkazac
	  -- tabele czyli: Sales.Orders.*,
FROM Sales.Orders



-------CUME_DIST()-------
/*
Cumulative distribution - rozklad skumulowany.
Kalkuluje dystrybujce punktow danych w obrebie okna.
CUME_DIST() = Position Number / Number of Rows
TIE RULE! - pozycja ostatniego wystapienia tej samej
wartosci jest brana pod uwage.
*/

SELECT
	OrderID,
	Sales,
	CUME_DIST() OVER(ORDER BY Sales DESC) [CUME_DIST()]
FROM Sales.Orders

------PERCENT_RANK()-------
/*
Kalkuluje relatywna pozycje kazdego wiersza.
Percent_Rank = (RANK - 1) / (Number of Rows - 1); dla jednego wiersza wynik to 0
TIE RULE! - pozycja pierszego wystapienia tej samej wartosci
jest brana pod uwage.
*/

SELECT
	OrderID,
	Sales,
	ROUND(PERCENT_RANK() OVER(ORDER BY Sales),2) [Pr]
FROM Sales.Orders

/*task: Find the products that fall within the hightest 40% of the prices*/

SELECT
*,
CONCAT(CD * 100, '%') DistRankPerc,
CONCAT(PR * 100, '%') PercentRankPerc
FROM(
SELECT
	Product,
	Price,
	CUME_DIST() OVER(ORDER BY Price DESC) [CD],
	PERCENT_RANK() OVER(ORDER BY Price DESC) [PR]
FROM Sales.Products
)t WHERE CD <= 0.4
