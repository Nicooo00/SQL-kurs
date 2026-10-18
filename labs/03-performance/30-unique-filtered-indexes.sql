-- Lesson 30 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-------------------Unique and Filtered Indexes----------------------

--------------Unique Index-------------
/*
Specjalny typ indexu,który zapewnia brak duplikatow w
danej kolumnie.

Benefits:
-- Wymusza unikalnosc w danych,
-- Nieznacznie poprawia wydajnosc zapytan(poniewaz SQL nie
   bedzie szukal dalej jak znajdzie dana szukana wartosc raz).

Sprawdzanie unikalnosci ma koszt przy zapisie; informacja o unikalnosci pomaga optymalizatorowi.
Nie daje to ogolnej gwarancji szybszego odczytu ani wolniejszego zapisu.

Syntax:

CREATE UNIQUE [CLUSTERED | NONCLUSTERED] INDEX index_name
ON table_name (column1, column2,...)
*/

SELECT*

FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product)

-- OCZEKIWANY BLAD 2601: odkomentuj tylko aby zobaczyc naruszenie unikalnosci.
-- INSERT INTO Sales.Products (ProductID,Product)
-- VALUES (106,'Caps') -- nie mozna dodawac bo unique index wymusza unikalnosc
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
