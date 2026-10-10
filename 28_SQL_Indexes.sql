---------------------SQL INDEXES---------------------
/*
INDEX to struktura danych, ktora zapewnia szybki dostep do danych,
optymalizuja szybkosc naszych zapytan.

Kategorie podzialu indexow:
Po strukturze:
	-- Clustered Index
	-- Non-Clustered Index

Po sposobie przechowywania:
	-- Rowstore Index
	-- Columnstore Index

Po funkcji:
	-- Unique Index
	-- Filtered Index

Niektore Indexy sa lepsze do odczytu, a inne do optymizacji
wydajnosci.

Page (strona) to najmniejsza czastka podzialu danych w bazie danych (8kb)
Przechowuje wszystko (Dane, Metadane, Indexy,etc.)
	Typy stron:
	--data page
	--index page

HEAP = table without clustered Index
Przechowuje wiersze losowo, bez okreslonego porzadku.
Wiec mamy szybki write ale wolny odczyt danych.

W takiej tabeli nieideksowanej dochodzi do full table scan.
SQL skanuje sie cala tabele strona po stronie i wiersz po wierszu
w poszukiwaniu danych.

INDEX SYNTAX:

CREATE [CLUSTERED | NONCLUSTERED] INDEX index_name ON table_name 
(column1, column2,...)

Jak tworzymy tabele i okreslimy PRIMARY KEY to SQL odrazu zrobi nam
clustered index..
*/


----------------Clustered Index-----------------
/*
Gdy uzyjemy Clustered indexu np na ID danej tabeli, to 
SQL zbuduje B-Tree (balance tree).

B-Tree to hierarchiczna struktura przechowywania danych w lisciach
by pomoc szybko zlokalizowac dane.

Struktura B-Tree:

Root Node
	Intermediate Nodes
		Leaf Nodes

Faktyczne dane strony danych bede przechowywane w lisciach.
W Intermediate Nodes SQL bedzie przechowywal INDEX PAGES.

INDEX PAGES - przechowuja kluczowe wartosci(wskazniki) do kolejnych stron indeksow lub do
faktycznych stron danych (Data Page).
Nie przechowuje faktycznych wierszy.

*/

------------------Non-Clustered Index--------------------
/*
Non-clustered index nie bedzie reorganizowal ani zmienial niczego w
stronach danych. SQL zacznie budowac b-tree ale bedzie ono nieco inaczej
wygladalo. W stronie indexu bedzie przechowywane ID przyporzadkowane do
ID pliku -> numeru strony danych -> row offset (zeby baza wiedziala dokladnie gdzie jest
te id np. klienta). 
To tworzy nam tkzw. RID (row identifier).
W takim sposobie indeksowania liscmi nazywamy INDEX Pages gdzie znajdua sie RID do 
konkretnych wierszy.
NOTE: wyzej struktura wyglada jest uporzadkowana tak jak w Clustered Index tj.
dziala to podobnie jak w clustered index tylko ostatni poziom to nie faktyczne DATA PAGES tylko
wzkazniki na to gdzie dane ID znajduje sie w DATA PAGE.
*/

SELECT*
INTO Sales.Ctest
FROM Sales.Customers

SELECT*
FROM Sales.Ctest
WHERE CustomerID = 1

CREATE CLUSTERED INDEX idx_Ctest_CustomerID
ON Sales.Ctest (CustomerID)

DROP INDEX idx_Ctest_CustomerID ON Sales.Ctest --jesli chcemy zmienic sposob klastrowania to musimy 
-- usunac stary index klastrowany

SELECT*
FROM Sales.Ctest
WHERE LastName = 'Brown'

SELECT*
FROM Sales.Ctest
WHERE FirstName = 'Anna'

CREATE NONCLUSTERED INDEX idx_Ctest_LastName
ON Sales.Ctest (LastName)

CREATE INDEX idx_Ctest_FirstName 
ON Sales.Ctest (FirstName)

-------COMPOSITE INDEX-------
/*
Czasem nasze klazule where ktore sa wykonywane czesto
sa skomplikowane i wtedy mozemy zastosowac COMPOSITE INDEX
aby jeszcze polepszyc szybkosc wykonywania zapytan.
*/

SELECT*
FROM Sales.Ctest
WHERE Country = 'USA' AND Score > 500

CREATE NONCLUSTERED INDEX idx_Ctest_Country_Score
ON Sales.Ctest (Country,Score)

/*
Leftmost Prefix Rule:
Indeks działa tylko wtedy, gdy filtry w zapytaniu zaczynają się od pierwszej
kolumny w indeksie i zachowują jego kolejność.
*/
