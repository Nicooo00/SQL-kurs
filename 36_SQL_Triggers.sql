------------------SQL Triggers--------------------
/*
Triggers (Wyzwalacze bazy danych) to specjalne procedury
skladowane ktore wykonuja sie automatycznie w odpowiedzi na
okreslone zjawisko w tabeli lub widoku.

Typy wyzwalaczy:
	DML Triggers
		AFTER triggers,
		INSTEAD  OF triggers
	DDL Triggers,
	LOGGON

USE CASE: Wyzwalacz na tabeli employees, ktory 
automatycznie dopisuje rzeczy do logs.

CREATE TRIGGER TriggerName ON TableName
AFTER INSERT, UPDATE , DELETE
AS
BEGIN
-- SQL statements
END
*/

CREATE TABLE Sales.EmployeeLogs 
(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
)

GO

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage,LogDate)
	SELECT
		EmployeeID,
		'New Employee Added =' + CAST(EmployeeID AS varchar),
		GETDATE()
	FROM INSERTED -- to tabela wirtualna ktora przechowuje kopie wierszy ktore sa wpisywane do tabeli docelowej
END

GO

INSERT INTO Sales.Employees 
VALUES
(6, 'Maria', 'Doe','HR','1988-01-12','F', 80000, 3)

SELECT*
FROM Sales.EmployeeLogs