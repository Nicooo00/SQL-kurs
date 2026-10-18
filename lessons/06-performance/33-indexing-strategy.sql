-- Lesson 33 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE SalesDB;
GO

-----------------INDEXING STRATEGY-----------------
/*
Unikaj posiadania zbyt wielu INDEXOW!
Gdy jest ich zbyt wiele to:
	-- write do tabel zajmuje wiecej czasu,
	poniewaz baza danych musi updatowac tez
	indexy,
	-- exectution plan nie bedzie optymalny
	i robienie go zajmie wiecej czasu

Mozemy podzielic tworzenie strategii indexowania na 4 fazy.

Phase#1
Initial indexing strategy:

Jaki jest glowny cel naszej strategii indexowania?

OLAP (Online Analytical Processing)
DATA WAREHOUSE (DWH)
W takim podejsciu czesto czytamy wiele wierszy, ale tylko wybrane kolumny.
Zwykle bardziej optymalizujemy READ performance.
Do tabeli fakt bedziemy podpinac dimensions i robic duze analizy
wiec COLUMNSTORE.

OLTP (Online Transaction Processing)
Optimazine Read or Write?
Zwykle bardziej optymalizujemy WRITE performance.
Wiele malych tabel, bedziemy uzywac
CLUSTERED INDEX PK


Phase#2
Usage Patterns Indexing:

1. Okreslamy czesto uzywane Tabele i kolumny (mozna dac zapytania do chata do analizy
zeby policzyl czego uzywamy czesto)

2. Wybieramy wlasciwy index (clustered non clustered, row store column store, unique,filtered,heap )

3. testujemy index



Phase#3
Scenario based indexing:
1. Identyfikujemy wolne zapytania (na dole skrypt)
2. Sprawdz execution plans (plany wykonania)
3. Wybierz wlasciwy index
4. (Test) Porownaj plany wykonywania


Phase#4
Monitoring and Maintenance
1. Monitoruj uzycie indexow w planach wykonywania
2. Monitoruj brakujace indexy
3. Monitoruj zdublowane indexy
4. Aktualizuj statystyki
5. Pilnuj fragmentacji indeksow.

NOTE: mozna zrobic sobie dashboard w PowerBIm,ktory monitoruje zdrowie naszych
indeksow.

*/


--1. Zapytania o najwiekszym lacznym czasie w biezacym cache.
-- TotalElapsedTime laczy koszt i czestotliwosc; AvgElapsedTime to sredni czas jednego wykonania.
-- Dane sa w mikrosekundach, cache moze byc wyczyszczony, a tekst moze zawierac cala partie.
SELECT
	TOP 10
	qs.total_elapsed_time AS TotalElapsedTime,
	qs.execution_count,
	qs.total_elapsed_time / NULLIF(qs.execution_count,0) AS AvgElapsedTimeMicroseconds,
	qs.total_worker_time AS TotalCPUTime,
	qs.last_execution_time,
	qt.text AS QueryText
FROM
	sys.dm_exec_query_stats qs
CROSS APPLY
	sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY
	qs.total_elapsed_time DESC;
