-- Lesson 15 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-------------NULL Functions------------
/*
NULL znaczy nic! Nie jest to zero, nie jest pusty string, ani
nawet pusta spacja.
*/

-----------ISNULL-----------
/*
Zamienia 'NULL' na podana wartosc.

syntax: ISNULL(value, replacement_value)

ex.

ISNULL(Shipping_Address, 'unknown') -- druga wartosc jest statyczna
ISNULL(Shipping_Address, Billing_Address) -- shipping addres dostanie replacement z billing address jesli jest NULL

*/

----------COALESCE----------
/*
Zwraca pierwsza wartosc non-NULL z listy. Taki lepszy ISNULL bo mozemy
odrazu obsluzyc sytuacje gdzie obie kolumny maja NULL i chcemy
wstawic static value.

syntax: COALESCE(value1, value2, value3, ...) -- tworzymy liste wartosci do sprawdzenia.

ex.

COALESCE(Shipping_Adress, 'unknown') -- jesli shipping adress bedzie null to wstawi sie 'unknown'
COALESCE(Shipping_Adress, Billing_Address) -- jesli shipping adress bedzie null to sprobuje sie wstawic billing adress

*/

/* IS NULL vs COALESCE */
/*
ISNULL jest ograniczony do 2 wartosci, w przeciewiestie do COALESCE w gdzie mozemy dac ile chcemy.
Nie ma ogolnej reguly szybkosci ISNULL vs COALESCE.
Roznia sie m.in. typem wyniku, nullowalnoscia i ewaluacja; wybieramy po semantyce.
NOTE:: ISNULL ma rozne nazwy w innych database service np. NVL (Oracle) IFNULLL (MySQL)
*/

------USE CASE: Handle the NULL before data aggregations-----
/*
Jesli naprzyklad chcemy dostac jakas srednia to tam gdzie bedzie NULL nie zostanie to wliczone do
mianownika sredniej. (np. 3 wartosci ale jedna jest NULL to SQL bedzie dzielil przez 2).
NULL bedzie pomijany w takich funkcjach oprocz funkcji COUNT(*), bo wtedy SQL liczy wszystkie
wiersze.
*/


/*task: Find the average scores of the customers*/

USE SalesDB

SELECT
	CustomerID,
	AVG(CAST(COALESCE(Score,0) AS decimal(18,2))) OVER() AvgScores -- window function, bedzie omowiona pozniej
FROM Sales.Customers as c

-------USE CASE: Handle the NULL before mathematical operations-------
/*
0 + 5 = 5 , ALE
NULL + 5 = NULL bo SQL nie wie jak poradzic sobie z takim przypadkiem
*/

/*task: Display the full name of customers in a single field by merging their first
and last names and add 10 bonus points to each customer's score*/

SELECT
	CustomerID,
	ISNULL(FirstName, 'unknown') + ' ' + ISNULL(LastName,'Kowalski') as [Imie i Nazwisko],
	10 + ISNULL(Score,0) as [Score plus 10]
FROM Sales.Customers

------USE CASE: Handle the NULL before Joining tables------
/*
Jesli NULLe beda wystepowac w kluczach po ktorych joinujemy tabele to
bedziemy miec missing records, SQL nie moze joinowac po NULL'ach.
NOTE:: mozemy miec wiecej niz 1 klucz w joinach

Przyklad obsluzenia nulli:

SELECT
a.year, a.type, a.orders, b.sales
FROM Table1 a
JOIN Table2 b
ON a.year = b.year
AND (a.type = b.type OR (a.type IS NULL AND b.type IS NULL)) -- jawne dopasowanie NULL do NULL
-- ISNULL(..., '') utozsamilby brak wartosci z prawdziwym pustym stringiem; to nie zawsze poprawne.

NOTE: w tym przykladzie po joinie dalej bedziemy w tabelach widziec NULL'e,
poniewaz obslugujemy NULL'e w joinie przez co nie bedziemy miec missing records
i oryginalne dane w tabelach.
*/

-----USE CASE: Handle the NULL before sorting data--------
/*
Jesli bedziemy miec NULL'e w danych to SQL bedzie dawal NULL na gore (ASC)
lub dol (DESC).
*/

/*task: Sort the customers from lowest to highest scores, with NULLs
appearing last. */

SELECT
	CustomerID,
	Score
FROM Sales.Customers as c
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score ASC
-- jak to dziala: sortujemy wpierw dane po naszej fladze (ASC) wiec tam gdzie mamy wartosc to flaga
-- jest 0, a potem dopiero po Score, co gwarantuje nam ze NULL'e beda na dole, a score bedzie
-- poprawnie uporzadkowany


----------NULLIF()---------
/*
Zwraca NULL jesli wartosci sa rowne lub zwraca pierwsza z wartosci jesli nie sa.
Druga wartosc dziala tylko jako sprawdzenie, nie bedzie ona nigdy zwrocona efektem
dzialania tej funkcji. NULLIT() pozwala nam na uzywanie NULL jako flagi dla naszych
zapytan.

syntax: NULLIF(value1, value2)

ex.

NULLIF(Shipping_Address, 'unknown')
NULLIF(Shippin_Addres, Billing_Address)

*/


-----USE CASE: Preventing the error of dividing by zero-----
/*task: Find the sales for each order by dividing the sales by the quantity*/

SELECT
	OrderID,
	Sales,
	Quantity,
	CAST(Sales AS decimal(18,2)) / NULLIF(Quantity,0) as sales_price
FROM Sales.Orders as o

---IS NULL oraz IS NOT NULL---
/*
IS NULL zwraca TRUE jesli wartosc jest NULL, przeciwnym FALSA.
IS NOT NULL zwraca TRUE jesli wartosc nie jest NULL, w przeciwnym FALSA.

syntax: Value IS NULL / VALUE IS NOT NULL

ex.
Shipping_Address IS NULL -- sprawdza czy jest NULL
Shipping_Address IS NOT NULL -- sprawdza czy nie jest NULL

*/

---IS NULL USE CASE: Filtering Data---
/*
Szukanie NULL w danych.
*/

/*task: Identify the customers who have no scores*/

SELECT
	CustomerID,
	CONCAT(TRIM(FirstName),' ',TRIM(LastName)) as [klienci bez wyniku]
FROM Sales.Customers
WHERE Score IS NULL

/*task: Identify the customers who have scores*/

SELECT
	CustomerID,
	CONCAT(TRIM(FirstName),' ',TRIM(LastName)) as [klienci z wynikiem]
FROM Sales.Customers
WHERE Score IS NOT NULL;

---IS NULL USE CASE: Finding unmatched rows between two tables---

/*task: List all details for customers who have not placed any orders*/

SELECT
	c.*,
	o.OrderID
FROM Sales.Customers as c
LEFT JOIN Sales.Orders as o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;
