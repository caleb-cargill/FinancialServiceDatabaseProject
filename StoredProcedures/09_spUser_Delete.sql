/* DELIVERABLE #9: STORED PROCEDURE SCRIPT */

USE [FinancialService]
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Delete')
DROP PROCEDURE spUser_Delete
GO
CREATE PROCEDURE [dbo].[spUser_Delete]
	@User_Id INT
AS
BEGIN
	DELETE 
	FROM [FinancialService].[dbo].[User]
	WHERE User_Id = @User_Id;
END
GO