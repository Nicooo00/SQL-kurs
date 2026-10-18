-- Lesson 12 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-----------SQL Date & Time Functions-----------
/*
Okreslenia na czas w SQL

Data to:  2020-4-14
Time to:  15:45:3
Data i czas: 2020-04-14T15:45:03 -- DATETIME2; timestamp w SQL Server oznacza rowversion, nie date.

Sa 3 zrodla dat w SQL.
1.daty w tabelach
2.daty ustawiane statycznie (patrz nizej)
3.daty uzyskane przez GETDATE() Function

Kategorie funkcji czasowych:
- Part Extraction (day,month,year,datepart,datename,datetrunc,eomonth)
- Format & casting (format,convert,cast)
- Calculations (dateadd,datediff)
- Validation (isdate)
*/

USE SalesDB

SELECT
	OrderID,
	CreationTime,
	'2025-08-20' as static_time
FROM Sales.Orders as o

------------GETDATE()-----------
/*
Zwraca obecna date i czas na moment wykonania zapytania.
*/

SELECT
	OrderID,
	CreationTime,
	'2025-08-20' as static_time,
	GETDATE() as Today
FROM Sales.Orders as o

------- DAY | MONTH | YEAR ------
/*
DAY() - zwraca dzien z daty,
MONTH() - zwraca miesiac z daty,
YEAR() - zwraca rok z daty
Wszystkie te funkcje przymuja daty.
*/

SELECT
	OrderID,
	CreationTime,
	DATEPART(YEAR,CreationTime) as year_dp,
	YEAR(CreationTime) as rok,
	MONTH(CreationTime) as miesiac,
	DAY(CreationTime) as dzien
FROM Sales.Orders as o

------------DATEPART()-----------
/*
Zwraca konktretna czesc daty jako liczbe int (na przyklad tygodnie, kwartaly).
syntax: DATEPART(part,date)
ex: DATEPART(month,OrderDate)
NOTE:: mm to skrot zamiast month (mm, OrderDate)
*/

SELECT
	OrderID,
	CreationTime,
	DATEPART(YEAR,CreationTime) as year_dp,
	DATEPART(MONTH,CreationTime) as month_dp,
	DATEPART(DAY,CreationTime) as day_dp,
	DATEPART(hour,CreationTime) as hour_dp, -- informacja wziala sie z czesci time timestampu (datetime2)
	DATEPART(quarter,CreationTime) as quarter_dp, -- dobre do analizy danych sql rozumie co to quarter
	DATEPART(week,CreationTime) as week_dp, -- pokazuje ktory to tydzein roku
	YEAR(CreationTime) as rok
FROM Sales.Orders as o

-------------DATENAME()------------
/*
Zwraca konktretna czesc daty jako nazwe (na przyklad nazwe miesiaca)
Syntax podobny jak w datepart tylko zwraca stringi.
Taka funkcja zeby ladniej wygladaly raporty.
*/

SELECT
	OrderID,
	CreationTime,
	DATENAME(MONTH,CreationTime) as month_dn,
	DATENAME(WEEKDAY,CreationTime) as weekday_dn,
	DATENAME(DAY,CreationTime) as day_dn -- to zwraca stringi nie inty!
FROM Sales.Orders as o

------------DATETRUNC()------------
/*
Obcina date do okreslonej czesci.
Jesli naprzyklad okreslimy dokladnosc do czesci minut to nie bedziemy juz przechowywac
informacji o sekundach w danej dacie (zmini je na :00, dni i miesiace zmieniaja sie na -01).
Syntax identyczny jak w datepart i datename.
*/

SELECT
	CreationTime,
	DATETRUNC(minute,CreationTime) as dt_min,
	DATETRUNC(hour,CreationTime) as dt_hour,
	DATETRUNC(DAY,CreationTime) as dt_day,
	DATETRUNC(MONTH,CreationTime) as dt_mon
FROM Sales.Orders as o

--use case example

SELECT
	DATENAME(month,DATETRUNC(month,CreationTime)),
	COUNT(*) as ilosc_zamowien_w_miesiacu
FROM Sales.Orders as o
GROUP BY DATETRUNC(month,CreationTime)

------------EOMONTH()-----------
/*
Zwraca ostatni dzien miesiaca (zmienia dzien w dacie na ostatni dzien
jak wypada w tym miesiacu).
syntax: EOMONTH(date)
*/

SELECT
	CreationTime,
	DATEPART(day,EOMONTH(CreationTime)) as ostatni_dzien_miesiaca,
	DATENAME(weekday,EOMONTH(CreationTime)) as ostatni_dzien_nazwa,
	CAST((DATETRUNC(month,CreationTime)) as DATE) as pierwszy_dzien_miesiaca -- tak mozna
	-- uzyskac pierwszy dzien miesiaca jako date
FROM Sales.Orders as o

--------USE CASES--------
/*task: How many orders were placed each year?*/

SELECT
	DATEPART(YEAR,OrderDate) as rok,
	COUNT(*)
FROM Sales.Orders as o
GROUP BY DATEPART(YEAR,OrderDate)

SELECT*
FROM Sales.Orders as o

/*task: How many orders were placed each month?*/

SELECT
	DATENAME(MONTH,OrderDate) as miesiac,
	COUNT(*) as NrOfOrders
FROM Sales.Orders as o
GROUP BY DATENAME(MONTH,OrderDate)

/*task: Show all orders that were placed during the
month of february*/

SELECT
	OrderID,
	DATENAME(MONTH,OrderDate)
FROM Sales.Orders as o
WHERE DATEPART(MONTH,OrderDate) = 2
--NOTE: Dla konkretnego okresu zakres po OrderDate moze umozliwic index seek,
-- np. OrderDate >= '20250201' AND OrderDate < '20250301'. Tu szukamy lutego ze wszystkich lat.
-- Sam typ INT zamiast stringa nie gwarantuje lepszej wydajnosci.

----------datatype results----------
/*
DAY,MONTH,YEAR,DATEPART zwracaja inty
DATENAME zwraca string
DATETRUNC zachowuje typ i precyzje daty wejsciowej (tu DATETIME2)
EOMONTH zwraca date

na materialach na yt jest tabelka ze sciaga
z all          *Date Parts*
*/
