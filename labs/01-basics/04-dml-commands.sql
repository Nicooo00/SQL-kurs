-- Lesson 04 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE MyDatabase;
GO

/*
INSERT syntax:

INSERT INTO table_name (column1, column2, column3, ...)
VALUES
	(value1, value2, value3, ...),
	(value1, value2, value3, ...)

NOTE: jesli nie wybierzemy konkretnych kolumn to sql bedzie to rozumial to tak ze chcemy dodac dane do
wszystkich kolumn

NOTE: ilosc kolumn i values ma byc taka sama
*/
USE MyDatabase

SELECT *
FROM dbo.customers

INSERT INTO dbo.customers (id, first_name, country, score)
VALUES
	(6, 'Anna', 'USA', NULL),
	(7, 'Sam', NULL, 100)
-- dodaje nowe wiersze do tabeli customers, zgodnie z tym co zapisalismy

INSERT INTO dbo.customers (id, first_name, country, score)
VALUES
	(8, 'USA', 'MAX', NULL)
/*jesli uzywamy odpowiednich datatypes to baza danych pozwoli nam je wpisac nawet jesli nie maja
 sensu w kontekscie naszej pracy */

 DELETE FROM dbo.customers -- usuwamy z customers
 WHERE id = 8; -- tam gdzie id jest = 8; NOTE: jesli nie damy WHERE to cala tabela stanie sie pusta!!

 INSERT INTO dbo.customers (id, first_name)
 VALUES
	(8,'Andreas'),
	(9, 'Sarah')

/*NOTE: kolumny nie zawarte w poleceniu INSERT domyslnie beda uznawane jako NULL'e (o ile nie instnieje
default albo constraint).*/

/*task: Copy data from 'customers' table into 'persons */

CREATE TABLE dbo.persons
(
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

/*uzywamy Selecta ponizej do dodania danych do innej tabeli
(wynik zapytania SELECT doda sie do innej tableli) */
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT
	id,
	first_name, --kolumny moga miec inne nazwy poniewaz baze danych obchodzi w typ przypadku jedynie typ danych
	NULL, --dajemy wartosc NULL bo nie mamy daty urodzenia w customers i MOZE byc NULL
	'Unknown' --wartosc statyczna (deafaultowa) bo w customers nie mamy numeru telefonu a NIE moze byc NULL
FROM dbo.customers

SELECT*
FROM dbo.persons

-----------------------------------------------------------------------------------------------------------------------
/*
UPDATE syntax:

UPDATE table_name
SET
	column1 = value1,
	column2 = value2
WHERE <condition>

NOTE: zawsze uzywa sie WHERE aby uniknac aktualizowania WSZYSTKICH wierszy!
*/

/*task: Change the score of customer with ID 6 to 0 */

UPDATE dbo.customers
SET	score = 0
WHERE id = 6 --pamietamy o where condition!

SELECT*
FROM dbo.customers
WHERE id = 6
-- BEST PRACTICE: sprawdz przed wykonaniem za pomoca selecta ktore wiersze zostana zmienione!

/*task: Change the score of customer with ID 10 to 0 and update the country to 'UK'*/

INSERT INTO dbo.customers (id, first_name, country, score)
VALUES (10, 'Maciek', 'POLAND', 345)

UPDATE dbo.customers
SET
	score = 0,
	country = 'UK'
WHERE id = 10

SELECT*
FROM dbo.customers
WHERE id = 10   -- sprawdzenie po UPDATE; przed zmiana uruchom SELECT osobno, zanim wykonasz UPDATE

/*task: Update all customers with a NULL score by setting their score to 0 */

UPDATE dbo.customers
SET score = 0
WHERE score IS NULL  -- tam gdzie cos jest NULL'em

SELECT*
FROM dbo.customers
WHERE score IS NULL

---------------------------------------------------------------------------------------------------------------
/*
DELETE syntax:
	DELETE FROM table_name
	WHERE <condition>

NOTE: tak jak z update zawsze dajemy where condition bo usuniemy WSZYSTKIE wiersze !!
*/

/*task: Delete all customers with an ID greater than 5 */

DELETE FROM dbo.customers
WHERE id > 5

SELECT*
FROM dbo.customers
WHERE id > 5

/*task: Delete all data from the persons table */

-- DELETE FROM dbo.persons tez usunie wszystkie wiersze.
TRUNCATE TABLE dbo.persons
/* TRUNCATE zwalnia strony zamiast logowac usuniecie kazdego wiersza.
Wymaga innych uprawnien, resetuje IDENTITY i ma ograniczenia (np. przy FK).
W SQL Server mozna go wycofac w transakcji. Wybieramy po semantyce, nie tylko szybkosci. */
SELECT*
FROM dbo.persons
-- NOTE: tabela dalej instnieje po tych komendach ale jest pusta
