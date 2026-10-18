-- Lesson 29 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-- Prerequisite: run lab 28 to create Sales.Ctest and its rowstore indexes.
----------------SQL COLUMNSTORE INDEX-----------------
/*
Przechowuja i kompresuja dane kolumnami w rowgroups; to nie oznacza automatycznego sortowania.
Wpierw dzieli wiersza na grupy np po miliono. potem nastepuje kopresja danych,
a nastepnie informacje zapisuja sie do LoB PAGE (Large Object Page).
W LoB znajduja sie nieco inne informacje takie jak:
DictionaryID. Dictionary id to taki tlumacz data streamu (1,2,1,1,2,)
na faktyczne wartosci w tabeli (active - 1 , inactive - 2).
Jesli zrobimy clustered columnstore index to mamy nowa strukture
danych. jesli zrobimy non-clustered to tak sie nie stanie bedzie
to "dodatek" ktory moze nam przyspieszyc prace zapytania jesli nadaje
sie ono do "uzycia" indexu.

COLUMNSTORE INDEXING jest duzo lepszy dla analiz bigData. Glownie przez
to ze tworzy sobie te dictionaries, a nie tylko sortuje dane jak w
clustered rowstore index albo robi b-tree wzkaznikow do recordow.

FAST read performance
SLOW write performance

To ogolna wskazowka dla duzych skanow/agregacji, nie gwarancja dla kazdego zapytania.
Kompresja nie zawsze korzysta ze slownika; efekt zalezy od danych i rozmiaru rowgroups.

-------------------------------------------------------------------
ROWSTORE INDEX jest najlepszy dla:

OLTP(Transactional)
commerce,banking,Financial systems,
order processing.

Jest tak poniewaz cale rekordy sa uzywane czesto.

USE CASES:
	--High frequency transaction applications
	--Quick access to complete records

------------------------------------------------------------------
COLUMNSTORE INDEX jest najlepszy dla:

OLAP(Analitycal)
Data Warehouse,Business Intelligence,
Reporting, Analitics

Jest tak poniewaz pracujemy z duza iloscia danych,
czesto mocno agregowanych.

USE CASES:
	--Big Data Analytics
	--Scanning of large datasets
	--Fast aggregation

------------------------------------------------------------------

COLUMNSTORE INDEX SYNTAX:

CREATE [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX index_name
ON table_name(column1, column2, ...)
*/

DROP INDEX IF EXISTS [idx_DBCustomers_CS]
ON Sales.Ctest

DROP INDEX IF EXISTS [idx_Ctest_CustomerID]
ON Sales.Ctest

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.Ctest

-- Alternatywa dla rowstore: przed NCCI usuwamy CCI; nie moga wspolistniec na tej tabeli.
DROP INDEX idx_DBCustomers_CS ON Sales.Ctest;
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.Ctest (FirstName)

-- OPCJONALNE: wymaga osobnej kopii AdventureWorksDW2022; zaznacz ten blok po przygotowaniu bazy.
/*
USE AdventureWorksDW2022
GO

------3 Przyklady tabel
--HEAP
SELECT*
INTO FactInternetSales_HP
FROM dbo.FactInternetSales

--RowStore
SELECT*
INTO FactInternetSales_RS
FROM dbo.FactInternetSales

CREATE CLUSTERED INDEX idx_FactInterSales_RS_PK
ON dbo.FactInternetSales_RS(SalesOrderNumber,SalesOrderLineNumber)

--ColumnStore
SELECT*
INTO FactInternetSales_CS
FROM dbo.FactInternetSales

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS
ON dbo.FactInternetSales_CS
*/
