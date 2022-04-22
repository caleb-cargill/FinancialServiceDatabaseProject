/* DELIVERABLE #10 - USER DEFINED FUNCTION */

/* Returns the amount of money in the Financial Service */

USE [FinancialService]
GO
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE Name = 'fnGetFinancialServiceNetWorth' AND Type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION [dbo].[fnGetFinancialServiceNetWorth]
GO
CREATE FUNCTION [dbo].[fnGetFinancialServiceNetWorth]()
RETURNS DECIMAL(18,2)
AS
BEGIN
	/* Variable to return sum */ 
	DECLARE @ret DECIMAL(18,2);

	/* Use View to get sum */
	SELECT 
		@ret = SUM(NetWorth) 
	FROM [FinancialService].[dbo].[vwUser_NetWorth];

	/* If it is null, set variable to 0 */
	IF (@ret IS NULL)
		SET @ret = 0;

	/* Return sum */
	RETURN @ret;
END
GO