/* DELIVERABLE #7: VIEW CREATION SCRIPT */

USE [FinancialService]
GO
IF EXISTS (SELECT * FROM [sys].[views] WHERE name = 'vwUser_Account_Roles')
DROP VIEW vwUser_Account_Roles
GO
CREATE VIEW [dbo].[vwUser_Account_Roles]
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
	FROM [dbo].[User] AS U
	JOIN ([dbo].[Role] AS R
		JOIN ([dbo].[Account] AS A
			JOIN [dbo].[Account_Type] AS T
			ON A.Acnt_Type_Id = T.Acnt_Type_Id)
		ON R.Acnt_Num = A.Acnt_Num)
	ON U.User_Id = R.User_Id;
GO