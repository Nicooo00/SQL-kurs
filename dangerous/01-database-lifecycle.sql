-- Lesson 01 | DANGER: disabled database-deletion examples
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
-- DANGER: usuwanie baz, przerywanie polaczen i wycofywanie cudzych transakcji.
-- Przyklady wylaczone: odkomentuj tylko wybrane polecenia na jednorazowej lokalnej instancji.
-- Dawne nazwy AdventureWorks i SalesDB3 sa zachowane jako historia nauki, nie instrukcja resetu.
-- Dane MyDatabase / SalesDB przygotuj przez setup/00-create-sample-databases.sql.
-- Zrodlo danych i cwiczen: Data With Baraa; patrz SOURCES.md i LICENSES/.

-- /*------------------- USUWANIE BAZ DANYCH PRZEZ SQL Query ---------------------*/
--
-- USE master; -- przelacz na baze master ("nie mozemy podciac swojej galezi", gbysmy byli na MyDatabase to nie moglibysmy usunac bazy)
-- GO -- separator partii SSMS/sqlcmd; to nie polecenie T-SQL
--
-- ALTER DATABASE MyDatabase -- bedzie zmieniac baze danych
-- SET SINGLE_USER  -- przelacza baze w tryb jednoosobowy
-- WITH ROLLBACK IMMEDIATE; -- jesli ktokolwiek jest polaczony z ta baza to przerwij te polacznia,
-- -- a niezapisane transakcje wycofaj
-- GO
--
-- DROP DATABASE MyDatabase;
-- GO
--
-- ALTER DATABASE SalesDB3
-- SET SINGLE_USER
-- WITH ROLLBACK IMMEDIATE;
-- GO
--
-- DROP DATABASE SalesDB3;
-- GO
--
-- ALTER DATABASE AdventureWorks2019
-- SET SINGLE_USER
-- WITH ROLLBACK IMMEDIATE;
-- GO
--
-- DROP DATABASE AdventureWorks2019;
-- GO
--
-- ALTER DATABASE AdventureWorks2025
-- SET SINGLE_USER
-- WITH ROLLBACK IMMEDIATE;
-- GO
--
-- DROP DATABASE AdventureWorks2025;
-- GO
--
--

------------------- Dodawanie baz danych przez inne sposoby -----------------

/*
1.Przez flat files
-kliknij prawym przyciskiem myszy na bazy danych i wcisnij "Nowa baza danych" i "OK"
(pojawi sie nowa pusta baza danych)
-kliknij prawym przyciskiem na nowa baze danych i wcisnij "zadania" -> "importuj plik prosty"
"dalej" -> wskaz lokazjacje pliku i wskaz plik csv -> dostosuj wedlug potrzeb (narazie wszedzie ok) -> i tak dla kazdej tabeli

2.Przez bak files
-kliknij prawym w bazy danych -> "Przywracanie bazy danych" -> najprawdopodobniej ustawiamy Urządzenie (device) ->
... -> "Dodaj" -> skopiowac sciezke backupow serwera -> wkleic tam nasze pliki bak baz danych -> wybrac odpowiednia baze -> ok ok

NOTE: jesli wczesniej na serwerze isntniala baza danych o tej samej nazwie to trzeba bedzie pogrzebac w opcjach
w tym przypadku pomoglo wylaczenie funkcji kopiowania koncowego fragmentu dziennika
*/
