-- Lesson 03 | LAB: changes data/schema; disposable learning databases only
-- Course exercises: Data With Baraa; Polish learning notes: Nicooo00.
-- Attribution and MIT notice: SOURCES.md, LICENSES/data-with-baraa-MIT.txt.
USE MyDatabase;
GO

USE MyDatabase

/*task: Create a new table called persons with colums:
id, person_name, birth_date, and phone */

CREATE TABLE persons -- tworzy tabele persons w MyDatabase
(
id INT NOT NULL,  -- tworzy kolumne id ustawia typ danych na INT i mowi ze rekordy musza byc NOT NULL
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
)
/*
CONSTRAINT to poprostu ograniczenie ktore mozemy sobie nazwac, w tym przypadku to pk_persons
Przez to pozniej latwo mozna z nich zrezygnowac uzywajac takiej komendy:
	ALTER TABLE persons DROP CONSTRAINT pk_persons;
Typy ograniczen:
PRIMARY KEY - kolumna musi byc unikalna i nie moze zawierac wartosci NULL

	CONSTRAINT pk_persons PRIMARY KEY (id)

FOREIGN KEY - kolumna musi wskazywac na instniejacy rekord w innej tabeli

	CONSTRAINT FK_Zamowienia_Klienci FOREIGN KEY (KlientID) REFERENCES Klienci(ID)

CHECK - warunek logiczney, ktore dane musza spelniac

	CONSTRAINT CHK_Wiek CHECK (Wiek >= 18)

UNIQUE - wartosc w kolumnie musi byc unikalna, ale moze zawierac jeden NULL

	CONSTRAINT UQ_Uzytkownicy_Email UNIQUE (Email)

Można wskazywac na wiecej niz 1 kolumne np.

	CONSTRAINT PK_ZamowieniePozycja PRIMARY KEY (ZamowienieID, PozycjaID)

tutaj PARA (ZamowienieID, PozycjaID) musi byc unikalna; obie kolumny sa NOT NULL.
*/

-------------------------------------------------------------------------------------------------------------------------------
SELECT*
FROM dbo.persons

/* Jesli chcemy zobaczyc jak jaki skrypt tworzy nam nasza tabele (bo naprzyklad stracilismy Query)
to klikamy prawym na nasza tabele -> tabela skryptu jako -> UTWÓRZ -> Nowe okno edytora Power Query
NOTE: lepiej zawsze dawac swoj kod na github, to jest taka bardziej deska ratunku
*/

/*task: Add a new column called email to the persons table */

ALTER TABLE dbo.persons -- edytujemy tabele persons
ADD email VARCHAR(50) NOT NULL -- dodajemy kolumne email

--NOTE: nowe kolumny pojawiaja sie na koncu tabeli. jesli chcemy zeby nasza nowa kolumna
--byla pomiedzy starymi to musimy zrobic tabele od nowa.

/*task: Remove the column phone from the persons table */

ALTER TABLE dbo.persons
DROP COLUMN phone -- usuwamy kolumne phone

/*task: Delete the table persons from the database */

DROP TABLE dbo.persons  -- usuwa tabele
