-- Lesson 10 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-------------String Functions---------------

/*

Typy string functions:
- manipulation (concat,upper,lower,trim,replace)
- calculation (len)
- string extraction (left, right, substring)

*/

-------------CONCAT------------
/*
Laczy wiele stringow w jeden.
*/

USE SalesDB
GO

/*task: Concatenate first name and country into one column*/

SELECT
	CONCAT(FirstName, ' ' ,Country) AS concatenation
FROM Sales.Customers

------------UPPER i LOWER------------
/*
UPPER zmienia litery na wielkie, LOWER na male
*/

/*task: Convert the first name to lowercase or uppercase */

SELECT
	LOWER(FirstName) as male_imiona,
	UPPER(LastName) as duze_nazwiska
FROM Sales.Customers

USE MyDatabase;
GO

----------------TRIM---------------
/*
Usuwa spacje na poczatku i na koncu stringa.
*/

/*task: Find customers whose first name contains leading or trailing spaces*/

SELECT
	first_name,
	TRIM(first_name) as bez_spacji
FROM dbo.customers
WHERE DATALENGTH(first_name) <> DATALENGTH(TRIM(first_name));
-- DATALENGTH wykrywa tez koncowe spacje; LEN je pomija.

--lub

SELECT
	first_name,
	DATALENGTH(first_name) as original_bytes,
	DATALENGTH(TRIM(first_name)) as trimmed_bytes,
	DATALENGTH(first_name) - DATALENGTH(TRIM(first_name)) as flag
FROM dbo.customers
WHERE DATALENGTH(first_name) <> DATALENGTH(TRIM(first_name));

---------------REPLACE--------------
/*
Zamienia konktretny znak nowym znakiem lub usuwa znak (wtedy dajemy '').
*/

/*task: Remove dashes (-) from a phone number*/

SELECT
	'123-456-678' as numer_telefonu,
	REPLACE('123-456-678','-','');

SELECT
	'report.txt' as txt,
	REPLACE('report.txt','.txt','.pdf') as pdf;

/*
SELECT
    CustomerID,
    Phone,
    REPLACE(Phone, '-', ' ') AS FormattedPhone
FROM Customers;
to zadziala tak ze kazdy numer telefonu z kolumny Phone zostanie sformatowany
*/


-----------------LEN-----------------
/*
Liczy znaki z pominieciem koncowych spacji. DATALENGTH mierzy bajty, nie znaki.
*/

/*task: Calculate the length of each customer's first name*/

SELECT
	first_name,
	LEN(TRIM(first_name)) as ile_liter -- jakbym nie dal trim to john by pokazalo ze ma 5 bo spacje tez sie licza
FROM dbo.customers


-------------LEFT i RIGHT--------------
/*
LEFT  ekstraktuje podana liczbe znakow od poczatku stringa.
RIGHT ekstraktuje podana liczbe znakow od konca stringa.
*/

/*task: Retrieve the first two charakters of each first name*/

SELECT
	first_name,
	LEFT(TRIM(first_name),2) as pierwsze_dwie
FROM dbo.customers

/*task: Retrieve the last two characters of eacxh first name*/

SELECT
	first_name,
	RIGHT(TRIM(first_name),2) as ostatnie_dwie
FROM dbo.customers;

---------------SUBSTRING--------------
/*
Zwraca czesc stringa w okreslonej pozycji.
struktura: SUBSTRING(Value, Start, Lenght)
Uzywa sie tego do zwracania czesci stringow od okreslonego miejsca.
Jesli mamy za zadanie np wydobyc wszystkie znaki od drugiego znaku
to jako parametr Lenght uzywamy funkcji LEN().  (dynamiczna dlugosc)
*/

/*task: Retrieve a list of customers' first names after removing the
first character*/

SELECT
	first_name,
	SUBSTRING(TRIM(first_name),2,LEN(first_name)) as litery_po_1
FROM dbo.customers
