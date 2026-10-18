-------------SQL Temp Tables---------------
/*
Przechowuja posrednie wyniki zapytan w tymczasowej pamieci
w bazie danych w trakcie sesji.
Baza danych pozbedzie sie wszystkich tymczasowych tabel gdy
sesja sie zakonczy.

Czas pomiedzy polaczeniem z rozlaczeniem sie z baza danych to
sesja.

Syntax of Temp Table:

SELECT...
INTO #New-Table
FROM...
WHERE...
*/

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
