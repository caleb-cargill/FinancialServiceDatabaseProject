/* DELIVERABLE #9: STORED PROCEDURE SCRIPT */

USE [FinancialService]
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE type = 'P' AND name = 'spUser_Read')
DROP PROCEDURE spUser_Read
GO
CREATE PROCEDURE [dbo].[spUser_Read]
	@User_Id INT
AS
BEGIN
	SELECT
		*
	FROM [FinancialService].[dbo].[User]
	WHERE User_Id = @User_Id;
END
GO