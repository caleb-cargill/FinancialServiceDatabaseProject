/* DELIVERABLE #11: CREATE NON-DEFAULT SCHEMA */

/* Create some users */
/* finman -> financial manager, highest priveleges 
	finadv -> financial advisor, medium priveleges
	finenthis -> financial enthusiast, low priveleges
	finclient -> financial client, lowest priveleges */

USE [FinancialService]
GO

-- Create Financial Manager
CREATE LOGIN finman
	WITH PASSWORD = 'c2Y4X@RbZ927!Er7'; 
GO
CREATE USER finman FOR LOGIN finman;
GO

-- Create Financial Advisor
CREATE LOGIN finadv 
	WITH PASSWORD = 'Wz_M8cEhKsJ?wb?j';
GO
CREATE USER finadv FOR LOGIN finadv;
GO

-- Create Financial Enthusiast
CREATE LOGIN finenthus
	WITH PASSWORD = 'CPVa9MMtb%WwL4fG';
GO
CREATE USER finenthus FOR LOGIN finenthus;
GO

-- Create Financial Client
CREATE LOGIN finclient
	WITH PASSWORD = '@Xwu4D#!9TXDW7Ax';
GO
CREATE USER finclient FOR LOGIN finclient;
GO

/* Create new schema giving priveleges to finman */
CREATE SCHEMA Manage AUTHORIZATION finman
	DENY INSERT, DELETE ON SCHEMA::Manage TO finadv
	DENY INSERT, UPDATE, DELETE ON SCHEMA::Manage TO finenthus
	GRANT UPDATE, SELECT ON SCHEMA::Manage TO finadv	
	GRANT SELECT ON SCHEMA::Manage TO finenthus
	DENY INSERT, UPDATE, SELECT, DELETE ON SCHEMA::Manage TO finclient;
GO

/* Create new schema giving priveleges to finadv */
CREATE SCHEMA Advise AUTHORIZATION finadv
	GRANT INSERT, UPDATE, SELECT, DELETE ON SCHEMA::Advise TO finman
	DENY INSERT, UPDATE, DELETE ON SCHEMA::Advise TO finenthus
	GRANT SELECT ON SCHEMA::Advise TO finenthus
	DENY INSERT, SELECT, UPDATE, DELETE ON SCHEMA::Advise TO finclient;
GO

/* Create new schema giving priveleges to finenthus */
CREATE SCHEMA Enthus AUTHORIZATION finenthus
	GRANT INSERT, UPDATE, SELECT, DELETE ON SCHEMA::Enthus TO finman
	GRANT INSERT, UPDATE, SELECT, DELETE ON SCHEMA::Enthus TO finadv
	GRANT SELECT ON SCHEMA::Enthus TO finclient
	DENY INSERT, UPDATE, DELETE ON SCHEMA::Enthus TO finclient;
GO

/* Update default schema permissions */
GRANT INSERT, UPDATE, SELECT, DELETE ON SCHEMA::dbo TO finman
GO
GRANT INSERT, UPDATE, SELECT, DELETE ON SCHEMA::dbo TO finadv
GO
GRANT INSERT, UPDATE, SELECT, DELETE ON SCHEMA::dbo TO finenthus;
GO
GRANT INSERT, UPDATE, SELECT, DELETE ON SCHEMA::dbo TO finclient;
GO