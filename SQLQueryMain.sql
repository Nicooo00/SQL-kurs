USE ClaudeDB

ALTER TABLE employees
ADD	email VARCHAR(100) NOT NULL

EXEC sp_rename 'books.price', 'retail_price', 'COLUMN'