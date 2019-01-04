DECLARE @year nchar(4), @tableName nchar(14);
SET @year = '2014';
SET @tableName = 'dbo.Rates_' + @year


/*Select Business_Year AS Year, State_Code AS State, Age, AVG(Individual_Rate) AS Avg_Rate
from dbo.Rates_2019
where State_Code = 'FL'
group by Business_Year, State_Code, Age
ORDER BY Age
*/

/*DECLARE @sqlCommand varchar(1000)
SET @sqlCommand = 'SELECT count(*) from dbo.Rates_2019 where State_Code = FL'
EXEC ('SELECT count(*) from dbo.Rates_201' + '9')
*/

--DECLARE @state nchar(2), @sql varchar(500)

--EXEC ('SELECT count(*) from dbo.Rates_2015 where State_Code = ' + @state)
--SELECT count(*) from dbo.Rates_2015 where State_Code = @state

--SET @sql = 'SELECT count(*) from dbo.Rates_2015 where State_Code = ' + @state
--print @sql 
--exec (@sql)

DECLARE @state nchar(10)
SET @state = '''FL'''
--EXEC ('SELECT count(*) from dbo.Rates_2016 WHERE State_Code = ' + @state)
--EXEC ('SELECT count(*) from ' + @tableName + ' WHERE State_Code = ' + @state)

/*CREATE PROCEDURE TestProc
AS
EXEC ('SELECT count(*) from ' + @tableName + ' WHERE State_Code = ' + @state)
*/
--EXEC TestProc

/*select * from TestFunc()
union all
select * from TestFunc()
*/
--select * FROM Healthcare.dbo.TestFunc()
--select count(*) from Healthcare.dbo.Rates_2014
--select count(*) from Healthcare.dbo.Rates_2014

--select '95 or lower', cast(substring('95 or lower',1,2) as int)

/*Select Business_Year AS Year, State_Code AS State, Age, AVG(Individual_Rate) AS Avg_Rate
from Healthcare.dbo.Rates_2019
where State_Code = 'FL' and Age <> 'Family Option' and Age <> '0-14' and CAST(Age as int) < 21
group by Business_Year, State_Code, Age
ORDER BY Age*/

Select T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate, '25-34' as Age_Range
from (select * from Healthcare.dbo.Rates_2019 where Age <> 'Family Option' and Age <> '0-14') as T2
where T2.State_Code = 'FL' and CAST(Substring(T2.Age, 1,2) as int) > 24 and CAST(Substring(T2.Age, 1,2) as int) < 35
group by T2.Business_Year, T2.State_Code
