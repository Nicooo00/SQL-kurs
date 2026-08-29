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
	DATEDIFF(year, BirthDate,GETDATE()) as [ile ma lat] -- GETDATE() daje nam dzisiejsza date
FROM Sales.Employees


/*task: Find the average shipping duration in days for each month*/
SELECT
	FORMAT(OrderDate, 'yyyy MMM') as [year month format],
	AVG(DATEDIFF(day,OrderDate,ShipDate)) as [sredni czas wysylki]
FROM Sales.Orders as o
GROUP BY FORMAT(OrderDate, 'yyyy MMM'); -- moj

SELECT
	MONTH(OrderDate) as OrderDate,
	AVG(DATEDIFF(day,OrderDate,ShipDate)) as Avgship
FROM Sales.Orders
GROUP BY MONTH(OrderDate) -- barra

/*task: Find the number of days between each order and previous order*/

SELECT
	OrderID,
	OrderDate as CurrentOrderDate,
	LAG(OrderDate) OVER (ORDER BY OrderDate) as PreviousOrderDate, -- window function, bedzie pozniej, daje dostep do poprzedniego wiersza
	DATEDIFF(day,LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate) as [odstep miedzy zamoweniami]
FROM Sales.Orders as o


-------------ISDATE()------------
/*
Sprawdza czy wartosc moze byc data. jesli tak zwraca 1,
jesli nie zwraca 0.

syntax: ISDATE(value)

ex.
ISDATE('2025-08-20') -- 1
ISDATE('2025') -- 1 poniewaz to moze byc data
ISDATE('2026-02-30') -- 0 poniewaz nie ma daty z 30 lutym

*/

SELECT 
	ISDATE('123'), 
	ISDATE('2025-08-20'),
	ISDATE('20-08-2025'), -- zwrocil 0 poniewaz nie przestrzegamy ISO 8601 
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
	--select wymusza typ danych i nazwe kolumn w zlaczeniach po wierszach
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08'
) AS t
WHERE ISDATE(OrderDate) = 0

