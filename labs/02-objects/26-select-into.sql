-- Lesson 26 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

---------------------SQL CTAS-----------------------
/*
CTAS (Create table as Select) - robi nowa tabele bazujac
na zapytaniu SQL.
Materializacja moze uniknac ponownych obliczen, ale nie gwarantuje szybszego odczytu.
Trzeba uwzglednic indeksy, koszt odswiezania i aktualnosc danych. Problem jest to ze
takie tabele CTAS ciezej jest utrzymac bo zmiana w glownej
tabeli nie spowoduje odswiezenia sie tableli CTAS.

Syntax of create/insert:

CREATE TABLE Table-Name
(
	ID INT,
	Name VARCHAR(50)
)

INSERT INTO Table-Name
VALUES (1,'Frank')

Syntax of CTAS (MySQL | Postgres | Oracle):

CREATE TABLE NAME AS
(
	SELECT...
	FROM...
	WHERE...
)

Syntax of CTAS (Sql Server):

SELECT ...
INTO New-Table
FROM ...
WHERE...

*/

-------USE CASE: Optimize Performance--------
/*
Jesli view ma skomplikowana logike, to wykonywanie go caly
czas bedzie kosztowne. W takiej sytuacji lepiej sprawdzi sie
CTAS.
*/

-- Odczyt MonthlyOrders jest ponizej, po utworzeniu tabeli.

-- Skrypt odswiezajacy tabele CTAS (tsql)

IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrders;
GO
SELECT
	DATETRUNC(month,OrderDate) [miesiac],
	COUNT(OrderID) [totalOrders]
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate);

SELECT * FROM Sales.MonthlyOrders;

-------USE CASE: Create Snapshot of Data--------
/*
Jesli mamy jakis bug i chcemy go naprawic to dobrym
pomyslem bedzie analizowanie tego na snapshocie bazy,
a nie faktycznych danych bo one moga sie zmieniac,
co utrudni nam analize bledow.
*/

-------USE CASE: Physical Data Mart--------
/*
Fizyczny data mart moze przyspieszyc wybrane raporty kosztem miejsca i odswiezania.
Porownaj aktualnosc, plan i pomiary dla swojego obciazenia.
*/
