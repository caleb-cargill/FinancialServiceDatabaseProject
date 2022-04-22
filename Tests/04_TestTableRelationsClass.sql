/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */

/* This Test tests the relations between the User table and the Role table */
EXEC [tSQLt].[NewTestClass] 'TestTableRelationsClass';
GO
CREATE PROCEDURE [TestTableRelationsClass].[Test that User - Role table relations exist as expected]
AS
BEGIN
	/* Declare Variables for Testing Data */
	DECLARE @user_Id INT;
	SET @user_Id = 1;
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

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT 
		@actual = R.Role_Name
	FROM [FinancialService].[dbo].[User] AS U
	JOIN [FinancialService].[dbo].[Role] AS R
	ON U.User_Id = R.User_Id
	WHERE U.User_Id = @user_Id; 

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @role_Name, @actual;
END
GO

/* This Test tests the relations between the Role table and the Role_Type table */
CREATE PROCEDURE [TestTableRelationsClass].[Test that Role - Role_Type table relations exist as expected]
AS
BEGIN
	/* Declare Variables for Testing Data */
	DECLARE @user_Id INT;
	SET @user_Id = 1;	
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @role_Name varchar(50);
	SET @role_Name = 'Owner';
	DECLARE @role_Rank INT;
	SET @role_Rank = 1;	

	/* Fake Tables */

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

	/* Fake Role_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role_Type';

	INSERT INTO [FinancialService].[dbo].[Role_Type]
		(Role_Name,
		Role_Rank)
	VALUES
		(@role_Name,
		@role_Rank);

	/* Execution */
	DECLARE @actual INT;
	SELECT
		@actual = RT.Role_Rank
	FROM [FinancialService].[dbo].[Role] AS R
	JOIN [FinancialService].[dbo].[Role_Type] AS RT
	ON R.Role_Name = RT.Role_Name
	WHERE R.Role_Name = @role_Name;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @role_Rank;
END
GO

/* This Test tests the relations between the Role table and the Account table */
CREATE PROCEDURE [TestTableRelationsClass].[Test that Role - Account table relations exist as expected]
AS
BEGIN
	/* Declare Variables for Testing Data */
	DECLARE @user_Id INT;
	SET @user_Id = 1;	
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @role_Name varchar(50);
	SET @role_Name = 'Owner';
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;

	/* Fake Tables */

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

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = A.Acnt_Amount
	FROM [FinancialService].[dbo].[Role] AS R
	JOIN [FinancialService].[dbo].[Account] AS A
	ON R.Acnt_Num = A.Acnt_Num
	WHERE R.Acnt_Num = @acnt_Num;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @acnt_Amount;
END
GO

/* This Test tests the relations between the Account table and the Account_Type table */
CREATE PROCEDURE [TestTableRelationsClass].[Test that Account - Account_Type table relations exist as expected]
AS
BEGIN
	/* Declare Variables for Testing Data */
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;
	DECLARE @acnt_Type varchar(50);
	SET @acnt_Type = 'Checking';

	/* Fake Tables */

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Fake Account_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account_Type';

	INSERT INTO [FinancialService].[dbo].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_type_Id,
		@acnt_Type);

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT 
		@actual = T.Acnt_Type
	FROM [FinancialService].[dbo].[Account] AS A
	JOIN [FinancialService].[dbo].[Account_Type] AS T
	ON A.Acnt_Type_Id = T.Acnt_Type_Id
	WHERE A.Acnt_Type_Id = @acnt_type_Id;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @acnt_type;
END
GO

