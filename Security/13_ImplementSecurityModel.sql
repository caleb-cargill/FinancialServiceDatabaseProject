/* DELIVERABLE #13 - IMPLEMENT SECURITY MODEL */

USE [FinancialService]
GO

-------------------------------------------------------------------------
-- Grant Permissions
-------------------------------------------------------------------------

-- Manage Schema
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::Manage TO finman
GO
GRANT UPDATE, SELECT ON SCHEMA::Manage TO finadv
GO
DENY INSERT, DELETE ON SCHEMA::Manage TO finadv
GO
GRANT SELECT ON SCHEMA::Manage TO finenthus
GO
DENY INSERT, UPDATE, DELETE ON SCHEMA::Manage TO finenthus
GO
DENY INSERT, UPDATE, DELETE, SELECT ON SCHEMA::Manage TO finclient
GO

-- Advise Schema
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::Advise TO finman
GO
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::Advise TO finadv
GO
GRANT UPDATE, SELECT ON SCHEMA::Advise TO finenthus
GO
DENY INSERT, DELETE ON SCHEMA::Advise TO finenthus
GO
DENY INSERT, UPDATE, DELETE, SELECT ON SCHEMA::Advise TO finclient
GO

-- Enthus Schema
GRANT INSERT, UPDATE, DELETE, SELECT, EXEC ON SCHEMA::Enthus TO finman
GO
GRANT INSERT, UPDATE, DELETE, SELECT, EXEC ON SCHEMA::Enthus TO finadv
GO
GRANT INSERT, UPDATE, DELETE, SELECT, EXEC ON SCHEMA::Enthus TO finenthus
GO
GRANT SELECT, EXEC ON SCHEMA::Enthus TO finclient
GO
DENY INSERT, UPDATE, DELETE ON SCHEMA::Enthus TO finclient
GO

-- dbo Schema
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::dbo TO finman
GO
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::dbo TO finadv
GO
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::dbo TO finenthus
GO
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::dbo TO finclient
GO

-------------------------------------------------------------------------
-- Transfer Tables to Correct Schemas
-------------------------------------------------------------------------

-- Account_Type Table
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[Account_Type];
GO

-- Transaction_Type Table
ALTER SCHEMA Advise TRANSFER OBJECT::[dbo].[Transaction_Type];
GO

-- User Table
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[User];
GO

-- Role Table
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[Role];
GO

-- Account Table
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[Account];
GO

-- Transaction Table
ALTER SCHEMA Advise TRANSFER OBJECT::[dbo].[Transaction];
GO

-- Role_Type Table
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[Role_Type];
GO

-------------------------------------------------------------------------
-- Update Stored Procedures
-------------------------------------------------------------------------

-- spUser_Create
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[spUser_Create];
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Create')
DROP PROCEDURE spUser_Create
GO
CREATE PROCEDURE [Manage].[spUser_Create]
	@User_FName varchar(100),
	@User_LName varchar(100),
	@User_Email varchar(255)
AS
BEGIN
	INSERT INTO [FinancialService].[Manage].[User]
		(User_FName,
		User_LName,
		User_Email)
	VALUES
		(@User_FName,
		@User_LName,
		@User_Email)
END
GO

-- spUser_Update
ALTER SCHEMA Advise TRANSFER OBJECT::[dbo].[spUser_Update];
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Update')
DROP PROCEDURE spUser_Update
GO
CREATE PROCEDURE [Advise].[spUser_Update]
	@User_Id INT,
	@User_FName varchar(100),
	@User_LName varchar(100),
	@User_Email varchar(255)
AS
BEGIN
	UPDATE [FinancialService].[Manage].[User]
	SET
		User_FName = @User_FName,
		User_LName = @User_LName,
		User_Email = @User_Email
	WHERE
		User_Id = @User_Id;
END
GO

