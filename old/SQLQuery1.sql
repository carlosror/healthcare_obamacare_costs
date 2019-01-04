Select Business_Year AS Year, State_Code AS State, Age, AVG(Individual_Rate) AS Avg_Rate
from dbo.[Rate_PUF_-_2015]
where State_Code = 'FL'
group by Business_Year, State_Code, Age
ORDER BY Age
--where Age = 24
--where Issuer_ID = '27357';
-- Business_Year AS Year, 
-- State_Code AS State

/*
SELECT Individual_Rate, COUNT(*)
from dbo.[Rate_PUF_-_2015]
WHERE Age = '24'
GROUP BY Individual_Rate
*/

Select Age, AVG(Individual_Rate) AS Avg_Rate
from dbo.[Rate_PUF_-_2015]
where State_Code = 'FL'
group by Age
ORDER BY Age
