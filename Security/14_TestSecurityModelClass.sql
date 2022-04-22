/* DELIVERABLE 14 - TEST THE SECURITY MODEL */

USE [FinancialService]
GO

EXEC [tSQLt].[NewTestClass] 'TestSecurityModelClass';
GO

-------------------------------------------------------------------------
-- finman
-------------------------------------------------------------------------

/* Tests that the User table can be inserted into by finman */
CREATE PROCEDURE TestSecurityModelClass.[Test that user table can be inserted into by finman]
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

	EXECUTE AS USER = 'finman'

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

	REVERT;

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

/* Tests that the Transaction table can be inserted into by finman */
CREATE PROCEDURE TestSecurityModelClass.[Tests that the Transaction table can be inserted into by finman]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @tr_ID INT;
	SET @tr_ID = 1;
	DECLARE @tr_Type_Name varchar(50);
	SET @tr_Type_Name = 'Groceries';
	DECLARE @tr_Amount DECIMAL(18,2);
	SET @tr_Amount = 123.45;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	EXECUTE AS USER = 'finman'

	INSERT INTO [FinancialService].[Advise].[Transaction]
		(TR_ID,
		TR_Type_Name,
		TR_Amount,
		Acnt_Num)
	VALUES
		(@tr_ID,
		@tr_Type_Name,
		@tr_Amount,
		@acnt_Num);

	REVERT;

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	
	SELECT 
		@actual = TR_Amount
	FROM [FinancialService].[Advise].[Transaction]
	WHERE TR_ID = @tr_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @tr_Amount;

END
GO

/* Tests that the fnGetFinancialServiceNetWorth() function can be selected from by finman */
CREATE PROCEDURE TestSecurityModelClass.[Tests that the fnGetFinancialServiceNetWorth() function can be selected from by finman]
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

	EXECUTE AS USER = 'finman'

	SELECT @actual = [FinancialService].[Enthus].fnGetFinancialServiceNetWorth();

	REVERT;

	/* Assertion */
	DECLARE @expected DECIMAL(18,2);
	SELECT @expected = SUM(Acnt_Amount) FROM [FinancialService].[Manage].[Account];
	EXEC [tSQLt].[AssertEquals] @actual, @expected;

END 
GO

-------------------------------------------------------------------------
-- finadv
-------------------------------------------------------------------------

/* Tests that the User table cannot be inserted into by finadv */
CREATE PROCEDURE TestSecurityModelClass.[Test that user table can not be inserted into by finadv]
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

	EXEC tSQLt.ExpectException @ExpectedMessage = 'The INSERT permission was denied on the object ''User'', database ''FinancialService'', schema ''Manage''.', @ExpectedSeverity = NULL, @ExpectedState = NULL;

	EXECUTE AS USER = 'finadv'

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

	REVERT;

	/* Execution */
	DECLARE @actual varchar(255);
	
	SELECT 
		@actual = User_Email
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = 1;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, NULL;

END
GO

/* Tests that the Transaction table can be inserted into by finadv */
CREATE PROCEDURE TestSecurityModelClass.[Tests that the Transaction table can be inserted into by finadv]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @tr_ID INT;
	SET @tr_ID = 1;
	DECLARE @tr_Type_Name varchar(50);
	SET @tr_Type_Name = 'Groceries';
	DECLARE @tr_Amount DECIMAL(18,2);
	SET @tr_Amount = 123.45;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	EXECUTE AS USER = 'finadv'

	INSERT INTO [FinancialService].[Advise].[Transaction]
		(TR_ID,
		TR_Type_Name,
		TR_Amount,
		Acnt_Num)
	VALUES
		(@tr_ID,
		@tr_Type_Name,
		@tr_Amount,
		@acnt_Num);

	REVERT;

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	
	SELECT 
		@actual = TR_Amount
	FROM [FinancialService].[Advise].[Transaction]
	WHERE TR_ID = @tr_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, @tr_Amount;

END
GO

/* Tests that the fnGetFinancialServiceNetWorth() function can be selected from by finadv */
CREATE PROCEDURE TestSecurityModelClass.[Tests that the fnGetFinancialServiceNetWorth() function can be selected from by finadv]
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

	EXECUTE AS USER = 'finadv'

	SELECT @actual = [FinancialService].[Enthus].fnGetFinancialServiceNetWorth();

	REVERT;

	/* Assertion */
	DECLARE @expected DECIMAL(18,2);
	SELECT @expected = SUM(Acnt_Amount) FROM [FinancialService].[Manage].[Account];
	EXEC [tSQLt].[AssertEquals] @actual, @expected;

END 
GO

-------------------------------------------------------------------------
-- finenthus
-------------------------------------------------------------------------

/* Tests that the User table cannot be inserted into by finenthus */
CREATE PROCEDURE TestSecurityModelClass.[Test that user table can not be inserted into by finenthus]
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

	EXEC tSQLt.ExpectException @ExpectedMessage = 'The INSERT permission was denied on the object ''User'', database ''FinancialService'', schema ''Manage''.', @ExpectedSeverity = NULL, @ExpectedState = NULL;

	EXECUTE AS USER = 'finenthus'

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

	REVERT;

	/* Execution */
	DECLARE @actual varchar(255);
	
	SELECT 
		@actual = User_Email
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = 1;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, NULL;

END
GO

/* Tests that the Transaction table can not be inserted into by finenthus */
CREATE PROCEDURE TestSecurityModelClass.[Tests that the Transaction table can not be inserted into by finenthus]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @tr_ID INT;
	SET @tr_ID = 1;
	DECLARE @tr_Type_Name varchar(50);
	SET @tr_Type_Name = 'Groceries';
	DECLARE @tr_Amount DECIMAL(18,2);
	SET @tr_Amount = 123.45;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	EXEC tSQLt.ExpectException @ExpectedMessage = 'The INSERT permission was denied on the object ''Transaction'', database ''FinancialService'', schema ''Advise''.', @ExpectedSeverity = NULL, @ExpectedState = NULL;

	EXECUTE AS USER = 'finenthus'

	INSERT INTO [FinancialService].[Advise].[Transaction]
		(TR_ID,
		TR_Type_Name,
		TR_Amount,
		Acnt_Num)
	VALUES
		(@tr_ID,
		@tr_Type_Name,
		@tr_Amount,
		@acnt_Num);

	REVERT;

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	
	SELECT 
		@actual = TR_Amount
	FROM [FinancialService].[Advise].[Transaction]
	WHERE TR_ID = @tr_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, NULL;

END
GO

/* Tests that the fnGetFinancialServiceNetWorth() function can be selected from by finenthus */
CREATE PROCEDURE TestSecurityModelClass.[Tests that the fnGetFinancialServiceNetWorth() function can be selected from by finenthus]
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

	EXECUTE AS USER = 'finenthus'

	SELECT @actual = [FinancialService].[Enthus].fnGetFinancialServiceNetWorth();

	REVERT;

	/* Assertion */
	DECLARE @expected DECIMAL(18,2);
	SELECT @expected = SUM(Acnt_Amount) FROM [FinancialService].[Manage].[Account];
	EXEC [tSQLt].[AssertEquals] @actual, @expected;

END 
GO

-------------------------------------------------------------------------
-- finclient
-------------------------------------------------------------------------

/* Tests that the User table cannot be inserted into by finclient */
CREATE PROCEDURE TestSecurityModelClass.[Test that user table can not be inserted into by finclient]
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

	EXEC tSQLt.ExpectException @ExpectedMessage = 'The INSERT permission was denied on the object ''User'', database ''FinancialService'', schema ''Manage''.', @ExpectedSeverity = NULL, @ExpectedState = NULL;

	EXECUTE AS USER = 'finclient'

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

	REVERT;

	/* Execution */
	DECLARE @actual varchar(255);
	
	SELECT 
		@actual = User_Email
	FROM [FinancialService].[Manage].[User]
	WHERE User_Id = 1;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, NULL;

END
GO

/* Tests that the Transaction table cannot be inserted into by finclient */
CREATE PROCEDURE TestSecurityModelClass.[Tests that the Transaction table cannot be inserted into by finclient]
AS
BEGIN

	/* Declare Variables for Testing Data */
	DECLARE @tr_ID INT;
	SET @tr_ID = 1;
	DECLARE @tr_Type_Name varchar(50);
	SET @tr_Type_Name = 'Groceries';
	DECLARE @tr_Amount DECIMAL(18,2);
	SET @tr_Amount = 123.45;
	DECLARE @acnt_Num INT;
	SET @acnt_Num = 1000000000;

	/* Fake Tables */

	/* Fake User Table */
	EXEC [tSQLt].[FakeTable] 'FinancialService', 'Advise.Transaction';

	EXEC tSQLt.ExpectException @ExpectedMessage = 'The INSERT permission was denied on the object ''Transaction'', database ''FinancialService'', schema ''Advise''.', @ExpectedSeverity = NULL, @ExpectedState = NULL;

	EXECUTE AS USER = 'finclient'

	INSERT INTO [FinancialService].[Advise].[Transaction]
		(TR_ID,
		TR_Type_Name,
		TR_Amount,
		Acnt_Num)
	VALUES
		(@tr_ID,
		@tr_Type_Name,
		@tr_Amount,
		@acnt_Num);

	REVERT;

	/* Execution */
	DECLARE @actual DECIMAL(18,2);
	
	SELECT 
		@actual = TR_Amount
	FROM [FinancialService].[Advise].[Transaction]
	WHERE TR_ID = @tr_ID;

	/* Assertion */
	EXEC [tSQLt].[AssertEquals] @actual, NULL;

END
GO
