/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */

EXEC [tSQLt].[NewTestClass] 'TestFunctionsClass';
GO

/* This Test tests the Function fnGetFinancialServiceNetWorth */
CREATE PROCEDURE [TestFunctionsClass].[Test that fnGetFinancialServiceNetWorth works as expected]
AS
BEGIN
	/* Declare Variables for Testing Data */
	DECLARE @user_FName varchar(100);
	SET @user_FName = 'Billy';
	DECLARE @user_LName varchar(100);
	SET @user_LName = 'Joe';
	DECLARE @user_Email varchar(255);
	SET @user_Email = 'Billy.Joe@email.com';
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @role_Name varchar(50);
	SET @role_Name = 'Owner';
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;

	/* 2nd account */
	DECLARE @acnt_Num2 INT;
	SET @acnt_Num2 = 2000000000;
	DECLARE @acnt_type_Id2 INT;
	SET @acnt_type_Id2 = 2;
	DECLARE @acnt_Amount2 DECIMAL(18,2);
	SET @acnt_Amount2 = 1234.56;

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.User';

	INSERT INTO [FinancialService].[dbo].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(1,
		@user_FName,
		@user_LName,
		@user_Email);

	/* Fake Role Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role';

	INSERT INTO [FinancialService].[dbo].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num,
		@role_Name);

	INSERT INTO [FinancialService].[dbo].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num2,
		@role_Name);

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

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num2,
		@acnt_type_Id2,
		@acnt_Amount2);

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT @actual = [FinancialService].[dbo].fnGetFinancialServiceNetWorth();

	/* Assertion */
	DECLARE @expected DECIMAL(18,2);
	SELECT @expected = SUM(Acnt_Amount) FROM [FinancialService].[dbo].[Account];
	EXEC [tSQLt].[AssertEquals] @actual, @expected;

END 
GO