-- Lesson 08 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

---------JOINING MULTIPLE TABLES ---------------
/*
Jesli interesuje nas czesc wspolna roznych tabel to mozemy uzyc inner join.
Natomiast Baraa uzywa podejscia z LEFT JOIN i manipuluje to co chce otrzymac
uzywajac WHERE <conditions>.

NOTE:: dbo lub Sales oznaczaja schematy, dbo jest standartowy ale SalesDB ma inny container
wiec uzywamy Sales.

NOTE:: aby wylaczyc zapis do pliku klikamy na jakies opcje obok, najlepszy jest widok siatki

NOTE:: aby sprawnie i szybko byc w stanie laczyc rozne tabele, powinnismy miec albo robic ER table,
to jest Entity Relationship table. Dobre wieksze projekty powinny ja miec. Poki co uzywam rozwiniec
paska po lewej stronie czasem mozna po nazwac wywnioskowac o co chodzi.

*/

/*task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product
and employee details. For each order, display:
Order ID, Customer's name, Product name, Sales, Price, Sales person's name*/

USE SalesDB

SELECT
	o.OrderID,
	o.Sales,
	c.FirstName,
	c.LastName,
	p.Product as 'ProductName',
	p.Price,
	e.FirstName as 'SalesPersonName',
	e.LastName as 'SalesPersonLastName'
FROM Sales.Orders as o
LEFT JOIN Sales.Customers as c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products as p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees as e
ON o.SalesPersonID = e.EmployeeID
