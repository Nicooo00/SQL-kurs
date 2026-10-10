---------------------SQL CTAS-----------------------
/*
CTAS (Create table as Select) - robi nowa tabele bazujac
na zapytaniu SQL.
Pytanie widokow jest wolniejsze niz pytanie CTAS tabel,
poniewaz pytanie tabel jest szybsze.Problem jest to ze
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

SELECT*
FROM Sales.MonthlyOrders

DROP TABLE Sales.MonthlyOrders

-- Skrypt odswiezajacy tabele CTAS (tsql)

IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrders;
GO
SELECT
	DATENAME(Month,OrderDate) [miesiac],
	COUNT(OrderID) [totalOrders]
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(Month,OrderDate)

-------USE CASE: Create Snapshot of Data--------
/*
Jesli mamy jakis bug i chcemy go naprawic to dobrym
pomyslem bedzie analizowanie tego na snapshocie bazy,
a nie faktycznych danych bo one moga sie zmieniac,
co utrudni nam analize bledow.
*/

-------USE CASE: Physical Data Mart--------
/*
Zrobienie fizycznych hurtowni danych przyspiesza 
predkosc wydobywania z nich danych w porownaniu do
widokow.
*/
