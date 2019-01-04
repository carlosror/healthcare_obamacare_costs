DECLARE @Year int = 2014
DECLARE @statement NVARCHAR(max) = ''
DECLARE @state nchar(10) = '''FL'''
DECLARE @range1 nchar(20) = '''0-14'''
DECLARE @range2 nchar(20) = '''0-20'''
DECLARE @fam_option nchar(20) = '''Family Option'''
DECLARE @age_range nchar(20) = '''21-34'''
DECLARE @age_range_case int
DECLARE @age_range_low nchar(10) = '''20'''
DECLARE @age_range_high nchar(10) = '''34'''

/*
-- Query 1
SELECT Business_Year AS Year, State_Code AS State, AVG(Individual_Rate) AS Avg_Rate
FROM Healthcare.dbo.Rates_2014
WHERE State_Code = 'FL'
GROUP BY Business_Year, State_Code
*/


-- https://www.essentialsql.com/build-dynamic-sql-stored-procedure/
-- Query 2
SET @Year = 2014
SET @statement = ''
WHILE @Year <= 2019
	BEGIN
		SET @statement += 
		'SELECT Business_Year AS Year, State_Code AS State, AVG(Individual_Rate) AS Avg_Rate 
		 FROM Healthcare.dbo.Rates_' + CAST(@Year as NVARCHAR(10)) +
		' WHERE State_Code = ' + @state + 
		' GROUP BY Business_Year, State_Code '
		IF @Year < 2019
			SET @statement += ' UNION ALL ';
   
		SET @Year = @Year + 1
	END

EXECUTE sp_executesql @statement

/*
-- Query 3
SELECT Business_Year AS Year, State_Code AS State, Age, AVG(Individual_Rate) AS Avg_Rate
FROM Healthcare.dbo.Rates_2014
WHERE State_Code = 'FL'
GROUP BY Business_Year, State_Code, Age
ORDER BY Age
*/
/*
-- Query 3 embedded in a loop
SET @Year = 2014
SET @statement = ''
WHILE @Year <= 2019
	BEGIN
		SET @statement += 
		'Select Business_Year AS Year, State_Code AS State, Age, AVG(Individual_Rate) AS Avg_Rate 
		 FROM Healthcare.dbo.Rates_' + CAST(@Year as NVARCHAR(10)) +
		' WHERE State_Code = ' + @state + 
		' GROUP BY Business_Year, State_Code, Age '
		IF @Year < 2019
			SET @statement += ' UNION ALL ';
   
		SET @Year = @Year + 1
	END

SET @statement += 'ORDER BY Year, Age'

EXECUTE sp_executesql @statement
*/

/*
-- Query 4 subtable
SELECT * 
FROM Healthcare.dbo.Rates_2014 
WHERE Age <> + 'Family Option' AND Age <> '0-20' AND Age <> '0-14'
*/

/*
-- Query 4 embedded table
SELECT T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate, '21-34' as Age_Range
FROM (SELECT * 
	  FROM Healthcare.dbo.Rates_2014 
	  WHERE Age <> + 'Family Option' AND Age <> '0-20' AND Age <> '0-14') AS T2
WHERE T2. State_Code = 'FL' AND CAST(Substring(T2.Age, 1,2) as int) > 20 AND CAST(Substring(T2.Age, 1,2) as int) < 35
GROUP BY T2.Business_Year, T2.State_Code
*/
/*
-- Query 4
SET @Year = 2014
SET @statement = ''
WHILE @Year <= 2019
	BEGIN
		SET @age_range_case = 1
		WHILE @age_range_case <= 5
			BEGIN
			IF @age_range_case = 1 
				BEGIN
				SET @age_range = '''21-34'''; SET @age_range_low = '''20'''; SET @age_range_high = '''35'''
				END
			IF @age_range_case = 2 
				BEGIN
				SET @age_range = '''35-44'''; SET @age_range_low = '''34'''; SET @age_range_high = '''45'''
				END
			IF @age_range_case = 3 
				BEGIN
				SET @age_range = '''45-54'''; SET @age_range_low = '''44'''; SET @age_range_high = '''55'''
				END
			IF @age_range_case = 4 
				BEGIN
				SET @age_range = '''55-63'''; SET @age_range_low = '''54'''; SET @age_range_high = '''64'''
				END
			IF @age_range_case = 5 
				BEGIN
				SET @age_range = '''64 and over'''; SET @age_range_low = '''63'''; SET @age_range_high = '''99'''
				END
			SET @statement += 
			'SELECT T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate, ' 
			+ @age_range + ' AS Age_Range, COUNT(*) AS Num_Enrolled 
			 FROM (SELECT * FROM Healthcare.dbo.Rates_' + CAST(@Year AS NVARCHAR(10)) + 
			 ' WHERE Age <> ' + @fam_option + ' AND Age <> ' + @range1 + ' AND Age <> ' + @range2 +') as T2
			 WHERE T2.State_Code = ' + @state + ' AND CAST(Substring(T2.Age, 1,2) AS int) > ' + 
			 @age_range_low + ' AND CAST(SUBSTRING(T2.Age, 1,2) AS int) < ' + @age_range_high + 
			' GROUP BY T2.Business_Year, T2.State_Code'
			IF @age_range_case < 5
				SET @statement += ' UNION ALL '
			SET @age_range_case = @age_range_case + 1
			END
		IF @Year < 2019
			SET @statement += ' UNION ALL ';
   
		SET @Year = @Year + 1
	END

EXECUTE sp_executesql @statement
*/
/*select count(*) 
from (select * from Healthcare.dbo.Rates_2014 where Age <> 'Family Option' and Age <> '0-14' and Age <> '0-20') as T2
where T2.State_Code = 'GA' and CAST(Substring(T2.Age, 1,2) as int) > 34 and CAST(Substring(T2.Age, 1,2) as int) < 45
UNION ALL
select count(*) 
from (select * from Healthcare.dbo.Rates_2014 where Age <> 'Family Option' and Age <> '0-14' and Age <> '0-20') as T2
where T2.State_Code = 'GA' and CAST(Substring(T2.Age, 1,2) as int) > 20 and CAST(Substring(T2.Age, 1,2) as int) < 35

*/

