/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */
/* This Test tests that the Transaction table can be read from properly */

EXEC [tSQLt].[NewTestClass] 'TestTransactionTableClass';
GO
CREATE PROCEDURE [TestTransactionTableClass].[Test that Transaction table can be read from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @TR_ID INT;
	SET @TR_ID = 1;
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Amount DECIMAL(18,2);
	SET @TR_Amount = 123.45;
	DECLARE @Acnt_Num INT;
	SET @Acnt_Num = 100000000;

	/* Fake Tables */

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction';

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Type_Name, 
		TR_Amount,
		Acnt_Num)
	VALUES
		(@TR_ID,
		@TR_Type_Name,
		@TR_Amount,
		@Acnt_Num);

	/* Test - select from Transaction table */

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = TR_Amount
	FROM [FinancialService].[dbo].[Transaction]
	WHERE TR_ID = @TR_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @TR_Amount;

END
GO

/* This Test tests that the Transaction table can be updated properly */

CREATE PROCEDURE [TestTransactionTableClass].[Test that Transaction table can be updated as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @TR_ID INT;
	SET @TR_ID = 1;
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Amount DECIMAL(18,2);
	SET @TR_Amount = 123.45;
	DECLARE @Acnt_Num INT;
	SET @Acnt_Num = 100000000;

	/* Fake Tables */

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction';

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Type_Name, 
		TR_Amount,
		Acnt_Num)
	VALUES
		(@TR_ID,
		@TR_Type_Name,
		@TR_Amount,
		@Acnt_Num);

	/* Test - select from Transaction table */

	/* Execution */
	DECLARE @update DECIMAL(18,2);
	SET @update = 543.21;

	UPDATE [FinancialService].[dbo].[Transaction]
	SET
		TR_Amount = @update
	WHERE 
		@TR_ID = @TR_ID;

	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = TR_Amount
	FROM [FinancialService].[dbo].[Transaction]
	WHERE TR_ID = @TR_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @update;

END
GO

/* This Test tests that the Transaction table can be inserted into properly */

CREATE PROCEDURE [TestTransactionTableClass].[Test that Transaction table can be inserted into as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @TR_ID INT;
	SET @TR_ID = 1;
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Amount DECIMAL(18,2);
	SET @TR_Amount = 123.45;
	DECLARE @Acnt_Num INT;
	SET @Acnt_Num = 100000000;

	/* Fake Tables */

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction';

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Type_Name, 
		TR_Amount,
		Acnt_Num)
	VALUES
		(@TR_ID,
		@TR_Type_Name,
		@TR_Amount,
		@Acnt_Num);

	/* Test - select from Transaction table */

	/* Execution */
	DECLARE @TR_ID2 INT;
	SET @TR_ID2 = 2;
	DECLARE @TR_Type_Name2 varchar(50);
	SET @TR_Type_Name2 = 'Gas';
	DECLARE @TR_Amount2 DECIMAL(18,2);
	SET @TR_Amount2 = 53.45;
	DECLARE @Acnt_Num2 INT;
	SET @Acnt_Num2 = 200000000;	

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Type_Name, 
		TR_Amount,
		Acnt_Num)
	VALUES
		(@TR_ID2,
		@TR_Type_Name2,
		@TR_Amount2,
		@Acnt_Num2);

	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = TR_Amount
	FROM [FinancialService].[dbo].[Transaction]
	WHERE TR_ID = @TR_ID2;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @TR_Amount2;

END
GO

/* This Test tests that the Transaction table can be deleted from properly */

CREATE PROCEDURE [TestTransactionTableClass].[Test that Transaction table can be deleted from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
		DECLARE @TR_ID INT;
	SET @TR_ID = 1;
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Amount DECIMAL(18,2);
	SET @TR_Amount = 123.45;
	DECLARE @Acnt_Num INT;
	SET @Acnt_Num = 100000000;

	/* Fake Tables */

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction';

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Type_Name, 
		TR_Amount,
		Acnt_Num)
	VALUES
		(@TR_ID,
		@TR_Type_Name,
		@TR_Amount,
		@Acnt_Num);

	/* Test - select from Transaction table */

	/* Execution */
	DECLARE @TR_ID2 INT;
	SET @TR_ID2 = 2;
	DECLARE @TR_Type_Name2 varchar(50);
	SET @TR_Type_Name2 = 'Gas';
	DECLARE @TR_Amount2 DECIMAL(18,2);
	SET @TR_Amount2 = 53.45;
	DECLARE @Acnt_Num2 INT;
	SET @Acnt_Num2 = 200000000;	

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Type_Name, 
		TR_Amount,
		Acnt_Num)
	VALUES
		(@TR_ID2,
		@TR_Type_Name2,
		@TR_Amount2,
		@Acnt_Num2);

	DELETE FROM [FinancialService].[dbo].[Transaction]
	WHERE TR_ID = @TR_ID2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[dbo].[Transaction];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO