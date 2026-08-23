----------LEFT ANTI JOIN-----------
/*
Zwraca wiersze z A ktore NIE maja dopasowan po key column w B (graficznie;; A bez B).
Tabela A jest glownym zrodlem danych. Tabela B jest tabela lookup (filtrem).

struktura left anti join:

SELECT*
FROM A
LEFT JOIN B
ON A.Key = B.Key
WHERE B.key IS NULL -- bierze tylko te wiersze gdzie nie ma dopasowania po kluczu

*/

USE MyDatabase

/*task: Get all customers who haven't placed any order*/

SELECT
	c.id,
	c.first_name,
	o.sales
FROM dbo.customers AS c
LEFT JOIN dbo.orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

---------RIGHT ANTI JOIN-----------
/*
Zwraca wiersze z B ktore NIE maja dopasowan po key column z A (graficznie;; B bez A)
Tabela B jest glownym zrodlem danych. Tabala A jest tabela lookup (filtrem).
Dziala analogicznie jak LEFT ANTI JOIN.

struktura right anti join:

SELECT*
FROM A
RIGHT JOIN B
ON A.Key = B.Key
WHERE A.Key IS NULL

*/

/*task: Get all orders without matching customers*/

SELECT
	o.customer_id,
	o.order_id,
	o.order_date
FROM dbo.customers AS c
RIGHT JOIN dbo.orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL

/*task: Get all orders without matching customers (Using LEFT ANTI JOIN)*/

SELECT
	o.customer_id,
	o.order_id,
	o.order_date
FROM dbo.orders AS o
LEFT JOIN dbo.customers AS c
ON o.customer_id = c.id
WHERE c.id IS NULL

------------FULL ANTI JOIN-----------
/*
Zwraca wiersze ktore nie doposowuja sie w po key column o obu tabelach (graficznie;; A suma B \ A iloczyn B
- poprostu bez czesci wspolnej, only unmatching data). 

struktura full anti join:

SELECT*
FROM A
FULL JOIN B
ON A.Key = B.Key
WHERE 
	B.Key IS NULL OR
	A.Key IS NULL

*/

/*task: Find customers without orders and orders without customers*/

SELECT
	c.id,
	c.first_name,
	o.customer_id,
	o.order_id,
	o.order_date
FROM dbo.customers AS c
FULL JOIN dbo.orders AS o
ON c.id = o.customer_id
WHERE
	o.customer_id IS NULL OR
	c.id IS NULL

/*task: Get all customers along with their orders but only for customers who
have placed an order (Without Using INNER JOIN)*/

SELECT
	c.id,
	c.first_name,
	o.customer_id,
	o.order_id,
	o.order_date
FROM dbo.customers AS c
FULL JOIN dbo.orders AS o
ON c.id = o.customer_id
WHERE
	o.customer_id IS NOT NULL AND
	c.id IS NOT NULL --- albo left join i B.Key NOT NULL


-----------CROSS JOIN------------
/*
Zwraca wszystkie kombinacje polaczen. To jest laczy kazdy wiersz a A z kazdym wierszem z B.
All Possible Combinations - Cartesian Join.
NOTE:: z tym trzeba uwazac po ilosc kombinajcji to l_wA * l_wB.

struktura cross join:

SELECT*
FROM A
CROSS JOIN B

*/

/*task: Generate all possible combinations of customers and orders*/

SELECT*
FROM dbo.customers AS c
CROSS JOIN dbo.orders AS o
