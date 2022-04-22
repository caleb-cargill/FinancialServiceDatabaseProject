/* DELIVERABLE #9: STORED PROCEDURE SCRIPT */

USE [FinancialService]
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Update')
DROP PROCEDURE spUser_Update
GO
CREATE PROCEDURE [dbo].[spUser_Update]
	@User_Id INT,
	@User_FName varchar(100),
	@User_LName varchar(100),
	@User_Email varchar(255)
AS
BEGIN
	UPDATE [FinancialService].[dbo].[User]
	SET
		User_FName = @User_FName,
		User_LName = @User_LName,
		User_Email = @User_Email
	WHERE
		User_Id = @User_Id;
END
GO