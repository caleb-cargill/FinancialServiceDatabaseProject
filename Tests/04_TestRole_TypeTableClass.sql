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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role_Type';

	INSERT INTO [FinancialService].[dbo].[Role_Type]
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
	FROM [FinancialService].[dbo].[Role_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role_Type';

	INSERT INTO [FinancialService].[dbo].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank,
		@Role_Name);

	/* Test - select from Role_Type table */

	/* Execution */
	DECLARE @update varchar(50);
	SET @update = 'Viewer';

	UPDATE [FinancialService].[dbo].[Role_Type]
	SET
		Role_Name = @update
	WHERE 
		Role_Rank = @Role_Rank;

	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[dbo].[Role_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role_Type';

	INSERT INTO [FinancialService].[dbo].[Role_Type]
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

	INSERT INTO [FinancialService].[dbo].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank2,
		@Role_Name2);

	DECLARE @actual varchar(50);
	SELECT
		@actual = Role_Name
	FROM [FinancialService].[dbo].[Role_Type]
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
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'dbo.Role_Type';

	INSERT INTO [FinancialService].[dbo].[Role_Type]
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

	INSERT INTO [FinancialService].[dbo].[Role_Type]
		(Role_Rank,
		Role_Name)
	VALUES
		(@Role_Rank2,
		@Role_Name2);

	DELETE FROM [FinancialService].[dbo].[Role_Type]
	WHERE Role_Rank = @Role_Rank2;

	DECLARE @actual INT;
	SELECT
		@actual = COUNT(*)
	FROM [FinancialService].[dbo].[Role_Type];

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, 1;

END
GO