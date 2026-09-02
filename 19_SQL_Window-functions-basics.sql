-----------------WINDOW FUNCTIONS----------------
/*
Pozwala przeprowadzac kalkulacji (np. aggregacje) na specyficznym
podzbiorze danych, bez tracenia poziomu detali wierszy.
Window Functions robia tkzw. ROW-LEVEL Calculations (wierszy bedzie tyle samo co bylo
wczesniej).

WINDOW FUNCTIONS syntax:

Window Function f(x)            OVER Clause

Over Clause dzieli sie na:
 - Partition clause,
 - Order Clause,
 - Frame Clause
OVER CLAUSE mowi SQL ze uzyta funkcja to funkcja okna,
definiuje tez okno lub podzbior danych.

ex.

AVG(Sales) OVER (PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)

ZASADY WINDOW FUNCTIONS:
 - funkcji okna mozna uzywac tylko w selekcie lub w order by
 - nesting funkcji okna nie jest dozwolony (nie mozna dac funkcji okna do funkcji okna)
 - SQL wykonuje funkcje okna po klauzuli WHERE
 - funkcja onka moze byc uzyta z GROUP BY w tym samym zapytaniu, TYLKO jesli takie same
   kolumny sa w uzyciu

*/

USE SalesDB

/*task: Find the total Sales Across all orders*/

SELECT
	SUM(Sales) as SumOfSales
FROM Sales.Orders;

/*task: Find the total sales for each product*/

SELECT
	ProductID,
	SUM(Sales) as SumOfSales
FROM Sales.Orders
GROUP BY ProductID; -- result dimension okresla granularity

/*task: Find the total sales for each product, additionally provide
details such as order id & order date*/


SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) as SumOfSales -- PARTITION BY to takie GROUP BY tylko w funkcji
	--okna
FROM Sales.Orders


-------------PARTITION BY------------
/*
Dzieli result set na partycje (okna).
Partition by dzieli wiersze na grupy, bazujac na kolumnach.
*/

/*task1: Find the total sales across all orders additionally provide
details such as order & order date*/

SELECT
	OrderID,
	OrderDate,
	SUM(Sales) OVER() as SumOfSales
FROM Sales.Orders;

/*task2: Find the total sales for each product, additionally provide
details such as order id & order date*/

SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) as [task 2],
	SUM(Sales) OVER() as SumOfSales -- przyklad ze mozemy inne okna robic w tym samym selekcie
FROM Sales.Orders;

/*task3: Find the total sales for each combination of product and order status*/

SELECT
	ProductID,
	OrderID,
	OrderDate,
	OrderStatus,
	SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus) as [task3]
FROM Sales.Orders;


---------------ORDER BY---------------
/*
Sortuje dane w oknie (ASC lub DESC)
*/

/*task: Rank each order based on their sales from highest to lowest,
additionally provide details such as order id & order date */

SELECT
	RANK() OVER(ORDER BY Sales DESC) as [ranking zamowien],
	Sales,
	OrderID,
	OrderDate
FROM Sales.Orders;

----------------FRAME----------------
/*
Definiuje podzbior wieszy w kazdym oknie, ktore sa istotne
dla obliczen.Robimy takie okno w oknie, bedzie sie ono przesuwac!
Ten frame robi obliczenia do logiki window function.
Jesli zapomnisz jak to dziala to lepiej zobaczyc u barry wizualizacje.

Frame Types:
 -ROWS,
 -RANGE

Frame Lower Value Boundary:
 -CURRENT ROW,
 -N PRECIDING,
 -UNBOUNDED PRECIDING,

Frame Higher Value Boundary:
 -CURRENT ROW
 -N FOLLOWING
 -UNBOUNDED FOLLOWING

ZASADY:
 -frame moze byc tylko uzyty z klauzula ORDER BY
 -Lower Value musi byc przed Higher Value (boundary)
*/

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) as TotalSales
FROM Sales.Orders;

--NOTE: Frame jest kalkulowany w obrebie danego okna! nie wszystkich wierszow tabeli.
--NOTE: ORDER BY ma default frame: ROWN BETWEEN UNBOUNDED PRECIDING AND CURRENT ROW
--NOTE: Istnieje forma skrocona dla preciding i current row mianowicie:
/*
normal: ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
shortened: ROWN 2 FOLLOWING
*/

/*task: Find the total sales for each order status, only for two products
101 and 102 */

SELECT
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) as TotalSales 
FROM Sales.Orders
WHERE ProductID IN (101,102)

/*task: Rank Customers based on their total sales*/

SELECT 
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) as [ranking]
FROM Sales.Orders
GROUP BY CustomerID;

--NOTE: Barra slusznie zauwazyl ze sa to 2 rozne kalkulacje, rank musi byc
-- funkcja okna natomiast total sales mozna zgrupowac przez GROUP BY.
-- podobno dobra praktyka jest gropowanie prostych rzeczy przez wlasnie GROUP BY.
-- te zadanie to przykad zasady 4.
-- najpierw robimy group by potem window functions w takich przykladach
