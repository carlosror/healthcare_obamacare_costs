ALTER PROCEDURE TestProc
AS
SELECT count(*) from dbo.Rates_2014
UNION
SELECT count(*) from dbo.Rates_2015
--EXEC TestProc