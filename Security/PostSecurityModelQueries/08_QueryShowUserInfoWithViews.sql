/* DELIVERABLE #8: Query that Uses a View */

/* Show All Users and Their Accounts */
SELECT * FROM [FinancialService].[Enthus].[vwUser_Account_Roles];

/* Show Specific User and Their Accounts */
SELECT * FROM [FinancialService].[Enthus].[vwUser_Account_Roles]
WHERE User_FName = 'Joe' AND User_LName = 'Smith';

/* Show the Net Worth of Each User */
SELECT * FROM [FinancialService].[Enthus].[vwUser_NetWorth];

/* Show the Net Worth of Specific User */
SELECT * FROM [FinancialService].[Enthus].[vwUser_NetWorth]
WHERE User_FName = 'Joe' AND User_LName = 'Smith';
