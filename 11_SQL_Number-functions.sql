/*-------------NUMBER FUNCTIONS-------------*/


----------------ROUND----------------
/*
Zaokragla liczby. Zaokragla od 5 w gore, ponizej w dol.
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

