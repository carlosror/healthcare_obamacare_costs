DECLARE @Year int 
DECLARE @statement NVARCHAR(max) 
DECLARE @age_range nchar(20) 
DECLARE @age_range_case int
DECLARE @age_range_low nchar(10) 
DECLARE @age_range_high nchar(10) 

/*
-- Query 1
SELECT Business_Year AS Year, State_Code AS State, AVG(Individual_Rate) AS Avg_Rate
FROM Healthcare.dbo.Rates_2014
WHERE State_Code = 'FL'
GROUP BY Business_Year, State_Code
*/

/*
-- https://www.essentialsql.com/build-dynamic-sql-stored-procedure/
-- Query 2
SET @Year = 2014
SET @statement = ''
WHILE @Year <= 2019
	BEGIN
		SET @statement += 
		'SELECT Business_Year AS Year, State_Code AS State, AVG(Individual_Rate) AS Avg_Rate 
		 FROM Healthcare.dbo.Rates_' + CAST(@Year as NVARCHAR(10)) +
		' WHERE State_Code = ''FL''' +  
		' GROUP BY Business_Year, State_Code '
		IF @Year < 2019
			SET @statement += ' UNION ALL ';
   
		SET @Year = @Year + 1
	END

EXECUTE sp_executesql @statement
*/

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
SELECT T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate, '21-99' as Age_Range
FROM (SELECT * 
	  FROM Healthcare.dbo.Rates_2014 
	  WHERE Age <> + 'Family Option' AND Age <> '0-20' AND Age <> '0-14') AS T2
WHERE T2. State_Code = 'FL' AND CAST(Substring(T2.Age, 1,2) as int) > 20 AND CAST(Substring(T2.Age, 1,2) as int) < 100
GROUP BY T2.Business_Year, T2.State_Code
*/
/*
-- Query 4 embedded table single loop
SET @Year = 2014
SET @statement = ''
WHILE @Year <= 2019
	BEGIN
		SET @statement += 
		'SELECT T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate, ' 
		+ ' ''21-99'' AS Age_Range 
		FROM (SELECT * 
			  FROM Healthcare.dbo.Rates_' + CAST(@Year AS NVARCHAR(10)) + 
			  ' WHERE Age <> ''Family Option'' AND Age <> ''0-20'' AND Age <> ''0-14'') as T2
		WHERE T2.State_Code = ''FL'' AND CAST(Substring(T2.Age, 1,2) AS int) > 20' + 
		' AND CAST(SUBSTRING(T2.Age, 1,2) AS int) < 100' + 
		' GROUP BY T2.Business_Year, T2.State_Code'
		IF @Year < 2019
			SET @statement += ' UNION ALL ';
   
		SET @Year = @Year + 1
	END

EXECUTE sp_executesql @statement
*/

-- https://www.sqlshack.com/implement-array-like-functionality-sql-server/
-- Query 4
-- Creating a lookup table
DECLARE @ageRangeTable TABLE (id INT, age_range nchar(20), age_range_low nchar(20), age_range_high nchar(20))
insert into @ageRangeTable values 
	(1,'''21-34''', '''20''', '''35'''), (2,'''35-44''', '''34''', '''45'''), 
	(3,'''45-54''', '''44''', '''55'''), (4,'''55-63''', '''54''', '''64'''), 
	(5,'''64-99''', '''63''', '''99''')

SET @Year = 2014
SET @statement = ''
WHILE @Year <= 2019
	BEGIN
		SET @age_range_case = 1
		WHILE @age_range_case <= 5
			BEGIN
			-- Looking up values
			SET @age_range = (select age_range from @ageRangeTable where id = @age_range_case)
			SET @age_range_low = (select age_range_low from @ageRangeTable where id = @age_range_case)
			SET @age_range_high = (select age_range_high from @ageRangeTable where id = @age_range_case)
			SET @statement += 
			'SELECT T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate, ' 
			+ @age_range + ' AS Age_Range 
			 FROM 
				(SELECT * FROM Healthcare.dbo.Rates_' + CAST(@Year AS NVARCHAR(10)) + 
				' WHERE Age <> ''Family Option'' AND Age <> ''0-14'' AND Age <> ''0-20'') as T2
			 WHERE T2.State_Code = ''FL'' AND CAST(Substring(T2.Age, 1,2) AS int) > ' + @age_range_low + 
			 ' AND CAST(SUBSTRING(T2.Age, 1,2) AS int) < ' + @age_range_high + 
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
