ALTER FUNCTION TestFunc ()
RETURNS TABLE
AS
RETURN(
 EXEC('SELECT count(*) from dbo.Rates_201' + '9')
 )
