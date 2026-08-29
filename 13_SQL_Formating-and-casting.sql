-----------DATE & TIME FUNCTIONS----------
/*
YYYY-MM-dd HH:mm:ss - specjany case sensitive format dat w SQL.
International Standard (ISO 8601)

MM-dd-YYYY - USA standard
dd-MM-YYYY - standard Europejski

Formatowanie - zmienianie formatu wartosci na inny format. 
Zmieniamy jak wygladaja nasze dane.

Casting - zmiana typu danych z jednego na drugi.
*/

--------------FORMAT()------------
/*
Formatuje date lub wartosc czasowa lub liczbe.

syntax: FORMAT(value, format [,culture]) -- culture jest opcjonalne,
sluzy do przedstawiania dat w formacie danego kraju, kultury.
Jesli nie wybierzemy zadnej to ustawi sie domyslnie en-US.

ex.
FORMAT(OrderDate, ('dd/MM/yyyy')
FORMAT(OrderDate, 'dd/MM/yyyy', 'ja-JP')
FORMAT(1234.56, 'D' , 'fr-FR')
*/

USE SalesDB

SELECT
	OrderID,
	FORMAT(CreationTime, 'dd') as dd,
	FORMAT(CreationTime, 'ddd') as ddd,
	FORMAT(CreationTime, 'dddd') as dddd,
	FORMAT(CreationTime, 'MM') as MM,
	FORMAT(CreationTime, 'MMM') as MMM,
	FORMAT(CreationTime, 'MMMM') as MMMM,
	FORMAT(CreationTime, 'MM-dd-yyyy') as USA_format,
	FORMAT(CreationTime, 'dd/MM/yyyy') as sformatowana_data -- eu ale z ukosnikami zamiast -
FROM Sales.Orders

/*task: Show CreationTime using the following format:
Day Wed Jan Q1 2025 12:35:56 PM*/

SELECT
	OrderID,
	'Day ' + FORMAT(CreationTime, 'ddd MMM') +
	' Q' + DATENAME(quarter,CreationTime) + ' '
	+ FORMAT(CreationTime,'yyyy HH:mm:ss tt') -- tt do designator do AM i PM
FROM Sales.Orders

---------FORMAT() use case---------
SELECT
	FORMAT(OrderDate, 'MMM yy') as data_zamowienia,
	COUNT(*) as liczba_zamowien
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy') -- grupowanie po sformatowanej juz dacie

-----------CONVERT()----------
/*
Konwertuje date lub czas na inny typ danych oraz pomaga sformatowac wartosc.

syntax: CONVERT(data_type, value [,style])

ex.
CONVERT(INT, '124') -- zmien na typ int
CONVERT(VARCHAR, OrderDate, '34') -- styl 34 jesli nie okreslimy sami to bedzie styl 0

*/

SELECT
CONVERT(INT, '123') as [String to Int CONVERT], -- dawajac w takie nawiasy mamy wieksza swodobe w nazywaniu kolumn
CONVERT(DATE, '04-04-2012') as [String to Date CONVERT],
CONVERT(DATE, CreationTime) as [datetime2 zmieniony na date],
CONVERT(VARCHAR,CreationTime,32) as [USA Std. Style:32], -- convert moze pomoc nam formatowac daty, ale jak zminimy typ na VARCHAR
CONVERT(VARCHAR,CreationTime,34) as [EU Std. Style:34],
CreationTime
FROM Sales.Orders

--NOTE: reszta styli w skryptach kursu

-----------CAST()----------
/*
Konwertuje wartosc na zadany typ danych.

syntax: CAST(value as data_type)
zmienia poprostu typ danych na inny, ale juz nie formatuje jak CONVERT()

*/

SELECT
CAST('123' as INT) as [String to Int],
CAST(123 as VARCHAR) as [Int to String],
CAST('12-04-2002' as DATE) as [String to Date],
CAST('12-04-2002' as DATETIME2) as [String to Datetime2],
CAST(CreationTime as DATE) as [Creation time to Date]
FROM Sales.Orders as o

