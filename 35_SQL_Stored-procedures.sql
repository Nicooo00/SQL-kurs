----------------SQL Stored Procedures---------------------
/*
To procedura lub procedury ktore wykonuja sie gdy je wywolamy.
Stored procedures sa szybsze niz sktypty pythona, poniewaz
sa one prekompilowane przez baze danych. W praktyce sa one
jednak czesto skomplikowane do debugowania i nie pozwala nam
nam na tyle co Python (np. na wersjonawanie, skomplikowana logike).

SYNTAX:

CREATE PROCEDURE ProcedureName AS
BEGIN

-- Sql statements 

END

EXEC ProcedureName
*/

/*Step 1: For US Customers Find the Total Number of Customres and the Average Score*/
/*Step 2: Turining the Query Into a Stored Procedure*/
/*Step 3: Execute the Stored Procedure*/
/*Step 4: For German customers fing the total number of customers and the Average score*/
/*Step 5: find the total Nr. of Orders and total sales*/

USE SalesDB
GO 
--DROP PROCEDURE GetCustomerSummary
GO

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' -- to jest default value nie stale przypisanie
-- mozna tez ALTER jesli chcemy zmienic cos w istniejacej procedurze
AS
BEGIN

DECLARE @TotalCustomers INT;
DECLARE @AvgScore FLOAT;

SELECT
	@TotalCustomers = COUNT(*), 
	@AvgScore  = AVG(ISNULL(Score,0))
FROM Sales.Customers
WHERE Country = @Country;

/*
jesli nasze zapytanie przypisuje wartosci dla zmiennych to nie bedzie pokazywac nam
juz informacji w postaci tabeli, dlatego nie mozemy dawac aliasow, zmienne w zapytaniu
dajemy po lewej stronie
*/

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);   -- funkcja drukujaca z T-SQL
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

/*
Nie mozemy miec innego typu danych niz string z PRINT dlatego musielismy zrzutowac nasze zmienne na string
*/

SELECT
	COUNT(*) [NumberOfOrders],
	SUM(Sales) [SumOfSales]
FROM Sales.Orders o
INNER JOIN Sales.Customers c ON 
o.CustomerID = c.CustomerID AND
c.Country = @Country

END
GO

EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary;


-- zeby zobaczyc nasza procedure skladowana wchodzimy w:
-- nasza baze -> mozliwosci programowania -> procedury skladowane

-------Parametryzacja procedur skladowanych---------
/*
parametr okreslamy tak: @parametr
Mozemy tez mu przypisac domyslna wartosc w naszej procedurze (przyklad powyzej).
Paramert rozni sie od zmiennej w SQL. Parametr to wartosc ktora przekazujemy
do naszej procedury skladowanej. Zmienna natomiast dziala jak placeholder w naszej
strukturze.
*/

GO 

ALTER PROCEDURE GetCustomerSummary2 @Country NVARCHAR(50) = 'USA' 
AS

BEGIN
	BEGIN TRY
		-- ==============================
		-- Step 1: Prepare & Cleanup Data
		-- ==============================
		SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = 'USA' -- NULL check
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country) -- standarowy mechanizm if TRUE
		BEGIN
			PRINT('Updating NULL Scores to 0');
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE
		BEGIN
			PRINT('No NULL Scores found')
		END;

		-- ==================
		-- Generating Reports
		-- ==================
		DECLARE @TotalCustomers INT;
		DECLARE @AvgScore FLOAT;

		SELECT
			@TotalCustomers = COUNT(*), 
			@AvgScore  = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);  
		PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

		SELECT
			COUNT(*) [NumberOfOrders],
			SUM(Sales) [SumOfSales],
			1/0
		FROM Sales.Orders o
		INNER JOIN Sales.Customers c ON 
		o.CustomerID = c.CustomerID AND
		c.Country = @Country

	END TRY

	BEGIN CATCH
		-- ====================
		-- Error Handling
		-- ====================
		PRINT('An error occured.');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure ' + ERROR_PROCEDURE());
	END CATCH
END


EXEC GetCustomerSummary2 @Country = 'Germany';
EXEC GetCustomerSummary2;

---------Error Handling---------
/*
BEGIN TRY
-- SQL statements that might cause and error
END TRY

BEGIN CATCH
-- SQL statements to handle the error
END CATCH

*/