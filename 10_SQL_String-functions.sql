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
USE MyDatabase

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

----------------TRIM---------------
/*
Usuwa spacje na poczatku i na koncu stringa.
*/

/*task: Find customers whose first name contains leading or trailing spaces*/

SELECT
	TRIM(first_name) as bez_spacji
FROM dbo.customers

EXCEPT

SELECT
	first_name
FROM dbo.customers

--lub

SELECT
	first_name,
	LEN(first_name) as len_name,  --- mozna wyswietlac ta sama kolumne wiele razy
	LEN(TRIM(first_name)) as len_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) as flag
FROM customers
--WHERE first_name != TRIM(first_name)

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
Liczy ile znakow jest w danym stringu.
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