-- spUser_Delete
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[spUser_Delete];
GO
USE [FinancialService]
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Delete')
DROP PROCEDURE spUser_Delete
GO
CREATE PROCEDURE [Manage].[spUser_Delete]
	@User_Id INT
AS
BEGIN
	DELETE 
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = @User_Id;
END
GO

-- spUser_Read
ALTER SCHEMA Manage TRANSFER OBJECT::[dbo].[spUser_Read];
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Read')
DROP PROCEDURE spUser_Read
GO
CREATE PROCEDURE [Advise].[spUser_Read]
	@User_Id INT
AS
BEGIN
	SELECT
		*
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = @User_Id;
END
GO

-------------------------------------------------------------------------
-- Update Views
-------------------------------------------------------------------------

-- vwUser_Account_Roles
ALTER SCHEMA Enthus TRANSFER OBJECT::[dbo].[vwUser_Account_Roles];
GO
IF EXISTS (SELECT * FROM [sys].[views] WHERE name = 'vwUser_Account_Roles')
DROP VIEW [Enthus].vwUser_Account_Roles
GO
CREATE VIEW [Enthus].[vwUser_Account_Roles]
AS
	SELECT 
		U.User_Id,
		U.User_FName,
		U.User_LName,
		U.User_Email,
		R.Acnt_Num,
		R.Role_Name,
		A.Acnt_Amount,
		T.Acnt_Type
	FROM [Manage].[User] AS U
	JOIN ([Manage].[Role] AS R
		JOIN ([Manage].[Account] AS A
			JOIN [Manage].[Account_Type] AS T
			ON A.Acnt_Type_Id = T.Acnt_Type_Id)
		ON R.Acnt_Num = A.Acnt_Num)
	ON U.User_Id = R.User_Id;
GO

-- vwUser_NetWorth
ALTER SCHEMA Enthus TRANSFER OBJECT::[dbo].[vwUser_NetWorth];
GO
IF EXISTS (SELECT * FROM [sys].[views] WHERE name = 'vwUser_NetWorth')
DROP VIEW [Enthus].vwUser_NetWorth
GO
CREATE VIEW [Enthus].[vwUser_NetWorth]
AS
	SELECT 
		(SELECT UT.User_FName FROM [Manage].[User] AS UT WHERE UT.User_Id = U.User_Id) AS User_FName,
		(SELECT UT.User_LName FROM [Manage].[User] AS UT WHERE UT.User_Id = U.User_Id) AS User_LName,
		SUM(A.Acnt_Amount) AS NetWorth
	FROM [Manage].[User] AS U
	JOIN ([Manage].[Role] AS R
		JOIN [Manage].[Account] AS A			
		ON R.Acnt_Num = A.Acnt_Num)
	ON U.User_Id = R.User_Id
	GROUP BY U.User_Id;
GO

-------------------------------------------------------------------------
-- Update Functions
-------------------------------------------------------------------------

-- fnGetFinancialServiceNetWorth()
ALTER SCHEMA Enthus TRANSFER OBJECT::[dbo].[fnGetFinancialServiceNetWorth];
GO
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE Name = 'fnGetFinancialServiceNetWorth' AND Type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION [Enthus].[fnGetFinancialServiceNetWorth]
GO
CREATE FUNCTION [Enthus].[fnGetFinancialServiceNetWorth]()
RETURNS DECIMAL(18,2)
AS
BEGIN
	/* Variable to return sum */ 
	DECLARE @ret DECIMAL(18,2);

	/* Use View to get sum */
	SELECT 
		@ret = SUM(NetWorth) 
	FROM [FinancialService].[Enthus].[vwUser_NetWorth];

	/* If it is null, set variable to 0 */
	IF (@ret IS NULL)
		SET @ret = 0;

	/* Return sum */
	RETURN @ret;
END
GO

-------------------------------------------------------------------------
-- Update Tests
-------------------------------------------------------------------------

-- TestAccount_TypeTableClass
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account_Type';

	INSERT INTO [FinancialService].[Manage].[Account_Type]
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
	FROM [FinancialService].[Manage].[Account_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account_Type';

	INSERT INTO [FinancialService].[Manage].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id,
		@acnt_Type);

	/* Test - select from Account_Type table */

	/* Execution */
	DECLARE @update varchar(50);
	SET @update = 'Savings';

	UPDATE [FinancialService].[Manage].[Account_Type]
	SET
		Acnt_Type = @update
	WHERE 
		Acnt_Type_Id = @acnt_Type_Id;

	DECLARE @actual varchar(50);
	SELECT
		@actual = Acnt_Type
	FROM [FinancialService].[Manage].[Account_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account_Type';

	INSERT INTO [FinancialService].[Manage].[Account_Type]
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

	INSERT INTO [FinancialService].[Manage].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id2,
		@acnt_Type2);

	DECLARE @actual varchar(50);
	SELECT
		@actual = Acnt_Type
	FROM [FinancialService].[Manage].[Account_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account_Type';

	INSERT INTO [FinancialService].[Manage].[Account_Type]
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

	INSERT INTO [FinancialService].[Manage].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_Type_Id2,
		@acnt_Type2);

	DELETE FROM [FinancialService].[Manage].[Account_Type]
	WHERE Acnt_Type_Id = @acnt_Type_Id2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[Manage].[Account_Type];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO

-- TestTransaction_TypeTableClass
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction_Type';

	INSERT INTO [FinancialService].[Advise].[Transaction_Type]
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
	FROM [FinancialService].[Advise].[Transaction_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction_Type';

	INSERT INTO [FinancialService].[Advise].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name,
		@TR_Type);

	/* Test - select from Transaction_Type table */

	/* Execution */
	DECLARE @update varchar(50);
	SET @update = 'Credit';

	UPDATE [FinancialService].[Advise].[Transaction_Type]
	SET
		TR_Type = @update
	WHERE 
		TR_Type_Name = @TR_Type_Name;

	DECLARE @actual varchar(50);
	SELECT
		@actual = TR_Type
	FROM [FinancialService].[Advise].[Transaction_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction_Type';

	INSERT INTO [FinancialService].[Advise].[Transaction_Type]
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

	INSERT INTO [FinancialService].[Advise].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name2,
		@TR_Type2);

	DECLARE @actual varchar(50);
	SELECT
		@actual = TR_Type
	FROM [FinancialService].[Advise].[Transaction_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction_Type';

	INSERT INTO [FinancialService].[Advise].[Transaction_Type]
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

	INSERT INTO [FinancialService].[Advise].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name2,
		@TR_Type2);

	DELETE FROM [FinancialService].[Advise].[Transaction_Type]
	WHERE TR_Type_Name = @TR_Type_Name2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[Advise].[Transaction_Type];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO

-- TestUserTableClass
/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */
/* This Test tests that the user table can be read from properly */

