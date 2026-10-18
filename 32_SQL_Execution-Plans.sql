-----------------SQL Execution Plans----------------
/*
Jest to plan wygenerowany przez baze danych ktory
mowi o tym jak wykonywane bedzie zapytanie krok po
kroku.

Mamy 3 przyciski na gorze UI
- wyswietl szacowany plan wykonania,
- uwzglednij rzeczywisty plan wykonania,
- uwzglednij statystyke zapytan na zywo

Jesli przewidywania nie zgadzaja sie z faktycznym planem wykonania,
to wskazuje to na problemy takie jak niedokladne statystyki tabel lub 
przedawnione indexy co prowadzi to niskiej wydajnosci.

NOTE: Warto sprawdzic w sekcji wlasciwosc -> obiekt czy SQL
uzywa naszego utoworzonego indeksu.

TABLE scan -- odcztuje wszystkie wpisy w tabeli, aby znalesc wyniki.

INDEX Scan -- odczytuje wszystkie wpisy w indexie aby znalesc wyniki.

INDEX Seek -- to wycelowane wyszukanie w obrebie indexu,
wydobywajac tylko okreslone wiersze. (jest to dobry znak,
bo SQL nie czyta calej tabeli (albo indexu) tylko jakas jej czesc).


Nested Loops (Pętle zagnieżdżone): Porównuje wiersze z dwóch tabel, wiersz po wierszu.
Najlepiej sprawdza się przy niewielkich zbiorach danych.

Hash Match (Łączenie za pomocą tablicy haszującej): Dopasowuje wiersze przy użyciu tablicy haszującej.
Najlepiej sprawdza się przy dużych zbiorach danych.

Merge Join (Łączenie przez scalanie): Łączy dwa uporządkowane zbiory danych. 
Jest wydajne, gdy oba zbiory są już posortowane według kolumn używanych do łączenia.
*/
----------------------------------------------------------
SELECT*
INTO FactResellerSales_HP
FROM FactResellerSales
----------------------------------------------------------

SELECT*
FROM FactResellerSales_HP
ORDER BY SalesOrderNumber;

SELECT*
FROM FactResellerSales
ORDER BY SalesOrderNumber;
----------------------------------------------------------

SELECT*
FROM FactResellerSales_HP
WHERE CarrierTrackingNumber = '4911-403C-98';

SELECT*
FROM FactResellerSales
WHERE CarrierTrackingNumber = '4911-403C-98';

CREATE NONCLUSTERED INDEX idx_FactReseller_CTN
ON FactResellerSales (CarrierTrackingNumber)
---------------------------------------------------------

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactResellerSales_HP
ON FactResellerSales_HP

SELECT 
	p.EnglishProductName AS ProductName,
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName;

SELECT 
	p.EnglishProductName AS ProductName,
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales_HP s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName; -- to dac w innym query bo nam porowna to samo wtedy

/*
Zeby porownac 2 takie zapytania dajemy:
prawy przycisk na ekranie planu wykonywania -> Zapisz plan wykonywania jako ->
potem na drugim query -> prawy -> porownaj plan pokazow
*/

--------------SQL HINTS--------------
/*
Komendy ktore dodajemy do zapytania aby zmusic baze danych
by wykonala nasze zapytanie w konkretny sposob by wymusic
lepszy performance.
Czasem baza danych nie bedzie sama dobierac idealnych execution plans,
poniewaz np mamy nieaktualne statystyki tabel, lub mamy za duzo indexow
w bazie danych.
*/

USE SalesDB

SELECT
	o.Sales,
	c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH (FORCESEEK) -- wymuszamy index seek na sales.customers
ON		o.CustomerID = c.CustomerID
--OPTION (HASH JOIN) -- wplywamy bezposrednio na execution plan. wymuszamy tu hash join

SELECT
	o.Sales,
	c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH (INDEX([PK_customers])) -- wymuszamy uzycie konkretnego indexu
ON		o.CustomerID = c.CustomerID

/*GOOD PRACTICES
1. testuj hinty w roznych bazach danych (development, production)
   ich wydajnosc moze sie wtedy roznic.
2. hinty to szybkie laty. nalezy znalesc problem i go rozwiazac
*/