/* This Test tests the relations between the Account table and the Transaction table */
CREATE PROCEDURE [TestTableRelationsClass].[Test that Account - Transaction table relations exist as expected]
AS
BEGIN
	/* Declare Variables for Testing Data */
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @acnt_type_Id INT;
	SET @acnt_type_Id = 1;
	DECLARE @acnt_Amount DECIMAL(18,2);
	SET @acnt_Amount = 1234.56;
	DECLARE @TR_ID INT;
	SET @TR_ID = 1;
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Amount DECIMAL(18,2);
	SET @TR_Amount = 52.75;

	/* Fake Tables */

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction';

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Amount,
		TR_Type_Name,
		Acnt_Num)
	VALUES
		(@TR_ID,
		@TR_Amount,
		@TR_Type_Name,
		@acnt_Num);

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = T.TR_Amount
	FROM [FinancialService].[dbo].[Account] AS A
	JOIN [FinancialService].[dbo].[Transaction] AS T
	ON A.Acnt_Num = T.Acnt_Num
	WHERE A.Acnt_Num = @acnt_Num AND T.TR_ID = @TR_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @TR_Amount;
END
GO

/* This Test tests the relations between the Transaction table and the Transaction_Type table */
CREATE PROCEDURE [TestTableRelationsClass].[Test that Transaction - Transaction_Type table relations exist as expected]
AS
BEGIN
	/* Declare Variables for Testing Data */
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @TR_ID INT;
	SET @TR_ID = 1;
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Amount DECIMAL(18,2);
	SET @TR_Amount = 52.75;
	DECLARE @TR_Type varchar(50);
	SET @TR_Type = 'Expense';

	/* Fake Tables */

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction';

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Amount,
		TR_Type_Name,
		Acnt_Num)
	VALUES
		(@TR_ID,
		@TR_Amount,
		@TR_Type_Name,
		@acnt_Num);

	/* Fake Tranaction_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction_Type';

	INSERT INTO [FinancialService].[dbo].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name,
		@TR_Type);

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT
		@actual = TT.TR_Type
	FROM [FinancialService].[dbo].[Transaction] AS T
	JOIN [FinancialService].[dbo].[Transaction_Type] AS TT
	ON T.TR_Type_Name = TT.TR_Type_Name
	WHERE T.TR_ID = @TR_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @TR_Type;
END
GO

/* This Test tests the relations between the User table, the Role table, and the Account table */
CREATE PROCEDURE [TestTableRelationsClass].[Test that User - Role - Account table relations exist as expected]
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

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = A.Acnt_Amount 
	FROM [FinancialService].[dbo].[User] AS U
	JOIN ([FinancialService].[dbo].[Role] AS R
		JOIN [FinancialService].[dbo].[Account] AS A
		ON R.Acnt_Num = A.Acnt_Num)
	ON U.User_Id = R.User_Id
	WHERE U.User_Id = 1;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @acnt_Amount, @actual;
END
GO

/* This Test tests the relations between the User table, the Role table, the Account table, and the Transaction table */
CREATE PROCEDURE [TestTableRelationsClass].[Test that User - Role - Account - Transaction table relations exist as expected]
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
	DECLARE @TR_ID INT;
	SET @TR_ID = 1;
	DECLARE @TR_Type_Name varchar(50);
	SET @TR_Type_Name = 'Groceries';
	DECLARE @TR_Amount DECIMAL(18,2);
	SET @TR_Amount = 52.75;

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

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Account';

	INSERT INTO [FinancialService].[dbo].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Transaction';

	INSERT INTO [FinancialService].[dbo].[Transaction]
		(TR_ID,
		TR_Amount,
		TR_Type_Name,
		Acnt_Num)
	VALUES
		(@TR_ID,
		@TR_Amount,
		@TR_Type_Name,
		@acnt_Num);

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = T.TR_Amount
	FROM [FinancialService].[dbo].[User] AS U
	JOIN ([FinancialService].[dbo].[Role] AS R
		JOIN ([FinancialService].[dbo].[Account] AS A
			JOIN [FinancialService].[dbo].[Transaction] AS T
			ON A.Acnt_Num = T.Acnt_Num)
		ON R.Acnt_Num = A.Acnt_Num)
	ON U.User_Id = R.User_Id
	WHERE U.User_Id = 1 AND A.Acnt_NUM = @acnt_Num AND T.TR_ID = @TR_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @TR_Amount, @actual;

END
GO