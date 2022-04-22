/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */
/* This Test tests that the Account_Type table can be read from properly */

EXEC [tSQLt].[NewTestClass] 'TestAccount_TypeTableClass';
GO
CREATE PROCEDURE [TestAccount_TypeTableClass].[Test that Account_Type table can be read from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Type_Id INT;
	SET @acnt_Type_Id = 1;
	DECLARE @acnt_Type varchar(50);
	SET @acnt_Type = 'Checking';

	/* Fake Tables */

	/* Fake Account_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account_Type';

	INSERT INTO [FinancialService].[dbo].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id,
		@acnt_Type);

	/* Test - select from Account_Type table */

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT
		@actual = Acnt_Type
	FROM [FinancialService].[dbo].[Account_Type]
	WHERE Acnt_Type_Id = @acnt_Type_Id;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @acnt_Type;

END
GO

/* This Test tests that the Account_Type table can be updated properly */

CREATE PROCEDURE [TestAccount_TypeTableClass].[Test that Account_Type table can be updated as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Type_Id INT;
	SET @acnt_Type_Id = 1;
	DECLARE @acnt_Type varchar(50);
	SET @acnt_Type = 'Checking';

	/* Fake Tables */

	/* Fake Account_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account_Type';

	INSERT INTO [FinancialService].[dbo].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id,
		@acnt_Type);

	/* Test - select from Account_Type table */

	/* Execution */
	DECLARE @update varchar(50);
	SET @update = 'Savings';

	UPDATE [FinancialService].[dbo].[Account_Type]
	SET
		Acnt_Type = @update
	WHERE 
		Acnt_Type_Id = @acnt_Type_Id;

	DECLARE @actual varchar(50);
	SELECT
		@actual = Acnt_Type
	FROM [FinancialService].[dbo].[Account_Type]
	WHERE Acnt_Type_Id = @acnt_Type_Id;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @update;

END
GO

/* This Test tests that the Account_Type table can be inserted into properly */

CREATE PROCEDURE [TestAccount_TypeTableClass].[Test that Account_Type table can be inserted into as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Type_Id INT;
	SET @acnt_Type_Id = 1;
	DECLARE @acnt_Type varchar(50);
	SET @acnt_Type = 'Checking';

	/* Fake Tables */

	/* Fake Account_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account_Type';

	INSERT INTO [FinancialService].[dbo].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id,
		@acnt_Type);

	/* Test - select from Account_Type table */

	/* Execution */
	DECLARE @acnt_Type_Id2 INT;
	SET @acnt_Type_Id2 = 2;
	DECLARE @acnt_Type2 varchar(50);
	SET @acnt_Type2 = 'Savings';	

	INSERT INTO [FinancialService].[dbo].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id2,
		@acnt_Type2);

	DECLARE @actual varchar(50);
	SELECT
		@actual = Acnt_Type
	FROM [FinancialService].[dbo].[Account_Type]
	WHERE Acnt_Type_Id = @acnt_Type_Id2;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @acnt_Type2;

END
GO

/* This Test tests that the Account_Type table can be deleted from properly */

CREATE PROCEDURE [TestAccount_TypeTableClass].[Test that Account_Type table can be deleted from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @acnt_Type_Id INT;
	SET @acnt_Type_Id = 1;
	DECLARE @acnt_Type varchar(50);
	SET @acnt_Type = 'Checking';

	/* Fake Tables */

	/* Fake Account_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account_Type';

	INSERT INTO [FinancialService].[dbo].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id,
		@acnt_Type);

	/* Test - select from Account_Type table */

	/* Execution */
		DECLARE @acnt_Type_Id2 INT;
	SET @acnt_Type_Id2 = 2;
	DECLARE @acnt_Type2 varchar(50);
	SET @acnt_Type2 = 'Savings';	

	INSERT INTO [FinancialService].[dbo].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id2,
		@acnt_Type2);

	DELETE FROM [FinancialService].[dbo].[Account_Type]
	WHERE Acnt_Type_Id = @acnt_Type_Id2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[dbo].[Account_Type];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO