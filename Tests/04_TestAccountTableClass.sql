/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */
/* This Test tests that the Account table can be read from properly */

EXEC [tSQLt].[NewTestClass] 'TestAccountTableClass';
GO
CREATE PROCEDURE [TestAccountTableClass].[Test that Account table can be read from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;

	/* Fake Tables */

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num,
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		@acnt_type_Id,
		@acnt_Amount);

	/* Test - select from Account table */

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = Acnt_Amount
	FROM [FinancialService].[dbo].[Account]
	WHERE Acnt_Num = @acnt_Num;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @acnt_Amount;

END
GO

/* This Test tests that the Account table can be updated properly */

CREATE PROCEDURE [TestAccountTableClass].[Test that Account table can be updated as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;

	/* Fake Tables */

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num,
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		@acnt_type_Id,
		@acnt_Amount);

	/* Test - select from Account table */

	/* Execution */
	DECLARE @update DECIMAL(18,2);
	SET @update = 5432.10;

	UPDATE [FinancialService].[dbo].[Account]
	SET
		Acnt_Amount = @update
	WHERE 
		Acnt_Num = @acnt_Num;

	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = Acnt_Amount
	FROM [FinancialService].[dbo].[Account]
	WHERE Acnt_Num = @acnt_Num;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @update;

END
GO

/* This Test tests that the Account table can be inserted into properly */

CREATE PROCEDURE [TestAccountTableClass].[Test that Account table can be inserted into as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;

	/* Fake Tables */

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num,
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		@acnt_type_Id,
		@acnt_Amount);

	/* Test - select from Account table */

	/* Execution */
	DECLARE @acnt_Num2 INT;
	SET @acnt_Num2 = 2000000000;
	DECLARE @acnt_type_Id2 INT;
	SET @acnt_type_Id2 = 2;
	DECLARE @acnt_Amount2 DECIMAL(18,2);
	SET @acnt_Amount2 = 6543.21;	

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num,
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num2,
		@acnt_type_Id2,
		@acnt_Amount2);

	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = Acnt_Amount
	FROM [FinancialService].[dbo].[Account]
	WHERE Acnt_Num = @acnt_Num2;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @acnt_Amount2;

END
GO

/* This Test tests that the Account table can be deleted from properly */

CREATE PROCEDURE [TestAccountTableClass].[Test that Account table can be deleted from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;	

	/* Fake Tables */

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num,
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		@acnt_type_Id,
		@acnt_Amount);

	/* Test - select from Account table */

	/* Execution */
	DECLARE @acnt_Num2 INT;
	SET @acnt_Num2 = 2000000000;
	DECLARE @acnt_type_Id2 INT;
	SET @acnt_type_Id2 = 2;
	DECLARE @acnt_Amount2 DECIMAL(18,2);
	SET @acnt_Amount2 = 6543.21;	

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num,
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num2,
		@acnt_type_Id2,
		@acnt_Amount2);

	DELETE FROM [FinancialService].[dbo].[Account]
	WHERE Acnt_Num = @acnt_Num2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[dbo].[Account];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO