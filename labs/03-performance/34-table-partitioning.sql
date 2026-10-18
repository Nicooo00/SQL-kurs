-- Lesson 34 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-----------------SQL TABLE PARTITIONING----------------
/*
SQL partycjonowanie - dzieli duza tabele na mniejsze partycje
a jednocześnie jest traktowana jako pojedyncza tabela logiczna.
Eliminacja partycji moze ograniczyc odczyt, jesli predykat pasuje do klucza partycjonowania.
Samo partycjonowanie nie gwarantuje przyspieszenia; wazne sa plan, indeksy i rozklad danych.
Partycje pozwalaja tez na procesowanie rownolegle (parallel processing)
Procesory moga dzialac rownoczesnie na roznych partycjach.

1. Partition Function - definiuje logike okreslająca, jak podzielic dane na partycje
Stanie sie to na podstawie klucza partycjonowania (Partition Key) like
(Column,Region,Dates..)

2. Filegroups - Logiczny kontener na jeden lub więcej plikow danych, pomagajacy organizowac partycje.

3. Datafiles - przypisujemy do naszych filegroups pliki .ndf. To fizyczne pliki
gdzie nasze dane bede faktycznie przechowywane.

4. Partition Scheme - musimy zmapowac nasze partycje do naszych filegrops (grup plikow)

5. Create the Partitioned Table

6. Insert Data Into thje Partitioned Table
*/
--1.

CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31')

SELECT
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions

-- barra zaleca sprawdzanie czy moze mamy juz
-- funkcje partycjonujaca w naszym projekcie
-----------------------------------------------------------------------
--2.

-- OPCJONALNY przyklad fizycznego rozmieszczenia. Domyslny lab nie tworzy plikow systemowych.
/*
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023; -- tylko niezalezny pokaz usuwania PUSTEJ grupy

SELECT*
FROM sys.filegroups
WHERE type = 'FG' -- grupy plikow danych
-- tak sprawdzamy nasze Filegroups
-----------------------------------------------------------------------
--3.

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2023, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2023.ndf'
	-- w prawdziwych projektach trzeba spytac sie admina bazy danych gdzie mozna dac swoje
	-- datefiles dla partycji
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2024, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2024.ndf'
	-- w prawdziwych projektach trzeba spytac sie admina bazy danych gdzie mozna dac swoje
	-- datefiles dla partycji
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2025, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2025.ndf'
	-- w prawdziwych projektach trzeba spytac sie admina bazy danych gdzie mozna dac swoje
	-- datefiles dla partycji
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2026, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2026.ndf'
	-- w prawdziwych projektach trzeba spytac sie admina bazy danych gdzie mozna dac swoje
	-- datefiles dla partycji
) TO FILEGROUP FG_2026;

SELECT
	fg.name AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size / 128 AS SizeInMB
FROM
	sys.filegroups fg
JOIN
	sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE
	mf.database_id = DB_ID('SalesDB');
-----------------------------------------------------------------------------------------------------
*/

--4.

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
ALL TO ([PRIMARY]); -- cztery partycje logiczne, bez dodatkowych plikow
-- Opcjonalna alternatywa po utworzeniu filegroups i plikow:
-- TO (FG_2023,FG_2024,FG_2025,FG_2026); -- kolejnosc ma znaczenie!

SELECT
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id
-----------------------------------------------------------------------------------------------------
--5.

CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)

-----------------------------------------------------------------------------------------------------
--6.
-- TRUNCATE TABLE Sales.Orders_Partitioned; -- osobny destrukcyjny przyklad, niepotrzebny przy pierwszym uruchomieniu

INSERT INTO Sales.Orders_Partitioned VALUES
(1, '2023-05-15', 100),
(2, '2024-07-20', 100),
(3, '2025-02-01', 100),
(4,'2026-06-23',100);

SELECT*
FROM Sales.Orders_Partitioned

SELECT
	OBJECT_NAME(p.object_id) AS ObjectName,
	p.partition_number AS ParitionNumber,
	f.name AS PartitionFilefroup,
	p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id
JOIN sys.destination_data_spaces dds ON ps.data_space_id = dds.partition_scheme_id
AND p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = F.data_space_id
WHERE p.object_id = OBJECT_ID('Sales.Orders_Partitioned') AND p.index_id IN (0,1); -- sktypt barry

SELECT
    t.name AS TableName,
    ps.name AS PartitionScheme,
    p.partition_number AS PartitionNumber,
    p.rows AS NumberOfRows
FROM sys.tables t
JOIN sys.indexes i
    ON t.object_id = i.object_id
JOIN sys.partition_schemes ps
    ON i.data_space_id = ps.data_space_id
JOIN sys.partitions p
    ON i.object_id = p.object_id
    AND i.index_id = p.index_id
WHERE i.index_id IN (0, 1)
ORDER BY t.name, p.partition_number; -- sktypt ai
-------------------------------------------------------------------------------------------
--Sprawdzanie wydajnosci naszej partycji

SELECT*
INTO Sales.Orders_NotPartioned
FROM Sales.Orders_Partitioned

SELECT*
FROM Sales.Orders_NotPartioned
WHERE OrderDate = '2026-06-23'; -- porownaj Actual Number of Rows Read; wynik zalezy od planu

SELECT*
FROM Sales.Orders_Partitioned
WHERE OrderDate = '2026-06-23'; -- przy eliminacji partycji zakres odczytu moze byc mniejszy


SELECT*
FROM Sales.Orders_NotPartioned
WHERE OrderDate IN ( '2026-06-23','2025-12-31'); -- porownaj odczyty w planie

SELECT*
FROM Sales.Orders_Partitioned
WHERE OrderDate IN ('2026-06-23','2025-12-31'); -- porownaj partycje i odczyty, nie tylko liczbe zwroconych wierszy
