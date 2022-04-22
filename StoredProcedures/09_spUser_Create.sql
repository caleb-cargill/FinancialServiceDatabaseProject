/* DELIVERABLE #9: STORED PROCEDURE SCRIPT */

USE [FinancialService]
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Create')
DROP PROCEDURE spUser_Create
GO
CREATE PROCEDURE [dbo].[spUser_Create]
	@User_FName varchar(100),
	@User_LName varchar(100),
	@User_Email varchar(255)
AS
BEGIN
	INSERT INTO [FinancialService].[dbo].[User]
		(User_FName,
		User_LName,
		User_Email)
	VALUES
		(@User_FName,
		@User_LName,
		@User_Email)
END
GO