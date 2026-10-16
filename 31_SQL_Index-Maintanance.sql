------------------SQL Index Maintenance-----------------
/*
Indexy w naszej bazie danych trzeba 'pielegnowac', poniewaz
jesli index jest nieuzywany to zabiera niepotrzebnie miejsce w pamieci
oraz spowalnie zapis do naszych tabel. 


INDEX MANAGEMENT:
1. Monitor Index Usage
2. Monitor Missing Indexes
3. Monitor Duplicate Indexes
4. Update Statistics
5. Monitoring Fragmentation

*/

---------Monitor Index Usage---------

sp_helpindex 'Sales.Ctest' -- polecenie do sprawdzania indexow danej tabeli

-- 'Sys system schema' - zawiera metadane o tabelach, widokach, indexach. etc

SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	is_primary_key AS IsPrimaryKey,
	is_unique AS IsUnique,
	is_disabled AS IsDisabled,
	s.user_seeks AS [UserSeeks],
	s.user_scans AS [UserScans],
	s.user_lookups AS [UserLookups],
	s.user_updates AS [UserUpdates],
	COALESCE(s.last_user_seek,s.last_user_scan) [LastUpdate]
FROM sys.indexes idx
INNER JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats as s
ON  s.object_id = tbl.object_id
AND s.index_id = idx.index_id
ORDER BY
	tbl.name,
	idx.name

-- To powyzej to pierwsza rzecz ktora powinno sie robic,
-- jak dolacza sie do jakiegos projektu.
-- Omawiamy nieuzywane indexy i jesli sa niepotrzebne to
-- je usuwamy.

SELECT*
FROM Sales.Products
WHERE Product = 'Caps'

SELECT*
FROM sys.dm_db_index_usage_stats


/* 
Zeby sprawdzic faktyczny usage musimy wejsc w  DMV
(Dynamic Management View). Zawiera op aktualne dane o 
wydajnosci bazy danych i zdrowiu systemu.
*/

----------------Monitor Missing Indexes----------------

USE AdventureWorksDW2022
SELECT
	fs.SalesOrderNumber,
	dp.EnglishProductName,
	dp.Color
FROM		FactInternetSales fs
INNER JOIN DimProduct dp
ON		fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
AND fs.OrderDateKey BETWEEN 20101129 AND 20101231

SELECT*FROM sys.dm_db_missing_index_details 

-- te informacje sa przechowywane w cachu
/*
beda wyswietlac sie informacje na temat tego gdzie baza danych sugeruje stworzenie indexu
(dla tych included columns chodzi o dodatnie INCLUDE to indexu.). Najpierw trzeba jednak
pomyslec czy taki index napewno jest nam potrzebny.
*/

-------------Monitor Duplicate Indexes-------------
/*

*/

SELECT
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount -- nasza flaga
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY
		ColumnCount DESC

--------------Update Statistics--------------
/*
Jesli dane w naszych tabelach statystycznych (te tabele
tworza sie automatycznie gdy tworzymy jakas tabele) sa nieaktulne
baza danych moze nieoptymalnie dobierac swoj execution plan
*/

SELECT 
	SCHEMA_NAME (t.schema_id) AS SchemaName,
	t.name AS TableName,
	s.name AS StatisticName,
	sp.last_updated As LastUpdate,
	DATEDIFF(day,sp.last_updated, GETDATE()) As LastUpdateDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) As sp
ORDER BY
	sp.modification_counter DESC;

UPDATE STATISTICS Sales.Ctest _WA_Sys_00000001_04E4BC85 -- updatujemy dana statystyke

UPDATE STATISTICS Sales.Ctest -- updatujemy wszystkie statystyki dla tabeli

EXEC sp_updatestats

/* 
Aktualizowanie statystyk mozna robic np. na koniec tygodnia, aby statystiki tabel
i indexow byly aktualne. Przydatne jest to takze po migracji danych.
*/


---------------Monitoring Fragmentation---------------
/*
Fragementacja - nieuzyte miejsce w stronach danych
(Data Pages), lub strony te sa nieuporzadkowane.

Mamy 2 medoty aby temu zaradzic:
	-- Reorganize
		degragmentuje liscie by byly posortowany
		lekka operacja
	-- Rebuild
		tworzy index od nowa
		ciezka operacja
*/

SELECT*
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')

-- oczekiwana wartosc avg_fragentation_in_percent to 0
-- 100 oznacza ze index jest zupelnie zfragmentowany (nieuporzadkowany)

SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	s.avg_fragmentation_in_percent,
	s.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl
ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx
ON idx.object_id = s.object_id
AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC

/*
Kiedy defragementowac?
<10% No Action needed
10-30% Reorganize
> 30% Rebuild
*/

ALTER INDEX idx_Ctest_FirstName ON Sales.Ctest
REORGANIZE -- bedzie trwalo w miare krotko

ALTER INDEX idx_Ctest_FirstName ON Sales.Ctest
REBUILD -- bedzie trwalo dlugo