EXEC [tSQLt].[NewTestClass] 'TestUserTableClass';
GO
CREATE PROCEDURE [TestUserTableClass].[Test that user table can be read from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_FName varchar(100);
	SET @user_FName = 'Billy';
	DECLARE @user_LName varchar(100);
	SET @user_LName = 'Joe';
	DECLARE @user_Email varchar(255);
	SET @user_Email = 'Billy.Joe@email.com';	

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(1,
		@user_FName,
		@user_LName,
		@user_Email);

	/* Test - select from user table */

	/* Execution */
	DECLARE @actual varchar(255);
	SELECT
		@actual = User_Email
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = 1;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @user_Email;

END
GO

/* This Test tests that the user table can be updated properly */

CREATE PROCEDURE [TestUserTableClass].[Test that user table can be updated as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_FName varchar(100);
	SET @user_FName = 'Billy';
	DECLARE @user_LName varchar(100);
	SET @user_LName = 'Joe';
	DECLARE @user_Email varchar(255);
	SET @user_Email = 'Billy.Joe@email.com';	

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(1,
		@user_FName,
		@user_LName,
		@user_Email);

	/* Test - select from user table */

	/* Execution */
	DECLARE @update varchar(255);
	SET @update = 'Joe.Billy@email.com';

	UPDATE [FinancialService].[Manage].[User]
	SET
		User_Email = @update
	WHERE 
		User_Id = 1;

	DECLARE @actual varchar(255);
	SELECT
		@actual = User_Email
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = 1;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @update;

END
GO

/* This Test tests that the user table can be inserted into properly */

CREATE PROCEDURE [TestUserTableClass].[Test that user table can be inserted into as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_FName varchar(100);
	SET @user_FName = 'Billy';
	DECLARE @user_LName varchar(100);
	SET @user_LName = 'Joe';
	DECLARE @user_Email varchar(255);
	SET @user_Email = 'Billy.Joe@email.com';	

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(1,
		@user_FName,
		@user_LName,
		@user_Email);

	/* Test - select from user table */

	/* Execution */
	DECLARE @user_FName2 varchar(100);
	SET @user_FName2 = 'John';
	DECLARE @user_LName2 varchar(100);
	SET @user_LName = 'Smith';
	DECLARE @user_Email2 varchar(255);
	SET @user_Email2 = 'John.Smith@email.com';	

	INSERT INTO [FinancialService].[Manage].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(2,
		@user_FName2,
		@user_LName2,
		@user_Email2);

	DECLARE @actual varchar(255);
	SELECT
		@actual = User_Email
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = 2;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @user_Email2;

END
GO

/* This Test tests that the user table can be deleted from properly */

CREATE PROCEDURE [TestUserTableClass].[Test that user table can be deleted from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_FName varchar(100);
	SET @user_FName = 'Billy';
	DECLARE @user_LName varchar(100);
	SET @user_LName = 'Joe';
	DECLARE @user_Email varchar(255);
	SET @user_Email = 'Billy.Joe@email.com';	

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(1,
		@user_FName,
		@user_LName,
		@user_Email);

	/* Test - select from user table */

	/* Execution */
	DECLARE @user_FName2 varchar(100);
	SET @user_FName2 = 'John';
	DECLARE @user_LName2 varchar(100);
	SET @user_LName2 = 'Smith';
	DECLARE @user_Email2 varchar(255);
	SET @user_Email2 = 'John.Smith@email.com';	

	INSERT INTO [FinancialService].[Manage].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(2,
		@user_FName2,
		@user_LName2,
		@user_Email2);

	DELETE FROM [FinancialService].[Manage].[User]
	WHERE User_Id = 2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[Manage].[User];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO

-- TestAccountTableClass
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
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
	FROM [FinancialService].[Manage].[Account]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
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

	UPDATE [FinancialService].[Manage].[Account]
	SET
		Acnt_Amount = @update
	WHERE 
		Acnt_Num = @acnt_Num;

	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = Acnt_Amount
	FROM [FinancialService].[Manage].[Account]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
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

	INSERT INTO [FinancialService].[Manage].[Account]
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
	FROM [FinancialService].[Manage].[Account]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
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

	INSERT INTO [FinancialService].[Manage].[Account]
		(Acnt_Num,
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num2,
		@acnt_type_Id2,
		@acnt_Amount2);

	DELETE FROM [FinancialService].[Manage].[Account]
	WHERE Acnt_Num = @acnt_Num2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[Manage].[Account];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO

-- TestTransactionTableClass
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	INSERT INTO [FinancialService].[Advise].[Transaction]
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
	FROM [FinancialService].[Advise].[Transaction]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	INSERT INTO [FinancialService].[Advise].[Transaction]
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

	UPDATE [FinancialService].[Advise].[Transaction]
	SET
		TR_Amount = @update
	WHERE 
		@TR_ID = @TR_ID;

	DECLARE @actual DECIMAL(18,2);
	SELECT
		@actual = TR_Amount
	FROM [FinancialService].[Advise].[Transaction]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	INSERT INTO [FinancialService].[Advise].[Transaction]
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

	INSERT INTO [FinancialService].[Advise].[Transaction]
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
	FROM [FinancialService].[Advise].[Transaction]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	INSERT INTO [FinancialService].[Advise].[Transaction]
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

	INSERT INTO [FinancialService].[Advise].[Transaction]
		(TR_ID,
		TR_Type_Name, 
		TR_Amount,
		Acnt_Num)
	VALUES
		(@TR_ID2,
		@TR_Type_Name2,
		@TR_Amount2,
		@Acnt_Num2);

	DELETE FROM [FinancialService].[Advise].[Transaction]
	WHERE TR_ID = @TR_ID2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[Advise].[Transaction];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO

-- TestRoleTableClass
/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */
/* This Test tests that the Role table can be read from properly */

EXEC [tSQLt].[NewTestClass] 'TestRoleTableClass';
GO
CREATE PROCEDURE [TestRoleTableClass].[Test that Role table can be read from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_Id INT;
	SET @user_Id = 1;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @role_Name varchar(50);
	SET @role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num,
		Role_Name)
	VALUES
		(@user_Id,
		@acnt_Num,
		@role_Name);

	/* Test - select from Role table */

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[Manage].[Role]
	WHERE Acnt_Num = @acnt_Num AND User_Id = @user_Id;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @role_Name;

END
GO

/* This Test tests that the Role table can be updated properly */

CREATE PROCEDURE [TestRoleTableClass].[Test that Role table can be updated as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_Id INT;
	SET @user_Id = 1;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @role_Name varchar(50);
	SET @role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num,
		Role_Name)
	VALUES
		(@user_Id,
		@acnt_Num,
		@role_Name);

	/* Test - select from Role table */

	/* Execution */
	DECLARE @update varchar(50);
	SET @update = 'Viewer';

	UPDATE [FinancialService].[Manage].[Role]
	SET
		Role_Name = @update
	WHERE 
		Acnt_Num = @acnt_Num AND User_Id = @user_Id;

	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[Manage].[Role]
	WHERE Acnt_Num = @acnt_Num AND User_Id = @user_Id;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @update;

END
GO

/* This Test tests that the Role table can be inserted into properly */

CREATE PROCEDURE [TestRoleTableClass].[Test that Role table can be inserted into as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_Id INT;
	SET @user_Id = 1;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @role_Name varchar(50);
	SET @role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num,
		Role_Name)
	VALUES
		(@user_Id,
		@acnt_Num,
		@role_Name);

	/* Test - select from Role table */

	/* Execution */
	DECLARE @user_Id2 INT;
	SET @user_Id2 = 2;
	DECLARE @acnt_Num2 INT;
	SET @acnt_Num2 = 2000000000;
	DECLARE @role_Name2 varchar(50);
	SET @role_Name2 = 'Viewer';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num,
		Role_Name)
	VALUES
		(@user_Id2,
		@acnt_Num2,
		@role_Name2);

	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[Manage].[Role]
	WHERE Acnt_Num = @acnt_Num2 AND User_Id = @user_Id2;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @role_Name2;

END
GO

/* This Test tests that the Role table can be deleted from properly */

CREATE PROCEDURE [TestRoleTableClass].[Test that Role table can be deleted from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @user_Id INT;
	SET @user_Id = 1;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;
	DECLARE @role_Name varchar(50);
	SET @role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num,
		Role_Name)
	VALUES
		(@user_Id,
		@acnt_Num,
		@role_Name);

	/* Test - select from Role table */

	/* Execution */
	DECLARE @user_Id2 INT;
	SET @user_Id2 = 2;
	DECLARE @acnt_Num2 INT;
	SET @acnt_Num2 = 2000000000;
	DECLARE @role_Name2 varchar(50);
	SET @role_Name2 = 'Viewer';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num,
		Role_Name)
	VALUES
		(@user_Id2,
		@acnt_Num2,
		@role_Name2);

	DELETE FROM [FinancialService].[Manage].[Role]
	WHERE Acnt_Num = @acnt_Num2 AND User_Id = @user_Id2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[Manage].[Role];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO

-- TestRole_TypeTableClass
/* DELIVERABLE #4: TEST SCRIPTS TO UNIT TEST THE DATABASE */
/* This Test tests that the Role_Type table can be read from properly */

EXEC [tSQLt].[NewTestClass] 'TestRole_TypeTableClass';
GO
CREATE PROCEDURE [TestRole_TypeTableClass].[Test that Role_Type table can be read from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @Role_Rank INT;
	SET @Role_Rank = 1;
	DECLARE @Role_Name varchar(50);
	SET @Role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role_Type';

	INSERT INTO [FinancialService].[Manage].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank,
		@Role_Name);

	/* Test - select from Role_Type table */

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[Manage].[Role_Type]
	WHERE Role_Rank = @Role_Rank;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @Role_Name;

END
GO

/* This Test tests that the Role_Type table can be updated properly */

CREATE PROCEDURE [TestRole_TypeTableClass].[Test that Role_Type table can be updated as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @Role_Rank INT;
	SET @Role_Rank = 1;
	DECLARE @Role_Name varchar(50);
	SET @Role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role_Type';

	INSERT INTO [FinancialService].[Manage].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank,
		@Role_Name);

	/* Test - select from Role_Type table */

	/* Execution */
	DECLARE @update varchar(50);
	SET @update = 'Viewer';

	UPDATE [FinancialService].[Manage].[Role_Type]
	SET
		Role_Name = @update
	WHERE 
		Role_Rank = @Role_Rank;

	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[Manage].[Role_Type]
	WHERE Role_Rank = @Role_Rank;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @update;

END
GO

/* This Test tests that the Role_Type table can be inserted into properly */

CREATE PROCEDURE [TestRole_TypeTableClass].[Test that Role_Type table can be inserted into as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @Role_Rank INT;
	SET @Role_Rank = 1;
	DECLARE @Role_Name varchar(50);
	SET @Role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role_Type';

	INSERT INTO [FinancialService].[Manage].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank,
		@Role_Name);

	/* Test - select from Role_Type table */

	/* Execution */
	DECLARE @Role_Rank2 INT;
	SET @Role_Rank2 = 2;
	DECLARE @Role_Name2 varchar(50);
	SET @Role_Name2 = 'Viewer';	

	INSERT INTO [FinancialService].[Manage].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank2,
		@Role_Name2);

	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[Manage].[Role_Type]
	WHERE Role_Rank = @Role_Rank2;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @Role_Name2;

END
GO

/* This Test tests that the Role_Type table can be deleted from properly */

CREATE PROCEDURE [TestRole_TypeTableClass].[Test that Role_Type table can be deleted from as expected]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @Role_Rank INT;
	SET @Role_Rank = 1;
	DECLARE @Role_Name varchar(50);
	SET @Role_Name = 'Owner';

	/* Fake Tables */

	/* Fake Role_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role_Type';

	INSERT INTO [FinancialService].[Manage].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank,
		@Role_Name);

	/* Test - select from Role_Type table */

	/* Execution */
		DECLARE @Role_Rank2 INT;
	SET @Role_Rank2 = 2;
	DECLARE @Role_Name2 varchar(50);
	SET @Role_Name2 = 'Viewer';	

	INSERT INTO [FinancialService].[Manage].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank2,
		@Role_Name2);

	DELETE FROM [FinancialService].[Manage].[Role_Type]
	WHERE Role_Rank = @Role_Rank2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[Manage].[Role_Type];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO

