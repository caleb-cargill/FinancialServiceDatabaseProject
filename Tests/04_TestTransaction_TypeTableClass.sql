/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */
/* This Test tests that the Transaction_Type table can be read from properly */

EXEC [tSQLt].[NewTestClass] 'TestTransaction_TypeTableClass';
GO
CREATE PROCEDURE [TestTransaction_TypeTableClass].[Test that Transaction_Type table can be read from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Type varchar(50);
	SET @TR_Type = 'Expense';

	/* Fake Tables */

	/* Fake Transaction_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction_Type';

	INSERT INTO [FinancialService].[dbo].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name,
		@TR_Type);

	/* Test - select from Transaction_Type table */

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT
		@actual = TR_Type
	FROM [FinancialService].[dbo].[Transaction_Type]
	WHERE TR_Type_Name = @TR_Type_Name;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @TR_Type;

END
GO

/* This Test tests that the Transaction_Type table can be updated properly */

CREATE PROCEDURE [TestTransaction_TypeTableClass].[Test that Transaction_Type table can be updated as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Type varchar(50);
	SET @TR_Type = 'Expense';

	/* Fake Tables */

	/* Fake Transaction_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction_Type';

	INSERT INTO [FinancialService].[dbo].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name,
		@TR_Type);

	/* Test - select from Transaction_Type table */

	/* Execution */
	DECLARE @update varchar(50);
	SET @update = 'Credit';

	UPDATE [FinancialService].[dbo].[Transaction_Type]
	SET
		TR_Type = @update
	WHERE 
		TR_Type_Name = @TR_Type_Name;

	DECLARE @actual varchar(50);
	SELECT
		@actual = TR_Type
	FROM [FinancialService].[dbo].[Transaction_Type]
	WHERE TR_Type_Name = @TR_Type_Name;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @update;

END
GO

/* This Test tests that the Transaction_Type table can be inserted into properly */

CREATE PROCEDURE [TestTransaction_TypeTableClass].[Test that Transaction_Type table can be inserted into as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Type varchar(50);
	SET @TR_Type = 'Expense';

	/* Fake Tables */

	/* Fake Transaction_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction_Type';

	INSERT INTO [FinancialService].[dbo].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name,
		@TR_Type);

	/* Test - select from Transaction_Type table */

	/* Execution */
	DECLARE @TR_Type_Name2 varchar(50);
	SET @TR_Type_Name2 = 'Paycheck';
	DECLARE @TR_Type2 varchar(50);
	SET @TR_Type2 = 'Income';	

	INSERT INTO [FinancialService].[dbo].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name2,
		@TR_Type2);

	DECLARE @actual varchar(50);
	SELECT
		@actual = TR_Type
	FROM [FinancialService].[dbo].[Transaction_Type]
	WHERE TR_Type_Name = @TR_Type_Name2;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @TR_Type2;

END
GO

/* This Test tests that the Transaction_Type table can be deleted from properly */

CREATE PROCEDURE [TestTransaction_TypeTableClass].[Test that Transaction_Type table can be deleted from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Type varchar(50);
	SET @TR_Type = 'Expense';

	/* Fake Tables */

	/* Fake Transaction_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction_Type';

	INSERT INTO [FinancialService].[dbo].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name,
		@TR_Type);

	/* Test - select from Transaction_Type table */

	/* Execution */
		DECLARE @TR_Type_Name2 varchar(50);
	SET @TR_Type_Name2 = 'Paycheck';
	DECLARE @TR_Type2 varchar(50);
	SET @TR_Type2 = 'Income';	

	INSERT INTO [FinancialService].[dbo].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name2,
		@TR_Type2);

	DELETE FROM [FinancialService].[dbo].[Transaction_Type]
	WHERE TR_Type_Name = @TR_Type_Name2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[dbo].[Transaction_Type];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO