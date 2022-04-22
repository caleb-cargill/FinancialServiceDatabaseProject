/* DELIVERABLE #3 - DML SCRIPT TO INSERT DATA INTO TABLES */

/* USER TABLE */

/* Row 1 */
INSERT INTO [FinancialService].[dbo].[User] 
(User_FName, User_LName, User_Email)
VALUES 
('Joe', 'Smith', 'JoeSmith@email.com');

/* Row 2 */
INSERT INTO [FinancialService].[dbo].[User] 
(User_FName, User_LName, User_Email)
VALUES 
('Bob', 'Allen', 'BobAllen@email.com');

/* Row 3 */
INSERT INTO [FinancialService].[dbo].[User] 
(User_FName, User_LName, User_Email)
VALUES 
('Amy', 'Johnson', 'AmyJohnson@email.com');

/* Row 4 */
INSERT INTO [FinancialService].[dbo].[User] 
(User_FName, User_LName, User_Email)
VALUES 
('Sarah', 'Lee', 'SarahLee@email.com');

/* Row 5 */
INSERT INTO [FinancialService].[dbo].[User] 
(User_FName, User_LName, User_Email)
VALUES 
('Karl', 'Jacobs', 'KarlJacobs@email.com');

/* ACCOUNT TYPE TABLE */

/* Row 1 */
INSERT INTO [FinancialService].[dbo].[Account_Type]
(Acnt_Type)
VALUES
('Closed')

/* Row 2 */
INSERT INTO [FinancialService].[dbo].[Account_Type]
(Acnt_Type)
VALUES
('Checking')

/* Row 3 */
INSERT INTO [FinancialService].[dbo].[Account_Type]
(Acnt_Type)
VALUES
('Savings')

/* Row 4 */
INSERT INTO [FinancialService].[dbo].[Account_Type]
(Acnt_Type)
VALUES
('Retirement')

/* Row 5 */
INSERT INTO [FinancialService].[dbo].[Account_Type]
(Acnt_Type)
VALUES
('Credit')

/* TRANSACTION TYPE TABLE */

/* Row 1 */
INSERT INTO [FinancialService].[dbo].[Transaction_Type]
(TR_Type_Name, TR_Type)
VALUES 
('Groceries', 'Expense')

/* Row 2 */
INSERT INTO [FinancialService].[dbo].[Transaction_Type]
(TR_Type_Name, TR_Type)
VALUES 
('Gas', 'Expense')

/* Row 3 */
INSERT INTO [FinancialService].[dbo].[Transaction_Type]
(TR_Type_Name, TR_Type)
VALUES 
('Rent', 'Expense')

/* Row 4 */
INSERT INTO [FinancialService].[dbo].[Transaction_Type]
(TR_Type_Name, TR_Type)
VALUES 
('Insurance', 'Expense')

/* Row 5 */
INSERT INTO [FinancialService].[dbo].[Transaction_Type]
(TR_Type_Name, TR_Type)
VALUES 
('Paycheck', 'Income')

/* Row 6 */
INSERT INTO [FinancialService].[dbo].[Transaction_Type]
(TR_Type_Name, TR_Type)
VALUES 
('Reimbursement', 'Income')

/* Row 7 */
INSERT INTO [FinancialService].[dbo].[Transaction_Type]
(TR_Type_Name, TR_Type)
VALUES 
('Savings', 'Income')

/* ACCOUNT TABLE */

/* Row 1 */
INSERT INTO [FinancialService].[dbo].[Account]
(Acnt_Num, Acnt_Type_Id, Acnt_Amount)
VALUES
(10000000, 2, 523.78)

/* Row 2 */
INSERT INTO [FinancialService].[dbo].[Account]
(Acnt_Num, Acnt_Type_Id, Acnt_Amount)
VALUES
(10000001, 3, 33894.15)

/* Row 3 */
INSERT INTO [FinancialService].[dbo].[Account]
(Acnt_Num, Acnt_Type_Id, Acnt_Amount)
VALUES
(10000002, 4, 1589753.84)

/* Row 4 */
INSERT INTO [FinancialService].[dbo].[Account]
(Acnt_Num, Acnt_Type_Id, Acnt_Amount)
VALUES
(20000000, 2, 25.50)

/* Row 5 */
INSERT INTO [FinancialService].[dbo].[Account]
(Acnt_Num, Acnt_Type_Id, Acnt_Amount)
VALUES
(30000000, 2, 1523.78)

/* Row 6 */
INSERT INTO [FinancialService].[dbo].[Account]
(Acnt_Num, Acnt_Type_Id, Acnt_Amount)
VALUES
(40000001, 3, 87648.78)

/* Row 7 */
INSERT INTO [FinancialService].[dbo].[Account]
(Acnt_Num, Acnt_Type_Id, Acnt_Amount)
VALUES
(50000001, 3, 98761.78)

/* TRANSACTION TABLE */

/* Row 1 */
INSERT INTO [FinancialService].[dbo].[Transaction]
(TR_Type_Name, TR_Amount, Acnt_Num)
VALUES
('Paycheck', 100, 10000000)

/* Row 2 */
INSERT INTO [FinancialService].[dbo].[Transaction]
(TR_Type_Name, TR_Amount, Acnt_Num)
VALUES
('Savings', 1500, 10000001)

/* Row 3 */
INSERT INTO [FinancialService].[dbo].[Transaction]
(TR_Type_Name, TR_Amount, Acnt_Num)
VALUES
('Savings', 1000, 10000002)

/* Row 4 */
INSERT INTO [FinancialService].[dbo].[Transaction]
(TR_Type_Name, TR_Amount, Acnt_Num)
VALUES
('Groceries', 150, 20000000)

/* Row 5 */
INSERT INTO [FinancialService].[dbo].[Transaction]
(TR_Type_Name, TR_Amount, Acnt_Num)
VALUES
('Savings', 1000, 40000001)

/* Row 6 */
INSERT INTO [FinancialService].[dbo].[Transaction]
(TR_Type_Name, TR_Amount, Acnt_Num)
VALUES
('Gas', 55, 30000000)

/* Row 7 */
INSERT INTO [FinancialService].[dbo].[Transaction]
(TR_Type_Name, TR_Amount, Acnt_Num)
VALUES
('Insurance', 100, 50000001)

/* ROLE TYPE TABLE */

/* Row 1 */
INSERT INTO [FinancialService].[dbo].[Role_Type]
(Role_Name, Role_Rank)
VALUES
('Owner', 1)

/* Row 2 */
INSERT INTO [FinancialService].[dbo].[Role_Type]
(Role_Name, Role_Rank)
VALUES
('Manager', 2)

/* Row 3 */
INSERT INTO [FinancialService].[dbo].[Role_Type]
(Role_Name, Role_Rank)
VALUES
('Accountant', 3)

/* Row 4 */
INSERT INTO [FinancialService].[dbo].[Role_Type]
(Role_Name, Role_Rank)
VALUES
('Viewer', 4)

/* Row 5 */
INSERT INTO [FinancialService].[dbo].[Role_Type]
(Role_Name, Role_Rank)
VALUES
('None', 5)

/* ROLE TABLE */

/* Row 1 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(1, 10000000, 'Owner')

/* Row 2 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(1, 10000001, 'Owner')

/* Row 3 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(1, 10000002, 'Owner')

/* Row 4 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(1, 20000000, 'Viewer')

/* Row 5 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(2, 10000000, 'Viewer')

/* Row 6 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(2, 20000000, 'Manager')

/* Row 7 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(3, 30000000, 'Manager')

/* Row 8 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(4, 40000001, 'Manager')

/* Row 9 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(4, 50000001, 'Accountant')

/* Row 10 */
INSERT INTO [FinancialService].[dbo].[Role]
(User_Id, Acnt_Num, Role_Name)
VALUES
(5, 50000001, 'Manager')