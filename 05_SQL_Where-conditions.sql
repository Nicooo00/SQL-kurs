-----------------WHERE OPERATORS--------------------
/*
-comparison operators
-logical operators
-range operator
-membership operator
-search operator
*/

/*-------comparison operators---------*/
/*
structure:
condition -> EXPRESSION Operator EXPRESSION
*/

/*task: Retrieve all customers from Germany*/

Use MyDatabase

SELECT*
FROM dbo.customers
WHERE country = UPPER('GERMANY')  -- porownuje ze stringem w tabeli ale zapisanym wielkimi literami

/*task: Retrieve all customers who are not from Germany*/

SELECT*
FROM dbo.customers
WHERE country != UPPER('GERMANY')  --- mozna zamiast != uzyc <> to dziala tak samo

/*task: Retrieve all customers with a score greater than 500*/

SELECT*
FROM dbo.customers
WHERE score > 500

/*task: Retrieve all customers with a score 500 or more*/

SELECT*
FROM dbo.customers
WHERE score >= 500

/*task: Retrieve all customers who are from the USA and have a score greatere than 500*/

SELECT*
FROM dbo.customers 
WHERE country = UPPER('USA') AND score > 500 -- to i to ma byc prawdziwe

/*task: Retrieve all customers who are either from the USA or have a score greater than 500*/

SELECT*
FROM dbo.customers
WHERE country = UPPER('USA') OR score > 500  -- to albo to ma byc prawdziwe

/* Retrieve all customers with a score NOT less than 500*/

SELECT*
FROM dbo.customers
WHERE NOT score < 500 -- not odwraca logike zapytania

/* Retrieve all customers whose score falls in the range between 100 and 500*/

SELECT*
FROM dbo.customers
WHERE score BETWEEN 100 AND 500  -- between to jest nasz zakres i jest on inkluzywny (100 i 500) tez naleza

/*task: Retrieve all customes from either Germany OR USA*/

SELECT*
FROM dbo.customers
WHERE country IN (UPPER('Germany'), UPPER('Usa')) -- sprawdza czy cos jest "IN" lista. liste wypisuje w nawiasie
-- jest tez polecenie NOT IN ktore dziala analogicznie (jest to polaczenie bardziej ale zostawmy to tak)


/*-----------LIKE----------*/
/*
schemat: like -> pattern -> % lub _
% - oznacza ze cokolwiek spelnia warunki naszego zapytania np po jakiejs literze
_ (underscore) - oznacza ze tak jakby exact one (patrz przyklad na dole), poprostu cos ma byc w tym miejscu
ex.1
M%:  Maria, Ma, M - ok
Emma - zle

ex.2
%in: Martin,Gin,in - ok
intern - zle

ex.3
%r% - znaczy ze jesli gdziekolwiek wystapi 'r' to spelni warunek

ex.4
__b%: Albert,abbek,Rob - ok
Abel, An - zle
*/

/*task: Find all customers whose first name starts with 'M'*/

SELECT*
FROM dbo.customers
WHERE first_name LIKE 'M%'

/*task: Find all customers whose first name contains 'r'*/

SELECT*
FROM dbo.customers
WHERE first_name LIKE '%r%'

/*task: Find all customersa whose first name ends with 'n'*/

SELECT*
FROM dbo.customers
WHERE first_name LIKE '%n'

/*task: Find all customers whose first name has 'r' in the third position*/

SELECT*
FROM dbo.customers
WHERE first_name LIKE '__r%'

--extra logical operators: ALL, EXISTS,