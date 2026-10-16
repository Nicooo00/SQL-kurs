-------------------Unique and Filtered Indexes----------------------

--------------Unique Index-------------
/*
Specjalny typ indexu,który zapewnia brak duplikatow w 
danej kolumnie.

Benefits:
-- Wymusza unikalnosc w danych,
-- Nieznacznie poprawia wydajnosc zapytan(poniewaz SQL nie 
   bedzie szukal dalej jak znajdzie dana szukana wartosc raz).

Zapis unikalnego indexu jest wolniejszy niz nieunikalnego,
natomiast odczyt jest szybszy niz przy uzyciu indexow nieunikalnych.

Syntax:

CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX index_name
ON table_name (column1, column2,...)
*/

SELECT*

FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product)

INSERT INTO Sales.Products (ProductID,Product)
VALUES (106,'Caps') -- nie mozna dodawac bo unique index wymusza unikalnosc 
-- dla danej kolumny


--------------------Filtered Index---------------------
/*
To index zawierajacy tylko wiersze, ktore spelniaja okreslone
warunki.

Benefits:
-- ukierunkowa optymalizacja
-- przez to ze interesuja nas czesc danych sam index bedzie zajmowal
   mniej miejsca.

Syntax:

CREATE [UNIQUE] [NONCLUSTERED] INDEX index_name 
ON table_name (column1, column2, ...)
WHERE [Condition]

Nie mozna utworzyc takiego indexu na indexie klastowanym,
ani kolumnowym klastrowanym.
*/

SELECT*
FROM Sales.Customers
WHERE Country = 'USA'

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA'