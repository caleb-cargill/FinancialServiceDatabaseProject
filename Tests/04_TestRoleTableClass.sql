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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role';

	INSERT INTO [FinancialService].[dbo].[Role]
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
	FROM [FinancialService].[dbo].[Role]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role';

	INSERT INTO [FinancialService].[dbo].[Role]
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

	UPDATE [FinancialService].[dbo].[Role]
	SET
		Role_Name = @update
	WHERE 
		Acnt_Num = @acnt_Num AND User_Id = @user_Id;

	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[dbo].[Role]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role';

	INSERT INTO [FinancialService].[dbo].[Role]
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

	INSERT INTO [FinancialService].[dbo].[Role]
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
	FROM [FinancialService].[dbo].[Role]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role';

	INSERT INTO [FinancialService].[dbo].[Role]
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

	INSERT INTO [FinancialService].[dbo].[Role]
		(User_Id,
		Acnt_Num,
		Role_Name)
	VALUES
		(@user_Id2,
		@acnt_Num2,
		@role_Name2);

	DELETE FROM [FinancialService].[dbo].[Role]
	WHERE Acnt_Num = @acnt_Num2 AND User_Id = @user_Id2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[dbo].[Role];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO