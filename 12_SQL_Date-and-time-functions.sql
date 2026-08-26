-----------SQL Date & Time Functions-----------
/*
Okreslenia na czas w SQL

Data to:  2020-4-14
Time to:  15:45:3
Timestamp to: 2020-4-14 15:45:3  --(w SQL Server jest to Datetime2)

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

------------DATEPART-----------
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

-------------DATENAME------------
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

------------DATETRUNC------------
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
Zwraca ostatni dzien miesiaca.
*/