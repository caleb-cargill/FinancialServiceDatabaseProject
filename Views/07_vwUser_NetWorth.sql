/* DELIVERABLE #7: VIEW CREATION SCRIPT */

USE [FinancialService]
GO
IF EXISTS (SELECT * FROM [sys].[views] WHERE name = 'vwUser_NetWorth')
DROP VIEW vwUser_NetWorth
GO
CREATE VIEW [dbo].[vwUser_NetWorth]
AS
	SELECT 
		(SELECT UT.User_FName FROM [dbo].[User] AS UT WHERE UT.User_Id = U.User_Id) AS User_FName,
		(SELECT UT.User_LName FROM [dbo].[User] AS UT WHERE UT.User_Id = U.User_Id) AS User_LName,
		SUM(A.Acnt_Amount) AS NetWorth
	FROM [dbo].[User] AS U
	JOIN ([dbo].[Role] AS R
		JOIN [dbo].[Account] AS A			
		ON R.Acnt_Num = A.Acnt_Num)
	ON U.User_Id = R.User_Id
	GROUP BY U.User_Id;
GO