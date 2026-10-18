--------------Aggregate Functions---------------


---------COUNT(*)-------
/*
Liczy i zwraca ilosc wierszy.
*/

--------SUM()-------
/*
Sumuje.
*/

--------AVG()-------
/*
Liczy i zwraca srednia
*/

-------MAX()-------
/*
Szuka najwiejszej wartosci w naszej tabeli i ja zwraca.
*/

-------MIN()-------
/*
Szuka najmiejszej wartosci w tabeli i ja zwraca.
*/

/*task: Find the total number of orders*/
/*task: Find the total sales of all orders*/
/*task: Find average sales of all orders*/

SELECT
	COUNT(*) as [ilosc zamowien], 
	SUM(sales) AS total_sales,
	AVG(sales) AS srednia_sprzedaz
FROM Sales.Orders as o;

-- NOTE:: tych funkcji mozna uzywac tez w taki sposob jak nie mamy jeszcze wpisanych do wyswietlenia
-- kolumn z tabeli, to SQL nie przyczepi sie nam do tego

/*task: Find the highest score among customers*/

SELECT
	CustomerID,
	COUNT(*) as [ilosc zamowien], 
	SUM(score) AS total_sales,
	AVG(score) AS srednia_sprzedaz,
	MAX(score) as NajwyzszyWynik,
	MIN(score) as NajnizszyWynik
FROM Sales.Customers as c
GROUP BY CustomerID; -- pokazuje, ze jesli zgrupujemy sobie po ID to fajnie mozemy pouzywac sobie tych
-- funkcji agregujacych, w tej tabeli to akurat ma malo sensu


/*task: analyze the scores in customers table*/

SELECT
Country,
	SUM(Score) as [wynik sumaryczny],
	AVG(Score) as [sredni wynik],
	MAX(Score) as [najlepszy wynik],
	MIN(Score) as [najgorszy wynik],
	COUNT(*) as [ilosc klientow]
FROM Sales.Customers
GROUP BY Country
