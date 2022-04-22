#### CS4092 Database Project Final   
Due April 22nd, 2022   
Spring Semester 2022   
Caleb Cargill   

##### Contact Information
Caleb Cargill  
cargilch@mail.uc.edu 

##### Database Description
For the final project, I have created a database modeling data for users and their bank accounts, called 'FinancialService'.
Relatively basic, but it does model the real world, below is a list of tables I have included:
 1. User
 2. Role
 3. Role_Type
 4. Account
 5. Account_Type
 6. Transaction
 7. Transaction_Type

##### Submission Notes
For convenience, I have tried to keep this as organized as possible. I have labeled files with the 'deliverable number' that its contents satisfy.
Please see table below for a more detailed description of where each deliverable-satisfying file can be found.

 | #   		| Deliverable Description																	| File Location 									|
 | :---		| :---																						| :---												|
 | 1		| Conceptual Model																			| Models\01_ConceptualModel.pdf						|
 | 2		| DDL Scripts to Create DB, Tables and Relations											| 02_LoadDatabaseAndObjectsDDL.sql					|
 | 3		| DML Scripts to Load the Data																| 03_InsertDataAllTablesDML.sql						|
 | 4		| Test Scripts to Unit Test the DB															| Tests\04_TestAccount_TypeTableClass.sql			|
 |  		| 																							| Tests\04_TestAccountTableClass.sql				|
 |  		| 																							| Tests\04_TestRole_TypeTableClass.sql				|
 |  		| 																							| Tests\04_TestRoleTableClass.sql					|
 |  		| 																							| Tests\04_TestTableRelationsClass.sql				|
 |  		| 																							| Tests\04_TestTransaction_TypeTableClass.sql		|
 |  		| 																							| Tests\04_TestTransactionTableClass.sql			|
 |  		| 																							| Tests\04_TestUserTableClass.sql					|
 | 5		| Queries that show all the data															| Queries\05_QueryShowAllData.sql					|
 | 6		| Queries that show all the relations														| Queries\06_QueryShowAllRelations.sql				|
 | 7		| One or more view creation scripts															| Views\07_vwUser_Account_Roles.sql					|
 |			|																							| Views\07_vwUser_NetWorth.sql						|
 | 8		| A query that uses a view																	| Views\08_QueryShowUserInfoWithViews.sql			|
 | 9		| One or more stored procedures																| StoredProcedures\09_spUser_Create.sql				|
 |			|																							| StoredProcedures\09_spUser_Delete.sql				|
 |			|																							| StoredProcedures\09_spUser_Read.sql				|
 |			|																							| StoredProcedures\09_spUser_Update.sql				|
 | 10		| Optionally a User Defined Function														| Functions\10_fnGetFinancialServiceNetWorth().sql	|
 |			|																							| Functions\10_TestFunctionsClass.sql				|
 | 11		| Create a non-default schema																| Security\11_CreateNonDefaultSchema.sql			|
 | 12		| Describe the security model																| Security\12_SecurityModel.pdf						|
 | 13		| Scripts to implement the security model													| Security\13_ImplementSecurityModel.sql			|
 | 14 		| Scripts to test the security model														| Security\14_TestSecurityModelClass.sql			|	 
 