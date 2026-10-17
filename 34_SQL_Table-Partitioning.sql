-----------------SQL TABLE PARTITIONING----------------
/*
SQL partycjonowanie - dzieli duza tabele na mniejsze partycje
a jednocześnie jest traktowana jako pojedyncza tabela logiczna.
Jesli podzielimy sobie duza tabele na partycje to SQL nie musi
skanowac calej tabeli lub indexu, co znacznie poprawia wydajnosc.
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

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023;

SELECT*
FROM sys.filegroups
WHERE type = 'FG'
-- tak sprawdzamy nasze Filegroups
-----------------------------------------------------------------------
--3.

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2023, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2023.mdf' 
	-- w prawdziwych projektach trzeba spytac sie admina bazy danych gdzie mozna dac swoje
	-- datefiles dla partycji
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2024, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2024.mdf' 
	-- w prawdziwych projektach trzeba spytac sie admina bazy danych gdzie mozna dac swoje
	-- datefiles dla partycji
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2025, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2025.mdf' 
	-- w prawdziwych projektach trzeba spytac sie admina bazy danych gdzie mozna dac swoje
	-- datefiles dla partycji
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2026, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\P_2026.mdf' 
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
--4.

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023,FG_2024,FG_2025,FG_2026) -- tutaj musimy zwrocic uwage na wlasciwa kolejnosc!

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
TRUNCATE TABLE Sales.Orders_Partitioned

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
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = F.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned'; -- sktypt barry

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
WHERE OrderDate = '2026-01-01'; -- odczytano 4 wiersze (plan wykonania -> wlasciwosci)

SELECT*
FROM Sales.Orders_Partitioned
WHERE OrderDate = '2026-01-01'; -- odczytano 1 wiersz


SELECT*
FROM Sales.Orders_NotPartioned
WHERE OrderDate IN ( '2026-01-01','2025-12-31'); -- 4 wiersze

SELECT*
FROM Sales.Orders_Partitioned
WHERE OrderDate IN ('2026-01-01','2025-12-31'); -- 2 wiersze