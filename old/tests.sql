/*
select DISTINCT Age, COUNT(*)
from Healthcare.dbo.Rates_2017
where State_Code = 'FL'
GROUP BY Age
ORDER BY Age DESC
*/
/*
SELECT DISTINCT Age, COUNT(*)
FROM (SELECT * 
	  FROM Healthcare.dbo.Rates_2017 
	  WHERE Age <> + 'Family Option' AND Age <> '0-20' AND Age <> '0-14') AS T2
WHERE T2.State_Code = 'FL' AND CAST(Substring(T2.Age, 1,2) as int) > 20 AND CAST(Substring(T2.Age, 1,2) as int) < 99
GROUP BY Age
ORDER BY Age
*/

SELECT T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate 
FROM (SELECT * 
	  FROM Healthcare.dbo.Rates_2018
	  WHERE Age <> + 'Family Option' AND Age <> '0-20' AND Age <> '0-14') AS T2
WHERE T2.State_Code = 'FL' AND CAST(Substring(T2.Age, 1,2) as int) > 14 AND CAST(Substring(T2.Age, 1,2) as int) < 99 
GROUP BY T2.Business_Year, T2.State_Code

/*
SELECT T2.Business_Year AS Year, T2.State_Code AS State, AVG(T2.Individual_Rate) AS Avg_Rate, '21-34' as Age_Range
FROM (SELECT * 
	  FROM Healthcare.dbo.Rates_2017 
	  WHERE Age <> + 'Family Option' AND Age <> '0-20' AND Age <> '0-14') AS T2
WHERE T2. State_Code = 'FL' 
GROUP BY T2.Business_Year, T2.State_Code
*/
/*
SELECT DISTINCT Age
FROM Healthcare.dbo.Rates_2017 
WHERE Age <> + 'Family Option' AND Age <> '0-20' AND Age <> '0-14'
*/