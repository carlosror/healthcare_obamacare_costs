ALTER FUNCTION GetAvgRates ()
RETURNS TABLE
AS
RETURN (
	Select Business_Year AS Year, State_Code AS State, Age, AVG(Individual_Rate) AS Avg_Rate
	from Healthcare.dbo.Rates_2019
	where State_Code = 'FL'
	group by Business_Year, State_Code, Age
	ORDER BY Age
)