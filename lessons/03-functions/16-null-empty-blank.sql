-- Lesson 16 | READ ONLY: learning queries
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
--NULL vs Empty String vs Blank Space--
/*
NULL oznacza brak/nieznana wartosc, nie osobny typ danych.
Pamiec zalezy od typu, formatu wiersza i kompresji; nie ma rankingu szybkosci NULL vs string.
szukamy przez: IS NULL

Empty String to taki string ktory ma 0 znakow. typ to np. VARCHAR(n), nie String(0). Przechowywanie zalezy od typu.
szukamy przez: =''

Blank Space ' ' to taki String ktory jedna lub wiecej znakow spacji w sobie. typ to np. VARCHAR(n).
SQL Server przy = dopelnia stringi spacjami, wiec ='' moze tez pasowac do ' '.
Dla VARCHAR: DATALENGTH(col)=0 wykrywa pusty string; >0 i TRIM(col)='' same spacje.

Obsluga tych 3 przypadkow jest kluczowa aby unikac bledow w naszych analizach i nie tylko.
Robiac projekt trzeba bedzie sie ugadac na DATA POLICY czyli zestaw zasad ktory definiuje
jak dane powinny byc przechowywane.

Przykladowy DATA POLICY:
1. Uzywaj tylko NULL i Empty String, ale unikaj blank spaces.
2. Uzywaj tylko NULLS i unikaj uzywania pustych stringow i blank spaces.
3. Uzywaj tylko defaultowej wartosci 'unknown' i unikaj uzywania nulli,
   pustych stringow i blank spaces.


2 zasada Use case: Zmiana pustych stringow i blankow przez NULL
podczas przygotowywania danych przed wstawieniem do bazy danych
by spojnie reprezentowac brak wartosci (nie gwarantuje to oszczednosci pamieci ani czasu).

3 zasada Use case: Zamiana pustych stringow, blankow, NULLI przez wartosc domyslna
podczas przygotowywania danych przed uzyciem danych w raporcie by polepszyc czytelnosc
i zminimalizowac niezporozumienia.
*/

;WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)

SELECT
*,
DATALENGTH(Category) as CategoryLen, -- sprawdza dlugosc danych w polu
DATALENGTH(TRIM(Category)) as Policy1 -- mozna na cala kolumne zastosowac takie funkcje
FROM Orders;

--NOTE:Po uzyciu trim mozemy byc pewni ze Policy1 zostanie spelnione.

;WITH Orders2 AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)

SELECT
*,
TRIM(Category) as Policy1,
NULLIF(TRIM(Category),'') -- trim wymusza policy1 a wiec sa tylko nulle i empty stringi.
--wiec mozemy sprytnie tak sprawdzic czy mamy jakies empty string, jesli tak to
--NULLIF zwroci NULL (bo wartosci sa takie same) Policy 2
FROM Orders2;

;WITH Orders3 AS (
SELECT 1 Id, CAST('A' as VARCHAR(20)) Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)

SELECT
*,
TRIM(Category) as Policy1,
NULLIF(TRIM(Category),'') as Policy2,
ISNULL(NULLIF(TRIM(Category), ''),'unknown') as Policy3 -- gdyby nie cast na VARCHAR(20) to pokazaloby 'un',
-- Bez CAST typ Category ma dlugosc 2 od najdluzszego literalu ('  ') w UNION.
-- ISNULL zachowuje typ i dlugosc pierwszego argumentu, wiec ucina 'unknown' do 'un'.
FROM Orders3
