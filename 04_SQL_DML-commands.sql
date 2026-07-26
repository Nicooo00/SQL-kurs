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
	phone VARCHAR(15) NOT NULL
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