-- TestFunctionsClass
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num,
		@role_Name);

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num2,
		@role_Name);

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		@acnt_type_Id,
		@acnt_Amount);

	INSERT INTO [FinancialService].[Manage].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num2,
		@acnt_type_Id2,
		@acnt_Amount2);

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	SELECT @actual = [FinancialService].[Enthus].fnGetFinancialServiceNetWorth();

	/* Assertion */
	DECLARE @expected DECIMAL(18,2);
	SELECT @expected = SUM(Acnt_Amount) FROM [FinancialService].[Manage].[Account];
	EXEC [tSQLt].[AssertEquals] @actual, @expected;

END 
GO

-- TestRelationsClass
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
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
	FROM [FinancialService].[Manage].[User] AS U
	JOIN [FinancialService].[Manage].[Role] AS R
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num,
		@role_Name);

	/* Fake Role_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role_Type';

	INSERT INTO [FinancialService].[Manage].[Role_Type]
		(Role_Name,
		Role_Rank)
	VALUES
		(@role_Name,
		@role_Rank);

	/* Execution */
	DECLARE @actual INT;
	SELECT
		@actual = RT.Role_Rank
	FROM [FinancialService].[Manage].[Role] AS R
	JOIN [FinancialService].[Manage].[Role_Type] AS RT
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num,
		@role_Name);

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
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
	FROM [FinancialService].[Manage].[Role] AS R
	JOIN [FinancialService].[Manage].[Account] AS A
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Fake Account_Type Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account_Type';

	INSERT INTO [FinancialService].[Manage].[Account_Type]
		(Acnt_Type_Id,
		Acnt_Type)
	VALUES
		(@acnt_type_Id,
		@acnt_Type);

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT 
		@actual = T.Acnt_Type
	FROM [FinancialService].[Manage].[Account] AS A
	JOIN [FinancialService].[Manage].[Account_Type] AS T
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	INSERT INTO [FinancialService].[Advise].[Transaction]
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
	FROM [FinancialService].[Manage].[Account] AS A
	JOIN [FinancialService].[Advise].[Transaction] AS T
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	INSERT INTO [FinancialService].[Advise].[Transaction]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction_Type';

	INSERT INTO [FinancialService].[Advise].[Transaction_Type]
		(TR_Type_Name,
		TR_Type)
	VALUES
		(@TR_Type_Name,
		@TR_Type);

	/* Execution */
	DECLARE @actual varchar(50);
	SELECT
		@actual = TT.TR_Type
	FROM [FinancialService].[Advise].[Transaction] AS T
	JOIN [FinancialService].[Advise].[Transaction_Type] AS TT
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num,
		@role_Name);

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
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
	FROM [FinancialService].[Manage].[User] AS U
	JOIN ([FinancialService].[Manage].[Role] AS R
		JOIN [FinancialService].[Manage].[Account] AS A
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.User';

	INSERT INTO [FinancialService].[Manage].[User]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Role';

	INSERT INTO [FinancialService].[Manage].[Role]
		(User_Id,
		Acnt_Num, 
		Role_Name)
	VALUES
		(1,
		@acnt_Num,
		@role_Name);

	/* Fake Account Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Manage.Account';

	INSERT INTO [FinancialService].[Manage].[Account]
		(Acnt_Num, 
		Acnt_Type_Id,
		Acnt_Amount)
	VALUES
		(@acnt_Num,
		1,
		@acnt_Amount);

	/* Fake Transaction Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	INSERT INTO [FinancialService].[Advise].[Transaction]
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
	FROM [FinancialService].[Manage].[User] AS U
	JOIN ([FinancialService].[Manage].[Role] AS R
		JOIN ([FinancialService].[Manage].[Account] AS A
			JOIN [FinancialService].[Advise].[Transaction] AS T
			ON A.Acnt_Num = T.Acnt_Num)
		ON R.Acnt_Num = A.Acnt_Num)
	ON U.User_Id = R.User_Id
	WHERE U.User_Id = 1 AND A.Acnt_NUM = @acnt_Num AND T.TR_ID = @TR_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @TR_Amount, @actual;

END
GO