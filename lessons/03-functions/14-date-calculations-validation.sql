-- Lesson 14 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-------------DATE CALCULATIONS-------------


-------------DATEADD()-------------
/*
Dodaje lub odejmuje podany interwal czasowy to/z daty.

syntax: DATEADD(part, interval, date)

ex.
DATEADD(year, 2, OrderDate) -- bedzie dodawac 2 lata do kazdej OrderDate value
DATEADD(month, -4, OrderDate) -- bedzie odejmowac 4 miesiace od kazdej OrderDate value

*/

SELECT
	OrderID,
	OrderDate,
	DATEADD(day, -10, OrderDate) as[ten days before],
	DATEADD(year, 2, OrderDate) as TwoYearsLater,
	DATEADD(month, 3, OrderDate) as [3 months later]
FROM Sales.Orders as o


-------------DATEDIFF()-----------
/*
Zwraca liczbę przekroczonych granic jednostki (part) między start_date a end_date.

syntax: DATEDIFF(part, start_date, end_date)

ex.
DATEDIFF(year, OrderDate, ShipDate) -- liczy, ile razy minął 1 stycznia między datami
DATEDIFF(day, OrderDate, ShipDate)  -- liczy, ile razy minęła północ (zmiana dnia)

*/

/*task: Calculate the age of employees*/

SELECT
	BirthDate,
	DATEDIFF(year, BirthDate,GETDATE()) -
	CASE WHEN DATEADD(year, DATEDIFF(year, BirthDate,GETDATE()), BirthDate) > CAST(GETDATE() AS date)
	THEN 1 ELSE 0 END as [ile ma lat] -- odejmujemy rok, jesli urodziny jeszcze nie minely
-- Dla 29 lutego DATEADD przyjmuje 28 lutego w roku nieprzestepnym.
FROM Sales.Employees


/*task: Find the average shipping duration in days for each month*/
SELECT
	FORMAT(OrderDate, 'yyyy MMM') as [year month format],
	AVG(CAST(DATEDIFF(day,OrderDate,ShipDate) AS decimal(18,2))) as [sredni czas wysylki]
FROM Sales.Orders as o
GROUP BY FORMAT(OrderDate, 'yyyy MMM'); -- moj

SELECT
	DATETRUNC(month,OrderDate) as OrderMonth,
	AVG(CAST(DATEDIFF(day,OrderDate,ShipDate) AS decimal(18,2))) as Avgship
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate) -- przyklad z kursu, z zachowaniem roku

/*task: Find the number of days between each order and previous order*/

SELECT
	OrderID,
	OrderDate as CurrentOrderDate,
	LAG(OrderDate) OVER (ORDER BY OrderDate) as PreviousOrderDate, -- window function, bedzie pozniej, daje dostep do poprzedniego wiersza
	DATEDIFF(day,LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate) as [odstep miedzy zamoweniami]
FROM Sales.Orders as o


-------------ISDATE()------------
/*
Sprawdza konwersje do DATETIME, nie wszystkich typow dat.
Wynik zalezy od LANGUAGE i DATEFORMAT; DATETIME2 ma inny zakres i precyzje.
Dla konkretnego formatu DATE mozna uzyc TRY_CONVERT(date, value, 23).

syntax: ISDATE(value)

ex.
ISDATE('2025-08-20') -- 1
ISDATE('2025') -- 1 poniewaz to moze byc data
ISDATE('2026-02-30') -- 0 poniewaz nie ma daty z 30 lutym

*/

SELECT
	ISDATE('123'),
	ISDATE('2025-08-20'),
	ISDATE('20-08-2025'), -- wynik zalezy od DATEFORMAT sesji, nie od samego ISO 8601
	ISDATE('2025'),
	ISDATE('08')

-- przykald od barry

SELECT
	OrderDate,
	ISDATE(OrderDate),
	CASE
		WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		ELSE '9999-01-01'
	END AS NewOrderDate
FROM
(
	SELECT '2025-08-20' as OrderDate UNION -- alias wystarczyl tylko do pierwszego wiersza poniewaz to pierwszy
	--SELECT nadaje nazwe kolumnie; typ wynika z regul pierwszenstwa typow
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08'
) AS t
WHERE ISDATE(OrderDate) = 0
