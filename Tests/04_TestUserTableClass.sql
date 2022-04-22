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

	/* Test - select from user table */

	/* Execution */
	DECLARE @actual varchar(255);
	SELECT
		@actual = User_Email
	FROM [FinancialService].[dbo].[User]
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

	/* Test - select from user table */

	/* Execution */
	DECLARE @update varchar(255);
	SET @update = 'Joe.Billy@email.com';

	UPDATE [FinancialService].[dbo].[User]
	SET
		User_Email = @update
	WHERE 
		User_Id = 1;

	DECLARE @actual varchar(255);
	SELECT
		@actual = User_Email
	FROM [FinancialService].[dbo].[User]
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

	/* Test - select from user table */

	/* Execution */
	DECLARE @user_FName2 varchar(100);
	SET @user_FName2 = 'John';
	DECLARE @user_LName2 varchar(100);
	SET @user_LName = 'Smith';
	DECLARE @user_Email2 varchar(255);
	SET @user_Email2 = 'John.Smith@email.com';	

	INSERT INTO [FinancialService].[dbo].[User]
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
	FROM [FinancialService].[dbo].[User]
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

	/* Test - select from user table */

	/* Execution */
	DECLARE @user_FName2 varchar(100);
	SET @user_FName2 = 'John';
	DECLARE @user_LName2 varchar(100);
	SET @user_LName2 = 'Smith';
	DECLARE @user_Email2 varchar(255);
	SET @user_Email2 = 'John.Smith@email.com';	

	INSERT INTO [FinancialService].[dbo].[User]
		(User_Id,
		User_FName,
		User_LName,
		User_Email)
	VALUES
		(2,
		@user_FName2,
		@user_LName2,
		@user_Email2);

	DELETE FROM [FinancialService].[dbo].[User]
	WHERE User_Id = 2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[dbo].[User];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO