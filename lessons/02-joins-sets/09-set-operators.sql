-- Lesson 09 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

------------SET OPERATORS-------------
/*
Uzywajac SET Operators bedziemy laczyc tabele po wierszach wplywajac na jej dlugosc a nie szerokosc
jak w JOIN 'ach. Aby wykonac tego typu polaczenie bedziemy potrzebowali takich samych kolumn.

struktura SET Operators:

SELECT                             ---- 1st select statement
	FirstName,
	LastName
FROM Customers
(reszta select statementu
np.join where group by)

UNION                              ---- SET operator

SELECT                             ---- 2nd select statement
	FirstName
	LastName
FROM Employees
(reszta select statementu
np.join where group by)

Zasady SET Operators:
- mozna uzywac z niemal wszystkimi poleceniami z select statements, ale nie
z ORDER BY. Te mozna uzyc dopiero na koncu zapytania tylko jeden raz (na samym dole).

- liczba kolumn w kazdym zapytaniu musi byc taka sama

- typy danych w podanych kolumnach musza byc byc kompatybilne

- kolejnosc kolumn w select statementach musi byc taka sama

- nazwy kolumn w result set sa definiowane przez nazwy kolumn w pierszym zapytaniu SELECT

- nawet jesli wczesniejsze zasady sa zachowane to dalej nie ma gwarancji ze wynik jest
poprawny poprawne napisanie zapytania nalezy do nas

USE CASES dla SET Operators
- laczenie podobnych informacji przed analiza danych

- identyfikowanie roznic lub zmian (delty) w 2 partiach danych. przykladowo porownywanie informacji
z dnia 1 do dnia 2 aby uniknac wgrywania niepotrzebych danych do data warehouse lub data lake.

- operator EXCEPT moze byc uzywany by porownywac talebe aby zauwazyc rozbieznosci pomiedzy dwoma
bazami danych (np przy migracji. robimy EXCEPT zaczynajac od pierwszej, a potem od drugiej tabeli)

NOTE:: Pierwszy SELECT nadaje nazwy kolumn, a typ wyniku wynika z regul zgodnosci i pierwszenstwa typow.
*/

---------------UNION---------------
/*
Zwraca wszystkie unikalne wiersze z obu zapytan select. Usuwa duplikaty z wyniku.
(graficznie;; P suma R)

*/

USE SalesDB

/*task: Combine the data from employees and customers into one table*/

SELECT
	FirstName,
	LastName
FROM Sales.Employees

UNION

SELECT
	FirstName,
	LastName
FROM Sales.Customers

-------------UNION ALL--------------
/*
Zwraca wszystkie wiersze z dwoch zapytan select, takze duplikaty.
(graficznie;; osobne kolka)
NOTE:: UNION ALL nie usuwa duplikatow, wiec unika tego kosztu. Uzywaj gdy odpowiada to zadaniu.
NOTE:: Union all uzywa sie do znalezienia duplikatow i innych problemow jakosciowych
*/

/*task: Combine the data from employees and customers into
one table including duplicates */

SELECT
	FirstName,
	LastName
FROM Sales.Employees

UNION ALL

SELECT
	FirstName,
	LastName
FROM Sales.Customers

-----------EXCEPT (minus)------------
/*
Zwraca wszystkie unikalne wiersze z pierszego zapytania select, ktorych nie ma
w drugim zapytaniu drugim. Tak jak wszystkie set operators (oprocz union all) usuwa duplikaty.
(graficznie;; P \ R ..chocby left anti join).
*/

SELECT
	FirstName,
	LastName
FROM Sales.Employees

EXCEPT

SELECT
	FirstName,
	LastName
FROM Sales.Customers

------------INTERSECT-----------
/*
Zwraca tylko wiersze ktore wystepuja w obu zapytaniach select.
*/

/*task: Find the employees who are also customers*/

SELECT
	FirstName,
	LastName
FROM Sales.Employees

INTERSECT

SELECT
	FirstName,
	LastName
FROM Sales.Customers

/*task: Orders are stored in separat tables (Orders and OrdersArchive)
Combine all order records into one report, retaining archive history and source labels*/

SELECT
      'Orders' AS SourceTable
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders

UNION ALL  -- zachowujemy historie. Starsze daty nie gwarantuja unikalnosci OrderID ani calych wierszy.
-- OrdersArchive celowo ma kilka wersji OrderID 4 i 6. Deduplikacja wymaga jawnej reguly biznesowej.

SELECT
      'OrdersArchive' AS SourceTable
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive

--NOTE:: Nie uzywaj gwiazdki (*) by laczyc tabele; wypisz potrzebne kolumny
--NOTE:: Uzywaj source flag (ta kolumna ze statikiem na poczatku zapytan), aby okreslic
--z ktorej tabeli jest to wiersz
