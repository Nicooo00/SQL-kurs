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

/* GROUP BY
dziala nieco dziwnie na pierwszy rzut oka,
pod from jesli damy GROUP BY, np country to wtedy SQL
wie ze ma zgrupowac wiersze po np country i wyswietlic dla nich
agregacje, które piszemy z kolei jeszcze nad FROM
ex.
JOHN GERMANY 200
GINA GERMANY 300
pokaze: GERMANY 500 */

/*task: Find the total score for each country*/
SELECT 
	country AS customer_country,
	first_name AS imiona,
	SUM(score) AS total_points
FROM dbo.customers
GROUP BY country,first_name -- wpisujemy jaka kulomne chemy miec zgrupowana, a nie po czym grupowac, od tego sa aggregations
-- NOTE!! jesli mamy w naszych seleckcie GROUP BY to SQL nie moze wyswietlic kolumn po ktorych grupujemy, lub nie sa
-- agregacja. Jesli koniecznie chcemy wyswietlic jakas kolumne to mozemy dodac ja do GROUP BY, ale musimy zachować ostrożność
-- poniewaz te np te konkretne zgrupowanie bedzie laczyc tylko osoby w takim samym krajem i nazwiskiem czego raczej nie chcemy.

/*task: podaj laczny score danego kraju i podaj ile ma on klientow*/
SELECT 
country,
SUM(score) AS total_score,
COUNT(id) AS ilosc_osob -- liczy ilosc "zlaczen" spowodowanych przez agregacje w tym przypadku
FROM dbo.customers
GROUP BY country -- dziala to tak jak ma byc. grupujemy po country i wyswietlamy dla tego zgrupowania wszystkie agregacje.
ORDER BY total_score DESC

/*HAVING
Używamy HAVING do filtrowania danych PO agregacji (GROUP BY). DO warunku HAVING uzywamy 
z'agregowanych kolumn
*/

/*task: Find the average score for each county considering only
customers with a score not equal to 0. And return only those countries with
an average score greater than 430 */

SELECT
country,
AVG(score) AS srednia
FROM dbo.customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430 -- nie mozemy dac warunku po 'srednia' poniewaz alias dodaje sie w selectcie a one wykonuja sie pozniej
-- mozna by natomiast dac ORDER BY srenia i to by zadzialo (nie tak samo) poniuewaz ORDER BY wykonuje sie na koncu
