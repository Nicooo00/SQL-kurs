-- Lesson 11 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
/*-------------NUMBER FUNCTIONS-------------*/


----------------ROUND----------------
/*
Zaokragla do podanej liczby miejsc; przy remisie polowkowym od zera (tez dla liczb ujemnych).
*/

SELECT
	3.516,
	ROUND(3.516,2) as zaokraglenie_do_miejsc,
	ROUND(3.516,1) as zaokraglenie_do_jednego,
	ROUND(3.516,3) as zaokraglenie_do_trzech;

-----------------ABS-----------------
/*
Zwraca wartosc bezwgledna liczby.
*/

SELECT
	-10,
	ABS(-10) as bezwgledna
