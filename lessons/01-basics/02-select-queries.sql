-- Lesson 02 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE MyDatabase;
GO

USE MyDatabase; -- uzywamy tej samej bazy danych z ktorych chcemy dostac wynik selecta
GO

SELECT* -- pokazuje wszystkie kolumny i wiersze z danej tabeli w danej bazie damych
FROM dbo.customers

/*task: Retrieve all Order Data*/
SELECT*
FROM dbo.orders

/*task: Retrieve each customer's name country and score*/
SELECT
	first_name, --jesli chcemy wyswietlic konkretne kolumny zamiast gwiazdki wypisujemy nazwy kolumn
	country,
	score
FROM dbo.customers

/*task: Retrieve customers with a score not equal to 0*/
SELECT
	id,
	first_name
FROM dbo.customers
WHERE score != 0 --dajemy warunek ze score ma byc nierowny 0;

/*task: Retrieve customers from Germany*/

SELECT
	id,
	first_name,
	country
FROM dbo.customers
WHERE country = 'Germany' --uzywamy '' gdy porownujemy ze string values

-------------------------------------------------------------------------------------------------------------------------------------
/*task: Retrive all customers and sort the results by the highest score first*/
SELECT
first_name,
score
FROM dbo.customers
ORDER BY score DESC --to polecenie porzadkuje wiersze
--(w tym przypadku po score zaczynajac od najwyzszego bo mamy DESC a nie ASC czy domyslny ORDER BY)

/*task: Retrive all customers and sort the results by the lowest score first*/
SELECT
first_name,
score
FROM dbo.customers
ORDER BY score ASC

/*task: Retrieve all customers and sort the results by the country and then by the highest score */
SELECT
first_name,
country,
score
FROM dbo.customers
ORDER BY
	country ASC,
	score DESC  -- mozliwe jest sortowanie w po wiecej niz jednym warunku, w tym przypadku najpierw sortujemy po country a potem po score

----------------------------------------------------------------------------------------------------------------------------------------

/*
GROUP BY
dziala nieco dziwnie na pierwszy rzut oka,
pod from jesli damy GROUP BY, np country to wtedy SQL
wie ze ma zgrupowac wiersze po np country i wyswietlic dla nich
agregacje, które piszemy z kolei jeszcze nad FROM
ex.
JOHN GERMANY 200
GINA GERMANY 300
pokaze: GERMANY 500
 */

/*task: Find the total score for each country*/
SELECT
	country AS customer_country,
	SUM(score) AS total_points
FROM dbo.customers
GROUP BY country -- grupujemy po kraju; kolumny w SELECT musza nalezec do GROUP BY lub byc agregowane.
-- Dodanie first_name zmieniloby poziom szczegolowosci na kraj i imie.

/*task: podaj laczny score danego kraju i podaj ile ma on klientow*/
SELECT
country,
SUM(score) AS total_score,
COUNT(id) AS ilosc_osob -- liczy nie-NULL id w kazdej grupie (tu id jest NOT NULL)
FROM dbo.customers
GROUP BY country -- dziala to tak jak ma byc. grupujemy po country i wyswietlamy dla tego zgrupowania wszystkie agregacje.
ORDER BY total_score DESC

-------------------------------------------------------------------------------------------------------------------------------------------
/*
HAVING
Używamy HAVING do filtrowania danych PO agregacji (GROUP BY). DO warunku HAVING uzywamy
z'agregowanych kolumn
*/

/*task: Find the average score for each county considering only
customers with a score not equal to 0. And return only those countries with
an average score greater than 430 */

SELECT
country,
AVG(CAST(score AS decimal(18,2))) AS srednia
FROM dbo.customers
WHERE score != 0
GROUP BY country
HAVING AVG(CAST(score AS decimal(18,2))) > 430 -- nie mozemy dac warunku po 'srednia' poniewaz alias dodaje sie w selectcie a one wykonuja sie pozniej
-- mozna by natomiast dac ORDER BY srenia i to by zadzialo (nie tak samo) poniuewaz ORDER BY wykonuje sie na prawie na koncu (pozniej jest tylko TOP)

---------------------------------------------------------------------------------------------------------------------------------------------
USE MyDatabase
GO

SELECT*
FROM dbo.customers

/*task: Return Unique list of all countries*/

SELECT DISTINCT -- DISTINCT usuwa powtorzenia w wyniku.
--np jesli niemcy wystapily 2 razy to pokaza sie raz
	country
FROM dbo.customers
--NOTE: DISTINCT stosuj gdy potrzebujesz unikalnych wynikow. Koszt sprawdz w planie.

/*task: Retrieve only 3 Customers */
SELECT TOP 3 -- bez ORDER BY dowolne 3 wiersze, kolejnosc nie jest gwarantowana
	id,
	first_name
FROM dbo.customers

/* task: Retrieve the Top 3 Customers with the Highest Scores */
SELECT TOP 3 *
FROM dbo.customers
ORDER BY score DESC

/*task: Retrieve the Lowest 2 Customers based on the Score */
SELECT TOP 2 *
FROM dbo.customers
ORDER BY
	score ASC,
	id ASC -- to zadziala dopiero wtedy gbydy np 2 osoby mialy ten sam score to wtedy osoba z nizszym id byla by wyzej

SELECT*
FROM dbo.orders

/*task: Get the Two Most Recent Orders */
SELECT TOP 2 *
FROM dbo.orders
ORDER BY order_date DESC

-------------------------------------------------------------------------------------------------------------------------------------------------


/*
CODING ORDER:

SELECT DISTINCT TOP 2
	Col1,
	SUM(Col2)
FROM Table
WHERE score = 10
GROUP BY Col1                   -- kolumna po ktorej grupujemy
HAVING SUM(Col2) > 30
ORDER BY Col1 ASC

---------------------------------------

EXECUTE ORDER:

1. FROM
2. WHERE
3. GROUP BY   (will start aggregating the data)
4. HAVING
5. SELECT (DISTINCT)  -- pod tym kolumny ktore wzkazalismy do zaznaczenia
6. ORDER BY
7. TOP

*/
