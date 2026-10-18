--NULL vs Empty String vs Blank Space--
/*
NULL oznacza nic! data type: Special marker. zabiera minimalna ilosc pamieci. najlepszy perfomance!
szukamy przez: IS NULL

Empty String to taki string ktory ma 0 znakow. data type: String(0). zajmuje pamiec. szybki performance
szukamy przez: =''

Blank Space ' ' to taki String ktory jedna lub wiecej znakow spacji w sobie. data type: String(tyle ile spacji)
zajmuje pamiec. wolny performance! szukamy przez =' '

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
by optymalnie zoptymizowac pamiec i osiagi.

3 zasada Use case: Zamiana pustych stringow, blankow, NULLI przez wartosc domyslna
podczas przygotowywania danych przed uzyciem danych w raporcie by polepszyc czytelnosc
i zminimalizowac niezporozumienia.
*/

WITH Orders AS (
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

WITH Orders2 AS (
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

WITH Orders3 AS (
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
-- poniewaz kolumana Category zostala zdefiniowana jako VARCHAR(1) przez to ze jest jedna litera, natomiast
-- przez to ze ISNULL porownywal ze spacja to zarezerwowal jeszcze jeden znak do wyniku, stad 'un'.
FROM Orders3
