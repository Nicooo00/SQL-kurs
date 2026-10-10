----------------SQL COLUMNSTORE INDEX-----------------
/*
Sortuja dane nie po wierszach jak w indexaxh rowstore ale po kolumnach.
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

DROP INDEX [idx_DBCustomers_CS]
ON Sales.Ctest

DROP INDEX [idx_Ctest_CustomerID]
ON Sales.Ctest

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.Ctest

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.Ctest (FirstName)

USE AdventureWorks2022DW

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