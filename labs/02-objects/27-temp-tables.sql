-- Lesson 27 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-------------SQL Temp Tables---------------
/*
Lokalne tabele # przechowuja wyniki posrednie w tempdb, niekoniecznie tylko w RAM.
Znikaja po zakonczeniu sesji lub zakresu procedury, ktora je utworzyla.
Globalne tabele ## maja inne zasady czasu zycia.

Czas pomiedzy polaczeniem z rozlaczeniem sie z baza danych to
sesja.

Syntax of Temp Table:

SELECT...
INTO #New-Table
FROM...
WHERE...
*/

DROP TABLE IF EXISTS #Orders; -- pozwala powtorzyc cwiczenie w tej samej sesji

SELECT*
INTO #Orders
FROM Sales.Orders

SELECT*
FROM #Orders

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

SELECT*
INTO Sales.OrdersTest
FROM #Orders

DROP TABLE Sales.OrdersTest

--------USE CASE: Intermediate Results---------
/*
Mozemy pomoc w wybowywaniu danych z source database.
Jesli wydobedziemy te dane do temp tables to jak
je przygotujemy i zaladujemy do naszego data warehouse
to Temp Tables na ktorych pracowalismy same sie usuna
(baza danych usunie je po zakonczeniu sesji).
Barra zaleca jednak stosowanie takiego podejscia w pomniejszych
projektach, poniewaz jesli wystapia jakies bledy w data warehouse
to dobrze byloby miec kopie danych a temp tables nam tego nie
zapewnia.
*/
