/* DELIVERABLE #6: QUERIES THAT SHOW ALL RELATIONS */

/* User-Role Relation */
SELECT
	R.User_Id,
	R.Acnt_Num,
	R.Role_Name,
	U.User_FName,
	U.User_LName,
	U.User_Email
FROM [FinancialService].[dbo].[Role] AS R
JOIN [FinancialService].[dbo].[User] AS U
ON R.User_Id = U.User_Id;

/* Role-Role_Type Relation */
SELECT 
	R.User_Id,
	R.Acnt_Num,
	R.Role_Name,
	RT.Role_Rank
FROM [FinancialService].[dbo].[Role] AS R
JOIN [FinancialService].[dbo].[Role_Type] AS RT
ON R.Role_Name = RT.Role_Name;

/* Role-Account Relation */
SELECT 
	R.User_Id,
	R.Acnt_Num,
	R.Role_Name,
	A.Acnt_Type_Id,
	A.Acnt_Amount
FROM [FinancialService].[dbo].[Role] AS R
JOIN [FinancialService].[dbo].[Account] AS A
ON R.Acnt_Num = A.Acnt_Num;

/* Role-User-Account Relation */
SELECT
	R.User_Id,
	R.Acnt_Num,
	R.Role_Name,
	U.User_FName,
	U.User_LName,
	U.User_Email,
	A.Acnt_Type_Id,
	A.Acnt_Amount
FROM [FinancialService].[dbo].[User] AS U
JOIN [FinancialService].[dbo].[Role] AS R
	JOIN [FinancialService].[dbo].[Account] AS A
	ON R.Acnt_Num = A.Acnt_Num
ON R.User_Id = U.User_Id;

/* Account-Account_Type Relation */
SELECT
	A.Acnt_Num,
	A.Acnt_Type_Id,
	A.Acnt_Amount,
	T.Acnt_Type
FROM [FinancialService].[dbo].[Account] AS A
JOIN [FinancialService].[dbo].[Account_Type] AS T
ON A.Acnt_Type_Id = T.Acnt_Type_Id;

/* Account-Transaction Relation */
SELECT
	A.Acnt_Num,
	A.Acnt_Type_Id,
	A.Acnt_Amount,
	T.TR_Id,
	T.TR_Type_Name,
	T.TR_Amount
FROM [FinancialService].[dbo].[Account] AS A
JOIN [FinancialService].[dbo].[Transaction] AS T
ON A.Acnt_Num = T.Acnt_Num;

/* Transaction-Transaction_Type Relation */
SELECT
	T.TR_Id,
	T.Acnt_Num,
	T.TR_Type_Name,
	T.TR_Amount,
	TT.TR_Type
FROM [FinancialService].[dbo].[Transaction] AS T
JOIN [FinancialService].[dbo].[Transaction_Type] AS TT
ON T.TR_Type_Name = TT.TR_Type_Name;