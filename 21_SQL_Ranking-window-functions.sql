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
Ta funkcja nie rozstrzyga remisow.
*/

/*task: Rank the orders based on their sales from
highest to the lowest */

SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) [Ranking]
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
		ORDER BY Sales DESC) [pozycja]
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
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) [ranking] -- to dziala bo WF(X) dzialaja z GROUP BY 
        --jesli uzywaja tego samego co jest w reszcie selekta i akceptuje to group by
	FROM Sales.Orders
	GROUP BY CustomerID
)t  
WHERE ranking <= 2



