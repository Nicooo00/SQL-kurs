----------JOINS-----------
/*
Mozemy laczyc tabele A i B na rozne sposoby. Jesli laczymy chcemy zlaczyc je po kolumnach to
uzywamy JOIN 'ow  (<--> tabela jest szersza). Jesli chcemy zlaczyc je po wierszach to uzywamy
SET Operators (tabela jest dluzsza).

Podstawowe Typy JOIN:
-inner join   // czesc wspolna A i B
-full join   // A suma B
-left join   // A czesc wspolna z B (dajemy by miec kolumny z B ;; graficznie cale A)
-right join  // B czesc wspolna z A (dajemy by miec kolumny z A ;; graficznie cale B)

NOTE:: jesli w key column znajdziemy wiecej niz jedno dopasowanie po id, na przyklad
jeden klient ma wiecej zamowien to w tymczasowej tabeli zjoinowanej bedzie on wystepowal
tyle razy ile ma zamowien.

**extra: no join

Postawowe Typy SET Operators:
-Union
-Union all
-Except (minus)
-Intersect

Aby zjoinowac 2 tabele potrzebna bedzie key column. Aby zlaczyc za pomoca SET Operators bedziemy
potrzebowali takiej samej liczby kolumn.
Key column jest potrzeba aby poprawnie przyporzadkowac dane w nowej tabeli AB. (przyklad takiej kolumny
to kolumna z id).
Przykladowe uzycia joinow.
1. data recombination (tworzeniem master table)
2. data enrichement (wzbogacanie master table)
3. check existence (joinujemy z lookup table i zostaje nam tylko to co chcielismy based on the join)

Tabela A to left table, a Tabela B to right table,

*/

/*task: Retrieve all data from customers and orders as separate results*/
USE MyDatabase

SELECT*
FROM dbo.customers;

SELECT*
FROM dbo.orders;  -- ten task to przyklad no joina (dwa osobne wyniki)

--------INNER JOIN--------
/*
Zwraca tylko powtarzajace sie wiersze w obu tabelach (only common data).
Defaul join w SSMS to INNER JOIN ale najlepsza praktyka jest zawsze okreslanie
typu naszego joina jaki chcemy wykonac.

struktura inner join:

SELECT*
FROM A
INNER JOIN B 
ON A.Key = B.Key

*/

/*task: Get all customers along with their orders but only for customers who have placed an order*/

SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
ON c.id = o.customer_id -- taki jest best practice napisania inner joina dla tego taska

--------LEFT JOIN---------

/*
Zwraca wszystkie wiersze z lewej tabeli i tylko pasujace (po key column) wiersze w prawej tabeli.
Robi sie je aby miec kolumny z tabeli b. Ten join "obsluguje" tez duplikaty. Jesli jakis klient ma
wiecej niz 1 zamowienie to bedzie w tymczasowej zjoinowanej tabeli wystepowal tyle razy ile ma zamowien.
Dla elementow wystepujacych w A ale nie w B kolumny "dodatkowe" od tabeli B beda mialy
wartosc NULL (chyba ze uzyjemy funkcji ISNULL() lub COALESCE() ).

struktura left join:

SELECT*
FROM A
LEFT JOIN B
ON A.Key = B.key

*/

/*task: Get all customers along with their orders including those without orders*/

SELECT
	c.id,
	c.first_name,
	o.customer_id,
	o.order_id
FROM dbo.customers AS c
LEFT JOIN dbo.orders AS o
ON c.id = o.customer_id

-------RIGHT JOIN-------

/*
Zwraca wszystkie wiersze z B i tylko pasujace z A (po key column).
Dziala analogicze jak LEFT JOIN tylko odwrotnie. W tym joinie to B jest glowna tabela,
a A jest dodatkowa.

struktura right join:

SELECT*
FROM A
RIGHT JOIN B
ON A.Key = B.key

*/

/*task: Get all customers along with their orders, including orders
without matching customers*/

SELECT
	o.customer_id,
	o.order_id,
	c.first_name,
	c.score
FROM dbo.customers AS c
RIGHT JOIN dbo.orders AS o
ON c.id = o.customer_id

/*task: Get all customers along with their orders, including orders without 
matching customers (Using LEFT JOIN) */

SELECT
	o.customer_id, 
	o.order_id,
	c.first_name,
	c.country
FROM dbo.orders AS o
LEFT JOIN dbo.customers AS c
ON o.customer_id = c.id 

--NOTE: Zwykle uzywa sie left join poprostu zamienia sie kolejnosc tabeli, ale right join tez instnieje

----------FULL JOIN-----------
/*
Zwraca wszystkie wiersze z obu tabel (mamy tez wszystkie kolumny z A i B chyba ze chcemy inaczej).

struktura full join:

SELECT*
FROM A
FULL JOIN B
ON A.Key = B.Key

*/

/*task: Get all customers and all orders, even if there's no match*/

SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM dbo.customers AS c
FULL JOIN dbo.orders AS o
ON c.id = o.customer_id
