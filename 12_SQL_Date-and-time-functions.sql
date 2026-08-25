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
	YEAR(CreationTime) as rok,
	MONTH(CreationTime) as miesiac,
	DAY(CreationTime) as dzien
FROM Sales.Orders as o
