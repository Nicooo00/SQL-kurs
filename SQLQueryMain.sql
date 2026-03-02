USE ClaudeDB

/* -------------DDL--------------*/

ALTER TABLE employees
ADD	email VARCHAR(100) NOT NULL

EXEC sp_rename 'books.price', 'retail_price', 'COLUMN'

ALTER TABLE books
DROP COLUMN published_date

CREATE TABLE orders (
	order_id INT NOT NULL,
	customer_name VARCHAR(100) NOT NULL,
	order_date DATE NOT NULl,
	[status] VARCHAR(20) DEFAULT 'pending',
	amount DECIMAL(10,2) CHECK(amount > 0)
	CONSTRAINT pk_orders PRIMARY KEY (order_id)
)

CREATE TABLE departments (
	dept_id INT NOT NULL,
	dept_name VARCHAR(50) NOT NULL,
	CONSTRAINT pk_departments PRIMARY KEY(dept_id)
)

CREATE TABLE staff (
	staff_id INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	dept_id INT,
	CONSTRAINT pk_staff PRIMARY KEY(staff_id),
	CONSTRAINT fk_staff FOREIGN KEY(dept_id)
	REFERENCES departments(dept_id)
)

/*-------------DML---------------*/

INSERT INTO books (
	id,
	title,
	author,
	retail_price
)
VALUES (
	1,
	'Potop',
	'Henryk Sienkiewicz',
	50
)

SELECT * FROM books

INSERT INTO books (
	id,
	title,
	author,
	retail_price
)
VALUES 
	(2,'Lalka','Boleslaw Prus',70),
	(3,'Harry Potter','J.K Rowling',30),
	(4,'Dziady cz.3','Adam Mickiewicz',40)

UPDATE books
	SET retail_price = 45
	WHERE title = 'Harry Potter'

DELETE FROM books
	WHERE title = 'Dziady cz.3'

/*------------SELECT QUERIES-------------*/

USE MyDatabase

SELECT * FROM customers

SELECT first_name,country FROM customers

SELECT * FROM customers
WHERE country = 'Germany'

SELECT * FROM customers
WHERE score > 400

SELECT * FROM customers
WHERE country = 'USA' and score > 500

SELECT * FROM customers
WHERE country = 'Germany' or score > 700

SELECT * FROM customers
ORDER BY score DESC

SELECT TOP 3 * FROM customers
ORDER BY score DESC

SELECT DISTINCT country FROM customers

SELECT first_name AS 'Customer Name', score AS 'Loyalty Score' FROM customers

USE SalesDB
SELECT * FROM Sales.Customers
WHERE LastName is NULL

SELECT * FROM Sales.Customers
WHERE LastName is NOT NULL
